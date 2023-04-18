#!/bin/bash

echo ''
echo '**********************************************************************************************************************************'
echo "*                                                                                                                                *"
echo "* Author: Kharim Mchatta                                                                                                         *"
echo "*                                                                                                                                *"
echo "* Tool-Name: Recon-all                                                                                                           *"
echo "*                                                                                                                                *"
echo "* Version: 1.0                                                                                                                   *"
echo "*                                                                                                                                *"
echo "* Recon all is a tool that performs reconnaissance on the target from subdomain enumerations to robots.txt enumeration  it does  *"
echo "*  it all for you, we will be adding more functionalities to ease the work load of a bug bounty hunter/ penetration tester       *"
echo "* Disclaimer: the tool is not intended for malicious use, any malicious use of the tool shall not hold the author responsible.   *"
echo "*                                                                                                                                *"
echo "**********************************************************************************************************************************"

echo ""
echo ""
echo ""
echo ""
read -p 'enter the target domain name (example.com): ' domain
echo ''
echo ''

read -p 'enter the name of file to save the output in: ' output
echo ''
echo ''
echo 'creating a directory called recon on your desktop'
echo ''
echo ''
folder=$(mkdir /root/Desktop/recon-$domain)
echo ''
echo ''
echo 'a folder called recon has been created'
echo ''
echo ''
echo ''
echo ' robots.txt enumeration'
echo ''
# Fetch the robots.txt file and save it to a local file
url=$(curl -isL $domain/robots.txt) > /root/Desktop/recon-$domain/robots.txt
echo ''
echo "$url"
echo ''

$url > robots.txt

echo "robots.txt check complete. Results saved in /root/Desktop/recon/robots.txt file"
echo ''
echo ''
# Send a GET request to DNSDumpster to retrieve the page content and obtain the csrfmiddlewaretoken value
csrf_token=$(curl -s -X GET "https://dnsdumpster.com/" | grep -oP 'name="csrfmiddlewaretoken" value="\K.*?(?=")')

# Set the POST data with the target domain and csrfmiddlewaretoken value
data="csrfmiddlewaretoken=$csrf_token&targetip=$domain&user=free"

# Set the headers with the CSRF token and referer information
headers="Referer: https://dnsdumpster.com/"
cookies="csrftoken=$csrf_token"

# Send a POST request to DNSDumpster with the target domain and csrfmiddlewaretoken value
response=$(curl -isL -X POST -H "$headers" -H "Cookie: $cookies" -d "$data" "https://dnsdumpster.com/")

# Print the response content

echo "Domain                             IP"
echo "------------------------          ----------------------------------"
echo "$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}|([a-zA-Z0-9]+\.){1,}[a-zA-Z]{2,}' <<< $response | awk '{ if ($0 ~ /^[0-9]/) { ip=$0; } else { printf("%-30s %s\n", $0, ip); } }' | grep -v -E "xlsx|png|html|css|js|hackertarget\.com|dbaeur030138\.inbound\.protection\.outlook\.com|tz\.mail\.protection\.outlook\.com|favicon\.ico|DNSdumpster\.com|am7eur030202\.inbound\.protection\.outlook\.com|dnsdumpster\.com|exampledomain\.com|HackerTarget\.com|api\.hackertarget\.com" | grep "$domain")"


# save output
echo "$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}|([a-zA-Z0-9]+\.){1,}[a-zA-Z]{2,}' <<< $response | awk '{ if ($0 ~ /^[0-9]/) { ip=$0; } else { printf("%-30s %s\n", $0, ip); } }'| grep -v -E "xlsx|png|html|css|js|hackertarget\.com|dbaeur030138\.inbound\.protection\.outlook\.com|tz\.mail\.protection\.outlook\.com|favicon\.ico|DNSdumpster\.com|am7eur030202\.inbound\.protection\.outlook\.com|dnsdumpster\.com|exampledomain\.com|HackerTarget\.com|api\.hackertarget\.com" | tr ' ' '\n' | grep "$domain")" > "/root/Desktop/recon-$domain/$output"

echo "$(grep -Eo '([a-zA-Z0-9]+\.){1,}[a-zA-Z]{2,}' <<< $response | awk '{ if ($0 ~ /^[0-9]/) { ip=$0; } else { printf("%-30s %s\n", $0, ip); } }'| grep -v -E "xlsx|png|html|css|js|hackertarget\.com|dbaeur030138\.inbound\.protection\.outlook\.com|tz\.mail\.protection\.outlook\.com|favicon\.ico|DNSdumpster\.com|am7eur030202\.inbound\.protection\.outlook\.com|dnsdumpster\.com|exampledomain\.com|HackerTarget\.com|api\.hackertarget\.com" | tr ' ' '\n' | grep "$domain")" > /root/Desktop/recon-$domain/subdomains.txt

echo ''
echo ''
echo "checking the https status code of the subdomains"
echo ""
echo ""

# Set input and output file paths
input_file="/root/Desktop/recon-$domain/subdomains.txt"
output_file="/root/Desktop/recon-$domain/subdomain-status.txt"
status_200_file="/root/Desktop/recon-$domain/subdomain-status-200.txt"

# Check if input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: $input_file does not exist."
  exit 1
fi

# Print header for the output file
echo "Subdomain                                         status " | tee "$output_file"
echo "----------------------------------               --------" | tee -a "$output_file"

# Loop through each subdomain in the file and check its status code
while read subdomain; do
  status_code=$(curl -isL -o /dev/null -w "%{http_code}" "$subdomain")
  printf "%-50s %s\n" "$subdomain" "$status_code" | tee -a "$output_file"
  if [ "$status_code" = "200" ]; then
    echo "$subdomain" >> "$status_200_file"
  fi
done < "$input_file"
echo ''
echo ''
echo "Subdomain status code check complete. Results saved in $output_file and $status_200_file"

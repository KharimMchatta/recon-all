# recon-all
We all know that doing manual reconnaissance can be a very combusome task running multiple commands on your terminal from different tools etc. recon all is a tool that is created to do reconnaissance for you where all you have to do is give it a target domain, output name and the tool will do the rest for you. so far the tool does the following 
           1. Collects information from robots.txt and saves the output in robots.txt file 
           2. Perform subdomain enumeration and saves the output in subdomains.txt
           3. Checks the http status code for the subdomain and the output is saved in subdomain-status.txt
           4. Collects all the live subdomain hosts and saves them in subdomain-status-200.txt
           
more features will be added like 
- Basic directory bruteforce
- Port scanning 
- Basic fuzzing

if there will be any issues please let us know so that we can improve on the tool

Cheers

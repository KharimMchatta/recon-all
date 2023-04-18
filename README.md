# recon-all
Manual reconnaissance can often prove to be a cumbersome task, involving the execution of multiple commands through various tools on one's terminal. However, Recon-All presents itself as a solution to this issue by offering an automated approach to reconnaissance. By providing the tool with a target domain and output name, Recon-All undertakes the necessary reconnaissance steps on behalf of the user. Currently, the tool executes the following functions:

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

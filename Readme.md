# mygrep

A mini version of the `grep` command, written in Bash.

This script can:
- Search for a string in a file (case-insensitive).
- Show matching lines.
- Show line numbers with `-n`.
- Invert matches with `-v`.
- Combine options like `-vn` or `-nv`.
- Display helpful usage info with `--help`.

---

## 📜 Usage

```bash
./mygrep.sh [OPTIONS] SEARCH_STRING FILE
```
---

# Task 2: DNS Issue

## Root Cause Analysis Steps:

1- Verify DNS Resolution:
<br/>First, you need to compare DNS resolution behavior when using your local DNS resolver (as defined in /etc/resolv.conf) and Google's public DNS resolver (8.8.8.8). You can use dig or nslookup for this:
```shell
dig internal.example.com
```
- Check local dns server:
- ![dig](https://github.com/user-attachments/assets/7af1981e-640d-4987-ab56-ac73c4b495bc)
- Check Google DNS Server:
- ![dig google](https://github.com/user-attachments/assets/aad340ce-84c1-4abc-b7bc-965e9d32d637)
<br/>If the dig or nslookup command using 8.8.8.8 resolves correctly, but your local resolver doesn’t, this could indicate an issue with your local DNS configuration.
<br/>If both fail, the issue might be outside of your DNS setup, possibly with the service or network.
<br/>in my case both failed
<br/>I need to check my local dns:
- ![local dns](https://github.com/user-attachments/assets/debdb079-2940-4c7f-9da0-9b6953fdb4be)
<br/>My DNS server is configiured -> next step -> add a record to the `/etc/hosts` file
- ![add to local dns file](https://github.com/user-attachments/assets/b9bd09b2-c2b0-47e8-8e2b-f70e9e58de8a)
<br/>Bypass DNS Server to check if out config was correct:
- ![dig bypass dns server](https://github.com/user-attachments/assets/c8f5ce59-38c3-4c2b-a3c4-5f06fcb0d802)
<br/>Our config is correct
2- Diagnose Service Reachability:
<br/>Once DNS is resolved, the next step is to verify whether the web service is reachable on the resolved IP address.
<br/>Steps:
<br/>First, check the service’s IP address:
```shell
dig internal.example.com
```
<br/>you should recieve the ip address: `192.168.1.10`
- ![ip address'](https://github.com/user-attachments/assets/7b5c1dda-2ce3-480f-accc-58fd53e15a64)
- Verify if the web service (port 80 or 443) is open and reachable:
- Use curl to check the HTTP/HTTPS response:
```shell
curl http://192.168.1.10
curl https://192.168.1.10
```
- Use telnet to check port connectivity (both HTTP and HTTPS):
```shell
telnet 192.168.1.10 80
telnet 192.168.1.10 443
```
- Check if the service is listening on the expected ports using netstat or ss:
```shell
sudo netstat -tuln | grep -E '80|443'
```
- OR :
```shell
sudo ss -tuln | grep -E '80|443'
``` 
- What to look for:
<br/>If curl or telnet fails, the issue could be with the service not running, firewall blocking access, or networking issues.
<br/>If netstat or ss shows no service listening on port 80/443, the service might not be running or misconfigured.
3- Trace the Issue – List All Possible Causes:
<br/>Here’s a breakdown of potential causes for the issue:
- DNS Misconfiguration:
<br/>Local DNS server might not have the correct record for internal.example.com.
- Network Misconfiguration:
<br/>The machine might not have a proper network route to reach internal.example.com or its IP.
- Firewall Blocking:
<br/>Either a local firewall or network firewall might be blocking incoming traffic to ports 80/443.
- Service Down or Misconfigured:
<br/>The service (web server) might not be running, misconfigured, or not listening on the correct ports.
- Host File Misconfiguration:
<br/>Local /etc/hosts file might have an incorrect or outdated entry for internal.example.com.
- IP Address Change:
<br/>The resolved IP for internal.example.com might have changed, but DNS hasn’t been updated.
4- Propose and Apply Fixes:
### Fix 1: DNS Misconfiguration
- Confirmation: If dig or nslookup fails with the local resolver but works with Google's DNS, the issue lies with your local DNS.
- Fix: You can try to refresh the DNS cache or check your /etc/resolv.conf settings.
```shell
sudo systemctl restart systemd-resolved
```
- If the /etc/resolv.conf is misconfigured, update the nameserver entry to use a valid DNS server (e.g., 8.8.8.8 or your internal DNS server).
```shell
sudo nano /etc/resolv.conf
```
- Update or add the correct nameserver:
```shell
nameserver 8.8.8.8
```
### Fix 2: Network Misconfiguration
- Confirmation: If you can't reach the IP even after resolving DNS, check network routing with ip route:
```shell
ip route
```
- Fix: If the route is incorrect or missing, add the proper route:
```shell
sudo ip route add <network> via <gateway>
```
### F



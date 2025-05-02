#!/bin/bash

# API Keys - Replace these!
VIRUSTOTAL_API_KEY="your_virustotal_api_key"
GOOGLE_API_KEY="your_google_safe_browsing_api_key"
LOG_FILE="blackhat_$(date +%Y%m%d_%H%M%S).log"

# Colors for Blackhat Vibe
RED='\e[1;91m'
GREEN='\e[1;92m'
YELLOW='\e[1;93m'
NC='\e[0m'

# Hacking Quotes Array
ELON_QUOTES=(
    "Jay Hacking: 'The future is multiplanetary, but your site’s security ain’t!'"
    "BlackOps404 swag: 'I’d rather be on Mars than fix your vuln server!'"
    "Blackhat Hacker Mode: 'Zero to hacked in 3.5 seconds!'"
)

# Check dependencies
check_deps() {
    for cmd in whois dig host nslookup openssl nmap nikto curl wafw00f xsser sqlmap traceroute sublist3r dnsrecon torsocks; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            echo -e "${RED}[-] $cmd missing! Install kar bhai, Blackhat vibe nahi banega.${NC}"
            exit 1
        fi
    done
}

# Ensure URL input
if [ -z "$1" ]; then
    echo -e "${RED}Bhai, URL toh daal—Blackhat kaise karega? (e.g., example.com)${NC}"
    exit 1
fi

URL="$1"
echo -e "${GREEN}[+] Blackhat Investigation shuru for $URL... jay Hacking!${NC}" | tee -a "$LOG_FILE"

# Clean URL
URL=$(echo "$URL" | sed 's|http[s]*://||g' | cut -d'/' -f1)

# Blackhat Banner
banner() {
    echo -e "${RED}"
    echo "  ╔════════════════════════════════════╗"
    echo "  ║      Blackhat Investigation       ║"
    echo "  ║     Powered by BlackOps404        ║"
    echo "  ║              Team!                ║"
    echo "  ╚════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}${ELON_QUOTES[$((RANDOM % ${#ELON_QUOTES[@]}))]}${NC}"
}

# Stealth Mode Toggle
echo -e "${YELLOW}[+] Stealth Mode chahiye? (Tor use karega) [y/N]${NC}"
read -p "> " STEALTH
if [[ "$STEALTH" =~ ^[Yy]$ ]]; then
    CURL="torsocks curl"
    echo -e "${GREEN}[+] Tor ON - Blackhat shadow mode activated!${NC}"
else
    CURL="curl"
fi

# 1. WHOIS Lookup
banner
echo -e "${GREEN}1. WHOIS - Domain ka pura khandan pata karo:${NC}" | tee -a "$LOG_FILE"
whois "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 2. DNS Lookup and Records
echo -e "${GREEN}2. DNS - Network ka blueprint:${NC}" | tee -a "$LOG_FILE"
dig "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"
echo -e "${GREEN}3. DNS Records - Sab kuch expose:${NC}" | tee -a "$LOG_FILE"
host "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 3. IP Address Info
echo -e "${GREEN}4. IP - Target ka address pakdo:${NC}" | tee -a "$LOG_FILE"
nslookup "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 4. SSL/TLS Check
echo -e "${GREEN}5. SSL/TLS - Encryption ka nakab utaro:${NC}" | tee -a "$LOG_FILE"
echo | openssl s_client -connect "$URL:443" -showcerts 2>/dev/null | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 5. Nmap Vulnerability Scan
echo -e "${GREEN}6. Nmap - Chhed chhod do:${NC}" | tee -a "$LOG_FILE"
nmap -p 80,443 --script=http-vuln* "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 6. Nikto Web Scan
echo -e "${GREEN}7. Nikto - Web ka pura audit:${NC}" | tee -a "$LOG_FILE"
nikto -h "https://$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 7. VirusTotal Scan
echo -e "${GREEN}8. VirusTotal - Malware ka pata lagao:${NC}" | tee -a "$LOG_FILE"
URL_ID=$(echo -n "https://$URL" | base64)
$CURL -s -X GET "https://www.virustotal.com/api/v3/urls/$URL_ID" \
     -H "x-apikey: $VIRUSTOTAL_API_KEY" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 8. Phishtank Check
echo -e "${GREEN}9. Phishtank - Phishing ka jhol:${NC}" | tee -a "$LOG_FILE"
$CURL -s "https://www.phishtank.com/phish_search.php?query=$URL" | grep "Results" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 9. Google Safe Browsing
echo -e "${GREEN}10. Google Safe Browsing - Blacklist check:${NC}" | tee -a "$LOG_FILE"
$CURL -s "https://sb-ssl.google.com/safebrowsing/api/lookup?client=api&apikey=$GOOGLE_API_KEY&appver=1.0&pver=3.1.1&url=https://$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 10. Traceroute
echo -e "${GREEN}11. Traceroute - Rasta track karo:${NC}" | tee -a "$LOG_FILE"
traceroute "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 11. HTTP Headers
echo -e "${GREEN}12. HTTP Headers - Security ka haal:${NC}" | tee -a "$LOG_FILE"
$CURL -I "https://$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 12. DNS Records and Nameservers
echo -e "${GREEN}13. DNS Nameservers - Backbone dekho:${NC}" | tee -a "$LOG_FILE"
dig ns "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 13. WAF Detection
echo -e "${GREEN}14. WAF - Firewall ka pata lagao:${NC}" | tee -a "$LOG_FILE"
wafw00f "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 14. HTTP Status
echo -e "${GREEN}15. HTTP Status - Site zinda hai?${NC}" | tee -a "$LOG_FILE"
$CURL -s -o /dev/null -w "%{http_code}" "https://$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 15. Open Ports
echo -e "${GREEN}16. Open Ports - Darwaze khule hain?${NC}" | tee -a "$LOG_FILE"
nmap -p- "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 16. XSS Test
echo -e "${GREEN}17. XSS - Script daal ke dekho:${NC}" | tee -a "$LOG_FILE"
xsser -u "https://$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 17. SQL Injection
echo -e "${GREEN}18. SQL Injection - Database tod do:${NC}" | tee -a "$LOG_FILE"
sqlmap -u "https://$URL" --batch | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 18. Subdomain Scan
echo -e "${GREEN}19. Subdomains - Chhupe khazane:${NC}" | tee -a "$LOG_FILE"
sublist3r -d "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 19. Sensitive Data Leak
echo -e "${GREEN}20. Data Leak - Secrets pakdo:${NC}" | tee -a "$LOG_FILE"
$CURL -s "https://$URL" | grep -E 'password|secret|key|token' | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 20. DNS Exfiltration
echo -e "${GREEN}21. DNS Exfiltration - Data chori check:${NC}" | tee -a "$LOG_FILE"
dnsrecon -d "$URL" | tee -a "$LOG_FILE"
echo "-----------------------------------" | tee -a "$LOG_FILE"

# 21. Chaos Mode - Fake Requests (Blackhat Special)
echo -e "${YELLOW}[+] Chaos Mode - Thodi si tabahi? [y/N]${NC}"
read -p "> " CHAOS
if [[ "$CHAOS" =~ ^[Yy]$ ]]; then
    echo -e "${RED}[+] Blackhat Chaos shuru - Fake requests maaro!${NC}" | tee -a "$LOG_FILE"
    for i in {1..50}; do
        $CURL -s "https://$URL/fake_path_$i" -H "User-Agent: BlackOps404" &  # Background requests
    done
    echo -e "${GREEN}[+] Chaos complete - 50 fake requests fired!${NC}" | tee -a "$LOG_FILE"
fi

# Final Output
banner
echo -e "${GREEN}[+] Investigation pura hua for $URL! Log file: $LOG_FILE${NC}" | tee -a "$LOG_FILE"
echo -e "${YELLOW}${ELON_QUOTES[$((RANDOM % ${#ELON_QUOTES[@]}))]}${NC}"

# Check dependencies
check_deps

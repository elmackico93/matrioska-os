#!/bin/bash

LOG_FILE="matrioska_log.txt"
STATUS_FILE="setup_status.txt"

# Define Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}🚀 Welcome to Matrioska OS Intelligent Setup!${NC}"
echo -e "${YELLOW}This script will ensure everything is configured properly.${NC}"
echo -e "${BLUE}-------------------------------------------${NC}"

# Function to check if a step has already been completed
check_status() {
    if [ -f "$STATUS_FILE" ]; then
        grep -q "$1" "$STATUS_FILE"
    else
        return 1
    fi
}

# Function to update setup progress
update_status() {
    echo "$1" >> "$STATUS_FILE"
}

# Ensure the log and status files exist
touch "$LOG_FILE" "$STATUS_FILE"

# Loading animation
loading_animation() {
    echo -ne "${BLUE}Processing${NC} "
    for i in {1..5}; do
        echo -ne "🔄"
        sleep 0.5
    done
    echo -ne "\n"
}

# --- 🛠 Step 1: Check GitHub CLI Installation ---
if check_status "GitHub CLI Installed"; then
    echo -e "✅ ${GREEN}GitHub CLI already installed.${NC}"
else
    if ! command -v gh &> /dev/null; then
        echo -e "❌ ${RED}GitHub CLI ('gh') is not installed. Install it first: https://cli.github.com/${NC}"
        exit 1
    fi
    update_status "GitHub CLI Installed"
fi

# --- 🔑 Step 2: Check GitHub Authentication ---
if check_status "GitHub Authenticated"; then
    echo -e "✅ ${GREEN}GitHub Authentication already verified.${NC}"
else
    if ! gh auth status > /dev/null 2>&1; then
        echo -e "❌ ${RED}GitHub CLI is not authenticated. Run 'gh auth login' first!${NC}"
        exit 1
    fi
    update_status "GitHub Authenticated"
fi

# --- 📊 Step 3: Check GitHub API Rate Limits ---
if check_status "GitHub API Rate Check Completed"; then
    echo -e "✅ ${GREEN}GitHub API Rate Check already completed.${NC}"
else
    API_LIMIT=$(gh api rate_limit --jq '.rate.remaining')
    if [ "$API_LIMIT" -le 1 ]; then
        echo -e "⚠️ ${YELLOW}API Rate Limit Reached! Waiting for reset...${NC}"
        sleep 3600  # Wait 1 hour for reset
    fi
    update_status "GitHub API Rate Check Completed"
fi

# --- 👤 Step 4: Get GitHub Username ---
if check_status "GitHub Username Retrieved"; then
    echo -e "✅ ${GREEN}GitHub Username already retrieved.${NC}"
else
    GITHUB_USER=$(gh api user --jq '.login')
    if [ -z "$GITHUB_USER" ]; then
        echo -e "❌ ${RED}Could not retrieve GitHub username. Check authentication.${NC}"
        exit 1
    fi
    update_status "GitHub Username Retrieved: $GITHUB_USER"
fi

# --- 🔢 Step 5: Retrieve or Ask for GitHub Project ID ---
PROJECT_NAME="Matrioska OS Development"

if check_status "Project ID Retrieved"; then
    PROJECT_ID=$(grep "Project ID Retrieved" "$STATUS_FILE" | awk '{print $NF}')
    echo -e "✅ ${GREEN}Project ID already retrieved: $PROJECT_ID${NC}"
else
    echo -e "🛠 ${YELLOW}Enter your GitHub Project ID for '$PROJECT_NAME': ${NC}"
    read -p "👉 Project ID: " PROJECT_ID

    if [[ ! $PROJECT_ID =~ ^[0-9]+$ ]]; then
        echo -e "❌ ${RED}Invalid Project ID. Please enter a numeric value.${NC}"
        exit 1
    fi
    update_status "Project ID Retrieved: $PROJECT_ID"
fi

# --- 🏆 Step 6: Final Summary ---
loading_animation
echo -e "${GREEN}🎉 Matrioska OS Setup Completed!${NC}"
echo -e "📜 ${YELLOW}Setup Log: $LOG_FILE${NC}"
echo -e "🔄 ${YELLOW}Resumable Status File: $STATUS_FILE${NC}"

# Cool ASCII Art for final effect
echo -e "${BLUE}"
echo "  ███╗   ███╗ █████╗ ████████╗██████╗ ██╗ ██████╗ ███████╗ █████╗  "
echo "  ████╗ ████║██╔══██╗╚══██╔══╝██╔══██╗██║██╔════╝ ██╔════╝██╔══██╗ "
echo "  ██╔████╔██║███████║   ██║   ██████╔╝██║██║  ███╗███████╗███████║ "
echo "  ██║╚██╔╝██║██╔══██║   ██║   ██╔══██╗██║██║   ██║╚════██║██╔══██║ "
echo "  ██║ ╚═╝ ██║██║  ██║   ██║   ██║  ██║██║╚██████╔╝███████║██║  ██║ "
echo "  ╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ "
echo -e "${NC}"
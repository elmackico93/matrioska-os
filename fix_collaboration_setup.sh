#!/bin/bash

LOG_FILE="fix_log.txt"
echo "🚀 Starting Matrioska OS Fix Collaboration Script..." | tee $LOG_FILE

# --- 🛠 Ensure GitHub CLI is Installed ---
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI ('gh') is not installed. Install it first: https://cli.github.com/" | tee -a $LOG_FILE
    exit 1
fi

# --- 🔑 Check if GitHub Authentication is Active ---
if ! gh auth status > /dev/null 2>&1; then
    echo "❌ Error: GitHub CLI is not authenticated. Run 'gh auth login' first!" | tee -a $LOG_FILE
    exit 1
fi

# --- 📊 Check GitHub API Rate Limits ---
API_LIMIT=$(gh api rate_limit --jq '.rate.remaining')
if [ "$API_LIMIT" -le 1 ]; then
    echo "⚠️ API Rate Limit Reached! Waiting for reset..." | tee -a $LOG_FILE
    sleep 3600  # Wait 1 hour for reset
    echo "✅ API Limit Reset. Resuming script..." | tee -a $LOG_FILE
fi

# --- 👤 Get GitHub Username ---
GITHUB_USER=$(gh api user --jq '.login')
if [ -z "$GITHUB_USER" ]; then
    echo "❌ Error: Could not retrieve GitHub username. Check your authentication." | tee -a $LOG_FILE
    exit 1
fi
echo "✅ Using GitHub User: $GITHUB_USER" | tee -a $LOG_FILE

# --- ✅ Ensure Issues Are Enabled in Repo Settings ---
REPO_ISSUES_ENABLED=$(gh api repos/:owner/:repo --jq '.has_issues')
if [ "$REPO_ISSUES_ENABLED" != "true" ]; then
    echo "❌ Error: Issues are disabled in repository settings. Enable them in GitHub → Settings → General → Issues." | tee -a $LOG_FILE
    exit 1
fi

# --- 🎨 Ensure Labels Exist ---
declare -A labels=(
    ["kernel"]="FF5733|Kernel-related issues"
    ["security"]="33FF57|Security & encryption issues"
    ["networking"]="3377FF|Network stack & VPN"
    ["UI/UX"]="FFD700|User Interface & Design"
    ["AI"]="800080|Artificial Intelligence & Automation"
)

echo "🛠 Checking GitHub labels..." | tee -a $LOG_FILE
for label in "${!labels[@]}"; do
    color="${labels[$label]%%|*}"
    description="${labels[$label]#*|}"
    
    if ! gh label list | grep -q "^$label"; then
        gh label create "$label" --color "$color" --description "$description" 2>> $LOG_FILE
        if [ $? -eq 0 ]; then
            echo "✅ Label '$label' created successfully!" | tee -a $LOG_FILE
        else
            echo "⚠️ Warning: Failed to create label '$label' (may already exist or API limit reached)." | tee -a $LOG_FILE
        fi
    else
        echo "✅ Label '$label' already exists." | tee -a $LOG_FILE
    fi
done

# --- 🐞 Create GitHub Issues with Error Debugging ---
declare -A issues=(
    ["Implement Matrioska OS Kernel"]="Design the AI-optimized Kernel for Matrioska OS. Technologies: C, Rust.|kernel"
    ["Develop Decentralized VPN"]="Create a censorship-resistant VPN with stealth encryption. Technologies: WireGuard, Blockchain.|networking"
    ["Integrate GAIA AI Assistant"]="Develop the AI-driven GAIA Assistant for automation & intelligence.|AI"
    ["Secure Boot & Encryption Layer"]="Implement secure boot with quantum-proof encryption.|security"
    ["Design Matrioska UI"]="Build the futuristic UI that adapts across desktop, mobile, and embedded systems.|UI/UX"
)

echo "🐞 Creating GitHub Issues with full error logging..." | tee -a $LOG_FILE
for title in "${!issues[@]}"; do
    body="${issues[$title]%%|*}"
    label="${issues[$title]#*|}"
    
    ATTEMPTS=0
    SUCCESS=0

    while [ $ATTEMPTS -lt 3 ]; do
        RESPONSE=$(gh issue create --title "$title" --body "$body" --label "$label" --assignee "$GITHUB_USER" 2>&1)
        ISSUE_NUMBER=$(echo "$RESPONSE" | awk -F '/' '{print $NF}')
        
        if [[ "$ISSUE_NUMBER" =~ ^[0-9]+$ ]]; then
            echo "✅ Issue '$title' created successfully! (Issue #$ISSUE_NUMBER)" | tee -a $LOG_FILE
            SUCCESS=1
            break
        else
            echo "⚠️ Attempt $(($ATTEMPTS + 1)) failed for issue '$title'." | tee -a $LOG_FILE
            echo "🔍 GitHub API Response: $RESPONSE" | tee -a $LOG_FILE
            ATTEMPTS=$((ATTEMPTS + 1))
            sleep 5  # Wait before retrying
        fi
    done

    if [ $SUCCESS -eq 0 ]; then
        echo "❌ Error: Failed to create issue '$title' after multiple attempts. See $LOG_FILE for details." | tee -a $LOG_FILE
    fi
done

# --- 📊 Final Summary ---
echo "🎉 Fix Collaboration Script Completed Successfully!" | tee -a $LOG_FILE
echo "📜 Full log saved to $LOG_FILE" | tee -a $LOG_FILE

#!/bin/bash
# ==================================================
#  UNITY MAC INSTALLER - OPTIMIZED AUTO SETUP
# ==================================================
# This script automates the installation and configuration
# of Unity on macOS, ensuring seamless setup for future projects.

LOG_FILE="$HOME/Unity_Installer/logs/install_log.txt"
UNITY_VERSION="2022.3.8f1"
UNITY_HUB_URL="https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.dmg"
UNITY_PATH="/Applications/Unity/Hub/Editor/$UNITY_VERSION"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

log() {
    echo "$(date "+%Y-%m-%d %H:%M:%S") - $1" | tee -a "$LOG_FILE"
}

# Function to install Homebrew (if missing)
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        log "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        log "Homebrew is already installed."
    fi
}

# Function to install dependencies
install_dependencies() {
    log "Installing dependencies..."
    brew install git wget cmake mono fbx-sdk
}

# Function to install Unity Hub
install_unity_hub() {
    if [ ! -d "/Applications/Unity Hub.app" ]; then
        log "Downloading Unity Hub..."
        wget -O "UnityHub.dmg" "$UNITY_HUB_URL"
        hdiutil attach UnityHub.dmg
        cp -R "/Volumes/Unity Hub/Unity Hub.app" "/Applications/"
        hdiutil detach "/Volumes/Unity Hub"
        rm UnityHub.dmg
        log "Unity Hub installed successfully."
    else
        log "Unity Hub is already installed."
    fi
}

# Function to install Unity Editor
install_unity_editor() {
    if [ ! -d "$UNITY_PATH" ]; then
        log "Installing Unity Editor version $UNITY_VERSION..."
        unityhub -- --headless install --version $UNITY_VERSION --modules mac-il2cpp
        log "Unity Editor installed successfully."
    else
        log "Unity Editor $UNITY_VERSION is already installed."
    fi
}

# Function to configure Unity for first-time use
configure_unity() {
    log "Configuring Unity settings..."
    defaults write com.unity3d.UnityEditor ApplePressAndHoldEnabled -bool false
    mkdir -p "$HOME/Library/Unity/Cache"
    log "Unity configuration complete."
}

# Function to verify installation
verify_installation() {
    if [ -d "$UNITY_PATH" ]; then
        log "Unity $UNITY_VERSION installation verified. Ready to launch."
    else
        log "Error: Unity installation not found. Please check logs."
        exit 1
    fi
}

# Main setup function
main() {
    log "Starting Unity macOS setup..."
    install_homebrew
    install_dependencies
    install_unity_hub
    install_unity_editor
    configure_unity
    verify_installation
    log "Unity setup completed successfully! You can now start developing your applications."
}

main

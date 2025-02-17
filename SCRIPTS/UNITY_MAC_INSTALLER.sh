#!/bin/bash
###############################################################################
# Unity Automated Installer & Project Creator (macOS)
# 
# This script installs Unity Hub (if needed) and Unity Editor, then sets up a new
# Unity project with user-specified options (version type, template, etc.).
# It includes error handling and status messages for a seamless experience.
###############################################################################

# Exit immediately on error and treat unset variables as errors
set -euo pipefail

# Function to print an error message and exit
error_exit() {
    echo "❌ Error: $1" >&2
    exit 1
}

# Check that we're on macOS (Darwin)
if [[ "$(uname)" != "Darwin" ]]; then
    error_exit "This script is intended for macOS only."
fi

echo ">>> Unity Installation & Setup Script for macOS <<<"

# 1. Install Unity Hub if not present
HUB_APP="/Applications/Unity Hub.app"
HUB_CLI="$HUB_APP/Contents/MacOS/Unity Hub"

if [[ ! -d "$HUB_APP" ]]; then
    echo "Unity Hub not found. It will be installed for managing Unity versions."
    # If Homebrew is available, use it; otherwise, download the Hub manually.
    if command -v brew >/dev/null 2>&1; then
        echo "Installing Unity Hub via Homebrew..."
        if ! brew install --cask unity-hub; then
            echo "Homebrew installation failed. Attempting direct download..." >&2
        fi
    fi
    # If Hub still not installed (either brew not available or brew failed), do manual download
    if [[ ! -d "$HUB_APP" ]]; then
        echo "Downloading Unity Hub from Unity servers..."
        HUB_DMG="/tmp/UnityHubSetup.dmg"
        # Download Unity Hub installer (official URL) – ensure curl follows redirects (-L)
        if ! curl -L -o "$HUB_DMG" "https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup.dmg"; then
            error_exit "Failed to download Unity Hub. Check your internet connection."
        fi
        echo "Mounting Unity Hub installer disk image..."
        MOUNT_POINT=$(hdiutil attach "$HUB_DMG" -nobrowse | grep -Eo '/Volumes/Unity Hub[^"]*')
        if [[ -z "$MOUNT_POINT" || ! -d "$MOUNT_POINT" ]]; then
            error_exit "Failed to mount the Unity Hub installer DMG."
        fi
        echo "Copying Unity Hub to /Applications (requires admin privileges)..."
        # Copy the .app into Applications
        if ! sudo cp -R "$MOUNT_POINT/Unity Hub.app" "/Applications/"; then
            error_exit "Failed to copy Unity Hub to /Applications."
        fi
        # Unmount the DMG
        hdiutil detach "$MOUNT_POINT" -quiet || echo "Warning: Failed to unmount DMG (it may unmount on its own)."
        rm -f "$HUB_DMG"
        echo "Unity Hub installed successfully."
    fi
else
    echo "Unity Hub is already installed."
fi

# Ensure Unity Hub CLI path is correct
if [[ ! -x "$HUB_CLI" ]]; then
    # If for some reason the Hub executable isn't found, try to locate Unity Hub
    HUB_CLI="$(mdfind \"Unity Hub.app/Contents/MacOS/Unity Hub\" | head -n 1)"
    if [[ -z "$HUB_CLI" ]]; then
        error_exit "Unity Hub CLI could not be located."
    fi
fi

# On Apple Silicon (ARM) Macs, ensure Rosetta 2 is installed (Unity Hub needs it, as it is x86_64)
if [[ "$(uname -m)" == "arm64" ]]; then
    echo "Apple Silicon detected. Ensuring Rosetta 2 is installed for Unity Hub..."
    if ! /usr/bin/pgrep oahd >/dev/null 2>&1; then
        # Rosetta not running, attempt to install
        sudo softwareupdate --install-rosetta --agree-to-license || {
            error_exit "Rosetta installation failed or was declined. Unity Hub may not run on Apple Silicon without Rosetta."
        }
    else
        echo "Rosetta 2 is already installed."
    fi
fi

# 2. Determine if Unity Editor is already installed and possibly needs update
UNITY_INSTALLED="no"
DEFAULT_EDITOR_PATH=""
if [[ -d "/Applications/Unity/Hub/Editor" && "$(ls -A /Applications/Unity/Hub/Editor)" ]]; then
    # If Unity Hub has an Editors directory with contents, assume at least one version installed
    UNITY_INSTALLED="yes"
fi
# Also check for legacy installation (non-Hub)
if [[ -d "/Applications/Unity/Unity.app" ]]; then
    UNITY_INSTALLED="yes"
fi

if [[ "$UNITY_INSTALLED" == "yes" ]]; then
    echo "A Unity Editor installation was detected on this system."
    # Prompt user if they want to install a new version (update) or use existing
    read -rp "Do you want to install/upgrade to a new Unity version? (y/N): " UPDATE_CHOICE
    UPDATE_CHOICE=${UPDATE_CHOICE:-N}
else
    UPDATE_CHOICE="y"  # If none installed, we must install one
fi

INSTALL_VERSION=""  # e.g., "2023.2.20f1"
INSTALL_LABEL=""    # "LTS" or "Latest"

if [[ "$UPDATE_CHOICE" =~ ^[Yy]$ ]]; then
    # Offer user to choose latest stable or LTS
    echo "Choose Unity version type to install:"
    echo "1) Latest Official Release (Tech Stream)"
    echo "2) Latest LTS (Long Term Support)"
    read -rp "Enter 1 or 2 [1]: " VERSION_CHOICE
    VERSION_CHOICE=${VERSION_CHOICE:-1}
    # Fetch available releases from Unity Hub
    echo "Fetching list of Unity releases..."
    RELEASES_LIST=$("$HUB_CLI" -- --headless editors -r) || {
        error_exit "Failed to fetch Unity releases from Unity Hub."
    }
    # Parse the releases list to find latest stable and LTS
    # (Assume releases list is sorted by version/newest)
    LATEST_STABLE=$(echo "$RELEASES_LIST" | grep -v "LTS" | head -n1 | awk '{print $2}')
    LATEST_LTS=$(echo "$RELEASES_LIST" | grep "LTS" | head -n1 | awk '{print $2}')
    if [[ -z "$LATEST_STABLE" || -z "$LATEST_LTS" ]]; then
        error_exit "Could not determine latest Unity versions from Hub."
    fi
    if [[ "$VERSION_CHOICE" == "2" ]]; then
        INSTALL_VERSION="$LATEST_LTS"
        INSTALL_LABEL="LTS"
    else
        INSTALL_VERSION="$LATEST_STABLE"
        INSTALL_LABEL="Latest"
    fi
    echo "Selected Unity $INSTALL_LABEL version: $INSTALL_VERSION"
    # 3. Install the selected Unity Editor version
    echo "Installing Unity $INSTALL_VERSION via Unity Hub (this may take a while)..."
    # Use Unity Hub CLI to install the editor
    # Use Apple Silicon architecture if on arm64 for better performance (Unity defaults to x86_64 otherwise)&#8203;:contentReference[oaicite:10]{index=10}
    ARCH_FLAG=""
    if [[ "$(uname -m)" == "arm64" ]]; then
        ARCH_FLAG="--architecture arm64"
    fi
    # The install command will download Unity Editor (and we can add modules if needed in the future)
    if ! "$HUB_CLI" -- --headless install --version "$INSTALL_VERSION" $ARCH_FLAG; then
        error_exit "Unity Hub failed to install Unity $INSTALL_VERSION. Please check Unity Hub logs for details."
    fi
    echo "Unity $INSTALL_VERSION installation completed."
    # Set path for the newly installed Unity Editor executable
    DEFAULT_EDITOR_PATH="/Applications/Unity/Hub/Editor/$INSTALL_VERSION/Unity.app/Contents/MacOS/Unity"
    if [[ ! -x "$DEFAULT_EDITOR_PATH" ]]; then
        error_exit "Installed Unity editor not found at expected path: $DEFAULT_EDITOR_PATH"
    fi
else
    echo "Skipping Unity Editor installation. Will use existing Unity installation for project creation."
    # Find an existing Unity Editor to use
    if [[ -d "/Applications/Unity/Hub/Editor" ]]; then
        # Pick the latest version installed under Unity Hub/Editor
        LATEST_INSTALLED=$(ls "/Applications/Unity/Hub/Editor" | sort -V | tail -n1)
        DEFAULT_EDITOR_PATH="/Applications/Unity/Hub/Editor/$LATEST_INSTALLED/Unity.app/Contents/MacOS/Unity"
    fi
    if [[ -z "$DEFAULT_EDITOR_PATH" && -d "/Applications/Unity/Unity.app" ]]; then
        # Use legacy installed Unity
        DEFAULT_EDITOR_PATH="/Applications/Unity/Unity.app/Contents/MacOS/Unity"
    fi
    if [[ -z "$DEFAULT_EDITOR_PATH" ]]; then
        error_exit "No Unity Editor installation could be found to create the project."
    fi
fi

# 4. Prompt for new Unity project details
echo ">> Unity Editor is ready. Now let's set up a new Unity project."
# Default project directory suggestion
DEFAULT_PROJECT_DIR="$HOME/UnityProject"
read -rp "Enter the path for the new Unity project [default: $DEFAULT_PROJECT_DIR]: " PROJECT_PATH
PROJECT_PATH=${PROJECT_PATH:-$DEFAULT_PROJECT_DIR}
PROJECT_PATH="${PROJECT_PATH/%\//}"  # remove trailing slash if any for consistency
if [[ -e "$PROJECT_PATH" ]]; then
    # If path exists, ensure it's a directory and (nearly) empty
    if [[ ! -d "$PROJECT_PATH" ]]; then
        error_exit "The path '$PROJECT_PATH' exists and is not a directory."
    fi
    # Allow using an empty directory or one that only contains perhaps a .git folder (if user re-running script)
    if [[ -n "$(ls -A "$PROJECT_PATH" 2>/dev/null)" ]]; then
        echo "Warning: The directory '$PROJECT_PATH' is not empty. Unity will still create a project here."
        echo "         Existing files (if any) that conflict with Unity project files may be overwritten."
        read -rp "Proceed with project creation in this directory? (y/N): " CONT
        CONT=${CONT:-N}
        if [[ ! "$CONT" =~ ^[Yy]$ ]]; then
            error_exit "Project creation aborted by user due to non-empty directory."
        fi
    fi
else
    # Path doesn't exist, create it
    if ! mkdir -p "$PROJECT_PATH"; then
        error_exit "Failed to create directory '$PROJECT_PATH'."
    fi
fi

# Convert PROJECT_PATH to absolute path (in case relative was given)
PROJECT_PATH="$(cd "$PROJECT_PATH" && pwd -P)"

# Project name from path (last folder name)
PROJECT_NAME="$(basename "$PROJECT_PATH")"

# 5. Prompt for project template choice
echo "Select a Unity project template for '$PROJECT_NAME':"
echo "1) 3D (Default template)"
echo "2) 2D"
echo "3) URP (Universal Render Pipeline)"
echo "4) HDRP (High Definition RP)"
echo "5) Custom (specify your own template project or package)"
read -rp "Enter 1-5 [default 1]: " TEMPLATE_CHOICE
TEMPLATE_CHOICE=${TEMPLATE_CHOICE:-1}

# Flags for template handling
USE_URP="no"
USE_HDRP="no"
USE_CUSTOM="no"
CUSTOM_TEMPLATE_PATH=""
case "$TEMPLATE_CHOICE" in
    1) TEMPLATE_NAME="3D" ;;
    2) TEMPLATE_NAME="2D" ;;
    3) TEMPLATE_NAME="URP"; USE_URP="yes" ;;
    4) TEMPLATE_NAME="HDRP"; USE_HDRP="yes" ;;
    5) TEMPLATE_NAME="Custom"; USE_CUSTOM="yes" ;;
    *) TEMPLATE_NAME="3D" ;;  # default fallback
esac
echo "Project template selected: $TEMPLATE_NAME"

if [[ "$USE_CUSTOM" == "yes" ]]; then
    # Ask for custom template source (directory, zip, or unitypackage)
    read -rp "Enter path to custom template folder/zip/unitypackage: " CUSTOM_TEMPLATE_PATH
    CUSTOM_TEMPLATE_PATH=${CUSTOM_TEMPLATE_PATH:-}
    if [[ -z "$CUSTOM_TEMPLATE_PATH" ]]; then
        error_exit "No custom template path provided."
    fi
    if [[ ! -e "$CUSTOM_TEMPLATE_PATH" ]]; then
        error_exit "The specified template path '$CUSTOM_TEMPLATE_PATH' does not exist."
    fi
    # If it's a file, determine type
    if [[ -f "$CUSTOM_TEMPLATE_PATH" ]]; then
        case "$CUSTOM_TEMPLATE_PATH" in
            *.unitypackage)
                echo "Custom template is a Unity package. Will import it into a new project."
                ;;
            *.zip|*.tgz|*.tar.gz)
                echo "Custom template is an archive. It will be extracted into the project folder."
                ;;
            *)
                echo "Custom template is a file (unknown type). Assuming it's a Unity package."
                CUSTOM_TEMPLATE_PATH_TYPE="unitypackage"
                ;;
        esac
    elif [[ -d "$CUSTOM_TEMPLATE_PATH" ]]; then
        echo "Custom template is a directory. Its contents will be copied into the project folder."
    else
        error_exit "Unsupported template path type."
    fi
fi

# 6. Create the new Unity project (unless we are going to use a full custom project directly)
PROJECT_CREATED="no"
if [[ "$USE_CUSTOM" == "yes" && -f "$CUSTOM_TEMPLATE_PATH" && "$CUSTOM_TEMPLATE_PATH" != *.unitypackage ]]; then
    # If custom template is a zip/tgz archive (not a unitypackage), we will use it directly instead of -createProject
    echo "Using custom project archive as base. Extracting contents..."
    if [[ "$CUSTOM_TEMPLATE_PATH" == *.zip ]]; then
        unzip -q "$CUSTOM_TEMPLATE_PATH" -d "$PROJECT_PATH" || error_exit "Failed to unzip custom template."
    else
        tar -xf "$CUSTOM_TEMPLATE_PATH" -C "$PROJECT_PATH" || error_exit "Failed to extract custom template archive."
    fi
    # If the archive had a single top-level folder, its contents might be in a subdirectory now.
    # Move them up if so (i.e., if $PROJECT_PATH contains exactly one directory after extraction).
    if [[ $(find "$PROJECT_PATH" -maxdepth 1 -mindepth 1 -type d | wc -l) -eq 1 && -f "$PROJECT_PATH/$(basename "$CUSTOM_TEMPLATE_PATH")" ]]; then
        # Uncommon scenario: skip for simplicity.
        echo "Note: Custom template archive extracted with a root folder. You may need to move files up one level."
    fi
    PROJECT_CREATED="yes"
elif [[ "$USE_CUSTOM" == "yes" && -d "$CUSTOM_TEMPLATE_PATH" ]]; then
    echo "Copying custom template project files..."
    # Copy all files from the custom directory into the new project directory
    # (This will overwrite any existing files if names clash)
    cp -R "$CUSTOM_TEMPLATE_PATH/." "$PROJECT_PATH/" || error_exit "Failed to copy custom template files."
    PROJECT_CREATED="yes"
else
    # Use Unity Editor to create a new project (for 3D, 2D, URP, HDRP, or unitypackage-based custom)
    echo "Creating new Unity project at '$PROJECT_PATH'..."
    # Determine any extra arguments for -createProject based on template if possible
    # (Unity's -createProject does not take a template parameter directly in current versions, so we create a blank project and will configure it below)
    if ! "$DEFAULT_EDITOR_PATH" -batchmode -createProject "$PROJECT_PATH" -quit; then
        # If Unity returns an error, it could be due to license not activated or other issues
        error_exit "Unity Editor failed to create the project. You may need to activate Unity (open it once manually) and then rerun this script."
    fi
    PROJECT_CREATED="yes"
fi

echo "Unity project structure created."

# 7. Post-creation project configuration (templates, packages, settings)
# We will prepare an Editor script to run inside Unity for setting up things like URP/HDRP, 2D mode, etc., then run Unity in batch mode to execute it.

# Create an Editor script in the project (Assets/Editor/SetupProject.cs) to configure project settings and import pipeline if needed.
EDITOR_DIR="$PROJECT_PATH/Assets/Editor"
mkdir -p "$EDITOR_DIR"
SETUP_SCRIPT_PATH="$EDITOR_DIR/SetupProject.cs"
cat > "$SETUP_SCRIPT_PATH" << 'EOF'
using UnityEditor;
using UnityEngine;
#if UNITY_2020_1_OR_NEWER
using UnityEngine.Rendering;
#endif
#if UNITY_2021_1_OR_NEWER
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering.HighDefinition;
#endif

// This editor script is automatically generated to configure the Unity project.
public class SetupProject
{
    // Configures common project settings (version control, serialization, 2D/3D default) 
    public static void ConfigureProjectSettings()
    {
        // Ensure Visible Meta Files for version control
        EditorSettings.externalVersionControl = "Visible Meta Files";
        // Force asset serialization mode to Force Text (YAML) for better version control
        EditorSettings.serializationMode = SerializationMode.ForceText;
        // Set default behavior mode (2D or 3D) based on what user selected (to be toggled below)
        // (We will override this below in specific template methods if needed)
    }

    public static void SetupFor2D()
    {
        // Set editor default behavior mode to 2D (so new scenes open in 2D mode, etc.)
        EditorSettings.defaultBehaviorMode = EditorBehaviorMode.Mode2D;
        Debug.Log("Project set to 2D mode by default.");
    }

    public static void SetupFor3D()
    {
        // Explicitly set to 3D mode (though Unity defaults to 3D if not changed)
        EditorSettings.defaultBehaviorMode = EditorBehaviorMode.Mode3D;
        Debug.Log("Project set to 3D mode by default.");
    }

    public static void AddURP()
    {
#if UNITY_2021_1_OR_NEWER
        Debug.Log("Installing URP package...");
        var request = UnityEditor.PackageManager.Client.Add("com.unity.render-pipelines.universal");
        // Wait for the package installation to complete
        while (!request.IsCompleted)
        {
            System.Threading.Thread.Sleep(100);
        }
        if (request.Status == UnityEditor.PackageManager.StatusCode.Success)
        {
            Debug.Log("URP package installed.");
            // Create and assign a basic Universal Render Pipeline asset
            var rpAsset = ScriptableObject.CreateInstance<UniversalRenderPipelineAsset>();
            AssetDatabase.CreateAsset(rpAsset, "Assets/Settings/UniversalRP-Pipeline.asset");
            GraphicsSettings.renderPipelineAsset = rpAsset;
            QualitySettings.renderPipeline = rpAsset;
            Debug.Log("URP Render Pipeline Asset created and assigned.");
        }
        else
        {
            Debug.LogError("Failed to install URP package: " + request.Error.message);
        }
#else
        Debug.LogError("URP setup is not supported for this Unity version via script.");
#endif
    }

    public static void AddHDRP()
    {
#if UNITY_2021_1_OR_NEWER
        Debug.Log("Installing HDRP package...");
        var request = UnityEditor.PackageManager.Client.Add("com.unity.render-pipelines.high-definition");
        while (!request.IsCompleted)
        {
            System.Threading.Thread.Sleep(100);
        }
        if (request.Status == UnityEditor.PackageManager.StatusCode.Success)
        {
            Debug.Log("HDRP package installed.");
            // Create and assign a basic High Definition Render Pipeline asset
            var rpAsset = ScriptableObject.CreateInstance<HDRenderPipelineAsset>();
            AssetDatabase.CreateAsset(rpAsset, "Assets/Settings/HDRP-Pipeline.asset");
            GraphicsSettings.renderPipelineAsset = rpAsset;
            QualitySettings.renderPipeline = rpAsset;
            Debug.Log("HDRP Render Pipeline Asset created and assigned.");
        }
        else
        {
            Debug.LogError("Failed to install HDRP package: " + request.Error.message);
        }
#else
        Debug.LogError("HDRP setup is not supported for this Unity version via script.");
#endif
    }
}
EOF

# Note: The above script uses Unity's PackageManager Client API to add URP/HDRP packages and configures render pipeline assets.
# It also sets EditorSettings for 2D/3D and version control settings. It will be invoked in the next step.

# Build the ExecuteMethod to call in Unity based on template choice
UNITY_METHOD="SetupProject.ConfigureProjectSettings"  # always configure base settings first
if [[ "$USE_URP" == "yes" ]]; then
    UNITY_METHOD="${UNITY_METHOD};SetupProject.AddURP"
elif [[ "$USE_HDRP" == "yes" ]]; then
    UNITY_METHOD="${UNITY_METHOD};SetupProject.AddHDRP"
fi
if [[ "$TEMPLATE_CHOICE" == "2" ]]; then  # 2D
    UNITY_METHOD="${UNITY_METHOD};SetupProject.SetupFor2D"
elif [[ "$TEMPLATE_CHOICE" == "1" ]]; then  # 3D
    UNITY_METHOD="${UNITY_METHOD};SetupProject.SetupFor3D"
fi

echo "Configuring Unity project settings (applying template-specific adjustments)..."
# Run Unity in batch mode to execute the setup script's methods
if ! "$DEFAULT_EDITOR_PATH" -batchmode -quit -projectPath "$PROJECT_PATH" -executeMethod "$UNITY_METHOD"; then
    echo "Warning: Unity project configuration step encountered an error. Check logs for details." >&2
    # (We won't treat as fatal; the project is still created. User can adjust settings manually if needed.)
fi

# 8. Import any external unitypackage if provided (for either custom template or additional package)
IMPORT_PKG_PATH=""
if [[ "$USE_CUSTOM" == "yes" && -f "$CUSTOM_TEMPLATE_PATH" && "$CUSTOM_TEMPLATE_PATH" == *.unitypackage ]]; then
    IMPORT_PKG_PATH="$CUSTOM_TEMPLATE_PATH"
else
    # Ask user if they want to import any additional unitypackage (only if not already doing a custom unitypackage)
    read -rp "Path to a .unitypackage to import (or leave blank to skip): " EXTRA_PKG
    EXTRA_PKG=${EXTRA_PKG:-}
    if [[ -n "$EXTRA_PKG" ]]; then
        if [[ ! -f "$EXTRA_PKG" || "$EXTRA_PKG" != *.unitypackage ]]; then
            echo "Warning: '$EXTRA_PKG' is not a valid .unitypackage file. Skipping import."
        else
            IMPORT_PKG_PATH="$EXTRA_PKG"
        fi
    fi
fi

if [[ -n "$IMPORT_PKG_PATH" ]]; then
    echo "Importing Unity package '$IMPORT_PKG_PATH' into project..."
    if ! "$DEFAULT_EDITOR_PATH" -batchmode -projectPath "$PROJECT_PATH" -importPackage "$IMPORT_PKG_PATH" -quit; then
        echo "Warning: Failed to import package $IMPORT_PKG_PATH. You may import it manually." >&2
    else
        echo "Package imported successfully."
    fi
fi

# 9. Git repository initialization (if chosen)
read -rp "Initialize a git repository in the project? (y/N): " GIT_CHOICE
GIT_CHOICE=${GIT_CHOICE:-N}
if [[ "$GIT_CHOICE" =~ ^[Yy]$ ]]; then
    echo "Initializing git repository..."
    git init "$PROJECT_PATH" || error_exit "Failed to initialize git repository."
    # Create Unity .gitignore
    echo "Creating .gitignore with Unity-specific rules..."
    cat > "$PROJECT_PATH/.gitignore" << 'GIEOF'
# Unity generated folders
[Ll]ibrary/
[Tt]emp/
[Oo]bj/
[Bb]uild/
[Bb]uilds/
[Ll]ogs/
MemoryCaptures/
# Asset meta data should be tracked, but not generated meta files
/[Aa]ssets/**/*.meta
# Autogenerated VS/MD/JetBrains project files
*.csproj
*.sln
*.unityproj
*.pidb
*.userprefs
*.user
*.booproj
*.svd
*.tmp
*.ide
*.suo
# Unity Cache files
/[Uu]serSettings/
# Packages
*.unitypackage
*.unitypackage.meta
# OS-specific files
.DS_Store
Thumbs.db
GIEOF
    # (The .gitignore above covers Unity cache and build directories, OS files, etc.)
    # Optional: initial commit
    read -rp "Create initial Git commit? (y/N): " COMMIT_CHOICE
    COMMIT_CHOICE=${COMMIT_CHOICE:-N}
    if [[ "$COMMIT_CHOICE" =~ ^[Yy]$ ]]; then
        git -C "$PROJECT_PATH" add . 
        git -C "$PROJECT_PATH" commit -m "Initial Unity project setup"
        echo "Initial commit created."
    fi
fi

# 10. Include example script/assets (if chosen)
read -rp "Include an example script in the project? (y/N): " EXAMPLE_CHOICE
EXAMPLE_CHOICE=${EXAMPLE_CHOICE:-N}
if [[ "$EXAMPLE_CHOICE" =~ ^[Yy]$ ]]; then
    echo "Creating example Unity script..."
    SCRIPTS_DIR="$PROJECT_PATH/Assets/Scripts"
    mkdir -p "$SCRIPTS_DIR"
    cat > "$SCRIPTS_DIR/ExampleScript.cs" << 'SCRPT'
using UnityEngine;
public class ExampleScript : MonoBehaviour
{
    void Start()
    {
        Debug.Log("ExampleScript is running. Hello from the automated setup!");
    }
}
SCRPT
    echo "ExampleScript.cs created under Assets/Scripts. (Attach it to a GameObject to test after opening the project.)"
fi

echo "✅ Unity project setup is complete! You can now open '$PROJECT_NAME' in Unity and start developing."
echo "Unity Project Path: $PROJECT_PATH"

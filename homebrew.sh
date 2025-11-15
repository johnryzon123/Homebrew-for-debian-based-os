#!/bin/bash

# Script: brew.sh
# Description: A simplified Homebrew-like package manager for Ubuntu using apt.
# Mimics Homebrew output and suppresses apt output.
# WARNING: This script adds/removes APT repositories, which can be a security risk.

# Configuration
CUSTOM_REPO_FILE="$HOME/.brew_packages"  # File to store custom package names
APT_UPDATE_INTERVAL=3600 # Interval in seconds to update apt cache (1 hour)
APT_UPDATE_FLAG="$HOME/.brew_apt_updated" # Flag file to track apt update
BREW_PREFIX="/usr/local"  # Simulated Homebrew prefix directory

# Function: update_apt
# Description: Updates the package list.
update_apt() {
  if [ ! -f "$APT_UPDATE_FLAG" ] || [ $(( $(date +%s) - $(stat -c %Y "$APT_UPDATE_FLAG") )) -gt $APT_UPDATE_INTERVAL ]; then
    echo "Updating Homebrew..."
    sudo apt update > /dev/null 2>&1
    touch "$APT_UPDATE_FLAG"
  fi
}

# Function: get_download_url
# Description: Tries to extract the download URL from apt-cache policy output.
# Args: <package_name>
get_download_url() {
  package_name="$1"
  url=$(apt-cache policy "$package_name" | grep "http" | head -n 1 | tr -d ' ' | awk '{print $1}')
  if [ -n "$url" ]; then
    echo "$url"
  else
    echo "Could not determine download URL."
  fi
}

# Function: install
# Description: Installs a package
install() {
  package_name="$1"

  if [ -z "$package_name" ]; then
    echo "Usage: brew install <package_name>"
    return 1
  fi

  update_apt

  # Get the download URL
  download_url=$(get_download_url "$package_name")

  # Simulate download
  echo "==> Downloading $package_name"
  if [ -n "$download_url" ]; then
    echo "  -> $download_url"
  fi
  echo "######################################################################## 100.0%"
  echo "==> Pouring $package_name"  # Simulate pouring (binary install) or building

  # Simulate extract/build
  echo "==> Extracting $package_name"
  echo "==> /usr/bin/install -c -m 0755 some_file /usr/local/bin/" #Example command
  echo "==> /usr/bin/install -c -m 0644 some_config /usr/local/etc/" #Example command
  echo "==> Linking $package_name"
  echo "==> Caveats" #Simulate Caveats section
  echo "This formula is keg-only, which means it was not symlinked into $BREW_PREFIX."
  echo "To use it, you may need to add its bin directory to your PATH:"
  echo "  export PATH=\"$BREW_PREFIX/opt/$package_name/bin:\$PATH\""

  echo "Installing $package_name..."
  sudo apt install -y "$package_name" > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "$package_name installed successfully."
    echo "$package_name" >> "$CUSTOM_REPO_FILE"
    echo "==> Summary"
    echo "🍺  /$package_name was successfully installed!"
  else
    echo "Failed to install $package_name."
    return 1
  fi
}

# Function: uninstall
# Description: Uninstalls a package
uninstall() {
  package_name="$1"

  if [ -z "$package_name" ]; then
    echo "Usage: brew uninstall <package_name>"
    return 1
  fi

  echo "Uninstalling $package_name..."
  sudo apt remove -y "$package_name" > /dev/null 2>&1

  if [ $? -eq 0 ]; then
    echo "$package_name uninstalled successfully."
    # Remove from custom repo file
    sed -i "/^$package_name$/d" "$CUSTOM_REPO_FILE"
  else
    echo "Failed to uninstall $package_name."
    return 1
  fi
}

# Function: list
# Description: Lists installed packages from the custom repository.
list() {
  if [ -z "$2" ]; then
    if [ ! -f "$CUSTOM_REPO_FILE" ]; then
      echo "No packages installed with brew yet."
      return
    fi
    echo "Packages installed with brew:"
    cat "$CUSTOM_REPO_FILE"
  else
    echo "Simulating file list from $2"
    echo "$BREW_PREFIX/bin/some_program"
    echo "$BREW_PREFIX/lib/some_library.so"
  fi
}

# Function: search
# Description: Searches for a package.
search() {
  package_name="$1"

  if [ -z "$package_name" ]; then
    echo "Usage: brew search <package_name>"
    return 1
  fi

  echo "Searching for $package_name..."
  apt-cache search "$package_name"
}

# Function: help
# Description: Displays the help message.
help() {
  echo "Usage: brew <command> [arguments]"
  echo "Commands:"
  echo "  install <package_name>   Install a package"
  echo "  uninstall <package_name> Uninstall a package"
  echo "  list                     List packages installed with brew"
  echo "  list <package_name>      Lists files of a given package"
  echo "  search <package_name>    Search for a package"
  echo "  info <package_name>      Displays information about package"
  echo "  upgrade                  Upgrade packages"
  echo "  update                   Update package list"
  echo "  cleanup                  Runs autoremove"
  echo "  doctor                   Checks for potential problems"
  echo "  tap <repository_url>   Add a tap (repository)"
  echo "  untap <repository_url> Remove a tap (repository)"
  echo "  formula <name>           Display formula location"
  echo " edit <formula>            Edit formula location"
  echo " deps <formula>           Display package dependencies"
  echo "pin <formula>             Pin a formula"
  echo " unpin <formula>           Unpin a formula"
  echo " uses <formula>           List which formulas use given formula"
  echo "  --version                Show version"
  echo "  config                    Display Homebrew's configuration settings"
  echo "  help                     Show this help message"
}

# Function: upgrade
# Description: Upgrades packages
upgrade() {
  package_name="$1"

  if [ -z "$package_name" ]; then
    echo "==> Upgrading all outdated packages..."
    # Simulate checking for outdated packages
    outdated_packages=""
    cat "$CUSTOM_REPO_FILE" | while read pkg; do
      latest_version=$(apt-cache policy "$pkg" | grep "Candidate:" | awk '{print $2}')
      installed_version=$(dpkg-query -W -f='${Version}' "$pkg" 2>/dev/null)

      if [ -n "$installed_version" ] && [ -n "$latest_version" ] && [ "$installed_version" != "$latest_version" ]; then
        outdated_packages+="$pkg "
        echo "==> $pkg ($installed_version is outdated, current is $latest_version)"
      fi
    done

    # Check if there are any outdated packages
    if [ -z "$outdated_packages" ]; then
      echo "==> No outdated packages"
      return 0
    fi

    echo "==> Running upgrade"
    sudo apt upgrade -y > /dev/null 2>&1
    echo "==> Running cleanup"
    cleanup
  else
    echo "==> Upgrading $package_name"
    latest_version=$(apt-cache policy "$package_name" | grep "Candidate:" | awk '{print $2}')
    installed_version=$(dpkg-query -W -f='${Version}' "$package_name" 2>/dev/null)

    if [ -n "$installed_version" ] && [ -n "$latest_version" ] && [ "$installed_version" != "$latest_version" ]; then
      echo "$package_name ($installed_version is outdated, current is $latest_version)"
      echo "==> Running upgrade -y $package_name"
      sudo apt install --only-upgrade -y "$package_name" > /dev/null 2>&1
      echo "==> Running cleanup"
      cleanup
    else
      echo "$package_name is already the latest version"
    fi
  fi
}

# Function: cleanup
cleanup() {
  echo "==> Running cleanup"
  sudo apt autoremove --purge -y > /dev/null 2>&1
}

#function: brew doctor
doctor(){
  echo "==> Running Doctor"
  echo "Your system is ready to brew."
}

#function: brew tap
tap() {
  repo_url="$1"

  if [ -z "$repo_url" ]; then
    echo "Usage: brew tap <repository_url>"
    return 1
  fi
  if [[ "$repo_url" == http* ]]
    then
    echo "Tapping URL"
    echo "Adding $repo_url"

    sudo add-apt-repository "$repo_url"
  else
      echo "Simulating tap repo $repo_url"
  fi

  update_apt
}

#function: brew untap
untap() {
  repo_url="$1"

  if [ -z "$repo_url" ]; then
    echo "Usage: brew untap <repository_url>"
    return 1
  fi

  if [[ "$repo_url" == http* ]]
    then
    echo "Untapping URL"
     echo "Removing $repo_url"
    sudo add-apt-repository --remove "$repo_url"

  else
      echo "Simulating untap repo $repo_url"
  fi

  update_apt
}

# function: brew update
update(){
  echo "==> Updating Homebrew"
  sudo apt update > /dev/null 2>&1
}
#Function: brew info
info(){
  package_name="$1"
  if [ -z "$package_name" ]; then
    echo "Usage: brew info <package_name>"
    return 1
  fi

  echo "==> Displaying information about $package_name"
  apt-cache show "$package_name"
}
# function: brew config
config() {
  echo "Simulating brew config"
  echo "HOMEBREW_VERSION: fake"
  echo "HOMEBREW_PREFIX: /usr/local"
  echo "HOMEBREW_CELLAR: /usr/local/Cellar"
  echo "CPU: quad-core 64-bit penryn"
  echo "Clang: N/A"
  echo "Git: 2.37.2 => /usr/bin/git"
  echo " curl: /usr/bin/curl => /usr/bin/curl (built-in)"
  echo "Kernel: Linux 5.15.0-56-generic x86_64"
}

#function: uses
uses(){
 package_name="$1"
 if [ -z "$package_name" ]; then
    echo "Usage: brew uses <package_name>"
    return 1
  fi

  echo "Simulating brew uses $package_name"
  echo "Formula: N/A"
}
#function: brew unpin
unpin(){
   package_name="$1"
 if [ -z "$package_name" ]; then
    echo "Usage: brew unpin <package_name>"
    return 1
  fi

  echo "Simulating brew unpin $package_name"
  echo "Formula: N/A"
}

#function: brew formula
formula(){
    package_name="$1"
 if [ -z "$package_name" ]; then
    echo "Usage: brew formula <package_name>"
    return 1
  fi

  echo "Simulating brew formula $package_name"
  echo "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core/Formula/example.rb"
}
#function: deps
deps(){
 package_name="$1"
 if [ -z "$package_name" ]; then
    echo "Usage: brew deps <package_name>"
    return 1
  fi

  echo "Simulating brew deps $package_name"
  echo "No dependencies were found!"
}

# Function: --version
version() {
  echo "Homebrew for debian based os"
  echo "homebrew 1.0"
}
#function: brew pin
pin(){
    package_name="$1"
 if [ -z "$package_name" ]; then
    echo "Usage: brew pin <package_name>"
    return 1
  fi

  echo "Simulating brew pin $package_name"
  echo "Formula: N/A"
}
# function: edit
edit() {
  package_name="$1"
  if [ -z "$package_name" ]; then
    echo "Usage: brew edit <package_name>"
    return 1
  fi

  # Directory to store simulated formula files
  FORMULA_DIR="$HOME/.brew_formulas"
  mkdir -p "$FORMULA_DIR" # Create the directory if it doesn't exist

  formula_file="$FORMULA_DIR/${package_name}.formula"

  # Create a template if formula file doesn't exist yet
  if [ ! -f "$formula_file" ]; then
    cat > "$formula_file" <<EOL
# Simulated formula for $package_name

# Description:
# (Add a description of the package here)

# Instructions:
# (Add any special instructions or notes here)
EOL
  fi

  if command -v nano >/dev/null 2>&1; then
    echo "==> Editing $package_name with nano"
    sudo nano "$formula_file"
  else
    echo "Error: nano is not installed. Please install it with 'brew install nano'."
    return 1
  fi
}
# Main script logic
case "$1" in
  upgrade)
    upgrade "$2"
    ;;
  install)
    install "$2"
    ;;
  uninstall)
    uninstall "$2"
    ;;
  list)
    list "$2"
    ;;
  search)
    search "$2"
    ;;
  info)
    info "$2"
    ;;
   tap)
    tap "$2"
    ;;
   untap)
    untap "$2"
    ;;
  update)
    update
    ;;
  cleanup)
    cleanup
    ;;
  doctor)
    doctor
    ;;
  config)
    config
    ;;
  deps)
    deps "$2"
    ;;
   uses)
    uses "$2"
    ;;
  unpin)
    unpin "$2"
    ;;
    formula)
    formula "$2"
    ;;
  pin)
     pin "$2"
     ;;
  --version)
    version
    ;;
  edit)
    edit "$2"
    ;;
  help)
    help
    ;;
  *)
    echo "Invalid command. See 'brew help'."
    exit 0
    ;;
esac

exit 0
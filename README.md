# homebrew: A Simplified Homebrew-like Package Manager for Debian based os

This project provides a simplified, Homebrew-inspired package manager for Ubuntu Linux, built as a shell script wrapper around `apt`. It aims to provide a more user-friendly and familiar command-line experience for users accustomed to Homebrew on macOS.

**WARNING: This is a simplified simulation and uses `apt` underneath. Many commands are simulations, and are not accurate. Use at your own risk.**

## Features

*   **Familiar Homebrew-style commands:**
    *   `brew install <package_name>`: Installs a package using `apt`.
    *   `brew uninstall <package_name>`: Uninstalls a package using `apt`.
    *   `brew upgrade`: Upgrades all outdated packages using `apt`.
    *   `brew search <package_name>`: Searches for packages in the `apt` cache.
    *   `brew list`: Lists packages installed via `brew.sh`.
    *   `brew info <package_name>`: Displays information about a package using `apt-cache show`.
    *   `brew update`: Updates the `apt` package list.
    *   `brew cleanup`: Runs `apt autoremove` to remove unused dependencies.
    *   `brew doctor`: Performs a basic system check (currently a simulation).
    *   `brew tap <repository_url>`: Adds an APT repository.
    *   `brew untap <repository_url>`: Removes an APT repository.
    *   `brew formula <formula>`: Displays a dummy formula location.
    *   `brew edit <formula>`: Opens a "formula" file in `nano` for editing (creates a stub file if it doesn't exist).
    *   `brew deps <formula>`: Display dependencies (currently a simulation).
    *   `brew pin <formula>`: Simulates pinning a formula.
    *   `brew unpin <formula>`: Simulates unpinning a formula.
    *   `brew uses <formula>`: Simulate usage of formula.
    *   `brew config`: Shows brew config.
    *   `brew --version`: Shows the APT version.

*   **Homebrew-like output:** The script attempts to mimic the output style of Homebrew, providing a more visually familiar experience.

*   **Simplified dependency management:** Relies on `apt` for dependency resolution.

**WARNING**
This program supports adding taps that calls `sudo add-apt-repository`.

## Installation

1.  **Download the `brew.sh` and `installer.sh` scripts:**
    [brew.sh](link to the raw file) and [installer.sh](link to the raw file)
     Or, clone this repository.

2.  **Make the scripts executable:**
   ```bash chmod +x brew.sh installer.sh `````
3. **Run the installer:**
   ```bash ./install.sh `````
  This will copy the brew.sh script to ~/bin,
  add an alias to your .bashrc or .zshrc file, and source the file to activate the alias.

## Usage

After installation, you can use the `brew` command as you would with Homebrew:

```bash
brew install <package_name>
brew search <package_name>
brew update
brew upgrade
brew list
brew help
`````

## Configuration

1. **CUSTOM_REPO_FILE:** (Default: $HOME/.brew_packages) - File to store a custom list of installed
2. **APT_UPDATE_INTERVAL:** (Default: 3600 seconds) - Interval in seconds to update the apt package cache.

## Limitations

1. **Not a full Homebrew replacement:** This is a simplified simulation and does not provide the full functionality of the real Homebrew.
2. **Uses apt underneath:** The core package management is handled by apt. The output is a simulation, and may not be accurate.
3. **Limited error handling:** Error messages might not be as informative as those provided by Homebrew.
4. **Security:** Always be careful when adding external repositories.

## Security
Be aware that adding external repositories can be a security risk. Only add repositories that you trust.

## Disclaimer
this project is intended for educational and demonstration purposes only. Use it at your own risk.

## License
MIT License

## Author
johnryzon Z. Abejero
johnryzon142

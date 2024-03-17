# Vim-Dev-Setup
Vim setup script which includes a variety of plugins to enhance Quality of Life of VIM and support for Rust, Bash, Python

## Prerequisites

- Linux-based operating system.
- Superuser (**root**) privileges are required to execute the script.
- Internet connection for downloading packages and Vim plugins.

## Script Features

- **Root Privilege Check:** Ensures the script is executed with root permissions to install necessary packages and perform system configurations.

- **User Home Directory Detection:** Dynamically identifies the user's home directory for configuring Vim in a user-specific context, especially useful when running the script with sudo.

- **Package Manager Detection and Update:** Identifies the system's package manager and updates the package lists to ensure that the latest versions of packages and dependencies are installed.

- **Vim Installation:** Checks if Vim is already installed; if not, installs it using the system's package manager.

- **Vim-Plug Installation:** Installs Vim-Plug, a powerful plugin manager for Vim, enabling easy plugin management.

- **Vim Configuration and Plugin Setup:** Generates a new .vimrc configuration file or backs up an existing one, then configures Vim with a predefined set of plugins and settings to enhance the development experience.

- **Additional Dependencies Check:** Ensures necessary software for the full functionality of the installed plugins (such as curl, git, python3, cargo) is present and installs any missing ones.

## Usage

To use this script, follow these steps:

- Download the script to your local machine.

- Open a terminal and navigate to the directory containing the script.

- Make the script executable with the following command:

  ```
  chmod +x vim_setup.sh
  ```

- Execute the script with root privileges:
  ```
  sudo ./vim_setup.sh
  ```

## Script Breakdown

- **Initial Checks:** Verifies root access and determines the user's home directory for subsequent configurations.

- **Package Manager Handling:** Adapts to the specific Linux distribution by detecting the appropriate package manager and setting update and installation commands accordingly.

- **Vim Setup:** Installs Vim if it's not already present and sets up Vim-Plug for managing additional plugins.

- **Plugin Configuration:** Applies a comprehensive set of Vim plugins and settings through the .vimrc file, tailored for an enhanced coding environment. This includes plugins for syntax highlighting, file navigation, version control, and more.

- **Final Steps:** Installs essential plugins via Vim-Plug and ensures all required dependencies for the plugins are installed.

## Troubleshooting

- If the script exits unexpectedly, verify that you have superuser (root) privileges.
- Ensure your internet connection is stable throughout the installation process.
- Check the compatibility of the script with your Linux distribution, as it supports the most common package managers (apt, pacman, dnf, zypper).

## Customization

You can customize the .vimrc configuration and the list of plugins according to your preferences.

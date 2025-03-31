#!/bin/zsh

# Define color variables
RED="\033[0;31m" # Report cancellations or errors
GREEN="\033[0;32m" # Confirm that certain actions were completed successfully, such as updates completed
YELLOW="\033[1;33m" # Shows information about local and available versions, as well as confirmation requests
BLUE="\033[0;34m" # Indicate important steps in the process, such as downloads, checkouts, and installations

# Function to update packages
update_packages() {
    echo -e "${BLUE}Updating packages ..."
    sudo apt update && sudo apt full-upgrade && sudo apt autoremove && sudo apt autoclean && sudo apt clean
    echo
}

# get_local_kitty_version {
#   kitty -v | head -n 1 | awk '{print $2}'
# }

# get_latest_kitty_version {
#   curl --silent "https://api.github.com/repos/kovidgoyal/kitty/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
# }
#
# update_kitty {
#   local latest_version = $(get_latest_kitty_version)
# }

# Function to get the current installed version of Neovim
get_local_nvim_version() {
    nvim --version | head -n 1 | awk '{print $2}'
}

# Function to get the latest version of Neovim available on GitHub
get_latest_nvim_version() {
    curl --silent "https://api.github.com/repos/neovim/neovim/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

# Function to download and install the latest Neovim AppImage
update_nvim() {
    local latest_version=$(get_latest_nvim_version)
    local appimage_url="https://github.com/neovim/neovim/releases/download/$latest_version/nvim.appimage"
    local appimage_path="/usr/local/bin/nvim.appimage"
    
    echo -e "${BLUE}Downloading Neovim $latest_version AppImage..."
    sudo curl -L $appimage_url -o $appimage_path
    
    echo -e "${BLUE}Making the AppImage executable..."
    sudo chmod +x $appimage_path
    
    echo -e "${BLUE}Creating a symlink to /usr/local/bin/nvim..."
    sudo ln -sf $appimage_path /usr/local/bin/nvim

    echo -e "${GREEN}Neovim updated to version $latest_version."
}

# Function to get the current installed version of Starship
get_local_starship_version() {
    starship --version | head -n 1 | awk '{print $2}'
    
}

# Function to get the latest version of Starship available on GitHub
get_latest_starship_version() {
    curl --silent "https://api.github.com/repos/starship/starship/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/'
}

# Function to download and install the latest Starship binary
update_starship() {
    local latest_version=$(get_latest_starship_version)
    local tarball_url="https://github.com/starship/starship/releases/download/v$latest_version/starship-x86_64-unknown-linux-gnu.tar.gz"
    local temp_dir=$(mktemp -d)
    
    echo -e "${BLUE}Downloading Starship $latest_version..."
    curl -L $tarball_url -o $temp_dir/starship.tar.gz
    
    echo -e "${BLUE}Extracting the tarball..."
    tar -xzf $temp_dir/starship.tar.gz -C $temp_dir
    
    echo -e "${BLUE}Installing Starship..."
    sudo mv $temp_dir/starship /usr/local/bin/
    
    echo -e "${BLUE}Cleaning up..."
    rm -rf $temp_dir

    echo -e "${GREEN}Starship updated to version $latest_version."
}

# Function to get the latest version of Discord available on their website
get_latest_discord_version() {
    curl --silent "https://discord.com/api/download?platform=linux&format=deb" -I | grep -i location | sed -E 's/.*discord-(.*)\.deb.*/\1/'
}

# Function to download and install the latest Discord .deb package
update_discord() {
    local latest_version=$(get_latest_discord_version)
    local deb_url="https://discord.com/api/download?platform=linux&format=deb"
    local deb_path="/tmp/discord-latest.deb"

    echo -e "${BLUE}Downloading Discord $latest_version .deb package..."
    curl -L $deb_url -o $deb_path

    echo -e "${BLUE}Installing Discord..."
    sudo dpkg -i $deb_path
    sudo apt-get install -f -y

    echo -e "${GREEN}Discord updated to version $latest_version."
}


# Update packages
update_packages

# Check and update Neovim
local_nvim_version=$(get_local_nvim_version)
latest_nvim_version=$(get_latest_nvim_version)

echo -e "${YELLOW}Local Neovim version: $local_nvim_version"
echo -e "${YELLOW}Latest Neovim version available: $latest_nvim_version"

if [[ "$local_nvim_version" != "$latest_nvim_version" ]]; then
    read -r "REPLY?${YELLOW}A new version of Neovim is available. Do you want to update Neovim? (Y/n) " REPLY
    REPLY=${REPLY:-Y}
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        update_nvim
    else
        echo -e "${RED}Neovim update canceled."
    fi
else
    echo -e "${GREEN}Neovim is already up to date."
fi
echo

# Check and update Starship
local_starship_version=$(get_local_starship_version)
latest_starship_version=$(get_latest_starship_version)

echo -e "${YELLOW}Local Starship version: $local_starship_version"
echo -e "${YELLOW}Latest Starship version available: $latest_starship_version"

if [[ "$local_starship_version" != "$latest_starship_version" ]]; then
    read -r "REPLY?${YELLOW}A new version of Starship is available. Do you want to update Starship? (Y/n) " REPLY
    REPLY=${REPLY:-Y}
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        update_starship
    else
        echo -e "${RED}Starship update canceled."
    fi
else
    echo -e "${GREEN}Starship is already up to date."
fi
echo

# Check and update Discord
local_discord_version="N/A" # Discord does not provide an easy way to get the current installed version via CLI
latest_discord_version=$(get_latest_discord_version)

echo -e "${YELLOW}Local Discord version: $local_discord_version"
echo -e "${YELLOW}Latest Discord version available: $latest_discord_version"

read -r "REPLY?${YELLOW}A new version of Discord is available. Do you want to update Discord? (Y/n) " REPLY
REPLY=${REPLY:-Y}
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    update_discord
else
    echo -e "${RED}Discord update canceled."
fi
echo

echo -e "${GREEN}Script finished."

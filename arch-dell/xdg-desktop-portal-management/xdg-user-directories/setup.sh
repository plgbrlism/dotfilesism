#!/usr/bin/env bash
set -euo pipefail

# 1. Update system defaults to only include essential directories
sudo tee /etc/xdg/user-dirs.defaults > /dev/null << 'EOF'
# Default settings for user directories
#
# The values are relative pathnames from the home directory and
# will be translated on a per-path-element basis into the users locale
DOWNLOAD=Downloads
DOCUMENTS=Documents
MUSIC=Music
PICTURES=Pictures
VIDEOS=Videos
EOF

# 2. Disable user-dirs-update globally
sudo mkdir -p /etc/xdg
echo "enabled=false" | sudo tee /etc/xdg/user-dirs.conf > /dev/null

# 3. Clean up user config and make it immutable to stop overwrites
mkdir -p ~/.config
cat > ~/.config/user-dirs.dirs << 'EOF'
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"
EOF

# Lock down the file against further modifications
chmod 444 ~/.config/user-dirs.dirs

# 4. Remove unwanted folders from home directory
rm -rf ~/Public ~/Desktop ~/Templates ~/Projects

echo "Cleanup complete! Unwanted XDG folders have been removed and system defaults updated."

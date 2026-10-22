# ~/.profile

# ~~ default apps ~~
export TERMINAL="kitty"
export EDITOR="micro"
export VISUAL="micro"
export MICRO_TRUECOLOR=1

# ~~ qt apps use qt6ct ~~
export QT_QPA_PLATFORMTHEME="qt6ct"
unset QT_STYLE_OVERRIDE

# ~~ cursor ~~
export XCURSOR_THEME="Twilight-cursors"
export XCURSOR_SIZE=30

# ~~ sys paths ~~
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/sbin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# ~~ node & bun ~~
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/scripts:$PATH"

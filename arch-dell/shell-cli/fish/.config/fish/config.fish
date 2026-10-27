# ~/.config/fish/config.fish

# ~~ color theme for tty ~~
if test "$TERM" = linux; and test -f $HOME/.cache/rizzoo/colors-tty.sh
    bash $HOME/.cache/rizzoo/colors-tty.sh
end

# ~~ welcome message ~~
set -g fish_greeting
if type -q fastfetch
    fastfetch
end

# ~~ environment variables ~~
set -gx TERMINAL "kitty"
set -gx EDITOR "micro"
set -gx VISUAL "micro"
set -gx MICRO_TRUECOLOR 1

set -gx QT_QPA_PLATFORMTHEME "qt6ct"
set --erase QT_STYLE_OVERRIDE

set -gx XCURSOR_THEME "Twilight-cursors"
set -gx XCURSOR_SIZE 30

# ~~ paths ~~
fish_add_path ~/.local/bin
fish_add_path /usr/local/bin
fish_add_path /usr/sbin
fish_add_path ~/.cargo/bin
fish_add_path ~/.bun/bin
fish_add_path ~/scripts

# ~~ custom script directory ~~
for dir in ~/scripts/*/
    fish_add_path $dir
end

# ~~ core ~~
# atuin
if type -q atuin
    atuin init fish --disable-up-arrow | source
end

# complete auto-suggestion via Ctrl + Space
function fish_user_key_bindings
    bind ctrl-space accept-autosuggestion 2>/dev/null; or bind \x00 accept-autosuggestion
end

# starship
if type -q starship
    starship init fish | source
end

# ~~ node/nvm ~~
if type -q fnm
    fnm env --use-on-cd --shell fish | source
end

# ~~ Bun Completions ~~
if test -s "$HOME/.local/share/bun/_bun"
    source "$HOME/.local/share/bun/_bun"
end

# ~~ aliases ~~
abbr -a zed zeditor

# mega-cmd
abbr -a vault-sync mega-sync
abbr -a vault-status mega-transfers
abbr -a vault-close mega-quit

# omniroute
abbr -a omniroute /home/paul/apps/omniroute/node_modules/.bin/omniroute

# myprojhelpers
abbr -a py-anki-mcq-builder "source ~/projects/anki-mcq-builder/.venv/bin/activate"
abbr -a image-curate "$HOME/scripts/images-curator/.venv/bin/python $HOME/scripts/images-curator/img-curate.py"

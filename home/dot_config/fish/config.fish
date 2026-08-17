fish_config theme choose catppuccin-mocha
set fish_greeting

set -x OP_PLUGIN_ALIASES_SOURCED 1
function gh --wraps gh --description "1Password shell plugin for GitHub CLI"
    op plugin run -- gh $argv
end

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SUDO_EDITOR nvim
set -gx MANPAGER 'nvim +Man!'
set -gx MANROFFOPT -c
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx SSH_AUTH_SOCK "$HOME/.1password/agent.sock"
set -gx MAKEFLAGS "--jobs="(nproc)
fish_add_path --global "$HOME/.config/emacs/bin" "$HOME/.local/bin" "$HOME/.cargo/bin" "$HOME/.local/share/bob/nvim-bin"

status is-interactive; and begin
    # Keep the logical /home path so Starship recognizes home on Atomic systems.
    if string match -q "/var/home/*" (pwd)
        cd (string replace -r "^/var/home/" "/home/" (pwd))
    end

    abbr --add -- consolidate-here 'fd -t f -X mv -b -t .; fd -t d -x rmdir'
    abbr --add -- fu 'flatpak uninstall --user --delete-data'
    abbr --add -- ga 'git add --all'
    abbr --add -- chd 'chezmoi diff'
    abbr --add -- chr 'chezmoi re-add'
    abbr --add -- cha 'chezmoi apply -v'
    abbr --add -- chp 'chezmoi git -- push'
    abbr --add -- che 'chezmoi edit-config'
    abbr --add -- gc 'git commit'
    abbr --add -- gcl 'git clone'
    abbr --add -- gcm 'git commit -m'
    abbr --add -- gd 'git diff'
    abbr --add -- gi 'git init'
    abbr --add -- gp 'git push'
    abbr --add -- gst 'git status --short'
    abbr --add -- gu 'git pull'
    abbr --add -- sshc 'ssh cloud'
    abbr --add -- rmr 'rm -rf'
    abbr --add -- rm 'rm -i'

    alias .. 'cd ..'
    alias ... 'cd ../..'
    alias bonsai 'cbonsai -S -t 10 --life 60'
    alias c z
    alias cat 'bat --style header --style snip --style changes --style header'
    alias ci zi
    alias ff fastfetch
    alias grep 'ugrep --color=auto'
    alias ifone 'rsync -ahvP ~/mnt/DCIM/* "$HOME/backupDir"'
    alias ip 'ip -color'
    alias jctl 'journalctl -p 3 -xb'
    alias la 'lsd -A'
    alias less 'bat --paging=always --pager=less'
    alias lg lazygit
    alias ll 'lsd -l'
    alias lla 'lsd -lA'
    alias llt 'lsd -l --tree'
    alias ls lsd
    alias lt 'lsd --tree'
    alias navi "rsync -havP --exclude '*.m3u' --delete -e ssh ~/Music/* my@cloud:/home/my/navi/music"
    alias sshc 'ssh cloud'
    alias svim sudoedit
    alias v nvim
    alias yt yt-dlp

    fzf --fish | source
    zoxide init fish | source
    if test "$TERM" != dumb
        starship init fish | source
    end

    # cargo
    source "$HOME/.cargo/env.fish"

    if set -q KITTY_INSTALLATION_DIR
        set --global KITTY_SHELL_INTEGRATION no-rc
        source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
        set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
    end
    if set -q GHOSTTY_RESOURCES_DIR; and test -r "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
        source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
    end
end

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

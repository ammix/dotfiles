# Environment
load-env {
  EDITOR: "nvim"
  VISUAL: "nvim"
  SUDO_EDITOR: "nvim"
  MANPAGER: "nvim +Man!"
  MANROFFOPT: "-c"
  OPENCODE_EXPERIMENTAL: "true"
  VIRTUAL_ENV_DISABLE_PROMPT: "1"
}

# Integrations
source ~/.config/nushell/vendor/catppuccin-mocha.nu
source ~/.config/nushell/vendor/zoxide.nu
use ~/.config/nushell/vendor/starship.nu
source ~/.config/nushell/vendor/fzf.nu

# Options
$env.config.buffer_editor = "nvim"
$env.config.show_banner = false
$env.config.edit_mode = "vi"

$env.config.completions.external = {
  enable: true
  max_results: 100
  completer: {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
  }
}

# Aliases
alias fu = flatpak uninstall --user --delete-data

alias ga = git add
alias gaa = git add --all
alias gc = git commit
alias gcm = git commit -m
alias gst = git status
alias gp = git push
alias gpl = git pull
alias gd = git diff
alias gra = git remote add
alias gcl = git clone

alias ".." = cd ..
alias "..." = cd ../..
alias "c" = z
alias "cat" = bat --style header --style snip --style changes --style header
alias "ci" = zi
alias "eza" = eza --icons always --color always --group-directories-first
alias "ff" = fastfetch
alias "grep" = ugrep --color=auto
alias "ip" = ip -color
alias "jctl" = journalctl -p 3 -xb
alias "less" = bat --paging=always --pager=less
alias "lg" = lazygit
alias "sshc" = ssh cloud
alias "svim" = sudoedit
alias "v" = nvim
alias "yt" = yt-dlp

# Commands
def extract [file: string] {
  let ext = ($file | path parse | get extension)
  let stem = ($file | path parse | get stem)
  match $ext {
    "tar" | "gz" | "tgz" | "bz2" | "tbz2" | "xz" | "txz" | "zst" | "tzst" => { tar -xvf $file }
    "zip" | "7z" | "rar" | "jar" | "war" | "ear" => { 7z x $file $"-o($stem)" }
    _ => { error make {msg: $"cannot extract unknown archive type: ($file)"} }
  }
}

def fbackup [file: string] {
  cp $file $"($file).bak"
}

def --env dev [] {
  let selected = (ls ~/Projects | where type == dir | get name | to text | fzf | str trim)
  if ($selected | is-not-empty) {
    cd $selected
    nvim
  }
}

def --env y [...args] {
  let state_dir = ($nu.home-path | path join .local state yazi)
  mkdir $state_dir
  let cwd_file = ($state_dir | path join cwd)
  ^yazi ...$args --cwd-file $cwd_file
  let cwd = (open $cwd_file)
  if $cwd != "" and $cwd != $env.PWD {
    cd $cwd
  }
}

# Hooks
$env.config.hooks.pre_prompt = (
  $env.config.hooks.pre_prompt?
  | default []
  | append {||
      let values = (direnv export json | from json --strict | default {})
      $values | items {|key, value| [$key $value] } | where {|pair| $pair.1 != null } | into record | load-env
    }
)

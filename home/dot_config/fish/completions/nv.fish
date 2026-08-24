complete -c nv -f

function __fish_nv_needs_command
    not __fish_seen_subcommand_from install use update rollback status help
end

complete -c nv -n __fish_nv_needs_command -a install -d 'Install or update a channel'
complete -c nv -n __fish_nv_needs_command -a use -d 'Install or update a channel, then select it'
complete -c nv -n __fish_nv_needs_command -a update -d 'Update installed channels'
complete -c nv -n __fish_nv_needs_command -a rollback -d 'Swap current and previous releases'
complete -c nv -n __fish_nv_needs_command -a status -d 'Show channel and release status'
complete -c nv -n __fish_nv_needs_command -a help -d 'Show help'
complete -c nv -n __fish_nv_needs_command -s h -l help -d 'Show help'

complete -c nv -n '__fish_seen_subcommand_from install use rollback; and not __fish_seen_subcommand_from stable nightly' -a stable -d 'Stable Neovim'
complete -c nv -n '__fish_seen_subcommand_from install use rollback; and not __fish_seen_subcommand_from stable nightly' -a nightly -d 'Nightly Neovim'

complete -c nv -n '__fish_seen_subcommand_from update; and not __fish_seen_subcommand_from stable nightly all' -a stable -d 'Stable Neovim'
complete -c nv -n '__fish_seen_subcommand_from update; and not __fish_seen_subcommand_from stable nightly all' -a nightly -d 'Nightly Neovim'
complete -c nv -n '__fish_seen_subcommand_from update; and not __fish_seen_subcommand_from stable nightly all' -a all -d 'All installed channels'

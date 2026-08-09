function chc --description 'Stage and commit Chezmoi changes'
    if test (count $argv) -eq 0
        echo 'usage: chc COMMIT MESSAGE' >&2
        return 2
    end

    set -l message (string join ' ' -- $argv)

    chezmoi git -- add -A
    or return

    chezmoi git -- commit -m "$message"
end

function dev
    if not set -q KITTY_WINDOW_ID
        echo 'dev requires kitty' >&2
        return 1
    end

    set -l project (find "$HOME/Projects" -mindepth 1 -maxdepth 1 -type d | fzf)
    test -n "$project"; or return

    set -l project_name (path basename "$project")
    set -l session_name "$project_name.project"

    if kitten @ ls | jq -e --arg session "$session_name" \
            'any(.[].tabs[].windows[]; .session_name == $session)' >/dev/null
        kitten @ action goto_session "$session_name"
        return
    end

    kitten @ launch --type=tab --add-to-session="$session_name" \
        --tab-title="$project_name" --cwd="$project" \
        fish -lc 'if test -f Session.vim; exec nvim -S Session.vim; else; exec nvim .; end' >/dev/null
    or return

    kitten @ launch --type=tab --keep-focus --add-to-session="$session_name" \
        --tab-title=shell --cwd="$project" >/dev/null
    or return

    kitten @ action goto_session "$session_name"
end

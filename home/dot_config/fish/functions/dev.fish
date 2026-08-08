function dev
    set selected (find ~/Projects -mindepth 1 -maxdepth 1 -type d | fzf)
    if test -n "$selected"
        cd $selected
        nvim
    end
end

function targz
    set -l dir_name (string trim --right --char=/ $argv[1])
    tar -czvf "$dir_name.tar.gz" "$dir_name"
    echo "Created '$dir_name.tar.gz'"
end

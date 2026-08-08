function consolidate-into
    mkdir -p $argv[1]
    fd -t f -X mv -b -t $argv[1]
    fd -t d -E $argv[1] -x rmdir
end

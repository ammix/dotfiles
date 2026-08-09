function extract
    switch "$argv[1]"
        case "*.tar" "*.tar.gz" "*.tgz" "*.tar.bz2" "*.tbz2" "*.tar.xz" "*.txz" "*.tar.zst" "*.tzst"
            tar -xvf "$argv[1]"
        case "*.zip" "*.7z" "*.jar" "*.war" "*.ear"
            set dirname (path change-extension "" "$argv[1]")
            7z x "$argv[1]" -o"$dirname"
        case "*.rar"
            set archive "$argv[1]"
            set dirname (path change-extension "" "$archive")
            mkdir -p "$dirname"
            unrar x "$archive" "$dirname/"
        case "*.gz"
            gunzip "$argv[1]"
        case "*.bz2"
            bunzip2 "$argv[1]"
        case "*"
            echo "Cannot extract '$argv[1]': Unknown format."
            return 1
    end
end

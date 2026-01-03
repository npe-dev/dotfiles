ss () {
    PPWD=$PWD
    cd "$CLIENT_ROOT/docker-$CURRENT_APP" && ./stack "$@"
    cd "$PPWD"
}

bf () {
    print -n "Enter the string to encode: "
    read -s input
    echo
    encoded=$(echo -n "$input" | base64)
    echo "$encoded"
    echo -n "$encoded" | pbcopy
    echo "(Copied to clipboard)"
}

obf () {
    if [[ -n "$1" ]]; then
        input="$1"
    else
        printf "Enter the string to encode: "
        read -s input
        echo
    fi

    encoded=$(echo -n "$input" | base64)
    echo "$encoded"
    echo -n "$encoded" | pbcopy
    echo "(Copied to clipboard)"
}

unobf () {
    if [[ -n "$1" ]]; then
        input="$1"
    else
        print -n "Enter the base64 string to decode: "
        read -s input
        echo
    fi

    if decoded=$(echo -n "$input" | base64 -d 2>/dev/null); then
        echo "$decoded"
        echo -n "$decoded" | pbcopy
        echo "(Copied to clipboard)"
    else
        echo "Error: Invalid base64 input."
    fi
}

lint() {
    composer lint "$1"
}

pstan() {
    vendor/bin/phpstan analyse --memory-limit=-1 "$1"
}

cc() {
    gto
    git fetch
    ticket_link="$1"
    ticket_identifier=$(echo "$ticket_link" | sed -E 's/^.*\/([A-Z]+-[0-9]+).*/\1/')
    git branch --all | grep "$ticket_identifier" | while IFS= read -r branch; do
        branch_name=$(echo "$branch" | sed 's#remotes/origin/##' | tr -d '[:space:]')
        echo "$branch_name"
    done

    if [ -z "$branch_name" ]; then
        echo "No branches found containing $ticket_identifier"
        return 1
    fi
    
    echo "Found branch containing $ticket_identifier: $branch_name"
    git checkout "$branch_name"
}

purgeCache() {
    gto
    rm -rf tmp/cache/twig/*
    rm -rf tmp/cache/mustache/* 
    rm -rf tmp/cache/translator/*
    cd -
}
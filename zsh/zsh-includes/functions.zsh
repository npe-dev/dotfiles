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

yml-validation() {
    export DEPLOYMENT=test
    export NAMESPACE=default
    export GO_PIPELINE_LABEL=latest
    export BACK_LARAVEL_WORKER_REPLICA_COUNT=1
    export BACK_LARAVEL_API_REPLICA_COUNT=1
    export FRONT_REPLICA_COUNT=1
    export CPU_LIMIT=100m
    export MEMORY_LIMIT=128Mi
    export CPU_REQUEST=50m
    export MEMORY_REQUEST=64Mi

    if [[ -z "$1" ]]; then
      echo "Usage: k8s-validate <file.yml> [file2.yml] ..."
      echo "       k8s-validate -d <directory>"
      return 1
    fi

    local ERRORS=0
    local FILES=()

    # Build file list if -d option is used
    if [[ "$1" == "-d" ]]; then
      if [[ -z "$2" ]]; then
        echo "Error: Directory path required after -d"
        return 1
      fi

      if [[ ! -d "$2" ]]; then
        echo "Error: Directory not found: $2"
        return 1
      fi

      # Find all yaml/yml files recursively
      while IFS= read -r -d '' file; do
        FILES+=("$file")
      done < <(find "$2" -type f \( -name "*.yml" -o -name "*.yaml" \) -print0)

      if [[ ${#FILES[@]} -eq 0 ]]; then
        echo "No YAML files found in: $2"
        return 1
      fi

      echo "Found ${#FILES[@]} YAML files in $2"
      echo "-----------------------------------"
    else
      FILES=("$@")
    fi

    for FILE in "${FILES[@]}"; do
      if [[ ! -f "$FILE" ]]; then
        echo "\033[0;31m✗\033[0m File not found: $FILE"
        ERRORS=$((ERRORS + 1))
        continue
      fi

      RENDERED=$(sed 's/{{\([^}]*\)}}/${\1}/g' "$FILE" | envsubst)

      if echo "$RENDERED" | kubeconform -strict -summary 2>&1; then
        echo "\033[0;32m✓\033[0m $FILE"
      else
        echo "\033[0;31m✗\033[0m $FILE"
        ERRORS=$((ERRORS + 1))
      fi
    done

    echo "-----------------------------------"
    if [[ $ERRORS -eq 0 ]]; then
      echo "\033[0;32mAll files valid!\033[0m"
    else
      echo "\033[0;31m$ERRORS file(s) failed validation\033[0m"
    fi

    return $ERRORS
}

purgeCache() {
    gto
    rm -rf tmp/cache/twig/*
    rm -rf tmp/cache/mustache/*
    rm -rf tmp/cache/translator/*
    cd -
}

kube() {
    local contexts
    contexts=($(kubectl config get-contexts -o name 2>/dev/null))

    if [[ ${#contexts[@]} -eq 0 ]]; then
        echo "No kubectl contexts found."
        return 1
    fi

    if [[ -n "$1" ]]; then
        if printf '%s\n' "${contexts[@]}" | grep -qx "$1"; then
            kubectl config use-context "$1"
        else
            echo "Context '$1' not found. Available clusters:"
            printf '  %s\n' "${contexts[@]}"
        fi
        return
    fi

    local current
    current=$(kubectl config current-context 2>/dev/null)

    echo "Available clusters:"
    for ctx in "${contexts[@]}"; do
        if [[ "$ctx" == "$current" ]]; then
            echo "  * $ctx (active)"
        else
            echo "    $ctx"
        fi
    done
}

aws-vault() {
    if [[ "$1" == "exec" && -z "$2" ]]; then
        echo "Available profiles:"
        command aws-vault list 2>/dev/null | awk 'NR>2 {print "  " $1}'
        return 0
    fi

    if [[ "$1" == "exec" ]]; then
        local new_profile="$2"

        if [[ -n "$AWS_VAULT" ]]; then
            [[ "$AWS_VAULT" == "$new_profile" ]] \
                && echo "Already in $AWS_VAULT context. Refreshing..." \
                || echo "Switching from $AWS_VAULT to $new_profile..."
            unset AWS_VAULT AWS_REGION AWS_DEFAULT_REGION \
                  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY \
                  AWS_SESSION_TOKEN AWS_SECURITY_TOKEN \
                  AWS_CREDENTIAL_EXPIRATION
        fi
    fi

    command aws-vault "$@"
}
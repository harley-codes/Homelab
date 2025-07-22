#!/bin/bash

# Dictionary-style config: source file as key, output file as value
declare -A CONFIG_FILES
CONFIG_FILES=(
	["./configuration/traefik/traefik.template.yml"]="./configuration/traefik/traefik.yml"
    ["./configuration/authelia/configuration.template.yml"]="./configuration/authelia/configuration.yml"
    ["./configuration/authelia/users_database.template.yml"]="./configuration/authelia/users_database.yml"
)

# List of env files
ENV_FILES=(
    "./.env"
    "../.env"
)

# For each env file, parse each config file with envsubst using ONLY the env file's variables
for env in "${ENV_FILES[@]}"; do
    if [ -f "$env" ]; then
        echo "Using env file: $env"
        # Read only variable names from env file
        VARS=$(grep -v '^#' "$env" | cut -d= -f1 | xargs)
        for config in "${!CONFIG_FILES[@]}"; do
            target="${CONFIG_FILES[$config]}"
            echo "Parsing $config with envsubst and $env..."
            (export $(grep -v '^#' "$env" | xargs) && envsubst "$(printf '${%s} ' $VARS)" < "$config" > "$target")
            echo "Output saved to $target"
        done
    fi
done
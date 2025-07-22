#!/usr/bin/env bash
set -euo pipefail

# Dictionary-style config: source → target
declare -A CONFIG_FILES=(
    ["./configuration/traefik/traefik.template.yml"]="./configuration/traefik/traefik.yml"
    ["./configuration/authelia/configuration.template.yml"]="./configuration/authelia/configuration.yml"
    ["./configuration/authelia/users_database.template.yml"]="./configuration/authelia/users_database.yml"
)

# .env files (order = precedence; later wins)
ENV_FILES=(
    "./.env"
    "../.env"
)

declare -A env_vars

# Load env vars into associative array, stripping quotes if present
for env_file in "${ENV_FILES[@]}"; do
    if [[ -f "$env_file" ]]; then
        while IFS= read -r line; do
            [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
            if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
                key="${BASH_REMATCH[1]}"
                value="${BASH_REMATCH[2]}"
                # Strip matching quotes (single or double)
                if [[ "$value" =~ ^\"(.*)\"$ ]]; then
                    value="${BASH_REMATCH[1]}"
                elif [[ "$value" =~ ^\'(.*)\'$ ]]; then
                    value="${BASH_REMATCH[1]}"
                fi
                env_vars["$key"]="$value"
            fi
        done < "$env_file"
    fi
done

# Replace placeholders in templates, ignoring ones surrounded by quotes
for src in "${!CONFIG_FILES[@]}"; do
    target="${CONFIG_FILES[$src]}"

    # Read full template content
    template_content=$(<"$src")

    for var in "${!env_vars[@]}"; do
        val="${env_vars[$var]}"

        # Escape backslashes and & for safe sed replacement
        escaped_val="${val//\\/\\\\}"
        escaped_val="${escaped_val//&/\\&}"

        # Replace unquoted ${VAR} occurrences only
        template_content=$(echo "$template_content" | \
            sed -E "s#([^\"'])\\\${$var}([^\"'])#\1${escaped_val}\2#g")
    done

    # Overwrite target file (create or replace)
    echo "$template_content" > "$target"
done

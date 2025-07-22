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

# Function to load environment variables from files
load_env_vars() {
    local env_files=("$@")
    declare -A env_vars

    for env_file in "${env_files[@]}"; do
        if [[ -f "$env_file" ]]; then
            while IFS= read -r line || [[ -n "$line" ]]; do
                # Skip empty lines and comments
                if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
                    continue
                fi

                # Remove quotes if they exist and extract key/value
                if [[ "$line" =~ ^([^=]+)=(['\"]?)(.*)(['\"]?)$ ]]; then
                    key="${BASH_REMATCH[1]}"
                    # Only remove quotes if they match (both opening and closing)
                    if [[ "${BASH_REMATCH[2]}" == "${BASH_REMATCH[4]}" && -n "${BASH_REMATCH[2]}" ]]; then
                        value="${BASH_REMATCH[3]}"
                    else
                        value="${BASH_REMATCH[2]}${BASH_REMATCH[3]}${BASH_REMATCH[4]}"
                    fi
                    env_vars["$key"]="$value"
                fi
            done < "$env_file"
        fi
    done

    # Return the associative array by printing key=value pairs
    for key in "${!env_vars[@]}"; do
        printf "%s=%s\n" "$key" "${env_vars[$key]}"
    done
}

# Function to process template files
process_templates() {
    local -n config_files=$1
    local env_vars=("$@")
    
    # Create a sed command file for all substitutions
    local sed_script=$(mktemp)
    
    # Build sed script from environment variables
    for env_pair in "${env_vars[@]}"; do
        if [[ "$env_pair" =~ ^([^=]+)=(.*)$ ]]; then
            key="${BASH_REMATCH[1]}"
            # Escape special characters for sed
            value=$(sed -e 's/[\/&]/\\&/g' <<< "${BASH_REMATCH[2]}")
            printf "s/\${%s}/%s/g\n" "$key" "$value" >> "$sed_script"
        fi
    done

    # Process each template file
    for template in "${!config_files[@]}"; do
        local output="${config_files[$template]}"
        mkdir -p "$(dirname "$output")"
        echo "Generating $output from $template"
        sed -f "$sed_script" "$template" > "$output"
    done

    rm -f "$sed_script"
}

# Main execution
echo "Loading environment variables..."
mapfile -t loaded_vars < <(load_env_vars "${ENV_FILES[@]}")

echo "Processing template files..."
process_templates CONFIG_FILES "${loaded_vars[@]}"

echo "Configuration generation complete."
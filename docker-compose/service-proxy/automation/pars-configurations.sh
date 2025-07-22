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

# 1) Load all .env files into VARS[]
declare -A VARS
for envfile in "${ENV_FILES[@]}"; do
  if [[ ! -f "$envfile" ]]; then
    echo "❌ Env file not found: $envfile" >&2
    exit 1
  fi

  while IFS= read -r line; do
    # skip blank lines and any line containing '#' 
    [[ -z "$line" ]] && continue
    [[ "$line" == *\#* ]] && continue

    # must be KEY=VALUE
    if [[ "$line" == *=* ]]; then
      key="${line%%=*}"
      val="${line#*=}"
      # strip whitespace around key/val
      key="${key//[[:space:]]/}"
      val="${val//[[:space:]]/}"
      VARS["$key"]="$val"
    fi
  done < "$envfile"
done

# 2) Render each template → target
for src in "${!CONFIG_FILES[@]}"; do
  dst="${CONFIG_FILES[$src]}"

  # fail if template missing
  if [[ ! -f "$src" ]]; then
    echo "❌ Template not found: $src" >&2
    exit 1
  fi

  # overwrite target
  : > "$dst"

  while IFS= read -r line; do
    # skip any commented/template lines containing '#'
    [[ -z "$line" ]] && { echo "" >> "$dst"; continue; }
    [[ "$line" == *\#* ]] && continue

    # substitute all ${KEY} in this line
    for key in "${!VARS[@]}"; do
      line="${line//\$\{$key\}/${VARS[$key]}}"
    done

    printf '%s\n' "$line" >> "$dst"
  done < "$src"

  echo "✔ Rendered $src → $dst"
done

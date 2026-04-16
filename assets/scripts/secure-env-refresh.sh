#!/bin/sh

CACHE_FILE="$HOME/.cache/env/.env.cache"
TEMPLATE_FILE="$HOME/.config/.env.template"

# Check if Pass CLI is available
if ! command -v pass-cli &> /dev/null; then
  echo "❌ ProtonPass CLI not found"
  exit 1
fi

# Check if template exists
if [ ! -f "$TEMPLATE_FILE" ]; then
  echo "❌ Template file not found: $TEMPLATE_FILE"
  exit 1
fi 

mkdir -p "$HOME/.cache/env"
touch "$CACHE_FILE"

# Inject variables into cache file
echo "🔄 Fetching environment variables from Proton Pass..."
pass-cli inject -i "$TEMPLATE_FILE" -o "$CACHE_FILE" --force

if [ $? -eq 0 ]; then
  # Set restrictive permissions
  chmod 600 "$CACHE_FILE"
  echo "✅ Environment variables cached to $CACHE_FILE"
else
  echo "❌ Failed to fetch variables from Proton Pass"
  exit 1
fi


#!/usr/bin/env fish

set CACHE_FILE "$HOME/.cache/env/.env.cache"
set TEMPLATE_FILE "$HOME/.env.template"

# Check if 1Password CLI is available
if not command -v op &> /dev/null
    echo "❌ 1Password CLI not found"
    exit 1
end

# Check if template exists
if not test -f "$TEMPLATE_FILE"
    echo "❌ Template file not found: $TEMPLATE_FILE"
    exit 1
end

mkdir -p "$HOME/.cache/env"
touch "$CACHE_FILE"

# Inject variables from 1Password into cache file
echo "🔄 Fetching environment variables from 1Password..."
op inject -i "$TEMPLATE_FILE" -o "$CACHE_FILE" --force

if test $status -eq 0
    # Set restrictive permissions
    chmod 600 "$CACHE_FILE"
    echo "✅ Environment variables cached to $CACHE_FILE"
else
    echo "❌ Failed to fetch variables from 1Password"
    exit 1
end

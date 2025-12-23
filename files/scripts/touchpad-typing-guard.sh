#!/usr/bin/env bash
# Disables touchpad taps/clicks while typing on Hyprland/Wayland
#
# This script monitors keyboard events and disables the touchpad
# for a short period after each keypress to prevent accidental touches.

set -euo pipefail

# Configuration
DISABLE_DURATION=${TOUCHPAD_GUARD_DURATION:-0.15}  # seconds to keep touchpad disabled
TOUCHPAD_NAME=${TOUCHPAD_GUARD_DEVICE:-""}        # auto-detect if empty

# Find the touchpad device name if not specified
find_touchpad() {
    hyprctl devices -j | jq -r '.mice[] | select(.name | test("touchpad|trackpad"; "i")) | .name' | head -n1
}

# Get keyboard device paths
find_keyboards() {
    # Find keyboard event devices
    for dev in /dev/input/event*; do
        if udevadm info --query=property --name="$dev" 2>/dev/null | grep -q "ID_INPUT_KEYBOARD=1"; then
            echo "$dev"
        fi
    done
}

log() {
    echo "[touchpad-guard] $*" >&2
}

# Main logic
main() {
    # Auto-detect touchpad if not specified
    if [[ -z "$TOUCHPAD_NAME" ]]; then
        TOUCHPAD_NAME=$(find_touchpad)
        if [[ -z "$TOUCHPAD_NAME" ]]; then
            log "ERROR: Could not find touchpad device. Set TOUCHPAD_GUARD_DEVICE env var."
            log "Available devices:"
            hyprctl devices
            exit 1
        fi
    fi

    log "Monitoring keyboard for touchpad: $TOUCHPAD_NAME"
    log "Disable duration: ${DISABLE_DURATION}s"

    # Get keyboard devices
    KEYBOARDS=$(find_keyboards)
    if [[ -z "$KEYBOARDS" ]]; then
        log "ERROR: No keyboard devices found"
        exit 1
    fi

    log "Found keyboards:"
    echo "$KEYBOARDS" | while read -r kb; do
        log "  - $kb"
    done

    # Track state
    TOUCHPAD_DISABLED=false
    LAST_KEYPRESS=0
    REENABLE_PID=""

    # Function to disable touchpad
    disable_touchpad() {
        if [[ "$TOUCHPAD_DISABLED" == "false" ]]; then
            hyprctl keyword "device[$TOUCHPAD_NAME]:enabled" false >/dev/null 2>&1 || true
            TOUCHPAD_DISABLED=true
        fi
    }

    # Function to enable touchpad
    enable_touchpad() {
        if [[ "$TOUCHPAD_DISABLED" == "true" ]]; then
            hyprctl keyword "device[$TOUCHPAD_NAME]:enabled" true >/dev/null 2>&1 || true
            TOUCHPAD_DISABLED=false
        fi
    }

    # Cleanup on exit
    cleanup() {
        log "Cleaning up..."
        enable_touchpad
        # Kill any pending re-enable processes
        [[ -n "$REENABLE_PID" ]] && kill "$REENABLE_PID" 2>/dev/null || true
        exit 0
    }
    trap cleanup EXIT INT TERM

    # Monitor keyboard events using libinput
    # We use stdbuf to ensure line-buffered output
    stdbuf -oL libinput debug-events 2>/dev/null | while read -r line; do
        # Check for keyboard key events (press only, not release)
        if [[ "$line" == *"KEYBOARD_KEY"*"pressed"* ]]; then
            # Cancel any pending re-enable
            [[ -n "$REENABLE_PID" ]] && kill "$REENABLE_PID" 2>/dev/null || true

            # Disable touchpad
            disable_touchpad

            # Schedule re-enable after duration
            (
                sleep "$DISABLE_DURATION"
                hyprctl keyword "device[$TOUCHPAD_NAME]:enabled" true >/dev/null 2>&1 || true
            ) &
            REENABLE_PID=$!
            TOUCHPAD_DISABLED=false  # Will be re-enabled by background process
        fi
    done
}

main "$@"

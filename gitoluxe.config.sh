#!/bin/sh

# --------------------------------------------------
# Defaults
# --------------------------------------------------

CONFIG_FILE="gitoluxe.config.env"
DEFAULT_MODEL="qwen3:4b"
DEFAULT_TEMPERATURE="0.1"
DEFAULT_MAX_INPUT_CHARS="7000"


# --------------------------------------------------
# Qwen models
# Format:
# model|description
# --------------------------------------------------

QWEN_MODELS="
qwen3:4b|Recommended default. Excellent speed and quality balance for most users.
qwen3:1.7b|Lightweight. Good for simple commits and small code changes.
qwen3:0.6b|Ultra lightweight. Very fast, suitable for tiny diffs and low-end hardware.
deepseek-coder:6.7b|Code-focused. Excellent at understanding diffs and generating commit messages.
qwen3:8b|High quality. Better reasoning for complex commits, refactors, and larger changes.
llama3.1:8b|Strong general model. Produces clear, natural commit messages.
deepseek-coder-v2:16b|Best overall for coding. Outstanding for large diffs, refactors, and complex repositories.
"


# --------------------------------------------------
# Read config
#
# Usage:
# MODEL=$(config_get MODEL qwen3:4b)
# --------------------------------------------------

config_get()
{
    key="$1"
    default="$2"

    value=""

    if [ -f "$CONFIG_FILE" ]; then
        value=$(grep "^${key}=" "$CONFIG_FILE" | cut -d '=' -f2-)
    fi

    if [ -n "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}


# --------------------------------------------------
# Write config
#
# Usage:
# config_set MODEL qwen3:4b
# --------------------------------------------------

config_set()
{
    key="$1"
    value="$2"

    [ -f "$CONFIG_FILE" ] || touch "$CONFIG_FILE"

    if grep -q "^${key}=" "$CONFIG_FILE"; then
        sed -i.bak "s|^${key}=.*|${key}=${value}|" "$CONFIG_FILE"
        rm -f "${CONFIG_FILE}.bak"
    else
        echo "${key}=${value}" >> "$CONFIG_FILE"
    fi
}


# --------------------------------------------------
# Select Qwen model
# --------------------------------------------------

set_model()
{
    echo
    echo "Available Models:"
    echo

    i=1

    while IFS="|" read model description
    do
        [ -z "$model" ] && continue

        printf "%2s) %-25s - %s\n" \
            "$i" \
            "$model" \
            "$description"

        i=$((i + 1))

    done <<EOF
$QWEN_MODELS
EOF


    echo
    printf "Select model number: "
    read choice


    selected=$(echo "$QWEN_MODELS" | \
        sed -n "${choice}p" | \
        cut -d "|" -f1)


    if [ -z "$selected" ]; then
        echo "Invalid model selection"
        return 1
    fi


    config_set MODEL "$selected"

    echo
    echo "MODEL=$selected"
}


# --------------------------------------------------
# Set temperature
#
# Valid:
# 0
# 0.1
# 0.7
# 1
# 2
# --------------------------------------------------

set_temperature()
{
    value="$1"


    case "$value" in
        ''|*[!0-9.]*)
            echo "Temperature must be numeric"
            return 1
            ;;
    esac


    # Range check using awk
    valid=$(awk "BEGIN {
        if ($value >= 0 && $value <= 2)
            print 1
        else
            print 0
    }")


    if [ "$valid" != "1" ]; then
        echo "Temperature must be between 0 and 2"
        return 1
    fi


    config_set TEMPERATURE "$value"

    echo "TEMPERATURE=$value"
}


# --------------------------------------------------
# Set maximum input diff size
#
# This limits the git diff sent to the AI prompt.
#
# Example:
# set_max_input_chars 7000
# --------------------------------------------------

set_max_input_chars()
{
    value="$1"


    case "$value" in
        ''|*[!0-9]*)
            echo "MAX_INPUT_CHARS must be an integer"
            return 1
            ;;
    esac


    if [ "$value" -lt 500 ] || [ "$value" -gt 50000 ]; then
        echo "MAX_INPUT_CHARS must be between 500 and 50000"
        return 1
    fi


    config_set MAX_INPUT_CHARS "$value"

    echo "MAX_INPUT_CHARS=$value"
}


# --------------------------------------------------
# Show configuration
# --------------------------------------------------

show_config()
{
    echo
    echo "Gitoluxe configuration"
    echo "---------------------"

    echo "MODEL=$(config_get MODEL "$DEFAULT_MODEL")"
    echo "TEMPERATURE=$(config_get TEMPERATURE "$DEFAULT_TEMPERATURE")"
    echo "MAX_INPUT_CHARS=$(config_get MAX_INPUT_CHARS "$DEFAULT_MAX_INPUT_CHARS")"

    echo
}

set_model

printf "Temperature (default 0): "
read TEMP
TEMP=${TEMP:-0}
set_temperature "$TEMP"

printf "Max input chars (default 7000): "
read CHARS
CHARS=${CHARS:-7000}
set_max_input_chars "$CHARS"

show_config
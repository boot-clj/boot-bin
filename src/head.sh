#!/usr/bin/env bash

set -euo pipefail

process_properties() {
    if [[ -f "$1" ]]; then
        while IFS='=' read -r key value || [[ -n "$key" ]]; do
            if [[ -n "$value" ]]; then
                if [[ "$key" == "BOOT_JAVA_COMMAND" ]]; then
                    java_command="$value"
                elif [[ "$key" == "BOOT_JVM_OPTIONS" ]]; then
                    options=($value)
                fi
            fi
        done < "$1"
    fi
}

# defaults

java_command=java
declare -a options=(${BOOT_JVM_OPTIONS-})

# process properties files

process_properties "${BOOT_HOME:-$HOME/.boot}/boot.properties"
process_properties "boot.properties"

# environment variables take precdence

if [[ -n "${BOOT_JAVA_COMMAND-}" ]]; then
    java_command="$BOOT_JAVA_COMMAND"
fi
if [[ -n "${BOOT_JVM_OPTIONS-}" ]]; then
    options=($BOOT_JVM_OPTIONS)
fi

self="${BASH_SOURCE[0]}"
selfdir="$(cd "$(dirname "${self}")" ; pwd)"
selfpath="$selfdir/$(basename "$self")"
exec "$java_command" "${options[@]-}" -Dboot.app.path="$selfpath" -jar "$0" "$@"

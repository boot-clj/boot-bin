#!/usr/bin/env bash
self="${BASH_SOURCE[0]}"
selfdir="$(cd "$(dirname "${self}")" ; pwd)"
selfpath="$selfdir/$(basename "$self")"
eval $(source "${BOOT_HOME:-~/.boot}/boot.properties";
        echo BOOT_JVM_OPTIONS='${BOOT_JVM_OPTIONS:-'$BOOT_JVM_OPTIONS'}';
        echo BOOT_JAVA_COMMAND='${BOOT_JAVA_COMMAND:-'$BOOT_JAVA_COMMAND'}';)
eval $(source "./boot.properties";
        echo BOOT_JVM_OPTIONS='${BOOT_JVM_OPTIONS:-'$BOOT_JVM_OPTIONS'}';
        echo BOOT_JAVA_COMMAND='${BOOT_JAVA_COMMAND:-'$BOOT_JAVA_COMMAND'}';)
declare -a "options=($BOOT_JVM_OPTIONS)"
exec ${BOOT_JAVA_COMMAND:-java} "${options[@]}" -Dboot.app.path="$selfpath" -jar "$0" "$@"

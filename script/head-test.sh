#!/usr/bin/env bash

set -euo pipefail

unset BOOT_JAVA_COMMAND
unset BOOT_JVM_OPTIONS

# Variables ---------------------------------------------------------

global_opt="--option-from-global-boot-properties"
global_cmd="java-global"
local_opt="--option-from-local-boot-properties"
local_cmd="java-local"
env_opt="--env-option"
env_cmd="java-env"

headsh="$(pwd)/src/head.sh"
dir="$(mktemp -q -d)"

error=""

# Setup -------------------------------------------------------------

mkdir "$dir/.boot"
export BOOT_HOME="$dir/.boot"

pushd "$dir" > /dev/null

echo "Testing in directory $dir"
# echo "BOOT_HOME = $BOOT_HOME\n"

# Prepare modified version of `head.sh` 
# that just prints java command and options

sed '$ d' "$headsh" > "$dir/head.sh"
echo 'echo "$java_command" "${options[@]-}"' >> "$dir/head.sh"
chmod +x "$dir/head.sh"

# Helpers -----------------------------------------------------------

test_head_sh () {
    out="$("$dir/head.sh")"
    if [ "$out" == "$1" ]; then
        echo "✅  $out"
    else
        echo "   EXPECTED: $1"
        echo "🛑  WAS:      $out"
        error="yes"
        # exit 1
    fi
}

write_global () { 
    printf "BOOT_JAVA_COMMAND=$global_cmd\nBOOT_JVM_OPTIONS=$global_opt\n" > "$BOOT_HOME/boot.properties" 
}
clean_global () { 
    rm "$dir/.boot/boot.properties" 
}
write_local () { 
    # missing newline at the end here is no mistake :)
    printf "BOOT_JAVA_COMMAND=$local_cmd\nBOOT_JVM_OPTIONS=$local_opt" > "$dir/boot.properties" 
}
clean_local () { 
    rm "$dir/boot.properties" 
}
set_env () {
    export BOOT_JAVA_COMMAND=$env_cmd
    export BOOT_JVM_OPTIONS=$env_opt
}
clean_env () {
    unset BOOT_JAVA_COMMAND
    unset BOOT_JVM_OPTIONS
}

# Test setting of global options ------------------------------------

printf "\nTesting \$BOOT_HOME/boot.properties\n"

write_global
test_head_sh "$global_cmd $global_opt"
clean_global

# Test setting of local options -------------------------------------

printf "\nTesting ./boot.properties\n"

write_local
test_head_sh "$local_cmd $local_opt"
clean_local

# Test local > global precedence ------------------------------------

printf "\nTesting local > global precedence\n"

write_global
write_local
test_head_sh "$local_cmd $local_opt"
clean_global
clean_local

# Test env > local > global precedence ------------------------------

printf "\nTesting env > local > global precedence\n"

write_global
write_local
set_env
test_head_sh "$env_cmd $env_opt"
clean_global
clean_local
clean_env

# Test mixing of env & local ----------------------------------------

printf "\nTesting mixing of env & local\n"

printf "BOOT_JAVA_COMMAND=$local_cmd\n" > "$dir/boot.properties" 
export BOOT_JVM_OPTIONS=$env_opt
test_head_sh "$local_cmd $env_opt"
clean_local
clean_env

# Test mixing of local & global -------------------------------------

printf "\nTesting mixing of local & global\n"

printf "BOOT_JAVA_COMMAND=$local_cmd\n" > "$dir/boot.properties" 
printf "BOOT_JVM_OPTIONS=$global_opt\n" > "$BOOT_HOME/boot.properties" 
test_head_sh "$local_cmd $global_opt"
clean_local
clean_global

popd "$dir" > /dev/null

if [ "$error" == "yes" ]; then
    printf "\nSome errors occurred. 🛑\n"
    exit 1
else
    rm -rf "$dir"
fi
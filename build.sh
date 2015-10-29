#!/usr/bin/env bash

set -e

export PATH=${PATH}:launch4j
VERSION=$(git describe)

rm -rf target bin
mkdir -p target/boot bin

echo -e "\033[0;33m<< Version: $VERSION >>\033[0m"; \

javac -d target src/boot/Loader.java
cp src/tag-release.properties target/boot
(cd target && jar cef boot.Loader loader.jar boot)

sed -e "s@__VERSION__@$(git describe)@" src/launch4j-config.in.xml > launch4j-config.xml

if [ -z "$RUNNING_IN_CI" ]; then
  if which launch4j; then
    launch4j launch4j-config.xml
    echo -e "\033[0;32m<< Success: bin/boot.exe >>\033[0m"; \
  else
    echo -e "\033[0;31m<< Skipped: bin/boot.exe (launch4j not found) >>\033[0m"; \
  fi
fi

cat src/head.sh target/loader.jar > bin/boot.sh
chmod 755 bin/boot.sh
echo -e "\033[0;32m<< Success: bin/boot.sh >>\033[0m"

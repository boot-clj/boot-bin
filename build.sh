#!/usr/bin/env bash

set -e

export PATH=${PATH}:launch4j
VERSION=$(git describe)
JAVA_VERSION=$(java -version 2>&1 \
  | awk -F '"' '/version/ {print $2}' \
  | awk -F. '{print $1 "." $2}')

if [ "$JAVA_VERSION" != "1.7" ]; then
  echo "You must build with JDK version 1.7 only." 1>&2
  exit 1
fi

rm -rf target
mkdir target

echo -e "\033[0;33m<< Version: $VERSION >>\033[0m"; \


# Build target/loader.jar which serves as foundation for boot.sh/exe

javac -d target src/Boot.java src/boot/bin/ParentClassLoader.java
cp -r resources/* target/
jar cef Boot target/loader.jar -C target/ .


# Build boot.sh

cat src/head.sh target/loader.jar > target/boot.sh
chmod 755 target/boot.sh
echo -e "\033[0;32m<< Success: bin/boot.sh >>\033[0m"


# Build boot.exe

sed -e "s@__VERSION__@$(git describe)@" src/launch4j-config.in.xml > launch4j-config.xml

if which launch4j; then
  launch4j launch4j-config.xml
  echo -e "\033[0;32m<< Success: target/boot.exe >>\033[0m"; \
else
  echo -e "\033[0;31m<< Skipped: target/boot.exe (launch4j not found) >>\033[0m"; \
fi


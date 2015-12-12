#!/usr/bin/env bash

set -e

export PATH=${PATH}:launch4j
VERSION=$(git describe)
JAVA_VERSION=$(java -version 2>&1 \
  | awk -F '"' '/version/ {print $2}' \
  |awk -F. '{print $1 "." $2}')

if [ "$JAVA_VERSION" != "1.7" ]; then
  echo "You must build with JDK version 1.7 only." 1>&2
  exit 1
fi

mkdir -p bin build

if [ ! -e build/boot ]; then
  wget -O build/boot https://github.com/boot-clj/boot-bin/releases/download/2.4.2/boot.sh
  chmod 755 build/boot
fi

echo -e "\033[0;33m<< Version: $VERSION >>\033[0m"; \

./build/boot -s src -r resources javac jar -m Boot -f loader.jar

sed -e "s@__VERSION__@$(git describe)@" src/launch4j-config.in.xml > launch4j-config.xml

if which launch4j; then
  launch4j launch4j-config.xml
  echo -e "\033[0;32m<< Success: bin/boot.exe >>\033[0m"; \
else
  echo -e "\033[0;31m<< Skipped: bin/boot.exe (launch4j not found) >>\033[0m"; \
fi

cat src/head.sh target/loader.jar > bin/boot.sh
chmod 755 bin/boot.sh
echo -e "\033[0;32m<< Success: bin/boot.sh >>\033[0m"

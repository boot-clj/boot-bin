# Changes

### master

- The boot binary will now read `BOOT_JAVA_COMMAND` and `BOOT_JVM_OPTIONS` from local and global `boot.properties` files. Previously this setting could only be changed by setting environment variables. [boot #433](https://github.com/boot-clj/boot/issues/433)

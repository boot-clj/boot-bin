# boot-bin

Boot executable&mdash;downloads and runs [Boot](http://boot-clj.com).

* Compatible with any version of Boot, 2.0.0 or later.
* Unix / OSX / Linux / Windows

| Operating System | Download |
|------------------|----------|
| Unix / OSX / Linux | https://github.com/boot-clj/boot-bin/releases/download/latest/boot.sh |
| Windows | https://github.com/boot-clj/boot-bin/releases/download/latest/boot.exe |

## Build

System requirements:

* Java 7
* Bash shell
* [launch4j](http://launch4j.sourceforge.net/)

```
./build.sh # builds target/boot.sh (Unix) and target/boot.exe (Windows)
```

Running various artifacts:

- `target/Boot.class`: `java -cp target Boot`
- `target/loader.jar`: `java -jar target/loader.jar`
- `target/boot.sh`: `./target/boot.sh`

## License

Copyright © 2015 Alan Dipert and Micha Niskin

Distributed under the Eclipse Public License, the same as Clojure.

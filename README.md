# QDK-CC
A pure cross compiler environment for QNAP NAS, support x86-32 and x86-64.


## HOW-TO
1. edit `bin/makefile`.
2. put `src_xxx.tgz` into `/src` if you need to build from some source.zip.
3. run `build_cc.sh`.
```
./build_cc.sh all makefile
or
./build_cc.sh x86_64 makefile
or
./build_cc.sh x86 makefile
```

  - Will make the target which specified in the `all:` label, for instance: `all: Python-3.6.1`
  - The compiled binary will store in `/build/x86` or `/build/x86_64`

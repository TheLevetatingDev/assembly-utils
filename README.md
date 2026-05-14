# asm-coreutils
### Goal

Reimplementation of basic Unix command-line tools in x86_64 Linux assembly (Intel syntax).
Each tool is written close to the metal: raw syscalls, no libc, no standard library, no runtime.

### Build

```
make
```

### Run

```
./build/dog file.txt
```

Each tool compiles into its own standalone binary.

### Clean

```
make clean
```

### Philosophy

No libc. No abstraction layers. Only Linux syscalls.
Minimal surface, explicit behavior, deterministic control flow.
Built as a learning exercise in systems programming and low-level Unix interfaces.

### Status

Early experimental project. Expect instability, gaps, and constant change.

### Naming

Tool names (dog) are arbitrary and not meant to replace or imitate standard Unix utilities directly.

### Current Tools

Currently i have the following tools implemented:
- dog (cat)
- mute (echo)
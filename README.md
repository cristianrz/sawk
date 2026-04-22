# sawk

A build tool for awk used as a general-purpose scripting language.

```sh
sawk -o my-script myfile.awk
./my-script arg1 arg2
```

## Why

awk is a capable scripting language that starts fast, has no
dependencies, and runs everywhere. The problem is tooling: no way to
split programs across files, no linter, no formatter, and passing
arguments requires wrapping in a shell script every time.

`sawk` fixes all of this. Write awk programs the way you'd write any
other language, with `#include` for shared libraries and proper
command-line arguments.

## What it does

1. **Links** — resolves `#include "file.awk"` directives recursively,
   detecting circular includes
2. **Lints** — runs `gawk --lint=fatal` on the linked output so errors
   are caught before the script is written
3. **Formats** — pretty-prints via `gawk --pretty-print`, preserving
   blank lines
4. **Wraps** — produces an executable shell script so arguments reach
   your awk program as `ARGV` rather than being consumed by the
   interpreter

## Example

```awk
# lib/args.awk
function require_args(n,    msg) {
    if (ARGC - 1 < n) {
        msg = "error: expected " n " arguments, got " (ARGC - 1)
        print msg > "/dev/stderr"
        exit 1
    }
}
```

```awk
#!/usr/bin/awk -f
# greet: prints a greeting for the given name
#include "lib/args.awk"

BEGIN {
    require_args(1)
    print "Hello, " ARGV[1] "!"
    exit
}
```

```sh
$ sawk -o greet greet.awk
$ ./greet world
Hello, world!
$ ./greet
error: expected 1 arguments, got 0
```

## Install

```sh
git clone https://github.com/cristianrz/sawk.git
cd sawk
sudo make install
```

## Dependencies

- `gawk`

## Usage

```
sawk [-d] [-m] [-o output_file] [-v] [-h] file|-

  -d          Debug mode
  -m          Non-fatal linting (warnings only)
  -o <file>   Output file (default: a.out)
  -v          Version
  -h          Help
  -           Read from stdin
```

Also included: `awkfmt`, a standalone awk formatter.

```sh
awkfmt myfile.awk        # print formatted output
awkfmt -w myfile.awk     # format in place
```

See `man sawk` for full documentation.

## License

BSD 3-Clause
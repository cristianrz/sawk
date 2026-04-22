# sawk

A build tool for awk used as a general-purpose scripting language.

```sh
sawk -o my-script myfile.awk
./my-script arg1 arg2
```

Or run directly with a shebang:

```sh
#!/usr/bin/env sawk-run
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
#!/usr/bin/env sawk-run
# greet: prints a greeting for the given name
#include "lib/args.awk"

BEGIN {
    require_args(1)
    print "Hello, " ARGV[1] "!"
    exit
}
```

Run directly:

```sh
$ chmod +x greet.awk
$ ./greet.awk world
Hello, world!
$ ./greet.awk
error: expected 1 arguments, got 0
```

Or compile to a standalone executable:

```sh
$ sawk -o greet greet.awk
$ ./greet world
Hello, world!
```

## Install

```sh
git clone https://github.com/cristianrz/sawk.git
cd sawk
sudo make install
```

## Dependencies

- `gawk`

## Tools

| Tool | Description |
|---|---|
| `sawk` | Compile a sawk script to a standalone executable |
| `sawk-run` | Run a sawk script directly, for use as a shebang interpreter |
| `awkfmt` | Format an awk file in place or to stdout |

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

```
sawk-run script.awk [args...]
```

```
awkfmt [-w] file|-

  -w          Write result to source file instead of stdout
```

See `man sawk` for full documentation.

## License

BSD 3-Clause
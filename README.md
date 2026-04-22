# sawk

A build tool for awk. Adds `#include`, linting, and formatting — then
wraps the result in an executable shell script.

```sh
sawk -o my-script myfile.awk
```

## Why

POSIX awk has no way to split a program across files. Large awk programs
end up as a single monolithic script with no way to share common functions
between projects. `sawk` fixes this with a linker, and adds linting and
formatting while it's at it.

## What it does

1. **Links** — resolves `#include "file.awk"` directives recursively,
   detecting circular includes
2. **Lints** — runs `gawk --lint=fatal` on the linked output so errors
   are caught before the script is written
3. **Formats** — pretty-prints via `gawk --pretty-print`, preserving
   blank lines
4. **Wraps** — produces an executable shell script that passes all
   arguments directly to awk

## Example

```awk
# lib/strings.awk
function trim(s) {
    gsub(/^[ \t]+|[ \t]+$/, "", s)
    return s
}
```

```awk
#!/usr/bin/awk -f
#include "lib/strings.awk"

{ print trim($0) }
```

```sh
$ sawk -o trim trim.awk
$ echo "  hello  " | ./trim
hello
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
awkfmt myfile.awk          # print formatted output
awkfmt -w myfile.awk       # format in place
```

See `man sawk` for full documentation.

## License

BSD 3-Clause
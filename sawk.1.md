% SAWK(1)

# NAME

sawk - some extras to POSIX awk

# SYNOPSIS

sawk <command> [options] [args]

# DESCRIPTION

sawk ("slightly better awk") wraps gawk(1) to provide linking, linting,
formatting, and execution of POSIX awk scripts. Its name comes from
"slightly better awk" and it came to life from the frustration of working
with bare POSIX awk. It adds toolchain conveniences without sacrificing
portability — the final output is standard POSIX awk wrapped in a shell
script.

# COMMANDS

## sawk init [name]

Scaffold a new sawk project. Creates a **sawk.toml** manifest, a
**main.awk** entry point, and a **.gitignore**. If *name* is given, the
files are created inside a new directory of that name; otherwise they are
created in the current directory.

## sawk build [-d] [-m] [-o output] [file]

Link, lint, format, and wrap *file* into a self-contained executable shell
script. If *file* is omitted, the **entry** field from **sawk.toml** is
used. Prints the output file path on success.

**-d**
:   Activate set -x for debugging.

**-m**
:   Non-fatal lint — emit warnings but do not fail.

**-o** *file*
:   Write output to *file* (default: a.out).

## sawk run [-d] [-m] [file] [args...]

Compile *file* and execute it immediately without leaving an artifact on
disk. Any *args* after the file name are forwarded to the AWK program. If
*file* is omitted, the **entry** field from **sawk.toml** is used.

**-d**
:   Activate set -x for debugging.

**-m**
:   Non-fatal lint — emit warnings but do not fail.

## sawk fmt [-w] [file]

Format an AWK script using gawk's pretty-printer, preserving intentional
blank lines that gawk would otherwise discard. Reads from stdin if *file*
is omitted.

**-w**
:   Write the result back to *file* in place (cannot be used with stdin).

## sawk lint [-m] file

Lint *file* using gawk's **--posix --lint** flags.

**-m**
:   Non-fatal mode — emit warnings but exit 0.

# PROJECT MANIFEST

A **sawk.toml** file in the current directory describes the project:

    name    = "myproject"
    version = "0.1.0"
    entry   = "main.awk"

**build** and **run** read the **entry** key when no file argument is given.

# LINKING

sawk resolves **#include "file"** directives by inlining the referenced
file at that position. Includes are resolved relative to the working
directory. Missing include files are reported as errors.

# LINTING

sawk uses gawk's **--lint=fatal** option to catch undefined variables,
non-portable constructs, and other warnings before the script is
distributed. The **-m** flag downgrades fatal errors to warnings.

# FORMATTING

sawk uses gawk's **-o-** pretty-printer. Because gawk deletes blank lines
during pretty-printing, sawk substitutes a sentinel token before
formatting and removes it afterward, preserving the author's blank lines.
Consecutive blank lines are collapsed to one.

# SHELL WRAPPING

The output of **sawk build** is a sh(1) script of the form:

    #!/usr/bin/env sh
    exec awk '
    ...awk program...
    ' -- "$@"

The **--** separator prevents awk from interpreting the caller's arguments
as interpreter options.

# INVOCATION AS awkfmt / awkexe

When invoked as **awkfmt**, sawk behaves as **sawk fmt**.
When invoked as **awkexe**, sawk behaves as **sawk run**.
The Makefile installs symlinks for both names.

# FILES

**sawk.toml**
:   Project manifest, read from the current directory.

# ENVIRONMENT

No environment variables.

# BUGS

See GitHub issues: <https://github.com/cristianrz/sawk/issues>

# AUTHOR

Cristian Ariza <dev@cristianrz.com>

# SEE ALSO

awk(1), gawk(1)

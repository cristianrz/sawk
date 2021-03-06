% SAWK(1)

# NAME

sawk - some extras to POSIX awk

# SYNOPSIS

sawk [options] filename

# DESCRIPTION

Wraps some gawk(1) functions and a linker to make POSIX awk slightly easier to
work with.

sawk's name comes from "slightly better awk" and it came to live from the
frustration from trying to work with POSIX awk. It adds some of the features of
systems programming languages without making it unportable as its main purpose
is to transpile to POSIX awk.

## Linking

sawk allows linking libraries to sawk programs by using the traditional
#include "file" directive. sawk will look for the file and include that file's
code in the main file at the position where the include directive was found.

## Linting

sawk uses gawk's --lint utility with the fatal option to lint the code before
it transpiles it to POSIX awk.

## Formatting

sawk wraps gawk's --format utility to protect empty lines in between lines of
code, which gawk, for some reason, deletes.

## Shell wrapping

sawk wraps the output of the the previous functions inside a shell script that
passes all arguments directly to your awk program. This is to avoid awk itself
recognising the arguments as options for the interpreter rather than for the
program. It finally outputs a file with the name specified in the arguments, if
any, otherwise a.out.

## Options

-d

:   Activates set -x for debugging.

-h

:   Prints brief usage information.

-m

:   Don't fail if lint finds error.

-o file

:   Write output to file.

-v

:   Prints the current version number.


# FILES

No files for now.

# ENVIRONMENT

No environment variables for now.

# BUGS

See GitHub issues: <https://github.com/cristianrz/sawk/issues>

# AUTHOR

Cristian Ariza <dev@cristianrz.com>

# SEE ALSO

awk(1), gawk(1)


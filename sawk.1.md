% SAWK(1)

# NAME

sawk - some extras to POSIX awk

# SYNOPSIS

sawk _file_

# DESCRIPTION

Wraps some gawk(1) functions and a linker into an interface makeawk slightly
easier to work with.

sawk's name comes from "slightly better awk" and it came to live from the frustration
from trying to work with POSIX awk. It adds some of the features of systems
programming languages without making it unportable as its main purpose is to
transpile to POSIX awk.

## Linking

sawk allows linking libraries to sawk programs by using the traditional
_#include "file"_ directory. sawk will look for the file and include that file's
code in the main file at the position where the include directive was found.

## Linting

## Options

-h, --help

:   Prints brief usage information.

-o, --output

:   Outputs the greeting to the given filename.

    The file must be an **open(2)**able and **write(2)**able file.

-v, --version

:   Prints the current version number.

# FILES

*~/.hellorc*

:   Per-user default dedication file.

*/etc/hello.conf*

:   Global default dedication file.

# ENVIRONMENT

**DEFAULT_HELLO_DEDICATION**

:   The default dedication if none is given. Has the highest precedence
    if a dedication is not supplied on the command line.

# BUGS

See GitHub Issues: <https://github.com/[owner]/[repo]/issues>

# AUTHOR

Foobar Goodprogrammer <foo@example.org>

# SEE ALSO

**hi(1)**, **hello(3)**, **hello.conf(4)**


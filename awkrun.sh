#!/usr/bin/env sh
file="$1"
shift
exec awk -f "$file" -- "$@"


#!/bin/sh
#
# Wrapper around awk to make it more friendly

set -eu

THIS="$(basename "$0")"

type gawk >/dev/null || echo "$THIS: gawk not installed" >&2

format() {
	# we want to protect single empty lines because gawk does not care about your
	# vertical spacing
	sed 's/^[\t ]*$/#~#~#/g' | gawk --posix -o- -f- | sed 's/#~#~#//g'
}

# wraps awk scripts with a shell file so command line arguments can be passed
# easily
wrap() {
	echo "#!/bin/sh"
	echo "exec awk '"
	#Remove shebang
	grep -Ev '^#!'
	echo "'"' -- "$@"'
}

usage() {
	{
		cat <<EOF
Usage: $THIS COMMAND [FILE]

Commands:
  build   links libraries and outputs a self-contained awk script
  format  formats an awk script
  run     run with gawk most strict setting
EOF
	} >&2
	exit 1
}

set -eu

fatal="=fatal"

[ "$#" -eq 0 ] && usage

while [ "$#" -ge 1 ]; do
	arg="$1" && shift

	case "x$arg" in
	xformat)
		[ "$#" -eq 0 ] && usage
		format <"$1"
		;;
	xrun)
		[ "$#" -eq 0 ] && usage

		gawk --lint=fatal --posix "$@"
		;;
	xbuild)
		[ "$#" -eq 0 ] && usage

		# Even though gawk has include statements for libraries, the resulting
		# script won't be portable. With soup, building the script requires soup but
		# after it is built it will run on any POSIX awk
		gawk -o- -f "$1" | wrap
		;;
	x-v) echo "$THIS v0.1.0" && exit ;;
	esac
done

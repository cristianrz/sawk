#!/bin/sh
#
# Wrapper around gawk to make it more friendly

set -eu

format() {
	# we want to protect single empty lines because gawk does not care about your
	# vertical spacing
	sed 's/^[\t ]*$/#~#~#/g; s/@include/#-#-#/g' "$@" |
		gawk -o- -f- |
		sed 's/#~#~#//g; s/#-#-#/@include/g'
}

usage() {
	{
		cat <<EOF
Usage: $THIS COMMAND [FILE]

Commands:
  build  links libraries and outputs a self-contained awk script
  fmt    formats an awk script
  run    run with gawk most strict setting
EOF
	} >&2
	exit 1
}

# wraps awk scripts with a shell file so command line arguments can be passed
# easily
wrap() {
	printf "#!/bin/sh\nexec awk '\n"

	#Remove shebang
	grep -Ev '^#!'

	printf "' -- \"\$@\"\n"
}

THIS="$(basename "$0")"

type gawk >/dev/null || echo "$THIS: gawk not installed" >&2

[ "$#" -eq 0 ] && usage

while [ "$#" -ge 1 ]; do
	arg="$1" && shift

	case "x$arg" in
	xfmt) format "$@" ;;
	xrun)
		[ "$#" -eq 0 ] && usage

		gawk --lint=fatal --lint=no-ext -f "$@"
		;;
	xbuild)
		[ "$#" -eq 0 ] && usage

		# Even though gawk has include statements for libraries, the resulting
		# script won't be portable. With soup, building the script requires soup but
		# after it is built it will run on any POSIX awk
		gawk -o- -f "$1" | wrap
		;;
	x-v) echo "$THIS v1.0.0" && exit ;;
	esac
done

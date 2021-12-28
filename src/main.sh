#!/bin/sh
#
# Wrapper around POSIX subset of gawk to make it more friendly

set -eu

type gawk >/dev/null || echo 'soup: gawk not installed' >&2

format() {
	# we want to protect single empty lines
	sed 's/^[\t ]*$/#~#~#/g' | gawk --posix -o- -f- | sed 's/#~#~#//g'
}

# wraps awk scripts with a shell file so command line arguments can be passed
wrap() {
	echo "#!/bin/sh"
	echo "exec gawk --posix --lint$fatal '"
	#Remove shebangs
	grep -Ev '^#!'
	echo "'"' -- "$@"'
}

# Even though gawk has include statements for libraries, the resulting script
# won't be portable. Gawk is more comfortable due to --lint and -f (format) but
# that doesn't mean we need to tie the final script with gawk.
link() {
	gawk "--posix --lint$fatal" '
		/^#include/ {
			gsub(/"/, "", $2)

			cmd = "[ -f " $2 " ]"

			exists = system(cmd)
			close(cmd)

			if ( exists == 1 ) {
				print "soup: could not find include: " $2 > "/dev/stderr"
				exit
			}

			while ((getline x < $2) > 0)
				print x
			next
		}

		{
			print
		}
		
		END {
			exit exists
		}
	' "$@"
}

usage() {
	{
		echo "Usage: soup COMMAND [FILE]"
		echo
		echo "See 'man soup' for more info."
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
	xbuild)
		[ "$#" -eq 0 ] && usage

		# Add libraries
		linked="$(link "$1")"
		echo "$linked" | wrap
		;;
	x-v) echo "soup v0.0.1" && exit ;;
	esac
done

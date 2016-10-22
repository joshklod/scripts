#!/bin/sh
#
# cygsetup.sh: A wrapper for Cygwin's setup-*.exe, which adds some default
#              settings and allows command line options to be overridden
#              properly.

# Default command line options
exe="setup-x86_64.exe"
upgrade="--upgrade-also"
shortcuts="--no-shortcuts"
quiet="--package-manager"
defsites="http://cygwin.mirror.constant.com http://cygwin.refractal.net"

# Read command line options
while [ $# -gt 0 ]; do
	case "$1" in
		--exe)
			exe="$2"
			shift
			;;
		--no-upgrade)
			upgrade=""
			;;
		--shortcuts)
			shortcuts=""
			;;
		--full-gui)
			quiet=""
			;;
		-q|--quiet-mode)
			quiet="--quiet-mode"
			
			;;
		-s|--site)
			sites="$sites $2"
			shift
			;;
		-h|--help)
			help=1
			args="$args --help"
			;;
		*)
			args="$args $1"
			;;
	esac
	shift
done

# Generate list of mirror options
for url in ${sites:-$defsites}; do
	mirrorstr="$mirrorstr --site $url"
done

# Execute command
$exe $upgrade $shortcuts $quiet $mirrorstr $args

if [ $help ]; then
	# Show extra help info
	echo "Additional Command Line Options:

    --exe                          The name of the setup executable. Can be a
                                   command or the path to an .exe file.
                                   (Default: 'setup-x86_64.exe')
    --no-upgrade                   Disable --upgrade-also, which is set by
                                   default.
    --shortcuts                    Disable --no-shortcuts, which is set by
                                   default.
    --full-gui                     Disable --package-manager, which is set by
                                   default. Also disable --quiet-mode."
fi

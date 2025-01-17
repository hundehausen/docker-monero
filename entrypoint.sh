#!/bin/ash
set -e

# if thrown flags immediately,
# assume they want to run the blockchain daemon
if [ "${1:0:1}" = '-' ]; then
	set -- monerod "$@"
fi

# if they are running the blockchain daemon,
# make efficient use of memory
if [ "$1" = 'monerod' ]; then
	numa='numactl --interleave=all'
	if $numa true &> /dev/null; then
		set -- $numa "$@"
	fi
	# start the daemon using fixuid
	# to adjust permissions if needed
	exec fixuid -q "$@"
fi

# otherwise, don't get in their way
exec "$@"

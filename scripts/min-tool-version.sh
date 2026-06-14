#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
#
# Print the minimum supported version of the given tool.

set -e

if [ $# != 1 ]; then
	echo "Usage: $0 toolname" >&2
	exit 1
fi

case "$1" in
binutils)
	echo 2.20.0
	;;
gcc)
	echo 4.6.0
	;;
llvm)
	echo 10.0.1
	;;
*)
	echo "$1: unknown tool" >&2
	exit 1
	;;
esac

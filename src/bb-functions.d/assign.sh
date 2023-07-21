#!/usr/bin/env bash

# ==================================================================
# bb-functions.d/assign
# ==================================================================
# BB-Functions Library
#
# File:         assign
# Author:       Ragdata
# Date:         25/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# ATTRIBUTION:	Portions of this software have been inspired, adapted,
#               or borrowed from Tyler Akins' brilliant 'bpm' package.
#				See Copyright & Attributions in this repository's
#				README file for links and more information.
# COPYRIGHT:	Copyright © 2017 Tyler Akins
# ==================================================================
# DEPENDENCIES
# ==================================================================
bb-import bb-functions/is
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# assign::array
# ------------------------------------------------------------------
# @description Send an array as a variable up to caller of a function.
# It is best used with some odd syntax as shown in the example, which
# preserves empty arrays
#
# @arg $1 - string - Variable name
# @arg $2 - array - Array elements
#
# @example
#	callFunc() {
#		local myArray=(one two three)
#		local "${1-}" && assign::array "$1" ${myArray[@]+"${myArray[@]}"}
#	}
#	callFunc dest
#	echo "${dest[@]}" # writes "one two three"
# ------------------------------------------------------------------
assign::array()
{
	local IFS

	# Must set IFS - see the Array splitting discussion
	IFS=
	unset -v "$1"

	eval "$(printf "%s=(\"\${@:2}\")" "$1")"
}
# ------------------------------------------------------------------
# assign::array
# ------------------------------------------------------------------
# @description Send an associative array as a variable up to the caller
# of a function.
#
# @arg $1 - string - Variable (array) Name
# @arg $2 - string - Key
# @arg $3 - string - Value
#
# @example
#	callFunc() {
#		assign::assoc $1 key val
#	}
#	callFunc myAssoc
#	echo "${myAssoc[@]}" (val)
#	echo "${!myAssoc[@]}" (key)
# ------------------------------------------------------------------
assign::assoc()
{
	unset -v "$1"

	eval "$(printf '%s["%s"]="%s"' "$1" "$2" "$3")"
}
# ------------------------------------------------------------------
# assign::ref
# ------------------------------------------------------------------
# @description Assigns a value by reference
# Copies an array or scalar to the destination.  This can be much simpler
# than assigning arrays.
#
# @arg $1 - string - Destination variable name
# @arg $2 - string - Source variable name
# ------------------------------------------------------------------
assign::ref()
{
	unset -v "$1"

	if is::array "$2"; then
		# This looks awful.  It generates a string like this:
		# [[ ${#SRC[@]} -gt 0 ]] && DST=("${SRC[@]}") || DST=()
		eval "$(printf "[[ \${#%s[@]} -gt 0 ]] && %s=(\"\${%s[@]}\") || %s=()" "$2" "$1" "$2" "$1")"
	elif [[ -n "${!2+_}" ]]; then
		# If there is a value, copy it
		printf -v "$1" '%s' "${!2}"
	fi
}
# ------------------------------------------------------------------
# assign::pipe
# ------------------------------------------------------------------
# @description Assign stdin to a value, preserving all newlines and everything that is piped in.
#
# @arg $1 - string - Variable name
# ------------------------------------------------------------------
assign::pipe()
{
	assign::value "$1" "$(
		cat

		# Tricky thing part 1: append a period to the end so the subshell
		# preserves any newlines at the end that cat found
		echo -n "."
	)"

	# Tricky thing part 2: remove that newline.  This is all done without
	# using a temporary variable so we don't need to worry about conflicting
	# with parent scope variables
	assign::value "$1" "${!1%.}"
}
# ------------------------------------------------------------------
# assign::value
# ------------------------------------------------------------------
# @description Send a variable up to the parent of the caller of this function.
#
# @arg $1 - string - Variable name
# @arg $2 - string - Value to assign
# ------------------------------------------------------------------
assign::value()
{
	unset -v "$1"
	printf -v "$1" '%s' "${2:-}"
}

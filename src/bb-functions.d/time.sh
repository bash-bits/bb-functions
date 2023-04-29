#!/usr/bin/env bb-import

# ==================================================================
# bb-functions.d/time
# ==================================================================
# BB-Functions Library
#
# File:         time
# Author:       Ragdata
# Date:         25/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# @file bb-functions.d/time
# @brief Time Functions for BB-Functions Bash Bits Submodule
# ==================================================================
# ATTRIBUTION:	Portions of this software have been inspired, adapted,
#               or borrowed from Labbots brilliant 'bash-utility' package.
#				See Copyright & Attributions in this repository's
#				README file for links and more information.
# COPYRIGHT:	Copyright © 2020 labbots
# ==================================================================
# DEPENDENCIES
# ==================================================================
bb-import bb-functions/assign
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# time::stamp
# ------------------------------------------------------------------
# @description Get a timestamp (seconds only)
#
# @arg $1 - string - Destination variable name
#
# @example
#	time::stamp seconds
#	echo "$seconds"		# 1499716539
# ------------------------------------------------------------------
time::stamp() { local "${1:-}" && assign::value "$1" "$(date +%s)"; }
# ------------------------------------------------------------------
# time::stampDiff
# ------------------------------------------------------------------
# @description Determine the difference between two timestamps.
# Works with low resolution	and high resolution time stamps.
# The time is limited to an accuracy of 9 digits beyond the decimal
# point because Bash can be compiled to use 32-bit math, whose limit
# is a signed 2147483648, easily holding 9 digits.  It also works when
# we have to hold the extra digit from carrying a 1 from the whole numbers.
#
# @arg $1 - string - Destination variable name
# @arg $2 - mixed - Starting Time (the smaller number)
# @arg $3 - mixed - Ending Time
#
# @example
#	time::stampDiff result 1499716539 1499716649.266348007
#	echo "$result"	# 110.266348007
# ------------------------------------------------------------------
time::stampDiff()
{
	local end len start result

	# Adding a dot at the end to ensure we have at least 2 entries in
	# the resulting arrays
	start="$2."
	start=( "${start%%.*}" "${start#*.}" )
	start[1]="${start[1]%.}"
	end="$3."
	end=( "${end%%.*}" "${end#*.}" )
	end[1]="${end[1]%.}"
	len="${#start[1]}"

	[[ "${#end[1]}" -gt "$len" ]] && len="${#end[1]}"

	# Calculate the seconds of difference
	result="$((end[0] - start[0]))"

	# Only calculate this if there are decimals
	if [[ "$len" -gt 0 ]]; then
		# Pad the right side of the strings to make them even.
		# This simplifies subtraction.  printf is not used here because
		# we could get unreasonably large numbers and we don't want to error
		while [[ "${#start[1]}" -lt "$len" ]]
		do
			start[1]+=0
		done

		while [[ "${#end[1]}" -lt "$len" ]]
		do
			end[1]+=0
		done

		# Only care about 9 digits after the decimal.
		# Lead with a "1" to avoid treating numbers like 059141135 as octal
		start[1]="1${start[1]:0:9}"
		end[1]="1${end[1]:0:9}"

		if [[ "${end[1]}" -lt "${start[1]}" ]]; then
			# Need to borrow from the whole seconds
			end[1]="2${end[1]:1:9}"
			result="$((result - 1))"
		fi

		printf -v result "%s.%0${len}d" "$result" "$((end[1] - start[1]))"
	fi

	local "${1:-}" && assign::value "$1" "$result"
}
# ------------------------------------------------------------------
# time::stampHr
# ------------------------------------------------------------------
# @description Get a high resolution timestamp, at least at millisecond resolution.
#
# @arg $1 - string - Destination variable name
#
# @example
#	time::stampHr timestamp
#	echo "$timestamp"	# 1551362098.463254
# ------------------------------------------------------------------
if [[ -n "$EPOCHREALTIME" ]]; then
	# slightly less precision, significant speed increase
	# EPOCHREALTIME=1551362098.463254
	time::stampHr() { local "${1:-}" && assign::value "$1" "$EPOCHREALTIME"; }
elif [[ "$(date +%N)" == "N" ]]; then
	# BSD version of date.  Fall back to Python
	time::stampHr() { local "${1:-}" && assign::value "$1" "$(python -c 'from time import time; print "%.9f" % time();')"; }
else
	# GNU version of date. Faster
	time::stampHr() { local "${1:-}" && assign::value "$1" "$(date +%s.%N)"; }
fi

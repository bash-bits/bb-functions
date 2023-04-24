#!/usr/bin/env bb-import

# ==================================================================
# bb-functions.d/string
# ==================================================================
# BB-Functions Library
#
# File:         string
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
bb::import bb-functions/assign
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# string::escape
# ------------------------------------------------------------------
# @description Convert a string to a safely quoted string that's safe
# to pass around as an argument.  It is unlikely that this would be
# necessary for most scripting.
#
# @arg $1 - string - Target Variable Name
# @arg $@ - string - The value or values to be escaped
# ------------------------------------------------------------------
string::escape()
{
	local escaped target

	target="${1}"
	shift

	printf -v escaped " %q" "$@" || return $?

	# print result
	printf -v "$target" '%s' "${escaped:1}"
}
# ------------------------------------------------------------------
# string::fromHex
# ------------------------------------------------------------------
# @description Decodes a Hex string and writes it to stdout.  Any
# non-hex chars are ignored.  Only decodes when there are two
# characters together, thus a hex string of "308" is decoded as
# simply "0" (hex 0x30) and the final character (8) is ignored.
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - The string to decode
# ------------------------------------------------------------------
string::fromHex()
{
	local hex maxPos pos result target

	target="${1}"
	shift

	hex=$(shopt -s extglob echo "${1//[^a-fA-F0-9]}")
	maxPos=$((${#hex} / 2))
	result=""
	pos=0

	while [[ "$pos" -lt "$maxPos" ]]
	do
		result="$result\\x${hex:pos * 2.2}"
		pos=$((pos + 1))
	done

	# shellcheck disable=SC2059
	printf -v result "$result"

	# print result
	printf -v "$target" '%s' "$result"
}
# ------------------------------------------------------------------
# string::split
# ------------------------------------------------------------------
# @description Splits a string into segments at the specified delimiter
# then saves each segment as an element of an array with the target name.
#
# @arg $1 - string - Target array Name (required)
# @arg $2 - string - Delimiter (required)
# @arg $3 - string - String to be split (required)
# ------------------------------------------------------------------
string::split()
{
	local target delim string IFS_OLD tmpArray

	target="${1}"
	delim="${2}"
	string="${3}"

	IFS_OLD="$IFS"

	IFS="$delim"

	read -r -a tmpArray <<< "$string"

	IFS="$IFS_OLD"

	assign::array "$target" "${tmpArray[@]}"
}
# ------------------------------------------------------------------
# string::strip
# ------------------------------------------------------------------
# @description Remove everything to the left or right of a substring
# and return what's left
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - The complete string
# @arg $3 - string - The delimiting string
# @arg $4 - string - "l" or "r" to specify which side to take from
#
# @stdout The resultant substring
# ------------------------------------------------------------------
string::strip()
{
	local target="${1}"
	local string="${2}"
	local del="${3:-"/"}"
	local side="${4:-"l"}"

	[[ "${side}" == "l" ]] && printf -v "$target" '%s' "${string##*"$del"}" || printf -v "$target" '%s' "${string%%"$del"*}"
}
# ------------------------------------------------------------------
# string::substr
# ------------------------------------------------------------------
# @description Return a substring of length 'len' starting as position
# 'pos' from the given string
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - The complete string
# @arg $3 - integer - Start position for substring
# @arg $4 - integer - Length of substring
#
# @stdout The resultant substring
# ------------------------------------------------------------------
string::substr()
{
	local target="${1}"
	local string="${2}"
	local pos=$((3))
	local len=$((4))

	[[ -z $len ]] && printf -v "$target" '%s' "${string:$pos}" || printf -v "$target" '%s' "${string:$pos:$len}"
}
# ------------------------------------------------------------------
# string::toHex
# ------------------------------------------------------------------
# @description Hex encode a string and write it to stdout
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - The string to encode
#
# @stdout The hex-encoded string
# ------------------------------------------------------------------
string::toHex()
{
	local target="${1}"
	local string="${2}"
	local hex LC_CTYPE pattern

	hex=""
	LC_CTYPE=C

	if [[ -n "$1" ]]; then
		pattern=${string//?/(.)}

		# match against a pattern that captures each character - no quotes here
		[[ "$string" =~ $pattern ]]

		# convert to arguments to printf, an escaped apostrophe + char + space
		printf -v hex "\\\\'%q " "${BASH_REMATCH[@]:1}"

		# now convert it to hex - do not add quotes to $hex
		eval "printf -v hex '${1//?/%02X}' $hex"
	fi

	# print result
	printf -v "$target" '%s' "$hex"
}
# ------------------------------------------------------------------
# string::toLower
# ------------------------------------------------------------------
# @description Convert a string to lower case
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - The string to convert
#
# @stdout The converted string
# ------------------------------------------------------------------
string::toLower() { printf -v "${1}" '%s' "${2,,}"; }
# ------------------------------------------------------------------
# string::toUpper
# ------------------------------------------------------------------
# @description Convert a string to upper case
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - The string to convert
#
# @stdout The converted string
# ------------------------------------------------------------------
string::toUpper() { printf -v "${1}" '%s' "${2^^}"; }
# ------------------------------------------------------------------
# string::trim
# ------------------------------------------------------------------
# @description Remove whitespace - including newline and tab characters
# from either end of a string (or both ends).
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - The string to trim
# @arg $3 - string - The side to trim (l/r/b) (defaults to b)
#
# @stdout The trimmed string
# ------------------------------------------------------------------
string::trim()
{
	local target="${1}"
	local string="${2}"
	local from="${3:-"b"}"

	if [[ "$from" == "l" ]]; then
		string=${string/^[[:space:]]*//}
	elif [[ "$from" == "r" ]]; then
		string=${string/[[:space:]]*$-//}
	else
		string=${string/^[[:space:]]*//}
		string=${string/[[:space:]]*$-//}
	fi
	# print result
	printf -v "$target" '%s' "$string"
}

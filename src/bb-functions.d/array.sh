#!/usr/bin/env bash

# ==================================================================
# bb-functions.d/array
# ==================================================================
# BB-Functions Library
#
# File:         array
# Author:       Ragdata
# Date:         25/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# @file bb-functions.d/array
# @brief Array Functions for BB-Functions Bash Bits Submodule
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
bb-import bb-functions/is
bb-import bb-functions/strict
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# array::contains
# ------------------------------------------------------------------
# @description Check if the specified value exists in the given array
#
# @arg $1 - mixed - Value to search for (needle - required)
# @arg $2 - string - Name of array to be searched (haystack - required)
#
# @example
#	array=(a b c)
#	array::contains "c" "array"
#	# RETURN VALUE
#	0
#
# @exitcode 0 - Success (match found)
# @exitcode 1 - Fail (no match found)
# @exitcode 2 - Error - Missing Argument(s)
# @exitcode 3 - ERROR - '$2' Not an Array
# ------------------------------------------------------------------
array::contains()
{
	[[ $# -lt 2 ]] && errorReturn "Missing Argument(s)!" 2
	[[ ! $(is::array "$2") ]] && errorReturn "'$2' Not an Array!" 3

	local needle="$1"
	local -n array="$2"

	for element in "${array[@]}"
	do
		[[ "$element" == "$needle" ]] && return 0
	done

	return 1
}
# ------------------------------------------------------------------
# array::dedupe
# ------------------------------------------------------------------
# @description Remove duplicate items from an array
#
# @arg $1 - string - Name for the deduped array
# @arg $2 - string - Name of array to be deduped
#
# @example
#	array=(a b a c)
#	array::dedupe newArray array
#	echo "${newArray[@]}"
#	# OUTPUT
#	a
#	b
#	c
#
# @exitcode 2 - ERROR - Missing Argument
# @exitcode 3 - ERROR - '$2' Not an Array
# ------------------------------------------------------------------
array::dedupe()
{
	[[ $# -eq 0 ]] && errorReturn "Missing Argument!" 2
	[[ ! $(is::array "$2") ]] && errorReturn "'$2' Not an Array!" 3

	local target="$1"
	local -n array="$2"
	local -A arrTmp
	local -a arrUnique

	for i in "${array[@]}"
	do
		[[ -z ${i} || ${arrTmp[${i}]} ]] && continue
		arrUnique+=("${i}") && arrTmp[${i}]=x
	done

	assign::array "$target" ${arrUnique[@]+"${arrUnique[@]}"}
}
# ------------------------------------------------------------------
# array::isEmpty
# ------------------------------------------------------------------
# @description Determine whether or not an array is empty
#
# @arg $1 - array - Array to be tested
#
# @example
#	array=(a b c d)
#	array::isEmpty "${array[@]}"
#	# RETURNS
#	1
#
# @exitcode 0 - Array is empty (true)
# @exitcode 1 - Array is not empty (false)
# @exitcode 2 - ERROR - Missing Argument
# @exitcode 3 - ERROR - "$1" Not an Array
# ------------------------------------------------------------------
array::isEmpty()
{
	[[ $# -eq 0 ]] && errorReturn "Missing Argument!" 2
	[[ ! $(is::array "$1") ]] && errorReturn "'$1' Not an Array!" 3

	local -n array="$1"

	[[ ${#array[@]} -eq 0 ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# array::indexOf
# ------------------------------------------------------------------
# @description Check if a value exists in an array.  If the value is
# found, the array index of that value is assigned to the destination
# variable and this function returns true.  If the value is NOT in the
# array, nothing is assigned to the destination variable, and this
# function returns an error.
#
# @arg $1 - string - Destination variable name
# @arg $2 - mixed - The value to search for
# @arg $# - array - Array elements to search
#
# @exitcode 0 - Success (true)
# @exitcode 1 - Failure (false)
# ------------------------------------------------------------------
array::indexOf()
{
	local check index needle target

	target="${1}"
	needle="${2}"
	shift 2
	index=0

	for check in "$@"
	do
		if [[ "$needle" == "$check" ]]; then
			assign::value "$target" "$index"
			return 0
		fi
		index=$((index + 1))
	done
	# Return false if we get here
	return 1
}
# ------------------------------------------------------------------
# array::join
# ------------------------------------------------------------------
# @description Join array elements with a string delimiter
#
# @arg $1 - string - Name of array to be joined
# @arg $2 - string - String to join array elements (optional)
#
# @example
#	array=(a b c d)
#	printf '%s' "$(array::join "array" ",")"
#	# OUTPUT
#	a,b,c,d
#
# @stdout String representation of all elements in array order with the glue string delimiting each element
#
# @exitcode 2 - ERROR - Missing Argument(s)
# @exitcode 3 - ERROR - "$1" Not an Array
# ------------------------------------------------------------------
array::join()
{
	[[ $# -lt 2 ]] && errorReturn "Missing Argument(s)!" 2
	[[ ! $(is::array "$1") ]] && errorReturn "'$1' Not an Array!" 3

	local -n array="$1"
	local delimiter="${2:-","}"
	local out

	out="$(printf '%s' "${array[@]:0:1}")"
	unset "array[0]"
	out+="$(printf '%s' "${array[@]/#/${delimiter}}")"

	printf '%s' "$out"
}
# ------------------------------------------------------------------
# array::reverse
# ------------------------------------------------------------------
# @description Return an array with elements in reverse order
#
# @arg $1 - string - Name of Input Array
#
# @example
#	array=(1 2 3 4 5)
#	printf '%s' "$(array::reverse "${array[@]}")"
#	# OUTPUT
#	5 4 3 2 1
#
# @example
#	array=(1 2 3 4 5)
#	arrayRev=("$(array::reverse "${array[@]}")")
#
# @stdout The reversed array
#
# @exitcode 2 - ERROR - Missing Argument
# @exitcode 3 - ERROR - "$1" Not an Array
# ------------------------------------------------------------------
array::reverse()
{
	[[ $# -eq 0 ]] && errorReturn "Missing Argument!" 2
	[[ ! $(is::array "$1") ]] && errorReturn "'$1' Not an Array!" 3

	local -n array="$1"
	local min=0
	local max=$((${#array[@] - 1})) x

	while [[ $min -lt $max ]]
	do
		# Swap current and first elements
		x="${array[$min]}"
		array[$min]="${array[$max]}"
		array[$max]="$x"
		# Move closer
		((min++, max--))
	done

	printf '%s' "${array[@]}"
}
# ------------------------------------------------------------------
# array::random
# ------------------------------------------------------------------
# @description Return a random element from the array
#
# @arg $1 - string - Name of Input Array
#
# @example
#	array=(a b c d)
#	printf '%s' "$(array::random "${array[@]}")"
#	# OUTPUT
#	c
#
# @stdout Random element from the input array
#
# @exitcode 2 - ERROR - Missing Argument
# @exitcode 3 - ERROR - "$1" Not an Array
# ------------------------------------------------------------------
array::random()
{
	[[ $# -eq 0 ]] && errorReturn "Missing Argument!" 2
	[[ ! $(is::array "$1") ]] && errorReturn "'$1' Not an Array!" 3

	local -n array="$1"

	printf '%s' "${array[RANDOM % $#]}"
}
# ------------------------------------------------------------------
# array::sort
# ------------------------------------------------------------------
# @description Sort an array from lowest to highest
#
# @arg $1 - string - Name of Input Array
#
# @example
#	array=("a c" "a" "d" 2 1 "4 5")
#	array::sort "${array[@]}"
#	# OUTPUT
#	1
#	2
#	4 5
#	a
#	a c
#	d
#
# @stdout The sorted array
#
# @exitcode 0 - Success
# @exitcode 1 - Failure
# @exitcode 2 - ERROR - Missing Argument
# @exitcode 3 - ERROR - "$1" Not an Array
# ------------------------------------------------------------------
array::sort()
{
	[[ $# -eq 0 ]] && errorReturn "Missing Argument!" 2
	[[ ! $(is::array "$1") ]] && errorReturn "'$1' Not an Array!" 3

	local -n array="$1"
	local -a sorted
	local noglobtate

	noglobtate="$(shopt -po noglob)"

	set -o noglob

	sorted=("$(sort <<< "${array[*]}")")

	eval "${noglobtate}"

	printf '%s' "${sorted[@]}"

	return $?
}
# ------------------------------------------------------------------
# array::rsort
# ------------------------------------------------------------------
# @description Sort an array in reverse order (highest to lowest)
#
# @arg $1 - string - Name of Input Array
#
# @example
#	array=("a c" "a" "d" 2 1 "4 5")
#	array::rsort "${array[@]}"
#	# OUTPUT
#	d
#	a c
#	a
#	4 5
#	2
#	1
#
# @stdout Reverse sorted array
#
# @exitcode 2 - ERROR - Missing Argument
# @exitcode 3 - ERROR - "$1" Not an Array
# ------------------------------------------------------------------
array::rsort()
{
	[[ $# -eq 0 ]] && errorReturn "Missing Argument!" 2
	[[ ! $(is::array "$1") ]] && errorReturn "'$1' Not an Array!" 3

	local -n array="$1"
	local -a sorted
	local noglobtate

	noglobtate="$(shopt -po noglob)"

	set -o noglob

	sorted=("$(sort -r <<< "${array[*]}")")

	eval "${noglobtate}"

	printf '%s' "${sorted[@]}"
}
# ------------------------------------------------------------------
# array::bsort
# ------------------------------------------------------------------
# @description Bubble sort an array from lowest to highest.
# This does not work on a string array.
#
# @arg $1 - string - Name of Input Array
#
# @example
#	array=(4 5 1 3)
#	array::bsort "${array[@]}"
#	# OUTPUT
#	1
#	2
#	3
#	4
#	5
#
# @stdout Bubble sorted array
#
# @exitcode 2 - ERROR - Missing Argument
# @exitcode 3 - ERROR - "$1" Not an Array
# ------------------------------------------------------------------
array::bsort()
{
	[[ $# -eq 0 ]] && errorReturn "Missing Argument!" 2
	[[ ! $(is::array "$1") ]] && errorReturn "'$1' Not an Array!" 3

	local -n array="$1"
	local tmp

	for ((i = 0; i <= $((${#array[@]} - 2)); ++i))
	do
		for ((j = ((i + 1)); j <= ((${#array[@]} - 1)); ++j))
		do
			if [[ ${array[i]} -gt ${array[j]} ]]; then
				# echo $i $j ${array[i]} ${array[j]}
				tmp=${array[i]}
				array[i]=${array[j]}
				array[j]=$tmp
			fi
		done
	done

	printf '%s' "${array[@]}"
}
# ------------------------------------------------------------------
# array::merge
# ------------------------------------------------------------------
# @description Merge two arrays.
#
# @arg $1 - string - Name of First Input Array
# @arg $2 - string - Name of Second Input Array
#
# @example
#	a=("a" "c")
#	b=("d" "c")
#	array::merge "a[@]" "b[@]"
#	# OUTPUT
#	a
#	c
#	d
#	c
#
# @stdout The merged array
#
# @exitcode 2 - ERROR - Missing Argument(s)
# @exitcode 3 - ERROR - "$1" Not an Array
# @exitcode 3 - ERROR - "$2" Not an Array
# ------------------------------------------------------------------
array::merge()
{
	[[ $# -lt 2 ]] && errorReturn "Missing Argument(s)!" 2
	[[ ! $(is::array "$1") ]] && errorReturn "'$1' Not an Array!" 3
	[[ ! $(is::array "$2") ]] && errorReturn "'$2' Not an Array!" 3

	local -n arr1="$1"
	local -n arr2="$2"
	local out

	out=("${arr1[@]}" "${arr2[@]}")

	printf '%s' "${out[@]}"
}
# ------------------------------------------------------------------
# array::hasKey
# ------------------------------------------------------------------
# @description Determine if a specific key exists within an associative array
#
# @arg $1 - string - Target Key
# @arg $2 - string - Name of Input Array
#
# @example
#	array=([name]="foo" [place]="bar")
#	[[ $(array::hasKey "name") ]] && echo "YES" || echo "NO"
#	# OUTPUT
#	YES
#
# @exitcode 0 - Success
# @exitcode 1 - Failure
# @exitcode 2 - ERROR - Missing Argument(s)
# @exitcode 3 - ERROR - "$2" Not an Array
# ------------------------------------------------------------------
array::hasKey()
{
	[[ $# -lt 2 ]] && errorReturn "Missing Argument(s)!" 2
	[[ ! $(is::array "$2") ]] && errorReturn "'$2' Not an Array!" 3

	local key="$1"
	local -n array="$2"

	[[ ${array[$key]+_} ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# array::filter
# ------------------------------------------------------------------
# @description Run the values of an array through a filter.
# When the filter function returns an error, remove that element from the list
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - Name of Filter Function
# @arg $3 - string - Name of Input Array
#
# @example
#	removeAnimals() {
#		case "$1" in
#			dog|cat|cow|moose)
#				# return a failure code and these elements will be removed
#				return 1
#				;;
#		esac
#		return 0
#	}
#	words=(a dog and a cat chased a cow)
#	array::filter filtered removeAnimals ${words[@]}
#	# OUTPUT
#	a and a chased a
#
# @exitcode 2 - ERROR - Missing Argument(s)
# @exitcode 3 - ERROR - "$3" Not an Array
# ------------------------------------------------------------------
array::filter()
{
	[[ $# -lt 3 ]] && errorReturn "Missing Argument(s)!" 2
	[[ ! $(is::array "$3") ]] && errorReturn "'$2' Not an Array!" 3

	local target="$1"
	local filter="$2"
	local -n array="$3"
	local -a result
	local returnCode

	while [[ $# -gt 0 ]]
	do
		strict::run returnCode "$filter" "$1"

		[[ "$returnCode" -eq 0 ]] && result[${#result[@]}]="$1"

		shift
	done

	assign::array "$target" ${result[@]+"${result[@]}"}
}

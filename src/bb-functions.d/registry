#!/usr/bin/env bb-import

# ==================================================================
# bb-functions.d/registry
# ==================================================================
# BB-Functions Library
#
# File:         registry
# Author:       Ragdata
# Date:         25/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# DEPENDENCIES
# ==================================================================
bb::import bb-functions/array
bb::import bb-functions/assign
bb::import bb-functions/is
bb::import bb-functions/string
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# registry::get
# ------------------------------------------------------------------
# @description Retrieve a list of sections, a list of keys, or the
# value of a specific key
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - Prefix
# @arg $3 - string - Section Name
# @arg $4 - string - Key Name
#
# @exitcode 0 - Success (true)
# @exitcode 1 - Failure (false)
# ------------------------------------------------------------------
registry::get()
{
	local target="${1:-}"
	local prefix="${2:-}" && prefix="${prefix^^}"
	local section="${3:-}" && section="${section^^}"
	local key="${4:-}" && key="${key^^}"
	local id="${prefix}_${section}_${key}"
	local thisKey thisSection
	local -a tmpArray

	if [[ -n "$prefix" && -n "$section" && -n "$key" ]]; then
		[[ "$(array::indexOf keyIndex "$id" "${REGISTRY[@]}")" ]] && assign::value "$target" "${REGISTRY[$keyIndex]}" || return 1
	elif [[ -n "$prefix" && -n "$section" ]]; then
		thisSection="${prefix}_${section}"
		for thisKey in "${!REGISTRY[@]}"
		do
			[[ "${thisKey:0:${#thisSection}}" == "$thisSection" ]] && tmpArray+=("$thisKey")
		done
		[[ "${#tmpArray[@]}" -gt 0 ]] && assign::array "$target" "${tmpArray[@]}" || return 1
	elif [[ -n "$prefix" ]]; then
		for thisSection in "${SECTIONS[@]}"
		do
			[[ "${thisSection:0:${#prefix}}" == "$prefix" ]] && tmpArray+=("$thisSection")
		done
		[[ "${#tmpArray[@]}" -gt 0 ]] && assign::array "$target" "${tmpArray[@]}" || return 1
	fi

	return 0
}
# ------------------------------------------------------------------
# registry::init
# ------------------------------------------------------------------
# @description Initialise a Registry Key without a value
#
# @arg $1 - string - Prefix
# @arg $2 - string - Section Name
# @arg $3 - string - Key Name
#
# @exitcode 2 - ERROR - Missing Argument(s)
# @exitcode 3 - ERROR - Registry Key Exists
# ------------------------------------------------------------------
registry::init()
{
	local prefix="${1:-}" && prefix="${prefix^^}"
	local section="${2:-}" && section="${section^^}"
	local key="${3:-}" && key="${key^^}"
	local id="${prefix}_${section}_${key}"

	[[ -z "$prefix" || -z "$section" || -z "$key" ]] && errorReturn "Missing Argument(s)!" 2

	[[ "$(declare -p "$id" 2> /dev/null)" == "declare -"[aA]* ]] && errorReturn "Registry Key '$id' Already Exists!" 3

	[[ "$(declare -p REGISTRY 2> /dev/null)" == "declare -"[aA]* ]] || declare -agx REGISTRY
	[[ "$(declare -p SECTIONS 2> /dev/null)" == "declare -"[aA]* ]] || declare -agx SECTIONS
	[[ "$(declare -p PREFIXES 2> /dev/null)" == "declare -"[aA]* ]] || declare -agx PREFIXES

	declate -agx "$id"

	[[ "$(array::contains "$prefix" "PREFIXES")" ]] || PREFIXES+=("$prefix")
	[[ "$(array::contains "$section" "SECTIONS")" ]] || SECTIONS+=("${prefix}_${section}")
	[[ "$(array::contains "$id" "REGISTRY")" ]] || REGISTRY+=("$id")
}
# ------------------------------------------------------------------
# registry::list
# ------------------------------------------------------------------
# @description List all keys and values for a specific prefix,
# section, or list all keys and values currently registered.
#
# @arg $1 - string - Prefix (optional)
# @arg $2 - string - Section Name (optional)
# ------------------------------------------------------------------
registry::list()
{
	local prefix="${1:-}" && prefix="${prefix^^}"
	local section="${2:-}" && section="${section^^}"
	local id key
	local -A tmpArray

	for key in "${!REGISTRY[@]}"
	do
		if [[ -n "$prefix" && -n "$section" ]]; then
			id="${prefix}_${section}"
			[[ "${key:0:${#id}}" == "$id" ]] && tmpArray["$id"]="$(eval echo "\${$id}")"
		elif [[ -n "$prefix" ]]; then
			[[ "${key:0:${#prefix}}" == "$prefix" ]] && tmpArray["$id"]="$(eval echo "\${$id}")"
		else
			tmpArray["$id"]="$(eval echo "\${$id}")"
		fi
	done
	for key in "${!tmpArray[@]}"
	do
		echo "$key=${tmpArray[$key]}"
	done
}
# ------------------------------------------------------------------
# registry::prefix
# ------------------------------------------------------------------
# @description Generate a unique prefix
#
# @arg $1 - string - Target Variable Name
# ------------------------------------------------------------------
registry::prefix()
{
	# 1 in 32K
	local prefix="BB${RANDOM}"
	# 1 in 1 Billion
	if is::set "$prefix"; then prefix="BB${RANDOM}${RANDOM}"; fi

	assign::value "$1" "$prefix"
}
# ------------------------------------------------------------------
# registry::remove
# ------------------------------------------------------------------
# @description Removes a key from a section, or a section from a
# prefix, or all currently registered keys.  Frees up memory by
# unsetting environment variables.  If no prefix is specified, will
# remove all currently registered keys
#
# @arg $1 - string - Prefix (optional)
# @arg $2 - string - Section Name (optional)
# @arg $3 - string - Key Name (optional)
# ------------------------------------------------------------------
registry::remove()
{
	local prefix="${1:-}" && prefix="${prefix^^}"
	local section="${2:-}" && section="${section^^}"
	local key="${3:-}" && key="${key^^}"
	local part

	for i in ${#REGISTRY[@]}
	do
		local id="${REGISTRY[$i]}"
		if [[ -n "$prefix" && -n "$section" && -n "$key" ]]; then
			local chk="${prefix}_${section}_${key}"
			[[ -n "$(eval echo "${!id}")" ]] && eval unset "${id}"
			[[ "$chk" == "$id" ]] && unset "${REGISTRY[$i]}"
		elif [[ -n "$prefix" && -n "$section" ]]; then
			local part="${prefix}_${section}"
			if [[ "${id:0:${#part}}" == "$part" ]]; then
				eval unset "${id}"
				unset "${REGISTRY[$i]}"
			fi
			[[ "$(array::indexOf sectionIndex "$part" "${SECTIONS[@]}")" ]] && unset "${SECTIONS[$sectionIndex]}"
		elif [[ -n "$prefix" ]]; then
			if [[ "${id:0:${#prefix}}" == "$prefix" ]]; then
				eval unset "${id}"
				unset "${REGISTRY[$i]}"
			fi
			for s in ${#SECTIONS[@]}
			do
				local section="${SECTIONS[$s]}"
				[[ "${section:0:${#prefix}}" == "$prefix" ]] && unset "${SECTIONS[$s]}"
			done
			[[ "$(array::indexOf prefixIndex "$prefix" "${PREFIXES[@]}")" ]] && unset "${PREFIXES[$prefixIndex]}"
		else
			eval unset "${id}"
			[[ "$(is::set REGISTRY)" ]] && unset REGISTRY
			[[ "$(is::set SECTIONS)" ]] && unset SECTIONS
			[[ "$(is::set PREFIXES)" ]] && unset PREFIXES
		fi

	done
}
# ------------------------------------------------------------------
# registry::set
# ------------------------------------------------------------------
# @description Assigns a value to a specific key.  If the key is
# already assigned a value, the key will be converted to an array,
# and this latest value will be added to it.
#
# @arg $1 - string - Prefix
# @arg $2 - string - Section Name
# @arg $3 - string - Key Name
# @arg $4 - string - Value
#
# @exitcode 2 - ERROR - Missing Argument(s)
# ------------------------------------------------------------------
registry::set()
{
	local prefix="${1:-}" && prefix="${prefix^^}"
	local section="${2:-}" && section="${section^^}"
	local key="${3:-}" && key="${key^^}"
	local id="${prefix}_${section}_${key}"
	local value="${4:-}"

	[[ -z "$prefix" || -z "$section" || -z "$key" || -z "$value" ]] && errorReturn "Missing Argument(s)!" 2

	[[ "$(declare -p "$id" 2> /dev/null)" == "declare -"[aA]* ]] && declare -agx "$id"

	[[ "$(array::contains "$value" "$id")" ]] || eval "${id}"+=\("$value"\)

	[[ "$(array::contains "$prefix" "PREFIXES")" ]] || PREFIXES+=("$prefix")
	[[ "$(array::contains "$section" "SECTIONS")" ]] || SECTIONS+=("${prefix}_${section}")
	[[ "$(array::contains "$id" "REGISTRY")" ]] || REGISTRY+=("$id")
}
# ------------------------------------------------------------------
# registry::toString
# ------------------------------------------------------------------
# @description Transforms the in-memory contents of the registry
# back into a string.  Strips all comments.  The order of sections
# and keys may not be preserved.
#
# @arg $1 - string - Target Variable Name
# @arg $2 - string - Prefix (optional)
# @arg $3 - string - Section Name (optional)
# ------------------------------------------------------------------
registry::toString()
{
	local target="${1:-}"
	local prefix="${2:-}" && prefix="${prefix^^}"
	local section="${3:-}" && section="${section^^}"
	local temp

	if [[ -n "$prefix" && -n "$section" ]]; then
		registry::list "$prefix" "$section" > "$BB_INC/tmpFile.ini"
	elif [[ -n "$prefix" ]]; then
		registry::list "$prefix" > "$BB_INC/tmpFile.ini"
	else
		registry::list > "$BB_INC/tmpFile.ini"
	fi
	while IFS= read -r line
	do
		temp+="$line"
	done < "$BB_INC/tmpFile.ini"
	# cleanup
	rm -f "$BB_INC/tmpFile.ini"
	# assign
	assign::value "$target" "$temp"
}

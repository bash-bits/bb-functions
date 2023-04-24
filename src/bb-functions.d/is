#!/usr/bin/env bb-import

# ==================================================================
# bb-functions.d/is
# ==================================================================
# BB-Functions Library
#
# File:         is
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
bb::import bb-regex/cc
bb::import bb-regex/date
bb::import bb-regex/general
bb::import bb-regex/network
bb::import bb-regex/numeric
bb::import bb-regex/options
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# is::array
# ------------------------------------------------------------------
# @description Determine if the given variable exists, and is either an array or associative array
#
# @arg $1 - string - The name of the variable to test
#
# @example
#	var=(a b c)
#	if is::array var; then
#		echo "This is an array"
#		echo "Be careful to use the variable's name in the function call"
#	fi
#
# @exitcode 0 - exists and is array or associative array (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::array() { [[ "$(declare -p "$1" 2> /dev/null)" == "declare -"[aA]* ]]; }
# ------------------------------------------------------------------
# is::associativeArray
# ------------------------------------------------------------------
# @description Determine if the given variable exists, and is an associative array
#
# @arg $1 - string - The name of the variable to test
#
# @example
#	var[test]="value"
#	if is::array var; then
#		echo "This is an associative array"
#		echo "Be careful to use the variable's name in the function call"
#	fi
#
# @exitcode 0 - exists and is array or associative array (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::associativeArray() { [[ "$(declare -p "$1" 2> /dev/null)" == "declare -A"* ]]; }
# ------------------------------------------------------------------
# is::bool
# ------------------------------------------------------------------
# @description Determine if the given variable exists and is boolean
#
# @arg $1 - string - The name of the variable to test
#
# @example
#	var=true
#	if is::bool var; then
#		echo "This is a boolean value"
#		echo "Be careful to use the variable's name in the function call"
#	fi
#
# @exitcode 0 - exists and is boolean (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::bool()
{
	local pattern

	pattern="$(regex::isBOOL)"

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# is::cc
# ------------------------------------------------------------------
# @description Determine if the given variable exists and is a credit card number
#
# @arg $1 - string - The name of the variable to test (required)
# @arg $2 - string - CC type (optional)
#				   - amex
#				   - diners
#				   - discover
#				   - jcb
#				   - mcard
#				   - visa
#
# @exitcode 0 - exists and is credit card (of type if applicable) (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::cc()
{
	local type="${2}"
	local pattern

	case "${type,,}" in
		amex)
			pattern="$(regex::isAMEX)"
			;;
		diners)
			pattern="$(regex::isDINERS)"
			;;
		discover)
			pattern="$(regex::isDISCOVER)"
			;;
		jcb)
			pattern="$(regex::isJCB)"
			;;
		mcard)
			pattern="$(regex::isMCARD)"
			;;
		visa)
			pattern="$(regex::isVISA)"
			;;
		*)
			pattern="$(regex::isCC)"
			;;
	esac

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# is::date
# ------------------------------------------------------------------
# @description Determine if the given variable exists and is a date variable
#
# @arg $1 - string - The name of the variable to test
# @arg $2 - string - Type (optional)
#				   - datetime
#				   - dmy (day/month/year)
#				   - mdy (month/day/year)
#				   - ymd (year/month/day)
#
# @exitcode 0 - exists and is date variable (of type if applicable) (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::date()
{
	local type="$2"
	local pattern

	case "${type,,}" in
		datetime)
			pattern="$(regex::isDATETIME)"
			;;
		dmy)
			pattern="$(regex::isDATEDMY)"
			;;
		mdy)
			pattern="$(regex::isDATEMDY)"
			;;
		ymd)
			pattern="$(regex::isDATEYMD)"
			;;
		*)
			pattern="$(regex::isDATE)"
			;;
	esac

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# is::email
# ------------------------------------------------------------------
# @description Determine if the given variable exists and is email address
#
# @arg $1 - string - The name of the variable to test
#
# @exitcode 0 - exists and is email address (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::email()
{
	local pattern

	pattern="$(regex::isEMAIL)"

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# is::function
# ------------------------------------------------------------------
# @description Determine if the given variable exists and is a function
#
# @arg $1 - string - The name of the variable to test
#
# @exitcode 0 - exists and is a function (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::function() { [[ "$(declare -Ff "$1" > /dev/null)" ]]; }
# ------------------------------------------------------------------
# is::included
# ------------------------------------------------------------------
# @description Determines if a script was included using bb::include
#
# @arg $1 - string - The name of the variable to test
#
# @exitcode 0 - exists and is sourced (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::included() { [[ "${FUNCNAME[1]-}" == "bb::include" ]]; }
# ------------------------------------------------------------------
# is::ip
# ------------------------------------------------------------------
# @description Determine if the given variable exists and is a ip address
#
# @arg $1 - string - The name of the variable to test
# @arg $2 - string - Type (optional)
#				   - v6 (IPv6)
#
# @exitcode 0 - exists and is ip address (of type if applicable) (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::ip()
{
	local type="$2"
	local pattern

	case "${type,,}" in
		v6)
			pattern="$(regex::isIPv6)"
			;;
		*)
			pattern="$(regex::isIPv4)"
			;;
	esac

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# is::mac
# ------------------------------------------------------------------
# @description Determine if the given variable exists and is MAC address
#
# @arg $1 - string - The name of the variable to test
#
# @exitcode 0 - exists and is MAC address (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::mac()
{
	local pattern

	pattern="$(regex::isMAC)"

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# is::number
# ------------------------------------------------------------------
# @description Determine if the given variable exists and is a number
#
# @arg $1 - string - The name of the variable to test
# @arg $2 - string - Type (required)
#				   - dec|decimal
#				   - float
#				   - integer
#
# @exitcode 0 - exists and is number of type (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::number()
{
	local type="$2"
	local pattern

	case "${type,,}" in
		dec|decimal)
			pattern="$(regex::isDECIMAL)"
			;;
		float)
			pattern="$(regex::isFLOAT)"
			;;
		int)
			pattern="$(regex::isINT)"
			;;
	esac

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# is::opt
# ------------------------------------------------------------------
# @description Determine if the given variable exists and is an option variable
#
# @arg $1 - string - The name of the variable to test
# @arg $2 - string -  Option type (optional)
#				   - optval 				(option, with value)
#				   - optnoval				(option, no value)
#				   - sopt|short				(short option)
#				   - soptval|shortval		(short option, with value)
#				   - soptnoval|shortnoval	(short option, no value)
#				   - lopt|long				(long option)
#				   - loptval|longval		(long option, with value)
#				   - loptnoval|longnoval	(long option, no value)
#
# @exitcode 0 - exists and is credit card (of type if applicable) (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::opt()
{
	local type="$2"
	local pattern

	case "${type,,}" in
		optval)
			pattern="$(regex::isOPTVAL)"
			;;
		optnoval)
			pattern="$(regex::isOPTNOVAL)"
			;;
		sopt|short)
			pattern="$(regex::isSOPT)"
			;;
		soptval|shortval)
			pattern="$(regex::isSOPTVAL)"
			;;
		soptnoval|shortnoval)
			pattern="$(regex::isSOPTNOVAL)"
			;;
		lopt|long)
			pattern="$(regex::isLOPT)"
			;;
		loptval|longval)
			pattern="$(regex::isLOPTVAL)"
			;;
		loptnoval|longnoval)
			pattern="$(regex::isLOPTNOVAL)"
			;;
		*)
			pattern="$(regex::isOPT)"
			;;
	esac

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# is::set
# ------------------------------------------------------------------
# @description Determines if the variable is assigned - even if it has an empty value
#
# @arg $1 - string - The name of the variable to test
#
# @exitcode 0 - exists and is set (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::set() { [[ "${!1-a}" == "${!1-b}" ]]; }
# ------------------------------------------------------------------
# is::sourced
# ------------------------------------------------------------------
# @description Determines if a script was sourced or executed
#
# @arg $1 - string - The name of the variable to test
#
# @exitcode 0 - exists and is sourced (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::sourced() { [[ "${FUNCNAME[1]-}" == "source" || "${FUNCNAME[1]-}" == "bb::include" ]]; }
# ------------------------------------------------------------------
# is::ssh
# ------------------------------------------------------------------
# @description Determine if string is an ssh server address
#
# @arg $1 - string - The name of the variable to test
#
# @exitcode 0 - exists and is ssh server address (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::ssh()
{
	local pattern

	pattern="$(regex::isSSH)"

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}
# ------------------------------------------------------------------
# is::url
# ------------------------------------------------------------------
# @description Determine if a string is a URL
#
# @arg $1 - string - The name of the variable to test
#
# @exitcode 0 - exists and is a URL (true)
# @exitcode 1 - otherwise (false)
# ------------------------------------------------------------------
is::url()
{
	local pattern

	pattern="$(regex::isURL)"

#	[[ "$(declare -p "$1" 2> /dev/null)" =~ $pattern ]] && return 0 || return 1
	[[ "${!1}" =~ $pattern ]] && return 0 || return 1
}

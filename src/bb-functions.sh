#!/usr/bin/env bash

# ==================================================================
# bb-functions
# ==================================================================
# BB-Functions Library File
#
# File:         bb-functions
# Author:       Ragdata
# Date:         15/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# DEPENDENCIES
# ==================================================================
bb-import bb-functions/is
# ==================================================================
# VARIABLES
# ==================================================================
#
# VERSION
#
PKG_VERSION="0.1.0"
PKG_BUILD="1001"
PKG_BUILD_DATE="20230813:1940"
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# functions::load
# ------------------------------------------------------------------
# ------------------------------------------------------------------
functions::load()
{
    local currDir file

    currDir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

    local -a args=("$@")

    if [[ "${#args[@]}" -eq 0 ]]; then
        for file in "$currDir"/bb-functions.d/*
        do
            args+=("${file##*/}")
        done
    else
        for file in "${args[@]}"
        do
            bb-import "bb-functions/$file"
        done
    fi
}
# ------------------------------------------------------------------
# functions::version
# ------------------------------------------------------------------
# @description Reports the version and build date of this release
#
# @noargs
#
# @stdout Version, Copyright, & Build Information
# ------------------------------------------------------------------
functions::version()
{
	local verbosity="${1:-}"

	if [[ -z "$verbosity" ]]; then
		echo "${PKG_VERSION}"
	else
		echo
		echo "Bash-Bits Modular Bash Library"
		echoWhite "BB-Functions Module ${PKG_VERSION}"
		echo "Copyright © 2022-2023 Darren (Ragdata) Poulton"
		echo "Build: ${PKG_BUILD}"
		echo "Build Date: ${PKG_BUILD_DATE}"
		echo
	fi
}
# ==================================================================
# MAIN
# ==================================================================
# IF SOURCED, RUN LOAD FUNCTION
if [[ $(is::sourced) ]]; then
	functions::load "$@" || return $?
else
	trap 'bb::errorHandler "LINENO" "BASH_LINENO" "${BASH_COMMAND}" "${?}"' ERR

	options=$(getopt -l "version::" -o "v::" -a -- "$@")

	eval set --"$options"

	while true
	do
		case "$1" in
			-v|--version)
				if [[ -n "${2}" ]]; then
					functions::version "${2}"
					shift 2
				else
					functions::version
					shift
				fi
				exitReturn 0
				;;
			--)
				shift
				break
				;;
			*)
				echoError "Invalid Argument!"
				exitReturn 2
				;;
		esac
	done
fi

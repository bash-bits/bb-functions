#!/usr/bin/env bb-import

# ==================================================================
# bb-functions.d/profile
# ==================================================================
# BB-Functions Library
#
# File:         profile
# Author:       Ragdata
# Date:         25/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# DEPENDENCIES
# ==================================================================
bb-import bb-ansi
# ==================================================================
# VARIABLES
# ==================================================================
declare -gx INV_LOG
declare -gx invPath
declare -gx invFile
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# profile::getInvLog
# ------------------------------------------------------------------
# @description Initialise the invocation log and rotate if required,
# and populates the global path variables.
# ------------------------------------------------------------------
profile::getInvLog()
{
	local size

	declare -gx INV_LOG="$BB_LOG/invocation.log"

	invPath=${INV_LOG%/*}
	invFile=${INV_LOG##*/}

	[[ ! -f "$invFile" ]] && touch "$INV_LOG"

	size=$(wc -c "$INV_LOG" | awk '{print $1}')

	if [[ "$size" -gt 1024000 ]]; then
		ext=$(date '+%y%m%d.%I%M')
		mv "$INV_LOG" "$INV_LOG.$ext"
		touch "$INV_LOG"
	fi
}
# ------------------------------------------------------------------
# profile::invoked
# ------------------------------------------------------------------
# @description Records the invocation of a command in the invocation log.
# Returns the status of the command to append the entry to the log file.
# ------------------------------------------------------------------
profile::invoked()
{
	local logString

	profile::getInvLog

	logString="$(date) :: $(whoami) :: ${FUNCNAME[1]}"

	echo "$logString" >> "$INV_LOG"
}

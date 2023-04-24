#!/usr/bin/env bb-import

# ==================================================================
# bb-functions.d/date
# ==================================================================
# BB-Functions Library
#
# File:         date
# Author:       Ragdata
# Date:         25/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# @file bb-functions.d/date
# @brief Date Functions for BB-Functions Bash Bits Submodule
# ==================================================================
# ATTRIBUTION:	Portions of this software have been inspired, adapted,
#               or borrowed from Labbots brilliant 'bash-utility' package.
#				See Copyright & Attributions in this repository's
#				README file for links and more information.
# COPYRIGHT:	Copyright © 2020 labbots
# ==================================================================
# DEPENDENCIES
# ==================================================================
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# date::now
# ------------------------------------------------------------------
# @description Get current time in unix timestamp
#
# @example
#	echo "$(date::now)"
#	# OUTPUT
#	1591554426
#
# @noargs
#
# @stdout Current Timestamp
#
# @exitcode 0 - Success
# @exitcode 1 - Failure - Unable to generate timestamp
# ------------------------------------------------------------------
date::now()
{
	local now
	now="$(date --universal +%s)" || return $?
	printf "%s" "${now}"
}
# ------------------------------------------------------------------
# date::
# ------------------------------------------------------------------
# ------------------------------------------------------------------

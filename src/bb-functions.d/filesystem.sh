#!/usr/bin/env bash

# ==================================================================
# bb-functions.d/filesystem
# ==================================================================
# BB-Functions Library
#
# File:         filesystem
# Author:       Ragdata
# Date:         25/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# DEPENDENCIES
# ==================================================================
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# files::checkCmd
# ------------------------------------------------------------------
files::checkCmd() { if command -v &> /dev/null; then return 0; else return 1; fi }
# ------------------------------------------------------------------
# files::checkDir
# ------------------------------------------------------------------
files::checkDir() { [[ -d "$1" ]] && return 0 || return 1; }
# ------------------------------------------------------------------
# files::checkFile
# ------------------------------------------------------------------
files::checkFile() { [[ -f "$1" ]] && return 0 || return 1; }
# ------------------------------------------------------------------
# files::checkSrc
# ------------------------------------------------------------------
files::checkSrc() { [[ -f "$1" || -d "$1" ]] && return 0 || return 1; }
# ------------------------------------------------------------------
# files::mkd
# ------------------------------------------------------------------
# shellcheck disable=SC2174
files::mkd() { mkdir -m "$1" -p "${@:2}"; }
# ------------------------------------------------------------------
# files::scriptPath
# ------------------------------------------------------------------
# @description Determine the calling script's current path
#
# @noargs
#
# @stdout The calling script's current path
# ------------------------------------------------------------------
file::scriptPath() { printf '%s' "$(realpath "${BASH_SOURCE[0]}")"; }
# ------------------------------------------------------------------
# files::win2lin
# ------------------------------------------------------------------
# Convert an absolute Windows path to an absolute linux path
# ------------------------------------------------------------------
files::win2lin()
{
	# convert an absolute Windows path to an absolute WSL linux path
	win_path="$1"
	win_path=${win_path/C://c}
	win_path=${win_path//\\//}
	win_path=/mnt$win_path

	printf '%s' "$win_path"
}
# ==================================================================
# ALIAS FUNCTIONS
# ==================================================================
checkCmd() { files::checkCmd; }
checkDir() { files::checkDir "$1"; }
checkFile() { files::checkFile "$1"; }
checkSrc() { files::checkSrc "$1"; }
mkd() { files::mkd "$@"; }
#!/usr/bin/env bash

# ==================================================================
# bb-functions.d/utility
# ==================================================================
# BB-Functions Library
#
# File:         utility
# Author:       Ragdata
# Date:         25/04/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# DEPENDENCIES
# ==================================================================
bb-import bb-functions/is
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# utility::bashInit
# ------------------------------------------------------------------
# @description Reset terminal session without closing terminal window
# ------------------------------------------------------------------
utility::bashInit() { reset; exec sudo --login --user "$USER" /bin/bash -c "cd '$PWD'; exec '$SHELL' -l"; }
# ------------------------------------------------------------------
# utility::checkBash
# ------------------------------------------------------------------
# ------------------------------------------------------------------
utility::checkBash() { [[ "${BASH_VERSION:0:1}" -lt 4 ]] && errorExit "This script requires a minimum Bash version of 4+"; }
# ------------------------------------------------------------------
# utility::checkDeps
# ------------------------------------------------------------------
# @description Checks whether dependencencies listed in arg array are installed on the current system
# ------------------------------------------------------------------
utility::checkDeps()
{
    [[ $# -eq 0 ]] && return
    [[ ! $(is::array "$1") ]] && errorReturn "'$1' Not an Array!" 1

    local -n TOOLS="$1"
    for i in "${!TOOLS[@]}"
    do
        if ! command -v "${TOOLS[$i]}" &> /dev/null; then
            errorReturn "ERROR :: Command '${TOOLS[$i]}' Not Found!" 1
        fi
    done
}
# ------------------------------------------------------------------
# utility::checkRoot
# ------------------------------------------------------------------
# ------------------------------------------------------------------
utility::checkRoot() { [[ "$EUID" -ne 0 ]] && errorExit "This script MUST be run as root!"; }
# ==================================================================
# ALIAS FUNCTIONS
# ==================================================================
bashInit() { utility::bashInit; }
checkBash() { utility::checkBash; }
checkRoot() { utility::checkRoot; }
checkDeps() { utility::checkDeps "$@"; }
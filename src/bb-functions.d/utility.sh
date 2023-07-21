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
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# utility::checkBash
# ------------------------------------------------------------------
utility::checkBash() { [[ "${BASH_VERSION:0:1}" -lt 4 ]] && errorExit "This script requires a minimum Bash version of 4+"; }
# ------------------------------------------------------------------
# utility::checkRoot
# ------------------------------------------------------------------
utility::checkRoot() { [[ "$EUID" -ne 0 ]] && errorExit "This script MUST be run as root!"; }
# ==================================================================
# ALIAS FUNCTIONS
# ==================================================================
checkBash() { utility::checkBash; }
checkRoot() { utility::checkRoot; }
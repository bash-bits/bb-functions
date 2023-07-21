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
    fi

    for file in "${args[@]}"
    do
        bb-import "bb-functions/$file"
    done
}
# ==================================================================
# MAIN
# ==================================================================
# IF SOURCED, RUN LOAD FUNCTION
if [[ $(is::sourced) ]]; then
	functions::load "$@" || return $?
fi

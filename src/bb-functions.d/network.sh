#!/usr/bin/env bash
# shellcheck disable=SC2154
# ==================================================================
# bb-functions.d/network
# ==================================================================
# BB-Functions Library
#
# File:         network
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
# net::getCIDR
# ------------------------------------------------------------------
net::getCIDR()
{
    [[ -z $1 ]] && errorExit "Cowardly refusing to calculate something for nothing!"

    [[ ! $1 =~ $isIPv4 ]] && errorExit "You must input a standard netmask for this function (ie: 255.255.255.0)"

    [[ $1 == "255.255.255.255" ]] && echo "/32"
    [[ $1 == "255.255.255.254" ]] && echo "/31"
    [[ $1 == "255.255.255.252" ]] && echo "/30"
    [[ $1 == "255.255.255.248" ]] && echo "/29"
    [[ $1 == "255.255.255.240" ]] && echo "/28"
    [[ $1 == "255.255.255.224" ]] && echo "/27"
    [[ $1 == "255.255.255.192" ]] && echo "/26"
    [[ $1 == "255.255.255.128" ]] && echo "/25"
    [[ $1 == "255.255.255.0" ]] && echo "/24"
    [[ $1 == "255.255.254.0" ]] && echo "/23"
    [[ $1 == "255.255.252.0" ]] && echo "/22"
    [[ $1 == "255.255.248.0" ]] && echo "/21"
    [[ $1 == "255.255.240.0" ]] && echo "/20"
    [[ $1 == "255.255.224.0" ]] && echo "/19"
    [[ $1 == "255.255.192.0" ]] && echo "/18"
    [[ $1 == "255.255.128.0" ]] && echo "/17"
    [[ $1 == "255.255.0.0" ]] && echo "/16"
    [[ $1 == "255.254.0.0" ]] && echo "/15"
    [[ $1 == "255.252.0.0" ]] && echo "/14"
    [[ $1 == "255.248.0.0" ]] && echo "/13"
    [[ $1 == "255.240.0.0" ]] && echo "/12"
    [[ $1 == "255.224.0.0" ]] && echo "/11"
    [[ $1 == "255.192.0.0" ]] && echo "/10"
    [[ $1 == "255.128.0.0" ]] && echo "/9"
    [[ $1 == "255.0.0.0" ]] && echo "/8"
    [[ $1 == "254.0.0.0" ]] && echo "/7"
    [[ $1 == "252.0.0.0" ]] && echo "/6"
    [[ $1 == "248.0.0.0" ]] && echo "/5"
    [[ $1 == "240.0.0.0" ]] && echo "/4"
    [[ $1 == "224.0.0.0" ]] && echo "/3"
    [[ $1 == "192.0.0.0" ]] && echo "/2"
    [[ $1 == "128.0.0.0" ]] && echo "/1"
}
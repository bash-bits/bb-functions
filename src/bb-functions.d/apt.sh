#!/usr/bin/env bash

# ==================================================================
# bb-functions.d/apt
# ==================================================================
# BB-Functions Library
#
# File:         apt
# Author:       Ragdata
# Date:         13/08/2023
# License:      MIT License
# Copyright:    Copyright © 2023 Darren (Ragdata) Poulton
# ==================================================================
# DEPENDENCIES
# ==================================================================
bb-import bb-regex/options
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# apt::addRepo
# ------------------------------------------------------------------
apt::addRepo()
{
    [[ "$#" -eq 0 ]] && errorReturn "apt::addRepo :: Missing Argument!"

    for repo in "$@"
    do
        echoLog "Adding APT Repository '$repo': " -n
        if sudo add-apt-repository "$repo" -y; then echoLog "SUCCESS!" -c; else errorLog "FAILED!" -c; fi
    done
}
# ------------------------------------------------------------------
# apt::install
# ------------------------------------------------------------------
apt::install()
{
    local log=1
    local fail=0

    for pkg in "$@"
    do
        # shellcheck disable=SC2154
        if [[ $pkg =~ $isLOPTVAL ]]; then
            case "${BASH_REMATCH[1]}" in
                log)
                    [[ ! ${BASH_REMATCH[2]} =~ ^0|1$ ]] && errorReturn "apt::install :: Invalid Argument Value (log) '${BASH_REMATCH[2]}'"
                    log=${BASH_REMATCH[2]}
                    ;;
                fail)
                    [[ ! ${BASH_REMATCH[2]} =~ ^0|1$ ]] && errorReturn "apt::install :: Invalid Argument Value (fail) '${BASH_REMATCH[2]}'"
                    fail=${BASH_REMATCH[2]}
                    ;;
                *)
                    errorReturn "apt::install :: Invalid Option '${BASH_REMATCH[1]}'"
                    ;;
            esac
        else
            apt::installPkg "$pkg" --log="${log}" --fail="${fail}"
        fi
    done

    if [[ "$log" -eq 1 ]] && [[ -f "$BB_LOG" ]]; then
        echoLog "Running 'apt-get clean': " -n
        if sudo apt-get clean -qq -y; then echoLog "SUCCESS!" -c; else exitLog "FAILED!" -c; fi
    else
        echo -n "Running 'apt-get clean': "
        if sudo apt-get clean -qq -y; then echoSuccess "SUCCESS!"; else echoError "FAILED!"; fi
    fi
}
# ------------------------------------------------------------------
# apt::installPkg
# ------------------------------------------------------------------
apt::installPkg()
{
    local package="${1:-}"

    [[ -z "$package" ]] && errorReturn "apt::installPkg :: Missing Argument!"

    shift

    local log=1
    local fail=0

    if [[ "$#" -ne 0 ]]; then
        for opt in "$@"
        do
            if [[ $opt =~ $isLOPTVAL ]]; then
                case "${BASH_REMATCH[1]}" in
                    log)
                        [[ ! ${BASH_REMATCH[2]} =~ ^0|1$ ]] && errorReturn "apt::installPkg :: Invalid Argument Value (log) '${BASH_REMATCH[2]}'"
                        log=${BASH_REMATCH[2]}
                        ;;
                    fail)
                        [[ ! ${BASH_REMATCH[2]} =~ ^0|1$ ]] && errorReturn "apt::installPkg :: Invalid Argument Value (fail) '${BASH_REMATCH[2]}'"
                        fail=${BASH_REMATCH[2]}
                        ;;
                    *)
                        errorReturn "apt::installPkg :: Invalid Option '${BASH_REMATCH[1]}'"
                        ;;
                esac
            else
                errorReturn "apt::installPkg :: Invalid Option '$opt'"
            fi
        done
    fi

    if [[ "$log" -eq 1 ]] && [[ -f "$BB_LOG" ]]; then
        echoLog "Installing package '$package': " -n
        if sudo apt install -qq -y; then echoLog "SUCCESS!" -c; else exitLog "FAILED!" -c; [[ "$fail" -eq 1 ]] && return 1; fi
    else
        echo -n "Installing package '$package': "
        if sudo apt install -qq -y; then echoSuccess "SUCCESS!"; else echoError "FAILED!"; [[ "$fail" -eq 1 ]] && return 1; fi
    fi
}
# ------------------------------------------------------------------
# apt::remove
# ------------------------------------------------------------------
apt::remove()
{
    local log=1

    for pkg in "$@"
    do
        if [[ $pkg =~ $isLOPTVAL ]]; then
            case "${BASH_REMATCH[1]}" in
                log)
                    [[ ! ${BASH_REMATCH[2]} =~ ^0|1$ ]] && errorReturn "apt::remove :: Invalid Argument Value (log) '${BASH_REMATCH[2]}'"
                    log=${BASH_REMATCH[2]}
                    ;;
                *)
                    errorReturn "apt::remove :: Invalid Option '${BASH_REMATCH[1]}'"
                    ;;
            esac
        else
            apt::removePkg "$pkg" --log="${log}"
        fi
    done

    if [[ "${log}" -eq 1 ]] && [[ -f "$BB_LOG" ]]; then
        echoLog "Running 'apt-get autoremove && apt-get autoclean': " -n
        if sudo apt-get autoremove && apt-get autoclean -qq -y; then echoLog "SUCCESS!" -c; else errorLog "FAILED!" -c;fi
    else
        echo -n "Running 'apt-get autoremove && apt-get autoclean': "
        if sudo apt-get autoremove && apt-get autoclean -qq -y; then echoSuccess "SUCCESS!" -c; else echoError "FAILED!" -c;fi
    fi
}
# ------------------------------------------------------------------
# apt::removePkg
# ------------------------------------------------------------------
apt::removePkg()
{
    local package="${1:-}"

    [[ -z "$package" ]] && errorReturn "apt::removePkg :: Missing Argument!" 1

    shift

    local log=1

    if [[ "$#" -ne 0 ]]; then
        for opt in "$@"
        do
            if [[ $opt =~ $isLOPTVAL ]]; then
                case "${BASH_REMATCH[1]}" in
                    log)
                        [[ ! ${BASH_REMATCH[2]} =~ ^0|1$ ]] && errorReturn "apt::removePkg :: Invalid Argument Value (log) '${BASH_REMATCH[2]}'" 1
                        log=${BASH_REMATCH[2]}
                        ;;
                    *)
                        errorReturn "apt::removePkg :: Invalid Option '${BASH_REMATCH[1]}'" 1
                        ;;
                esac
            else
                errorReturn "apt::removePkg :: Invalid Option '$opt'" 1
            fi
        done
    fi

    if [[ "$log" -eq 1 ]] && [[ -f "$BB_LOG" ]]; then
        echoLog "Removing package '$package': " -n
        if sudo apt purge -qq -y; then echoLog "SUCCESS!" -c; else exitLog "FAILED!" -c; fi
    else
        echo -n "Installing package '$package': "
        if sudo apt purge -qq -y; then echoSuccess "SUCCESS!"; else echoError "FAILED!"; fi
    fi
}
# ------------------------------------------------------------------
# apt::findPkg
# ------------------------------------------------------------------
apt::findPkg()
{
    [[ -z "$1" ]] && errorReturn "apt::findPkg :: Cowardly refusing to search for nothing!"
    sudo apt-cache search "${1}"
}
# ------------------------------------------------------------------
# apt::showPkg
# ------------------------------------------------------------------
apt::showPkg()
{
    [[ -z "$1" ]] && errorReturn "apt::showPkg :: Cowardly refusing to show nothing!"
    sudo apt-cache show "${1}"
}
# ------------------------------------------------------------------
# apt::list
# ------------------------------------------------------------------
apt::list()
{
    local cmd

    [[ -z "$1" ]] && errorReturn "apt::list :: Missing Argument!" 1

    case "$1" in
        -a|--available|available)
            cmd="sudo apt-cache search ."
            ;;
        -i|--installed|installed)
            cmd="sudo apt list --installed"
            ;;
        *)
            errorReturn "apt::list :: Invalid Argument '$1'!"
            ;;
    esac

    if [[ -n "$2" ]]; then
        eval "$cmd" | grep "$2"
    else
        eval "$cmd"
    fi
}

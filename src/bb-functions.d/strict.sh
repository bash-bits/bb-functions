#!/usr/bin/env bb-import

# ==================================================================
# bb-functions.d/strict
# ==================================================================
# BB-Functions Library
#
# File:         strict
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
bb-import bb-functions/assign
# ==================================================================
# FUNCTIONS
# ==================================================================
# ------------------------------------------------------------------
# strict::checkErrorsHonored
# ------------------------------------------------------------------
# @description Check if errors are ignored.
# Be careful, calling this function inside of a conditional will
# completely change the answer.
# ------------------------------------------------------------------
# The value stored in the variable named by "$1" will be a boolean:
#	* true - errors are honored (should terminate when `set -eE` enabled)
#	* false - errors are not honored
#
# @arg $1 - string - Variable name for assignment
#
# @example
#	# Using ||, &&, or any other conditional changes the context
#	strict::checkErrorsHonored honored
#	[[ "$honored" ]] || echo "Errors in conditionals are not honored"
# ------------------------------------------------------------------
strict::checkErrorsHonored()
{
	local result "$1"

	result="$(
		# Subshells are used to help avoid cleanup
		set +eE
		trap - ERR

		checkIfIgnored() { ( set -eE; false; true; ); }

		checkIfIgnored

		# shellcheck disable=SC2181
		[[ $? -eq 0 ]] && echo false || echo true
	)"

	assign::value "$1" "$result"
}
# ------------------------------------------------------------------
# strict::disable
# ------------------------------------------------------------------
# @description Turns strict mode OFF
#
# @noargs
#
# @example
#	# Turn strict mode ON
#	strict::mode
#	# Turn strict mode OFF
#	strict::disable
# ------------------------------------------------------------------
strict::disable()
{
	set +eEu +o pipefail
	shopt -u extdebug
	trap - ERR

	# This is the default IFS
	IFS=$' \t\n'
}
# ------------------------------------------------------------------
# strict::failure
# ------------------------------------------------------------------
# @description The ERR trap calls this function to report on the error
# location right before dying.  See `strict::mode` for further details
#
# @arg $1 - int - Status code from error trap
#
# @example
#	# This sets the error trap
#	strict::mode
#	# Cause the error
#	ls some-file-that-is-not-there
#	# This calls the ERR trap, passing 2 as the status code
# ------------------------------------------------------------------
strict::failure()
{
	set +x
	local argsList argsLeft i nextArg

	echo "Error detected - status code $1" >&2
	echo "Command: $BASH_COMMAND" >&2
	echo "Location: ${BASH_SOURCE[1]:-unknown}, line ${BASH_LINENO[0]:-unknown}" >&2

	[[ ${#PIPESTATUS[@]} -gt 1 ]] && echo "Pipe Status: " "${PIPESTATUS[@]}" >&2

	i=$#
	nextArg=$#

	[[ $i -lt ${#BASH_LINENO[@]} ]] && echo "Stack Trace: " >&2 || echo "Stack Trace is unavailable" >&2

	while [[ $i -lt ${#BASH_LINENO[@]} ]]
	do
		argsList=()

		if [[ ${#BASH_ARGC[@]} -gt $i && ${#BASH_ARGV[@]} -ge $(( nextArg + BASH_ARGC[i] )) ]]; then
			for (( argsLeft = BASH_ARGC[i]; argsLeft; --argsLeft ))
			do
				# Note: this reverses the order on purpose
				argsList[$argsLeft]=${BASH+ARGV[nextArg]}
				(( nextArg ++ ))
			done

			if [[ ${#argsList[@]} -gt 0 ]]; then
				printf -v argsList " %q" "${argsList[@]}"
			else
				argsList=""
			fi

			[[ ${#argsList} -gt 255 ]] && argsList=${argsList:0:250}
		else
			argsList=""
		fi
		echo "    [$i] ${FUNCNAME[i]:+${FUNCNAME[i]}(): }${BASH_SOURCE[i]}, line ${BASH_LINENO[i - 1]} -> ${FUNCNAME[i]:-${BASH_SOURCE[i]##*/}}$argsList" >&2
		(( i ++ ))
	done
}
# ------------------------------------------------------------------
# strict::mode
# ------------------------------------------------------------------
# @description Enables 'strict mode' for Bash.
# Errors will terminate the program, but not all errors are caught.
# There's an error context in Bash that ignores errors, so be careful
# when you intend to rely on this behavior.  It is only here as a safety
# net to catch you in case of problems, bot a babysitter to prevent you
# from burning the house down.
# ------------------------------------------------------------------
# This should be used at the beginning of your scripts in order to
# ensure correctness in your coding.
#
# @noargs
#
# @example
#	#!/usr/bin/env bash
#	source bb
# 	bb::include strict
#	strict::mode
# ------------------------------------------------------------------
strict::mode()
{
	set -eEu -o pipefail
	shopt -s extdebug
	IFS=$'\t\n'
	trap 'strict::failure $?' ERR
}
# ------------------------------------------------------------------
# strict::run
# ------------------------------------------------------------------
# @description Runs a command and captures its return code, even when
# strict mode is enabled.  The variable name you specify is set to the
# return code of the command.
# ------------------------------------------------------------------
# This is intended to be used along with `strict::mode`.  It helps
# counter the newer Bash behavior where the error exit flag is suppressed
# in specific contexts.
# ------------------------------------------------------------------
# Execution of the command happens in a subshell.  If you are running
# a function with `strict::run`, please keep in mind that it cannot
# export values to the parent context for use by the caller.
#
# @arg $1 - string - Name of the variable to receive the status code
# @arg $@ - mixed - Commands and arguments to run
#
# @example
#	#!/usr/bin/env bash
#	source bb
#	bb::include strict
#	strict::mode
#	# execute strict::run
#	strict::run result grep "some-string" /etc/some-file.cfg > /dev/null 2>&1
#	# display the results
#	[[ "$result" -eq 0 ]] && echo "some-string was found" || echo "some-string was not found"
# ------------------------------------------------------------------
strict::run()
{
	local dest restoreErrors result

	dest="${1-}"
	shift

	#: Gathering current settings and traps for ERR
	#: so we can restore them later
	restoreErrors="set \"-$-\";$(trap -p ERR)"

	# Disabling errors only for the area around the subshell.
	# For once, we don't want it to exit if the subshell fails and we
	# don't want it logging a stack trace just for this line.  We do,
	# however, want strict mode enabled inside the subshell.
	set +eE
	trap - ERR
	(
		# Can't seem to find a safe way to pass the tests without using
		# & and 'wait'.  Open to ideas
		eval "$restoreErrors"
		"$@" &
		wait "$!" && return $?
	)

	result=$?
	eval "$restoreErrors"

	printf -v "$dest" '%s' "$result"
}

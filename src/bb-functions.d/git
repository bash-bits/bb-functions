#!/usr/bin/env bb-import

# ==================================================================
# bb-functions.d/git
# ==================================================================
# BB-Functions Library
#
# File:         git
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
# git::commitLog
# ------------------------------------------------------------------
git::commitLog()
{
	local commit_hash="echo {} | grep -o '[a-fA-F0-9\{7\}]' | head -1"
	local view_commit="$commit_hash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

	git log --color=always \
			--format="%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" "$@" | \
	fzf --no-sort --tiebreak=index --no-multi --reverse --ansi \
			--header="enter to view, alt-y to copy hash" --preview="$view_commit" \
			--bind="enter:execute:$view_commit | less -R" \
			--bind="alt-y:execute:$commit_hash | xclip -selection clipboard"
}

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# Source any distro specific base shell
[ -f /etc/bash.bashrc ] && . /etc/bash.bashrc &> /dev/null
[ -f /etc/bashrc ] && . /etc/bashrc &> /dev/null

# Uncomment for color prompt when supported
color_prompt_when_supported=yes

# Check for color support
if [ -n "$color_prompt_when_supported" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >& /dev/null; then
		color_prompt=yes
	fi
fi

# Define prompt fragments
jobs_ps1='$(
	N="$(jobs 2> /dev/null | wc -l)"
	if [[ -n "$N" ]] && [[ "$N" != 0 ]]; then
		if [[ "$N" == 1 ]]; then
			N="${N} job"
		else
			N="${N} jobs"
		fi
		echo "[$N] "
	fi
)'
debian_chroot_ps1='${debian_chroot:+($debian_chroot)}'
rc_ps1='$(RC="$?"; [[ "$RC" -ne 0 ]] && echo -n "[rc=$RC] ")'
login_ps1='\u@\h'
window_ps1="$([[ -n "$WINDOW" ]] && echo -n "[w$WINDOW]")"
pwd_ps1='\w'
# __git_ps1 provided by /usr/share/git-core/contrib/completion/git-prompt.sh
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
  . /usr/share/git-core/contrib/completion/git-prompt.sh
  #export GIT_PS1_SHOWDIRTYSTATE=true
  #export GIT_PS1_SHOWUNTRACKEDFILES=true
fi
git_ps1='$(__git_ps1 " (%s)" 2> /dev/null)'

# Add color to fragments
if [ "$color_prompt" = yes ]; then
	# No color for debian_chroot_ps1
	[ -n "$rc_ps1"     ] &&     rc_ps1="\[\033[01;31m\]$rc_ps1\[\033[01;00m\]"
	[ -n "$jobs_ps1"   ] &&   jobs_ps1="\[\033[01;32m\]$jobs_ps1\[\033[01;00m\]"
	#[ -n "$login_ps1"  ] &&  login_ps1="\[\033[01;32m\]$login_ps1\[\033[00m\]"
	[ -n "$login_ps1"  ] &&  login_ps1="\[\033[01;91m\]$login_ps1\[\033[00m\]"
	[ -n "$window_ps1" ] && window_ps1="\[\033[01;33m\]$window_ps1\[\033[00m\]"
	[ -n "$pwd_ps1"    ] &&    pwd_ps1="\[\033[01;34m\]$pwd_ps1\[\033[00m\]"
	[ -n "$git_ps1"    ] &&    git_ps1="\[\033[01;31m\]$git_ps1\[\033[01;00m\]"
fi

# Set prompt
export PS1="$debian_chroot_ps1$rc_ps1$jobs_ps1$login_ps1$window_ps1 $pwd_ps1$git_ps1\$ "
export SUDO_PS1="$( echo -n "$PS1" | sed -e 's/;32m/;31m/g' )"
unset debian_chroot_ps1 rc_ps1 login_ps1 window_ps1 pwd_ps1 git_ps1
unset color_prompt color_prompt_when_supported

# update terminal title
if [ -z "$PROMPT_COMMAND" ]; then
	case $TERM in
		xterm*|vte*)
			if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
				PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
			elif [ "${VTE_VERSION:-0}" -ge 3405 ]; then
				PROMPT_COMMAND="__vte_prompt_command"
			else
				PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
			fi
			;;
		screen*)
			if [ -e /etc/sysconfig/bash-prompt-screen ]; then
				PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
			else
				PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
			fi
			;;
		*)
			[ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
			;;
	esac
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Man pages in vim
# FIXME issues with bold
#if which vim &>/dev/null; then
#	export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
#fi

# Add user local bin/ directory to path
if [[ -e "$HOME/bin" ]]; then
	export PATH="$HOME/bin:$PATH"
fi

# Proxy settings
if [[ -z "$proxy_addr" ]]; then
	proxy_file="$HOME/.proxy"
	if [[ -f "$proxy_file" ]]; then
		proxy_addr=$( cat "$proxy_file" )
	fi
fi
if [[ -n "$proxy_addr" ]]; then
	export http_proxy="$proxy_addr"
	export https_proxy="$proxy_addr"
fi
unset proxy_addr proxy_file


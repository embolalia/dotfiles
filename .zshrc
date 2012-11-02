# With great thanks and credit to Paradigm and his wonderfully crafted .zshrc
# https://github.com/paradigm/dotfiles/blob/master/.zshrc


# Lines configured by zsh-newuser-install, minus those also set by Paradigm
HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/embo/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# ==============================================================================
# = general settings =
# ==============================================================================

# cd into directory just by directory name
setopt autocd

# prompt to correct typos
setopt correct

# don't propose _shellfunctions when correcting
CORRECT_IGNORE='_*'

# additional glob options
setopt extendedglob

# shut up
setopt nobeep

# don't change nice for bg tasks
setopt nobgnice

# Disable flow control. Specifically, ensure that ctrl-s does not stop
# terminal flow so that it can be used in other programs (such as Vim).
setopt noflowcontrol
stty -ixon

# Do not kill background processes when closing the shell. 
setopt nohup

# Do not warn about closing the shell with background jobs running.
setopt nocheckjobs

# don't record repeated things in history
setopt histignoredups

# allows comments in commands
setopt interactivecomments

# consider / a word break, for ctrl-w
WORDCHARS=${WORDCHARS//\/}

# ==============================================================================
# = completion =
# ==============================================================================

# $fpath defines where Zsh searches for completion functions. Include one in
# the $HOME directory for non-root-user-made completion functions.

#fpath=(~/.zsh/completion $fpath)

# Zsh's completion can benefit from caching. Set the directory in which to
# load/store the caches.
CACHEDIR="$HOME/.zsh/$(uname -n)"

# Use completion functionality.
autoload -U compinit
compinit -d $CACHEDIR/zcompdump 2>/dev/null

# cache, speed things up
zstyle ':completion:*' use-cache on

# Set the cache location.
zstyle ':completion:*' cache-path $CACHEDIR/cache

# If the <tab> key is pressed with multiple possible options, print the
# options. If the options are printed, begin cycling through them.
zstyle ':completion:*' menu select

# Print the catagories the completion options fit into.
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

# Set format for warnings
zstyle ':completion:*:warnings' format 'Sorry, no matches for: %d%b'

# Use colors when outputting file names for completion options.
zstyle ':completion:*' list-colors ''

# Do not prompt to cd into current directory.
# For example, cd ../<tab> should not prompt current directory.
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# When using history-complete-(newer/older), complete with the first item on
# the first request (as opposed to 'menu select' which only shows the menu on
# the first request)
zstyle ':completion:history-words:*' menu yes


# ==============================================================================
# = functions and zle widgets =
# ==============================================================================
#
# ------------------------------------------------------------------------------
# - zle widgets -
# ------------------------------------------------------------------------------
#
# The ZLE widges are all followed by "zle -<MODE> <NAME>" and bound below in
# the "Key Bindings" section.

# Prepend "sudo" to the command line if it is not already there.
prepend-sudo() {
	if ! echo "$BUFFER" | grep -q "^sudo "
	then
		BUFFER="sudo $BUFFER"
		CURSOR+=5
	fi
}
zle -N prepend-sudo

# Prepend "vim" to the command line if it is not already there.
prepend-vim() {
	if ! echo "$BUFFER" | grep -q "^vim "
	then
		BUFFER="vim $BUFFER"
		CURSOR+=5
	fi
}
zle -N prepend-vim

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# other custom functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# cd into a directory then immediately ls
cds() {
	cd $1 && ls
}

# ==============================================================================
# = key bindings =
# ==============================================================================

# temporarily save line contents
bindkey "^Y" push-line

# prepend sudo
bindkey "^S" prepend-sudo

# prepend vim
bindkey "^V" prepend-vim

# ==========================================================================
# environmental variables
# ==========================================================================
#
# ------------------------------------------------------------------------------
# - general (evironmental variables) -
# ------------------------------------------------------------------------------

# "/bin/zsh" should be the value of $SHELL if this config is parsed. This line
# should not be necessary, but it's not a bad idea to have just in case.
export SHELL="/bin/zsh"

# Set the default text editor.
export EDITOR="vim"

# Set the default file manager.
export FILEMAN="nautilus"

# if in X11, set firefox as browser
# else, set elinks as browser
if [[ -z $DISPLAY ]]; then
	export BROWSER="elinks"
else
	export BROWSER="firefox"
fi

# If in a terminal that can use 256 colors, ensure TERM reflects that fact.
if [ "$TERM" = "xterm" ]
then
	export TERM="xterm-256color"
elif [ "$TERM" = "screen" ]
then
	export TERM="screen-256color"
fi

# set PDF reader
export PDFREADER="evince"
export PDFVIEWER="evince"

# Set the default image viewer.
export IMAGEVIEWER="eog"

# sets mail directory
export MAIL="~/.mail"

export TZ="America/New_York"

if [ -x "$(which fpaste)" ]
then
	export PASTEBIN="fpaste"
elif [ -x "$(which pastebinit)" ]
then
	export PASTEBIN="pastebinit"
else
	export PASTEBIN="echo \"You dont have a pastebin!\""
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/lib" ] ; then
    export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH
fi

# ------------------------------------------------------------------------------
# - prompt (environmental variables) -
# ------------------------------------------------------------------------------
#
# Prompt is user@host:directory, in red and followed by # if root, otherwise
# in blue and followed by $

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    LOCATION_SYMBOL='Σ'
# many other tests omitted
else
    LOCATION_SYMBOL=''
fi

autoload -U colors && colors

if [[ "$EUID" == "0" ]]; then
    export PROMPT="%{$fg_bold[blue]%}[%{$fg_bold[red]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$fg_bold[blue]%}] [%{$reset_color%}%{$fg[green]%}%~%{$fg_bold[blue]%}]%{$reset_color%}
$LOCATION_SYMBOL\# "
else
    export PROMPT="%{$fg_bold[blue]%}[%{$fg_bold[green]%}%n%{$reset_color%}%{$fg[green]%}@%m%{$fg_bold[blue]%}] [%{$reset_color%}%{$fg[green]%}%~%{$fg_bold[blue]%}]%{$reset_color%}
$LOCATION_SYMBOL\$ "
#export PROMPT=$'%{\e[0;36m%}%n@%m:%~'\$$'%{\e[0m%} '
fi

# ==============================================================================
# = aliases =
# ==============================================================================

# ------------------------------------------------------------------------------
# - new commands (aliases) -
# ------------------------------------------------------------------------------

# Clear the screen then run `ls`
alias cls="clear;ls"

# Search entire filesystem and ignore errors
alias finds="find / -name 2>/dev/null"

# Take ownership of file or directory
alias mine="sudo chown -R $(whoami):$(whoami)"

# allow others to read/execute
alias yours="sudo find . -perm -u+x -exec chmod a+x {} \; && sudo find . -perm -u+r -exec chmod a+r {} \;"

# ------------------------------------------------------------------------------
# - shortcuts to existing commands (aliases) -
# ------------------------------------------------------------------------------

alias pbin="$PASTEBIN"
alias fman="$FILEMAN ."
alias mc="java -jar ~/prog/minecraft/minecraft.jar&exit"
alias py="python"
alias py2="python2.7"
alias py3="python3.2"
alias ta="tmux attach"
alias :wq="exit"
alias :q="exit"
alias s="sudo"
alias v="vim"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias vv="cd /dev/shm/"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Networking, ssh, remote drives, etc.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias hbd="sudo mount 192.168.1.22:/files /h"
alias cse="ssh -X powelle@stdlinux.cse.ohio-state.edu"
alias osc="ssh -X embolalia@opensource.osu.edu"
alias chunk="ssh -X embo@66.172.33.23"
alias desktop="ssh -X embo@embolalia.net -p 1991"
alias tunnel="ssh -R 1991:localhost:22 tunnel@embolalia.net"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set default flags
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias ls="ls --color=auto -h --group-directories-first"
alias la="ls -A --color=auto -h --group-directories-first"
alias ll="ls -lA --color=auto -h --group-directories-first"
alias du="du -hs"
alias df="df -h"
alias grep="grep -IR --color=yes -D skip --exclude-dir=.git"
alias cl="clive --format=best"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# git
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias gc="git commit -a -v"
alias gb="git branch"
alias gl="git log --graph --color | less -R"
alias gr="git reset --hard HEAD"
alias gs="git status"
alias gw="git show"
alias gco="git checkout"
alias gm="git merge"
alias gus="git push"
alias guss='git push origin $(git branch | awk '\''/^\*/{print$2}'\'')'
alias gul="git pull"
alias gull='git pull origin $(git branch | awk '\''/^\*/{print$2}'\'')'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# package management
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f /etc/arch-release ]
then
	DISTRO="Arch"
elif [ -f /etc/slackware-version ]
then
	DISTRO="Slackware"
elif [ -f /etc/gentoo-release ]
then
	DISTRO="Gentoo"
elif [ -f /etc/debian-release ]
then
	DISTRO="Debian"
elif [ -d /etc/linuxmint ]
then
	DISTRO="Mint"
elif [ -f /etc/lsb-release ]
then
	DISTRO=$(awk -F= '/DISTRIB_ID/{print$2;exit}' /etc/lsb-release)
elif [ -f /etc/issue ]
then
	DISTRO=$(awk '/[:alpha:]/{print$1;exit}' /etc/issue 2>/dev/null)
fi


if [ "$DISTRO" = "Debian" ] || [ "$DISTRO" = "Ubuntu" ] || [ "$DISTRO" = "Mint" ]
	then
	# Install package
	alias ki="sudo apt-get install"
	# Remove package
	alias kr="sudo apt-get --purge remove"
	# Updated packages
	alias ku="sudo apt-get update && sudo apt-get upgrade"
	# List installed packages
	alias kl="dpkg -l"
	# Clean up package manager cruft
	alias kc="sudo apt-get --purge autoremove"
	# Search for package name in repository
	alias ks="apt-cache search"
	# show to which installed package a file Belongs
	alias kb="dpkg -S"
	# shoW information about package
	alias kw="apt-cache show"
	# Find package containing file
	alias kf="apt-file search"
elif [ "$DISTRO" = "Arch" ]
then
	if which packer >/dev/null
	then
		# Install package
		alias ki="sudo packer -S"
		# Remove package
		alias kr="sudo pacman -R" # packer does not provide -R
		# Updated packages
		alias ku="sudo packer -Syu"
		# List installed packages
		alias kl="pacman -Q" # packer does not provide -Q
		# Clean up package manager cruft
		alias kc='sudo packer -Sc && for PKG in `packer -Qqtd`; do sudo packer -Rs $PKG; done'
		# Search for package name in repository
		alias ks="packer -Ss"
		# show to which installed package a file Belongs
		alias kb="pacman -Qo"
		# shoW information about package
		alias kw="packer -Si"
		# Find package containing file
		alias kf="sudo pkgfile"
	else
		# Install package
		alias ki="sudo pacman -S"
		# Remove package
		alias kr="sudo pacman -R"
		# Updated packages
		alias ku="sudo pacman -Syu"
		# List installed packages
		alias kl="pacman -Q"
		# Clean up package manager cruft
		alias kc='sudo pacman -Sc && for PKG in `pacman -Qqtd`; do sudo pacman -Rs $PKG; done'
		# Search for package name in repository
		alias ks="pacman -Ss"
		# show to which installed package a file Belongs
		alias kb="pacman -Qo"
		# shoW information about package
		alias kw="pacman -Si"
		# Find package containing file
		alias kf="sudo pkgfile"
	fi
elif [ "$DISTRO" = "Fedora" ] || [ "$DISTRO" = "CentOS" ]
	then
	# Install package
	alias ki="sudo yum install"
	# Remove package
	alias kr="sudo yum remove"
	# Updated packages
	alias ku="sudo yum update"
	# List installed packages
	alias kl="yum list installed"
	# Clean up package manager cruft
	alias kc="sudo yum clean all"
	# Search for package name in repository
	alias ks="yum search"
	# show to which installed package a file Belongs
	alias kb="rpm -qa"
	# shoW information about package
	alias kw="yum info"
	# Find package containing file
	alias kf="sudo yum whatprovides"
elif [ "$DISTRO" = "Slackware" ]
then
	# Install package
	alias ki="sudo slackpkg install"
	# Remove package
	alias kr="sudo slackpkg remove"
	# Updated packages
	alias ku="sudo slackpkg update && slackpkg install-new && slackpkg upgrade-all"
	# Search for package name in repository
	alias ks="sudo slackpkg search"
elif [ "$DISTRO" = "Gentoo" ]
then # none of these are tested, just gathered around
	# Install package
	alias ki="emerge"
	# Remove package
	alias kr="emerge -C"
	# List installed package
	alias kl="emerge -ep world"
	# Clean up package manager cruft
	alias kc="emerge --depclean"
	# Search for package name in repository
	alias ks="emerge --search"
	# show to which installed package a file Belongs
	alias kb="equery belongs"
	# Updated packages
	alias ku="emerge --update --ask world"
	alias kU="emerge --update --deep --newuse world"
	# shoW information about package
	alias kS="emerge --searchdesc"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# pip aliases
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias pki="sudo pip install"
alias pkr="sudo pip uninstall"
alias pks="pip search"
alias pkl="pip freeze | grep "

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# global aliases
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias -g L="|less"
alias -g G="|grep"
alias -g B="&exit"
alias -g H="|head"
alias -g T="|tail"
alias -g V="|vim -m -c 'set nomod' -"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run-with-command
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias -s html=$BROWSER
alias -s htm=$BROWSER
alias -s org=$BROWSER
alias -s php=$BROWSER
alias -s com=$BROWSER
alias -s edu=$BROWSER
alias -s txt=$EDITOR
alias -s tex=$EDITOR
alias -s pdf=$PDFREADER
alias -s gz=tar -xzvf
alias -s bz2=tar -xjvf

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# nocorrect
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias mkdir="nocorrect mkdir"
alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias ln="nocorrect ln"

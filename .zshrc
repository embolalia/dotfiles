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

# Include local .zshrc if extant
if [[ -f "$HOME/.zshrc.local" ]] then
    source "$HOME/.zshrc.local"
fi

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

# Case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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

# Prepend "sudo" to the command line if it is not already there. If it's a vim
# command, use sudoedit instead.
prepend-sudo() {
    if ! echo "$BUFFER" | grep -q "^sudo "
    then
        if echo "$BUFFER" | grep -q "^vim "; then
            BUFFER="sudoedit ${BUFFER:4:${#BUFFER}}"
            CURSOR+=5
        else
            BUFFER="sudo $BUFFER"
            CURSOR+=5
        fi
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


# Remove command and prep to enter new one
new-command() {
    BUFFER=" ${BUFFER#* *}"
    CURSOR=0
}
zle -N new-command
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# other custom functions
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# cd into a directory then immediately ls
cds() {
    cd $1 && ls
}

say() {
    if [[ "${1}" =~ -[a-z]{2} ]]
    then
        local lang=${1#-}
        local text="${*#$1}"
    else local lang=${LANG%_*}
        local text="$*"
    fi
    mplayer "http://translate.google.com/translate_tts?ie=UTF-8&tl=${lang}&q=${text}" &> /dev/null 
}

# New Python virtualenv
function mkenv() {
    virtualenv --prompt=\($(basename $(pwd))\) env
    source ./env/bin/activate
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

# replace command
bindkey "^G" new-command

# Don't break insert/delete/etc. on some distros (COUGH FEDORA COUGH)
typeset -A key

key[Home]=${terminfo[khome]}

key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

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
export GEDITOR="gedit"

# Set the default file manager.
if [ -x "$(which nemo 2> /dev/null)" ]
then
    export FILEMAN="nemo"
elif [ -x "$(which nautilus 2> /dev/null)" ]
then
    export FILEMAN="nautilus"
#TODO is there an open command on non-OSX?
elif [ -x "$(which open 2> /dev/null)" ]
then
    export FILEMAN="open"
else
    export FILEMAN="echo \"No File Manager!\""
fi

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

if [ -x "$(which fpaste 2> /dev/null)" ]
then
    export PASTEBIN="fpaste"
    export PASTEBINF="fpaste -l"
elif [ -x "$(which pastebinit 2> /dev/null)" ]
then
    export PASTEBIN="pastebinit"
    export PASTEBINF="pastebinit -f"
else
    export PASTEBIN="echo \"You dont have a pastebin!\""
    export PASTEBINF="echo \"You dont have a pastebin!\""
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/lib" ] ; then
    export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH
fi

# Fix SSH auth forwarding when reconnecting to tmux sessions
# From http://qq.is/tutorial/2011/11/17/ssh-keys-through-screen.html
SOCK="/tmp/ssh-agent-$USER-screen"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
    rm -f /tmp/ssh-agent-$USER-screen
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
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
$LOCATION_SYMBOL# "
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

# Activate the virtualenv for the current Python project
alias venv="source ./env/bin/activate"
alias activate="source ./env/bin/activate"

# Remove pyc files
alias rmpyc="find . -name '*.pyc' -exec rm {} \;"

# ------------------------------------------------------------------------------
# - shortcuts to existing commands (aliases) -
# ------------------------------------------------------------------------------

if [ -x "$(which gvim 2> /dev/null)" ]
then
    # We need to always use gvim, if it's available, for X keyboard support.
    # *SOME* distros (cough cough Fedora) don't just make vim alias to this,
    # which is obnoxious.
    alias vim="gvim -v"
    export EDITOR="gvim -v"
fi

alias ytdl="youtube-dl -o \"%(uploader)s-%(stitle)s.%(ext)s\""
alias pbin="$PASTEBIN"
alias pbinf="$PASTEBINF"
alias fman="$FILEMAN . 2> /dev/null"
alias len="wc -l"
alias mc="java -jar ~/prog/minecraft/minecraft.jar&exit"
if which ipython &>/dev/null; then
    alias py="ipython"
else
    alias py="python"
fi
alias py2="python2.7"
alias py3="python3"
alias ta="tmux attach"
alias :wq="exit"
alias :q="exit"
alias s="sudo"
alias v="$EDITOR"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias vv="cd /dev/shm/"
alias pw="cd ~/prog/willie"
alias prog="cd ~/prog"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Networking, ssh, remote drives, etc.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias hbd="sudo mount 192.168.1.22:/files /h"
alias cse="ssh -X powelle@stdlinux.cse.ohio-state.edu"
alias aws="ssh -X edward@54.235.244.4"
alias osc="ssh -X embolalia@opensource.osu.edu"
alias chunk="ssh -X embo@76.74.177.239"
alias desktop="ssh -X embo@embolalia.com -p 1991"
alias tunnel="ssh -R 1991:localhost:22 tunnel@embolalia.com"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set default flags
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias ls="ls --color=auto -h --group-directories-first --ignore='*.pyc' --ignore-backups"
alias la="ls -A --color=auto -h --group-directories-first"
alias ll="ls -lA --color=auto -h --group-directories-first"
alias du="du -hs"
alias df="df -h"
alias grep="grep -I --color=yes -D skip --exclude-dir=.git"
alias cl="clive --format=best"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# git
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias gc="git commit -m"
alias gb="git branch"
alias gl="git log --graph --color | less -R"
alias gr="git reset --hard HEAD"
alias gs="git status"
alias gw="git show"
alias gco="git checkout"
alias gm="git merge"
alias gus="git push"
alias gul="git pull"
alias gull='git pull origin $(git branch | awk '\''/^\*/{print$2}'\'')'

function guss () {
    branch=$(git branch | awk '/^\*/{print$2}')
    if test $branch = master; then
        read "?Really push to master? (y/[n]) " yn
        if ! (test "$yn" = Y || test "$yn" = y); then
            echo "Fucked up, din'cha?"
            return
        fi
    fi
    git push origin $branch
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# package management
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if which yum &>/dev/null || which dnf &>/dev/null; then
    # Use DNF if we have it, and yum if we don't. The commands are the same for
    # both.
    _YUM=$(which dnf 2>/dev/null || which yum 2>/dev/null)
    # Install package
    alias ki="sudo $_YUM install"
    # Remove package
    alias kr="sudo $_YUM remove"
    # Updated packages
    alias ku="sudo $_YUM update"
    # List installed packages
    alias kl="$_YUM list installed"
    # Clean up package manager cruft
    alias kc="sudo $_YUM clean all"
    # Search for package name in repository
    alias ks="$_YUM search"
    # show to which installed package a file Belongs
    alias kb="rpm -qa"
    # shoW information about package
    alias kw="$_YUM info"
    # Find package containing file
    alias kf="sudo $_YUM whatprovides"
elif which apt-get &>/dev/null
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
elif which brew &> /dev/null; then
    # Install package
    alias ki="brew install"
    # Remove package
    alias kr="brew uninstall"
    # Updated packages
    alias ku="brew update"
    # List installed packages
    alias kl="brew list"
    # Clean up package manager cruft
    # alias kc=""
    # Search for package name in repository
    alias ks="brew search"
    # show to which installed package a file Belongs
    # alias kb=""
    # shoW information about package
    alias kw="brew info"
    # Find package containing file
    # alias kf=""
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# pip aliases
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function pki () {
    if test $VIRTUAL_ENV || ! test $USERNAME = epowell; then
        pip install $@
    else
        sudo pip install $@
    fi
}

function pkr () {
    if test $VIRTUAL_ENV; then
        pip uninstall $@
    else
        sudo pip uninstall $@
    fi
}

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
alias -g V="|$EDITOR -m -c 'set nomod' -"
alias -g P="|& $PASTEBIN"
alias -g PF="| $PASTEBINF"

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
alias -s gz="tar -xzvf "
alias -s bz2="tar -xjvf "

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# nocorrect
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

alias mkdir="nocorrect mkdir"
alias cp="nocorrect cp"
alias mv="nocorrect mv"
alias ln="nocorrect ln"

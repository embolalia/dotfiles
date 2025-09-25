#!/bin/bash -e
echo "Making symlinks"

if which wslpath && ! test $(wslpath $(wslvar USERPROFILE)) = $HOME; then
    echo "ERROR: Set home to $(wslpath $(wslvar USERPROFILE)) in /etc/passwd, and log out and back in, first"
    exit 1
elif which wslpath; then
    mkdir -p /home/.wsl/$USER/.ssh
    ln -fs /home/.wsl/$USER/.ssh .ssh
else
    mkdir -p .ssh
fi

if which brew &> /dev/null
then
    PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
fi

for f in ./.* ; do
    if [ $f != "./." ] && [ $f != "./.." ] && [ $f != "./.git" ] ; then
        target="$(readlink -f $f)"
        name="$HOME/$f"
        echo "Linking name $name to target $target"
        ln -fs $target $name
    else
        echo "Skipped " $f
    fi
done

winhome='/mnt/c/Users/Else'
if test -d $winhome
then
    vsc_dir=$winhome/Application\ Data/Code/User
    ln -Tfs $(readlink -f ~/.ssh) $winhome/.ssh
elif test -d ~/Library
then
    vsc_dir=~/Library/Application\ Support/Code/User
else
    vsc_dir="~/.config/Code/User"
fi

if which wslpath; then
    cp ssh_config ~/.ssh/config
else
    ln -fs $(readlink -f ssh_config) ~/.ssh/config
fi

mkdir -p "$vsc_dir"
ln -fs $(readlink -f vscode_settings.json) "$vsc_dir/settings.json"

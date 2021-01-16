#!/bin/bash -e
echo "Making symlinks"
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
    ln -Tfs ~/.ssh $winhome/.ssh
elif test -d ~/Library
then
    mkdir -p ~/.ssh
    vsc_dir=~/Library/Application\ Support/Code/User
else
    mkdir -p ~/.ssh
    vsc_dir="~/.config/Code/User"
fi
ln -fs ./ssh_config ~/.ssh/config

mkdir -p "$vsc_dir"
ln -fs vscode_settings.json "$vsc_dir/settings.json"

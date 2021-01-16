#!/bin/sh
PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
for f in ./.* ; do
    if [ $f != "./." ] && [ $f != "./.." ] && [ $f != "./.git" ] ; then
        ln -s $(readlink -f $f) $HOME/$f
    else
        echo "Skipped " $f
    fi
done
if test -d ~/Library
then
    mkdir -p ~/Library/Application\ Support/Code/User
    ln -s vscode_settings.json ~/Library/Application\ Support/Code/User/settings.json
fi

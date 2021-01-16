#!/bin/sh
PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
for f in ./.* ; do
    if [ $f != "./." ] && [ $f != "./.." ] && [ $f != "./.git" ] ; then
        ln -s $(readlink -f $f) $HOME/$f
    else
        echo "Skipped " $f
    fi
done

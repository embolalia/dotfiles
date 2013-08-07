#!/bin/sh
for f in ./.* ; do
    if [ $f != "./." ] && [ $f != "./.." ] && [ $f != "./.git" ] ; then
        ln -s $(readlink -f $f) $HOME/$f
    else
        echo "Skipped " $f
    fi
done

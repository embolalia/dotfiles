#!/bin/sh

ALL_ARGS=$*
shift
shift
scp $* powelle@stdlinux.cse.ohio-state.edu:~/submissions
ssh powelle@stdlinux.cse.ohio-state.edu "cd submissions && submit $ALL_ARGS"

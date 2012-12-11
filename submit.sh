#!/bin/sh

scp $3 powelle@stdlinux.cse.ohio-state.edu:~/submissions
ssh powelle@stdlinux.cse.ohio-state.edu "cd submissions && submit $*"

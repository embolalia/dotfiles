#!/bin/sh -e
# Set up *everything*

if [ -z $(which yum) ]; then
	INSTALLER="apt-get"
	PASTER="pastebinit"
else
	INSTALLER="yum"
	PASTER="fpaste"
fi

./make_symlinks.sh
git config --global core.excludesfile ~/.gitignore_global

git submodule init
git submodule update

if [ "sudo true" ]; then
	sudo $INSTALLER install -y zsh tmux vim $PASTER

	USER=$(whoami)
	sudo chsh -s /bin/zsh $USER
elif [ -n $(which zsh) ]; then
	chsh -s /bin/zsh
fi

if test -e /mnt/c
then
	sudo $INSTALLER install -y keychain
fi

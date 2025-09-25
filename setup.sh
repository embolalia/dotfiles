#!/bin/sh -ev
# Set up *everything*

./make_symlinks.sh

if [ -z $(which yum) ]; then
	INSTALLER="apt-get"
	PASTER="pastebinit"
else
	INSTALLER="yum"
	PASTER="fpaste"
fi

git config --global core.excludesfile ~/.gitignore_global

if [ "sudo true" ]; then
	sudo $INSTALLER install -y zsh tmux vim $PASTER

	USER=$(whoami)
	sudo chsh -s /bin/zsh $USER
elif [ -n $(which zsh) ]; then
	chsh -s /bin/zsh
fi

if which wslinfo
then
	sudo $INSTALLER install -y keychain
fi

git submodule init
git submodule update

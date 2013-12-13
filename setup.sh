#!/bin/sh
# Set up *everything*

if [ -z $(which yum) ]; then
	INSTALLER="apt-get"
	PASTER="pastebinit"
else
	INSTALLER="yum"
	PASTER="fpaste"
fi

DIR=$(cd "$(dirname $0)"; pwd)
cd
mv $DIR ~/.dotfiles
cd .dotfiles

./make_symlinks.sh

git submodule init
git submodule update

if [ "sudo true" ]; then
	sudo $INSTALLER install -y zsh tmux vim $PASTER

	USER=$(whoami)
	sudo chsh -s /bin/zsh $USER
elif [ -n $(which zsh) ]; then
	chsh -s /bin/zsh
fi

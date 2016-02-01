#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude "brew.sh" --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ~;
	source ~/.bash_profile;

	ST3SRC="${HOME}/init/ST3/"
	if [ -d "$ST3SRC" ]; then
		if [ $(uname -s) = "Darwin" ]; then
			ST3DST="${HOME}/Library/Application Support/Sublime Text 3/Packages/User/"
		elif [ $(uname -s) = "Linux" ]; then
			ST3DST="${HOME}/.config/sublime-text-3/Packages/User/"
		fi
		if [ -d "$ST3DST" ]; then
			echo "Syncing Sublime Text 3 config"
			echo "From: $ST3SRC"
			echo "To: $ST3DST"
			rsync -avh "${ST3SRC}" "${ST3DST}"
		fi
	fi
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;

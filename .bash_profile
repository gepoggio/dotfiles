# Global (OS X and Linux) stuff

# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# set vi mode
set -o vi;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null 2>&1 && [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
	complete -o default -o nospace -F _git g;
fi;

# Add AWS CLI completer
if [ -f /usr/local/bin/aws_completer ] && which aws 2>&1 >/dev/null; then
	complete -C '/usr/local/bin/aws_completer' aws
fi

# OS X Specifics
if [ $(uname -s) = "Darwin" ]; then
	# Add tab completion for `defaults read|write NSGlobalDomain`
	# You could just use `-g` instead, but I like being explicit
	complete -W "NSGlobalDomain" defaults;

	# Add `killall` tab completion for common apps
	complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;
fi

if ! [ $(uname -s) = "Darwin" ]; then
	# ssh-agent configuration
	if [ -z "$(pgrep ssh-agent)" ]; then
		rm -rf /tmp/ssh-*
		eval $(ssh-agent -s) > /dev/null
	else
		export SSH_AGENT_PID=$(pgrep ssh-agent)
		export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
	fi

	if [ "$(ssh-add -l)" == "The agent has no identities." ]; then
		ssh-add
	fi
fi

if [ -f "$(which pyenv)" ] && [ -d "$HOME/.pyenv" ]; then
	export PATH="$HOME/.pyenv:$PATH"
	eval "$(pyenv init -)"
fi

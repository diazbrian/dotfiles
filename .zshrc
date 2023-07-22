# Enable colors and change prompt:
autoload -U colors && colors
# PS1="%B%{$fg[magenta]%}[%{$fg[green]%}%n%{$fg[green]%}@%{$fg[green]%}%M %{$fg[magenta]%}%8~%{$fg[magenta]%}]%b"

# Set up the prompt
if [[ $EUID -ne 0 ]]; then
	PS1="%B%F{magenta}[%F{green}%n%F{green}@%F{green}%M %F{cyan}%8~%F{magenta}]%f%b"
else
	PS1="%B%F{magenta}[%F{red}%n%F{red}@%F{red}%M %F{cyan}%8~%F{magenta}]%f%b"
fi

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=8000
SAVEHIST=4000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
zmodload zsh/complist
compinit
_comp_options+=(globdots)

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
# zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Use vi keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# Aliases
alias ls='lsd'
alias ll='ls -l'
alias lla='ls -lA'
alias la='ls -A'
alias ld='ls --group-directories-first'
alias lt='ls --tree'
alias grep='grep --color=auto'
alias cat='batcat --style numbers --paging never'
alias radio="mpg123 http://69.64.46.123:8108/"

# Plugins
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/gitstatus/gitstatus.prompt.zsh
source ~/.config/timer.plugin.zsh

# shell status after gitstatus plugin
PROMPT+=' %(?.%B%#%b.%F{red}%B%#%b%f) '

# built in transient prompt
zle-line-init() {
	emulate -L zsh

	[[ $CONTEXT == start ]] || return 0

	while true; do
		zle .recursive-edit
		local -i ret=$?
		[[ $ret == 0 && $KEYS == $'\4' ]] || break
		[[ -o ignore_eof ]] || exit 0
	done

	local saved_prompt=$PROMPT
	# local saved_rprompt=$RPROMPT
	PROMPT='%B%#%b '
	# RPROMPT=''
	zle .reset-prompt
	PROMPT=$saved_prompt
	# RPROMPT=$saved_rprompt

	if (( ret )); then
		zle .send-break
	else
		zle .accept-line
	fi
	return ret
}

zle -N zle-line-init

# export TERM=xterm-256color

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
  # exec tmux new-session -A -s main
fi

echo -e -n "\x1b[\x31 q" # Blink cursor

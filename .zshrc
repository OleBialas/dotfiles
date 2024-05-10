# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=10000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/obi/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Configure PATH
export PATH=/home/obi/.config/emacs/bin:$PATH

# Set aliases
# delete orphaned packages, if none are found this retruns "error: argument '-' specified with empty stdin"
alias autoremove="sudo pacman -Qtdq | sudo pacman -Rns -"
alias cisco="/opt/cisco/anyconnect/bin/vpnui" # VPN client
alias vim="/usr/bin/nvim" # use neovim
# Fish-like suggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null



[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/obi/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/obi/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/home/obi/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/home/obi/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/obi/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/home/obi/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<


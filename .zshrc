# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/hazeycode/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# History autocomplete
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# Bindkeys
bindkey "^[[3~" delete-char
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;3D" beginning-of-line
bindkey "^[[1;3C" end-of-line

# Prompt config
setopt prompt_subst
autoload -Uz vcs_info # enable vcs_info
precmd () { vcs_info } # always load before displaying the prompt
zstyle ':vcs_info:git*' formats ' %F{42}%b%f' # format $vcs_info_msg_0_
PS1='%F{153}%/%f${vcs_info_msg_0_} $ '

# Set title to cwd
precmd() { print -Pn "\e]2;%~\a" }

# Path
export PATH=~/bin:$PATH

#!/usr/bin/zsh

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

export PLATFORMIO_CORE_DIR="${XDG_DATA_HOME}/platformio"
export DOT_SAGE="${XDG_CONFIG_HOME}/sage"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export OPAMROOT="${XDG_DATA_HOME}/opam"
export WINEPREFIX="${XDG_DATA_HOME}/wine"
export TEXMFHOME="${XDG_DATA_HOME}/texmf"

export JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}"/jupyter
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"

export NUGET_PACKAGES="${XDG_CACHE_HOME}/nuget"

export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

export GHCUP_USE_XDG_DIRS=true

[[ $TERM == eterm-color ]] && export TERM=xterm

export PATH="${HOME}/.zvm/bin/:${HOME}/.local/bin:$PATH"

systemctl --user import-environment PATH

if [ "$TERM" = "screen" ]; then; TERM=screen-256color; fi

# Remove GRML's prompt pre-hook which overwrites it
add-zsh-hook -d precmd prompt_grml_precmd

# GRML's Slow as hell C-e fix
bindkey -r '^Ed' # This causes the shell to wait after C-e to see if the d is going to be pressed, slowing down C-e, which is a pain.

# variables
export RANGER_LOAD_DEFAULT_RC=FALSE

# Sourced Plugins
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# compinits
# compinit ~/.bin/*.zsh-completion

# Sanity
setopt nonomatch

export EDITOR=nvim

# Aliases
alias sudo='sudo -s'
alias grep='rg'
alias ltr="command ls --color=auto -ltr"
export MAKEFLAGS="-j5"

# aura
alias aura="aura --color=always"

# Functions
psaux () { pgrep -f "$@" | xargs ps -fp 2>/dev/null; }


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit light miekg/lean
zinit light Tarrasch/zsh-bd
zinit light Tarrasch/zsh-command-not-found
zinit light Tarrasch/zsh-mcd
zinit light willghatch/zsh-cdr
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit snippet /usr/share/skim/key-bindings.zsh
# zinit snippet /usr/share/skim/completion.zsh

export CC=clang
export CXX=clang++

# Fix GRML prompt (if wanted) colors
prompt_grml_precmd

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias vim="nvim"
alias xmake="mold -run xmake"
alias xb="xmake b"
alias xr='\xmake r -w $(pwd)'

export PAGER=bat
export ZPAGER=bat

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

function scroll-top() {
    local esc
    local -i ROW COL OFFSET
    IFS='[;' read -sdR $'esc?\e[6n' ROW COL <$TTY
    OFFSET="${#${(@Af)PREBUFFER%$'\n'}}"+"${#${(@Af)LBUFFER:-1}}"
    (( ROW-OFFSET )) && printf '\e[%1$dS\e[%1$dA' ROW-OFFSET
    zle redisplay
}
zle -N clear-screen scroll-top

# if [ $TERM -neq foot ] && command -v theme.sh > /dev/null
#     theme.sh hemisu-dark
# fi

# opam configuration (equivalent to eval $(opam env))
[[ ! -r /home/home/.local/share/opam/opam-init/init.zsh ]] || source /home/home/.local/share/opam/opam-init/init.zsh  > /dev/null 2> /dev/null

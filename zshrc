#!/usr/bin/zsh

# zmodload zsh/zprof

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

export PLATFORMIO_CORE_DIR="${XDG_DATA_HOME}/platformio"
export DOT_SAGE="${XDG_CONFIG_HOME}/sage"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export OPAMROOT="${XDG_DATA_HOME}/opam"
export WINEPREFIX="${XDG_DATA_HOME}/wine"
export TEXMFHOME="${XDG_DATA_HOME}/texmf"
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export STACK_XDG=1

export npm_config_userconfig="$XDG_CONFIG_HOME/npm/config"
export npm_config_cache="$XDG_CACHE_HOME/npm"
export npm_config_prefix="$XDG_DATA_HOME/npm"

export JUPYTER_CONFIG_DIR="${XDG_CONFIG_HOME}"/jupyter
export IPYTHONDIR="${XDG_CONFIG_HOME}/ipython"

export NUGET_PACKAGES="${XDG_CACHE_HOME}/nuget"

export LESSHISTFILE="${XDG_STATE_HOME}/less/history"
export HISTFILE="${XDG_STATE_HOME}/zsh/history"

export GHCUP_USE_XDG_DIRS=true

# export PATH="${HOME}/.local/pipx/venvs/flit/bin/:$PATH:$XDG_DATA_HOME/npm/bin"
# export PATH="$PATH:$XDG_DATA_HOME/npm/bin"
# export PATH="$PATH:${HOME}/.local/pipx/venvs/flit/bin"
# export PATH="$PATH:${HOME}/.dotnet/tools"

source <(carapace _carapace)

[[ $TERM == eterm-color ]] && export TERM=xterm

export PATH="${HOME}/.local/share/cargo/bin:${HOME}/.zvm/bin/:${HOME}/.local/bin:$PATH"

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
export LD="mold"

# Aliases
alias sudo='sudo -s'
alias grep='rg'
alias ltr="command ls --color=auto -ltr"
export MAKEFLAGS="-j5"
alias asmdump="objdump -drwC -Mintel --visualize-jumps=color"

# aura
alias aura="aura --color=always"

# Functions
psaux () { pgrep -f "$@" | xargs ps -fp 2>/dev/null; }

export FZF_COMPLETION_TRIGGER="~~"

zstyle ':zim:zmodule' use 'degit'

ZIM_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}/zim"

# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
# [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# source "${ZINIT_HOME}/zinit.zsh"
# 
# zinit light miekg/lean
# 
# zinit light Tarrasch/zsh-bd
# zinit light Tarrasch/zsh-command-not-found
# zinit light Tarrasch/zsh-mcd
# zinit light willghatch/zsh-cdr
# zinit light zdharma-continuum/fast-syntax-highlighting
# zinit light zsh-users/zsh-autosuggestions
# zinit light zsh-users/zsh-completions
# 
# export FZF_COMPLETION_TRIGGER="~~"
# zinit snippet /usr/share/fzf/key-bindings.zsh 
# zinit snippet /usr/share/fzf/completion.zsh
# 
# zinit ice wait lucid
# zinit load wfxr/forgit
# 
# zinit ice wait lucid
# zinit load junegunn/fzf-git.sh

eval "$(zoxide init zsh)"

autoload -Uz compinit

if [[ -n ${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}(#qN.mh+24) ]]; then
    compinit -d ${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}
else
	compinit -C;
fi;

# export ATUIN_NOBIND=1
# zinit load atuinsh/atuin

export CC=clang
export CXX=clang++

# Fix GRML prompt (if wanted) colors
prompt_grml_precmd

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
    OFFSET="${#${(@Af)PREBUFFER%$'\n'}}"+"${#${(@Af)LBUFFER:-1}}" # "
    (( ROW-OFFSET )) && printf '\e[%1$dS\e[%1$dA' ROW-OFFSET
    zle redisplay
}
zle -N clear-screen scroll-top

atuin-setup() {
    if ! which atuin &> /dev/null; then return 1; fi
    # bindkey '^E' _atuin_search_widget

    _zsh_autosuggest_strategy_atuin_top() {
        suggestion=$(atuin search --cmd-only --limit 1 --search-mode prefix -- $1)
    }
    ZSH_AUTOSUGGEST_STRATEGY=atuin_top

    # export ATUIN_NOBIND="true"
    eval "$(atuin init zsh --disable-up-arrow)"
    # fzf-atuin-history-widget() {
    #     local selected num
    #     setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2>/dev/null

    #     # local atuin_opts="--cmd-only --limit ${ATUIN_LIMIT:-5000}"
    #     local atuin_opts="--cmd-only --print0"
    #     local fzf_opts=(
    #         --read0
    #         --height=${FZF_TMUX_HEIGHT:-80%}
    #         --tac
    #         "-n2..,.."
    #         --tiebreak=index
    #         "--query=${LBUFFER}"
    #         "+m"
    #         "--bind=ctrl-d:reload(atuin history list),ctrl-r:reload(atuin history list $atuin_opts)"
    #     )

    #     selected=$(
    #         eval "atuin history list ${atuin_opts}" |
    #             fzf "${fzf_opts[@]}" --read0
    #     )
    #     local ret=$?
    #     if [ -n "$selected" ]; then
    #         # the += lets it insert at current pos instead of replacing
    #         LBUFFER+="${selected}"
    #     fi
    #     zle reset-prompt
    #     return $ret
    # }
    # zle -N fzf-atuin-history-widget
    # bindkey '^R' fzf-atuin-history-widget
}
atuin-setup

# if [ $TERM -neq foot ] && command -v theme.sh > /dev/null
#     theme.sh hemisu-dark
# fi

# opam configuration (equivalent to eval $(opam env))
[[ ! -r /home/home/.local/share/opam/opam-init/init.zsh ]] || source /home/home/.local/share/opam/opam-init/init.zsh  > /dev/null 2> /dev/null

# ?
# source /home/home/.config/broot/launcher/bash/br

if alias z &>/dev/null; then 
    unalias z
fi

if (( $+commands[exa] )); then
    alias ls="eza"
    alias l="eza -lg"
    alias ll="eza -lg"
    alias la="eza -lag"
fi

# home-manager gl stuff doesn't work and i cba man
if (( $+commands[wezterm] )); then
    alias wezterm=$(which -a wezterm | tail -n 1)
fi;


z() {
	if (( ${#argv} == 1 )) && [[ -f ${1} ]]
	then
		[[ ! -e ${1:h} ]] && return 1
		print "Correcting ${1} to ${1:h}"
		__zoxide_z ${1:h}
	else
		__zoxide_z "$@"
	fi
}

function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

bindkey "^T" fzf-tab-complete
bindkey "^I" complete-word

# alias cd=z

# zprof

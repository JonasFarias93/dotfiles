# =============================================================================
# ~/.zshrc — gerenciado pelos dotfiles
# =============================================================================

# ------------------------------------------------------------------------------
# OH MY ZSH
# ------------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# --- Spaceship config ---
SPACESHIP_GIT_SHOW=true
SPACESHIP_GIT_BRANCH_SHOW=true
SPACESHIP_GIT_STATUS_SHOW=true
SPACESHIP_GIT_SYMBOL=" "

SPACESHIP_PROMPT_ORDER=(
  dir
  git
  exec_time
  line_sep
  char
)

source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# CONDA + MAMBA (Miniforge)
# ------------------------------------------------------------------------------
__conda_setup="$("$HOME/miniforge3/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

export MAMBA_EXE="$HOME/miniforge3/bin/mamba"
export MAMBA_ROOT_PREFIX="$HOME/miniforge3"
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup

# ------------------------------------------------------------------------------
# NVM
# ------------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ------------------------------------------------------------------------------
# VAGRANT (via Windows)
# ------------------------------------------------------------------------------
export PATH="$PATH:/mnt/c/Program Files/Vagrant/bin"
alias vagrant="/mnt/c/Program\ Files/Vagrant/bin/vagrant.exe"

# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# uv (se instalado)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# ------------------------------------------------------------------------------
# ALIASES — NAVEGAÇÃO
# ------------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias cls='clear'
alias reload='source ~/.zshrc'
alias zshconfig='$EDITOR ~/.zshrc'
alias dotfiles='cd ~/dotfiles'

# ------------------------------------------------------------------------------
# ALIASES — PROJETOS
# ------------------------------------------------------------------------------
alias proj='cd ~/projects'
alias linuxlab='cd /mnt/c/vagrant-labs/701-702'

# ------------------------------------------------------------------------------
# ALIASES — GIT
# ------------------------------------------------------------------------------
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull'

# ------------------------------------------------------------------------------
# ALIASES — PYTHON / CONDA
# ------------------------------------------------------------------------------
alias py='python3'
alias ca='conda activate'
alias cda='conda deactivate'
alias cenv='conda env list'

# Cria ambiente conda para o projeto atual e ativa
mkenv() {
  local name="${1:-$(basename $PWD)}"
  conda create -n "$name" python=3.11 -y && conda activate "$name"
}

# ------------------------------------------------------------------------------
# ALIASES — ZELLIJ
# ------------------------------------------------------------------------------
alias zj='zellij'
alias zja='zellij attach'
alias zjl='zellij list-sessions'
alias zjk='zellij kill-session'

# ------------------------------------------------------------------------------
# FUNÇÕES ÚTEIS
# ------------------------------------------------------------------------------

# Cria pasta e entra nela
mkcd() { mkdir -p "$1" && cd "$1"; }

# Clona repo e entra na pasta
gcl() { git clone "$1" && cd "$(basename "$1" .git)"; }

# IP do WSL
myip() { ip route show | grep -i default | awk '{ print $3 }'; }

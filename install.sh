#!/usr/bin/env bash
# =============================================================================
# dotfiles/install.sh
# Configura o ambiente WSL do zero.
# Uso: bash install.sh
# =============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
info() { echo -e "${BLUE}[→]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

echo ""
echo "  dotfiles — configurando ambiente WSL"
echo "  ======================================"
echo ""

# =============================================================================
# 1. PACOTES BASE
# =============================================================================
info "Atualizando apt..."
sudo apt update -qq

info "Instalando pacotes base..."
sudo apt install -y -qq \
  zsh git curl wget unzip tree \
  build-essential libssl-dev libffi-dev \
  make

log "Pacotes base instalados"

# =============================================================================
# 2. OH MY ZSH
# =============================================================================
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Instalando Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  log "Oh My Zsh instalado"
else
  warn "Oh My Zsh já instalado, pulando..."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Spaceship theme
if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
  info "Instalando tema Spaceship..."
  git clone -q https://github.com/spaceship-prompt/spaceship-prompt.git \
    "$ZSH_CUSTOM/themes/spaceship-prompt"
  ln -sf "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" \
    "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
  log "Spaceship instalado"
else
  warn "Spaceship já instalado, pulando..."
fi

# Plugins
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  info "Instalando zsh-autosuggestions..."
  git clone -q https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  info "Instalando zsh-syntax-highlighting..."
  git clone -q https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

log "Plugins do Zsh instalados"

# =============================================================================
# 3. ZELLIJ
# =============================================================================
if ! command -v zellij &>/dev/null; then
  info "Instalando Zellij..."
  ZELLIJ_VERSION=$(curl -s https://api.github.com/repos/zellij-org/zellij/releases/latest \
    | grep '"tag_name"' | cut -d'"' -f4)
  curl -sLo /tmp/zellij.tar.gz \
    "https://github.com/zellij-org/zellij/releases/download/${ZELLIJ_VERSION}/zellij-x86_64-unknown-linux-musl.tar.gz"
  tar -xzf /tmp/zellij.tar.gz -C /tmp
  sudo mv /tmp/zellij /usr/local/bin/zellij
  sudo chmod +x /usr/local/bin/zellij
  log "Zellij instalado"
else
  warn "Zellij já instalado, pulando..."
fi

# =============================================================================
# 4. MINIFORGE (conda + mamba)
# =============================================================================
if [ ! -d "$HOME/miniforge3" ]; then
  info "Instalando Miniforge (conda + mamba)..."
  curl -sLo /tmp/Miniforge3.sh \
    "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"
  bash /tmp/Miniforge3.sh -b -p "$HOME/miniforge3"
  "$HOME/miniforge3/bin/conda" init zsh
  log "Miniforge instalado"
else
  warn "Miniforge já instalado, pulando..."
fi

# =============================================================================
# 5. NVM
# =============================================================================
if [ ! -d "$HOME/.nvm" ]; then
  info "Instalando NVM..."
  curl -sLo- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  log "NVM instalado"
else
  warn "NVM já instalado, pulando..."
fi

# =============================================================================
# 6. SYMLINKS
# =============================================================================
info "Criando symlinks..."

symlink() {
  local src="$DOTFILES_DIR/$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backup: $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  log "Linked: $dst"
}

symlink "zsh/.zshrc"          "$HOME/.zshrc"
symlink "zellij/config.kdl"   "$HOME/.config/zellij/config.kdl"
symlink "git/.gitconfig"      "$HOME/.gitconfig"

# bin/ — scripts pessoais (new-project, etc)
mkdir -p "$HOME/bin"
for script in "$DOTFILES_DIR/bin/"*; do
  [ -f "$script" ] || continue
  name="$(basename "$script")"
  ln -sf "$script" "$HOME/bin/$name"
  chmod +x "$script"
  log "Linked bin: $name"
done

# =============================================================================
# 7. SHELL PADRÃO
# =============================================================================
if [ "$SHELL" != "$(which zsh)" ]; then
  info "Definindo zsh como shell padrão..."
  chsh -s "$(which zsh)"
  log "Shell padrão alterado para zsh"
fi

# =============================================================================
# CONCLUÍDO
# =============================================================================
echo ""
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo -e "${GREEN}  Ambiente configurado com sucesso! 🎉 ${NC}"
echo -e "${GREEN}══════════════════════════════════════${NC}"
echo ""
echo "  Próximos passos:"
echo "  1. Abra um novo terminal: exec zsh"
echo "  2. Edite seu nome/email:  vim ~/dotfiles/git/.gitconfig"
echo "  3. Clone os templates:    git clone <url> ~/dev-templates"
echo ""

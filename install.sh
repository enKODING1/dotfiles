#!/usr/bin/env bash
# dotfiles 설치 스크립트 (여러 번 실행해도 안전)
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }

# 기존 파일은 백업하고 심볼릭 링크로 교체
link() {
  local src="$DOTFILES/$1" dst="$HOME/$2"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    mv "$dst" "$BACKUP_DIR/"
    info "backup: $dst -> $BACKUP_DIR/"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  info "link: $dst -> $src"
}

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1 && [[ ! -x /opt/homebrew/bin/brew ]]; then
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

if [[ "${SKIP_BREW:-0}" != "1" ]]; then
  info "brew bundle"
  brew bundle --file="$DOTFILES/Brewfile"
fi

# 2. Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
if [[ ! -d "$ZSH" ]]; then
  info "Installing Oh My Zsh"
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 3. 테마 / 플러그인
ZSH_CUSTOM="$ZSH/custom"
clone() {
  [[ -d "$2" ]] || { info "clone: $1"; git clone --depth=1 "$1" "$2"; }
}
clone https://github.com/romkatv/powerlevel10k.git              "$ZSH_CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions.git      "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# 4. pokemon-colorscripts (sudo 없이 ~/.local 에 설치)
clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git  "$HOME/.local/share/pokemon-colorscripts"
mkdir -p "$HOME/.local/bin"
ln -sf "$HOME/.local/share/pokemon-colorscripts/pokemon-colorscripts.py" "$HOME/.local/bin/pokemon-colorscripts"

# 5. 심볼릭 링크
link zsh/.zshrc    .zshrc
link zsh/.zprofile .zprofile
link zsh/.p10k.zsh .p10k.zsh
link vim/.vimrc    .vimrc

info "Done. 새 터미널을 열거나 'exec zsh' 실행"

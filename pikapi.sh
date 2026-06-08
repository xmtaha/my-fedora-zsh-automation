#!/bin/bash

echo "Fedora Terminal Zsh, Kitty ve Fastfetch Scripti Başlatılıyor..."
sudo dnf update -y

echo " Gerekli paketler kuruluyor..."
sudo dnf install -y zsh kitty fzf git fastfetch

echo " Zsh eklenti klasörleri hazırlanıyor..."
ZSH_PLUGINS_DIR="$HOME/.zsh"
mkdir -p "$ZSH_PLUGINS_DIR"

echo "Zsh eklentileri indiriliyor..."
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

echo "Kitty ayarları yapılıyor..."
mkdir -p ~/.config/kitty
cat << 'EOF' > ~/.config/kitty/kitty.conf
# --- Kitty Görünüm Ayarları ---
background_opacity 0.75
dynamic_background_opacity yes
confirm_os_window_close 0
font_family FiraCode Nerd Font
font_size 11.0
EOF

echo "⚙Fastfetch profil ayarları yapılandırılıyor..."
mkdir -p ~/.config/fastfetch
cat << 'EOF' > ~/.config/fastfetch/config.jsonc
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "/home/*****/pikapi.png",
    "type": "kitty",
    "width": 28,
    "height": 12,
    "padding": {
      "top": 1,
      "left": 2,
      "right": 3
    }
  },
  "modules": [
    "title",
    "separator",
    "os",
    "kernel",
    "uptime",
    "packages",
    "shell",
    "cpu",
    "gpu",
    "memory",
    "disk",
  ]
}
EOF

echo ".zshrc yapılandırma dosyası yazılıyor..."
cat << 'EOF' > ~/.zshrc

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_all_dups
setopt hist_save_no_dups

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /usr/share/fzf/shell/key-bindings.zsh
source /usr/share/fzf/shell/completion.zsh

PROMPT='%B%F{white}%n@%m%f%b 
$ '

alias ll='ls -la'
alias update='sudo dnf update -y'
alias cls='clear'
alias fetch='fastfetch'

clear
fastfetch
EOF

echo "Varsayılan kabuk Zsh olarak değiştiriliyor..."
sudo chsh -s $(which zsh) $USER

echo "İşlem tamamlandı! Değişikliklerin oturumuna tam yansıması için sistemini yeniden başlatabilir veya oturumu kapatıp açabilirsin."

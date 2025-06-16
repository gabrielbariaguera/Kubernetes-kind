#!/bin/bash

# Script de instalação do Lens IDE para Fedora e Ubuntu/Debian
# Autor: Seu Nome
# Versão: 1.0

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verifica se é root
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}Este script precisa ser executado como root/sudo.${NC}"
  exit 1
fi

# Detecta a distribuição
if [ -f /etc/fedora-release ]; then
  DISTRO="fedora"
elif [ -f /etc/lsb-release ] && grep -q "Ubuntu" /etc/lsb-release; then
  DISTRO="ubuntu"
else
  echo -e "${RED}Distribuição não suportada. Este script funciona apenas para Fedora e Ubuntu.${NC}"
  exit 1
fi

# Função para instalar dependências
install_dependencies() {
  echo -e "${YELLOW}Instalando dependências...${NC}"
  
  if [ "$DISTRO" = "fedora" ]; then
    dnf install -y curl tar gzip libX11-xcb libXScrnSaver libXtst
  elif [ "$DISTRO" = "ubuntu" ]; then
    apt-get update
    apt-get install -y curl tar gzip libx11-xcb1 libxss1 libxtst6 libgtk-3-0 libnotify4 libnss3
  fi
}

# Função para baixar e instalar o Lens
install_lens() {
  echo -e "${YELLOW}Baixando a versão mais recente do Lens...${NC}"
  
  # Obtém a última versão
  LATEST_VERSION=$(curl -s https://api.github.com/repos/lensapp/lens/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  DOWNLOAD_URL="https://downloads.k8slens.dev/ide/Lens-${LATEST_VERSION}.tar.gz"
  
  # Diretório temporário
  TEMP_DIR=$(mktemp -d)
  cd "$TEMP_DIR" || exit
  
  echo -e "${GREEN}Versão detectada: ${LATEST_VERSION}${NC}"
  
  # Download
  if ! curl -L "$DOWNLOAD_URL" -o Lens.tar.gz; then
    echo -e "${RED}Falha no download do Lens. Verifique sua conexão.${NC}"
    exit 1
  fi
  
  # Extrai
  tar -xzf Lens.tar.gz
  rm Lens.tar.gz
  
  # Instala
  echo -e "${YELLOW}Instalando no sistema...${NC}"
  mkdir -p /opt/Lens
  mv Lens-*/* /opt/Lens/
  
  # Cria atalho
  cat > /usr/share/applications/lens.desktop <<EOL
[Desktop Entry]
Name=Lens IDE
Exec=/opt/Lens/lens
Icon=/opt/Lens/icon.png
Terminal=false
Type=Application
Categories=Development;
StartupWMClass=Lens
EOL

  # Permissões
  chmod +x /opt/Lens/lens
  ln -sf /opt/Lens/lens /usr/local/bin/lens
  
  echo -e "${GREEN}Instalação concluída!${NC}"
}

# Limpeza
cleanup() {
  rm -rf "$TEMP_DIR"
}

# Main
install_dependencies
install_lens
cleanup

echo -e "\n${GREEN}O Lens IDE foi instalado com sucesso!${NC}"
echo -e "Execute com: ${YELLOW}lens${NC} ou procure por 'Lens' no menu de aplicativos.\n"

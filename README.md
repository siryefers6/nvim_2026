# Neovim + LazyVim + configuración tmux y bashrc — Instalación y dependencias

## 0. Configuraciones bash y tmux para linux Debian y Termux

#### 0.1 .bashrc Debian

```bash
# ~/.bashrc limpio y personalizado

# Colores para el prompt
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
LIGHT_BLUE='\[\033[1;34m\]'
YELLOW='\[\033[0;33m\]'
CYAN='\[\033[0;36m\]'
RESET='\[\033[0m\]'

# Función para mostrar la rama actual de Git (si está en un repo)
parse_git_branch() {
    git branch 2>/dev/null | grep '*' | sed 's/* //'
}

# Prompt colorido con fecha, usuario, ruta y rama git
PS1="${YELLOW}[\$(date +'%Y-%m-%d %H:%M:%S')]${RESET} ${GREEN}\u${RESET}@${LIGHT_BLUE}\h${RESET}: ${CYAN}\w${RESET}\n(\$(parse_git_branch))-> "

# Alias básicos
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -la'
alias cls='clear'

# Editor de texto por defecto
export EDITOR=vim

# Modo vi en línea de comandos
set -o vi

# Autocompletado por historial (búsqueda incremental con flechas)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Historial más robusto
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups
HISTIGNORE="ls:cd:exit"
shopt -s histappend

# ------------------------------------------------------------
# PATH local
# ------------------------------------------------------------

export PATH="$HOME/.local/bin:$PATH"

export ANDROID_HOME="$HOME/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="/home/siryefers/flutter/3.44.8/bin:$PATH"

. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"

# Copiar contenido de un archivo directo al portapapeles
copy() {
    if [ $# -eq 0 ]; then
        echo "Uso: copy archivo1 [archivo2 ...]"
        return 1
    fi

    for file in "$@"; do
        if [ ! -f "$file" ]; then
            echo "Archivo no encontrado: $file" >&2
            return 1
        fi
    done

    {
        for file in "$@"; do
            printf '\n\n===== %s =====\n' "$file"
            cat -- "$file"
        done
    } | python3 -c '
import sys, base64
data = sys.stdin.buffer.read()
encoded = base64.b64encode(data).decode()
print("\033]52;c;" + encoded + "\a", end="")
'
}

```

#### 0.2 .bashrc Termux

```bash
# ============================================================
# CONFIGURACIÓN BASH - TERMUX
# ============================================================

# ============================================================
# PATH
# ============================================================

# Termux
export PATH="$PREFIX/bin:$PATH"

# Ejecutables instalados localmente (Neovim, uv, etc.)
export PATH="$HOME/.local/bin:$PATH"

# Flutter (si está instalado)
if [ -d "$HOME/flutter/bin" ]; then
    export PATH="$HOME/flutter/bin:$PATH"
fi

# Android SDK (si está instalado)
if [ -d "$HOME/Android/Sdk" ]; then
    export ANDROID_HOME="$HOME/Android/Sdk"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    export PATH="$ANDROID_HOME/platform-tools:$PATH"
fi

# ============================================================
# EDITOR
# ============================================================

export EDITOR="$HOME/.local/bin/nvim"
export VISUAL="$EDITOR"

# ============================================================
# COLORES
# ============================================================

RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
LIGHT_BLUE='\[\033[1;34m\]'
YELLOW='\[\033[0;33m\]'
CYAN='\[\033[0;36m\]'
RESET='\[\033[0m\]'

# ============================================================
# PROMPT
# ============================================================

parse_git_branch() {
    git branch --show-current 2>/dev/null
}

PS1="${YELLOW}[\$(date +'%Y-%m-%d %H:%M:%S')]${RESET} ${GREEN}\u${RESET}@${LIGHT_BLUE}\h${RESET}: ${CYAN}\w${RESET}\n(\$(parse_git_branch))-> "

# ============================================================
# ALIAS
# ============================================================

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -la'
alias cls='clear'

# ============================================================
# HISTORIAL
# ============================================================

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups
HISTIGNORE="ls:cd:exit"

shopt -s histappend

# ============================================================
# TERMINAL
# ============================================================

set -o vi

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ============================================================
# NVM (si está instalado)
# ============================================================

export NVM_DIR="$HOME/.nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
fi

if [ -s "$NVM_DIR/bash_completion" ]; then
    . "$NVM_DIR/bash_completion"
fi

# ============================================================
# COPIAR ARCHIVOS AL PORTAPAPELES (OSC 52)
# ============================================================

copy() {
    if [ "$#" -eq 0 ]; then
        echo "Uso: copy archivo1 [archivo2 ...]"
        return 1
    fi

    for file in "$@"; do
        if [ ! -f "$file" ]; then
            echo "Archivo no encontrado: $file" >&2
            return 1
        fi
    done

    {
        for file in "$@"; do
            printf '\n\n===== %s =====\n' "$file"
            cat -- "$file"
        done
    } | python -c '
import sys
import base64

data = sys.stdin.buffer.read()
encoded = base64.b64encode(data).decode("ascii")

sys.stdout.write("\033]52;c;" + encoded + "\a")
sys.stdout.flush()
'
}

```

#### 0.3 tmux Debian

```bash
set -g mouse off
set -g set-clipboard on
set -g allow-passthrough on


```

#### 0.4 tmux Termux

```bash
set -g mouse off
set -g set-clipboard on
set -g allow-passthrough on

```

> Guía de instalación para CachyOS, Debian y Termux.
>
> **Objetivo:** mantener una única configuración de Neovim sincronizada mediante Git y GitHub.

## 1. Requisitos generales

### Versiones mínimas

| Dependencia | Requisito |
| --- | --- |
| Neovim | 0.11.2 o superior |
| Git | 2.19.0 o superior |
| Lua | LuaJIT integrado en Neovim |
| Compilador C | GCC o Clang |
| curl | Última versión disponible |
| tree-sitter-cli | Recomendado para parsers |
| Nerd Font | Opcional, recomendado |

### Herramientas adicionales

| Herramienta | Utilidad |
| --- | --- |
| ripgrep | Búsqueda de texto |
| fd | Búsqueda de archivos |
| fzf | Búsqueda interactiva |
| lazygit | Interfaz Git en terminal |
| Node.js | Servidores LSP y herramientas JavaScript |
| Python | Desarrollo Python |
| uv | Gestión de entornos Python |
| IPython | Consola interactiva para Iron.nvim |
| unzip | Descompresión de archivos |
| wl-clipboard | Portapapeles en Wayland |
| xclip | Portapapeles en X11 |

---

## 2. CachyOS (Arch Linux)

### 2.1. Actualizar el sistema

```bash
sudo pacman -Syu
```

### 2.2. Instalar Neovim y dependencias

```bash
sudo pacman -S --needed \
  neovim \
  git \
  curl \
  wget \
  unzip \
  ripgrep \
  fd \
  fzf \
  lazygit \
  tree-sitter-cli \
  gcc \
  make \
  cmake \
  python \
  python-pip \
  nodejs \
  npm \
  wl-clipboard \
  xclip
```

### 2.3. Instalar uv

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Reiniciar la terminal o cargar el PATH actualizado.

### 2.4. Verificar

```bash
nvim --version
git --version
uv --version
python --version
node --version
rg --version
fd --version
```

---

## 3. Debian

### 3.1. Actualizar el sistema

```bash
sudo apt update
sudo apt upgrade -y
```

### 3.2. Instalar dependencias

```bash
sudo apt install -y \
  git \
  curl \
  wget \
  unzip \
  ripgrep \
  fd-find \
  fzf \
  build-essential \
  cmake \
  gettext \
  python3 \
  python3-venv \
  python3-pip \
  nodejs \
  npm \
  wl-clipboard \
  xclip
```

**Importante:** Debian puede ofrecer una versión de Neovim inferior al mínimo requerido por LazyVim. Instala la versión estable oficial.

### 3.3. Instalar la última versión estable de Neovim

```bash
ARCH=$(uname -m)

case "$ARCH" in
  x86_64) ARCH="x86_64" ;;
  aarch64) ARCH="arm64" ;;
  *)
    echo "Arquitectura no soportada: $ARCH"
    exit 1
    ;;
esac

curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"

sudo rm -rf "/opt/nvim-linux-${ARCH}"

sudo tar -C /opt -xzf "nvim-linux-${ARCH}.tar.gz"

sudo ln -sfn "/opt/nvim-linux-${ARCH}/bin/nvim" /usr/local/bin/nvim

rm "nvim-linux-${ARCH}.tar.gz"
```

### 3.4. Configurar fd

Debian utiliza el ejecutable `fdfind`.

```bash
mkdir -p ~/.local/bin

ln -sf "$(command -v fdfind)" ~/.local/bin/fd
```

Asegúrate de incluir `~/.local/bin` en tu PATH.

### 3.5. Instalar tree-sitter CLI

```bash
sudo npm install --global tree-sitter-cli
```

### 3.6. Instalar uv

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### 3.7. Verificar

```bash
nvim --version
git --version
uv --version
python3 --version
node --version
rg --version
fd --version
tree-sitter --version
```

---

## 4. Termux (Android)

### 4.1. Actualizar paquetes

```bash
pkg update && pkg upgrade -y
```

### 4.2. Instalar Neovim y dependencias

```bash
pkg install -y \
  neovim \
  git \
  curl \
  wget \
  unzip \
  ripgrep \
  fd \
  fzf \
  python \
  nodejs-lts \
  clang \
  make \
  cmake \
  pkg-config
```

### 4.3. Instalar IPython

```bash
pip install ipython
```

### 4.4. Instalar tree-sitter CLI (si se necesita)

```bash
npm install --global tree-sitter-cli
```

### 4.5. Configurar portapapeles

Instala el paquete:

```bash
pkg install termux-api
```

Instala también la aplicación complementaria Termux:API desde una fuente compatible con tu instalación de Termux.

### 4.6. Verificar

```bash
nvim --version
git --version
python --version
ipython --version
node --version
rg --version
fd --version
```

**Nota:** utiliza la versión de Neovim disponible en los repositorios de Termux. Comprueba que cumpla el mínimo de LazyVim.

---

## 5. Instalar LazyVim

Ejecuta en cualquiera de los tres sistemas:

```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

Inicia Neovim:

```bash
nvim
```

Espera a que LazyVim descargue e instale los plugins.

Ejecuta:

```vim
:Lazy sync
```

Después:

```vim
:LazyHealth
```

---

## 6. Configurar Python para Iron.nvim

### CachyOS y Debian

En cada proyecto Python:

```bash
uv init
uv add --dev ipython
```

Ejecuta IPython:

```bash
uv run ipython
```

Utiliza este comando desde la configuración de Iron.nvim:

```lua
command = { "uv", "run", "ipython", "--no-autoindent" }
```

### Termux

Instala IPython globalmente:

```bash
pip install ipython
```

Utiliza:

```lua
command = { "ipython", "--no-autoindent" }
```

La configuración compartida puede detectar automáticamente el entorno.

---

## 7. Fuentes Nerd Font

Instala una fuente Nerd Font para visualizar correctamente los iconos de LazyVim.

Opciones recomendadas:

- JetBrainsMono Nerd Font
- FiraCode Nerd Font
- Hack Nerd Font

Descargas:

<https://www.nerdfonts.com/font-downloads>

En Termux configura la fuente desde las opciones de apariencia o mediante Termux:Styling.

---

## 8. Portapapeles

### Linux con Wayland

```bash
sudo pacman -S wl-clipboard
```

En Debian:

```bash
sudo apt install wl-clipboard
```

### Linux con X11

```bash
sudo pacman -S xclip
```

En Debian:

```bash
sudo apt install xclip
```

### Termux

Utiliza Termux:API.

---

## 9. Comandos de diagnóstico

Ejecuta estos comandos cuando LazyVim presente problemas:

```bash
nvim --version
git --version
curl --version
python --version
node --version
uv --version
```

Dentro de Neovim:

```vim
:checkhealth
:LazyHealth
:Lazy
:Mason
```

Para comprobar el entorno detectado:

```vim
:lua print(vim.inspect(require("utils.environment")))
```

---

## 10. Sincronización de configuración

Repositorio personal:

```text
~/.config/nvim/
```

Clonar en otro dispositivo:

```bash
git clone https://github.com/TU_USUARIO/nvim-config.git ~/.config/nvim
```

Actualizar configuración:

```bash
cd ~/.config/nvim
git pull
```

Guardar modificaciones:

```bash
cd ~/.config/nvim
git add .
git commit -m "Actualizar configuración"
git push
```

Conservar siempre `lazy-lock.json` para mantener registradas las versiones de los plugins.

No subir las carpetas de caché, datos locales, entornos virtuales ni credenciales.

---

## 11. Referencias oficiales

- Neovim: <https://neovim.io/doc/install/>
- LazyVim: <https://www.lazyvim.org/installation>
- LazyVim Requirements: <https://www.lazyvim.org/>
- Lazy.nvim: <https://github.com/folke/lazy.nvim>
- Iron.nvim: <https://github.com/Vigemus/iron.nvim>
- Tree-sitter: <https://tree-sitter.github.io/tree-sitter/>
- uv: <https://docs.astral.sh/uv/>
- Nerd Fonts: <https://www.nerdfonts.com/>

---

**Última revisión:** 07-11-2026.

**Sistemas contemplados:** CachyOS, Debian y Termux.

**Gestor de configuración:** Git + GitHub.

**Editor:** Neovim + LazyVim.

# nvim_2026

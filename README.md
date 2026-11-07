# Neovim + LazyVim — Instalación y dependencias

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

#!/bin/bash

# Ensure the script is run with superuser privileges
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Use SUDO_USER to get the user's home directory if the script is run using sudo
USER_HOME=$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)

echo "Starting Vim installation and configuration..."


# Identify the package manager and update packages
PKG_UPDATE_CMD=""
PKG_INSTALL_CMD=""
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt-get"
    PKG_UPDATE_CMD="apt-get update"
    PKG_INSTALL_CMD="apt-get install -y"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    PKG_UPDATE_CMD="pacman -Sy"
    PKG_INSTALL_CMD="pacman -S --noconfirm"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    PKG_UPDATE_CMD="dnf makecache"
    PKG_INSTALL_CMD="dnf install -y"
elif command -v zypper &> /dev/null; then
    PKG_MANAGER="zypper"
    PKG_UPDATE_CMD="zypper refresh"
    PKG_INSTALL_CMD="zypper install -y"
else
    echo "Unsupported Linux distribution. Script only supports apt (Debian, Ubuntu), pacman (Arch), dnf (Fedora), and zypper (openSUSE)." 1>&2
    exit 1
fi

# Update package lists
echo "Updating package lists..."
$PKG_UPDATE_CMD
if [ $? -ne 0 ]; then
    echo "Failed to update package lists. Please check your package manager settings or internet connection." 1>&2
    exit 1
fi

# Step 1: Install Vim
echo "Checking for Vim installation..."
if ! command -v vim &> /dev/null; then
    echo "Vim not installed. Installing Vim..."
    $PKG_INSTALL_CMD vim
    if [ $? -ne 0 ]; then
        echo "Failed to install Vim. Please check your package manager settings or internet connection." 1>&2
        exit 1
    fi
    echo "Vim installed successfully."
else
    echo "Vim is already installed."
fi


# Step 2: Install Vim-Plug (Vim plugin manager)
echo "Installing Vim-Plug for plugin management..."
VIM_PLUG_FILE="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$VIM_PLUG_FILE" ]; then
    curl -fLo "$VIM_PLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    if [ $? -ne 0 ]; then
        echo "Failed to download Vim-Plug. Please check your internet connection." 1>&2
        exit 1
    fi
    echo "Vim-Plug installed successfully."
else
    echo "Vim-Plug is already installed."
fi

# Step 3: Configure Vim
echo "Configuring Vim..."
VIMRC="${USER_HOME}/.vimrc"
if [ ! -f "$VIMRC" ]; then
    echo "Creating a new .vimrc configuration file..."
    touch "$VIMRC"
    if [ $? -ne 0 ]; then
        echo "Failed to create .vimrc file." 1>&2
        exit 1
    fi
else
    echo ".vimrc already exists, creating a backup..."
    cp "$VIMRC" "${VIMRC}.backup_$(date +%F_%T)"
    if [ $? -ne 0 ]; then
        echo "Failed to backup the existing .vimrc file." 1>&2
        exit 1
    fi
fi


# Section to include plugins
cat <<EOT > "$VIMRC"
call plug#begin('~/.vim/plugged')
" QOL
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'itchyny/lightline.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Chiel92/vim-autoformat'
Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-startify'

" Gruvbox theme, change if you want the other one
Plug 'morhetz/gruvbox'

" Bash scripting plugins
Plug 'githubuser/bash-support.vim'
Plug 'githubuser/vim-shfmt'
Plug 'scrooloose/syntastic'

" Rust plugins
Plug 'rust-lang/rust.vim'
Plug 'rust-lang/rustfmt'
Plug 'racer-rust/vim-racer'

" Python plugins
Plug 'vim-python/python-syntax'
Plug 'davidhalter/jedi-vim'
Plug 'Vimjas/vim-python-pep8-indent'

" Add some more plugins here if needed
call plug#end()


" General configurations
let g:racer_cmd = '$HOME/.cargo/bin/racer'
let g:racer_cmd_timeout = 5000
set number
syntax enable
set incsearch
set showmatch
set mouse=a
set clipboard=unnamedplus
filetype plugin indent on
set smartindent
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set wrap
set background=dark
colorscheme gruvbox
let g:airline#extensions#tabline#enabled = 1

" Custom Key Mappings
" Leader key configuration
let mapleader = ","
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>s :wq<CR>
nnoremap <leader>c :bd<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resizing panes with arrow keys
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Buffer navigation
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Close buffers
nnoremap <leader>bd :bd<CR>
nnoremap <leader>ba :bufdo bd<CR>  " Close all buffers

" Save with Ctrl + S
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>

" Quit with Ctrl + Q
nnoremap <C-q> :q<CR>
inoremap <C-q> <C-o>:q<CR>

" Open and close the NERDTree easily
nnoremap <leader>e :NERDTreeToggle<CR>

" Fast file saving
nnoremap <leader>w :w!<CR>
nnoremap <leader>x :x!<CR>
nnoremap <leader>q :q!<CR>

" Split window
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>h :split<CR>

" Quick fix navigation
nnoremap <leader>j :cnext<CR>
nnoremap <leader>k :cprev<CR>

" Disable arrow keys in normal mode
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>

" Use space as a trigger to clear search highlighting and any message already displayed
nnoremap <silent> <Space> :noh<CR><CR>

" Insert an empty line above or below the current line without entering insert mode
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

EOT

echo "Vim configuration updated."

# Step 4: Install plugins using Vim-Plug
echo "Installing plugins using Vim-Plug..."
vim +PlugInstall +qall
echo "Vim plugins installation completed."

# Check for necessary software for the plugins
echo "Checking for additional dependencies..."
REQUIRED_PKGS="curl git python3 cargo"
for pkg in $REQUIRED_PKGS; do
    if ! command -v $pkg &> /dev/null; then
        echo "$pkg is not installed. Installing..."
        $PKG_INSTALL_CMD $pkg
        if [ $? -ne 0 ]; then
            echo "Failed to install $pkg." 1>&2
            # Consider whether failing to install a dependency should stop the script
        fi
    else
        echo "$pkg is already installed."
    fi
done

echo "All necessary dependencies are installed."

echo "Vim with plugins setup completed successfully."

set nocompatible
" Terminal Vim inherits font family, size, weight and spacing from its terminal.
" Adjust home/.config/ghostty/config or VS Code's terminal.integrated settings.
set number
set cursorline
set scrolloff=5
set sidescrolloff=5
set colorcolumn=100
set expandtab
set tabstop=2
set shiftwidth=2
set smartindent
set incsearch
set hlsearch
set ignorecase
set smartcase
set hidden
set backspace=indent,eol,start

" Persistent undo, kept out of the working directory.
if has('persistent_undo')
  let s:undo_dir = expand('~/.vim/undo')
  if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, 'p', 0700)
  endif
  let &undodir = s:undo_dir . '//'
  set undofile
endif

syntax on
filetype plugin indent on

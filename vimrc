call pathogen#infect()

set background=dark

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" let Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Let Vim load indentation rules and plugins according to the detected filetype
if has("autocmd")
  filetype plugin indent on
endif

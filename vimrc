set background=dark

" let Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Let Vim load indentation rules and plugins according to the detected filetype
if has("autocmd")
  filetype plugin indent on
endif



call plug#begin('~/.local/share/nvim/plugged')
Plug 'https://github.com/preservim/vim-markdown.git'
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-jedi'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/nerdtree'
Plug 'neomake/neomake'
Plug 'python-rope/ropevim'
Plug 'sainnhe/sonokai'
Plug 'machakann/vim-highlightedyank'
Plug 'morhetz/gruvbox'
Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'
Plug 'https://github.com/jeetsukumaran/vim-buffergator.git'
Plug 'https://github.com/joshdick/onedark.vim.git'
Plug 'lervag/vimtex'
Plug 'kyoz/purify', { 'rtp': 'vim' }
Plug 'junegunn/goyo.vim'
Plug 'https://github.com/junegunn/limelight.vim.git'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
call plug#end()

let g:deoplete#enable_at_startup = 1
" when editing a tex file, deactivate autocomplete and activate spell checking
autocmd FileType tex call deoplete#custom#buffer_option('auto_complete', v:false)
autocmd FileType tex set spell spelllang=en_us 
autocmd FileType tex set linebreak 

syntax enable
:filetype on
set clipboard=unnamedplus

set relativenumber  " diplay line number relative to current position
" disable autocompletion, because we use deoplete for completion
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = 0 "dont show in line function signatures
" open the go-to function in split, not another buffer
let g:jedi#use_splits_not_buffers = "right"

let g:neomake_python_enabled_makers = ['flake8'] "pylint more detailed, flake8 faster
call neomake#configure#automake('nrwi', 500)

" set colorscheme
if has('termguicolors')
  set termguicolors
endif
" The configuration options should be placed before `colorscheme sonokai`.
let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 1
colorscheme sonokai
let g:airline_theme = 'sonokai'
" latex configuration
let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'tectonic'

" set limelight colors" set limelight colors
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'
"integrate Limelight with Goyo
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" custom key mappings

" paste last thing yanked, not deleted
nmap ,p "0p
nmap  ,P "0P
" resize window splits vertically and horizontally
nmap v+ :vertical resize +2<CR>
nmap v- :vertical resize -2<CR>
nmap h+ :resize +2<CR>
nmap h- :resize -2<CR>
" open a terminal split horizontally or vertically
nmap <leader>vt :vsplit \| :terminal<CR>
nmap <leader>ht :split \| :terminal<CR>
" open and close nerdtree
nmap <F6> :NERDTreeToggle<CR>
" enclose a word in brackets
nmap <leader>] ysiw]
nmap <leader>) ysiw)
nmap <leader>) ysiw}
"Key remappings
"" disable arrow keys in normal mode
noremap <Left> <Nop>
noremap <Right> <Nop>
" disable backspace in insert mode
:inoremap <Left> <Nop>
:inoremap <Right> <Nop>

" remap keys for terminal emulator
:tnoremap <Esc> <C-\><C-n>
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

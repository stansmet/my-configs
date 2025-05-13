set nocompatible
set hlsearch
syntax on
set tabstop=4
set shiftwidth=4
set paste
set vb
set termencoding=utf-8
set nu
set nowrap
set nobackup
set ruler
set showcmd
set foldmethod=indent
set incsearch
set expandtab
set ch=1
set autoindent
set statusline=%<%f%h%m%r\ %b\ %{&encoding}\ 0x\ \ %l,%c%V\ %P  
set laststatus=2

" F3 - previous buffer
nmap <F3> :bp!<cr>
nmap <F3> :bp!<cr>
nmap <F3> :bp!<cr>

" F4 - next buffer
nmap <F4> :bn!<cr>
nmap <F4> :bn!<cr>
nmap <F4> :bn!<cr>

" F9 - Change encoding
set  wildmenu
set  wcm=<Tab>
menu Enc.cp1251     :e ++enc=cp1251<CR>
menu Enc.koi8-r     :e ++enc=koi8-r<CR>
menu Enc.cp866      :e ++enc=ibm866<CR>
menu Enc.utf-8      :e ++enc=utf-8<CR>
menu Enc.ucs-2le    :e ++enc=ucs-2le<CR>
map  <F9> :emenu Enc.<Tab>

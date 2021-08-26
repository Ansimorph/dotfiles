" Load shared config
luafile /Users/bg/.config/nvim/lua/shared-config.lua

call plug#begin('~/.config/nvim/plugged')
  Plug 'mattn/emmet-vim'
  Plug 'svermeulen/vim-subversive'
call plug#end()

" CodeCommentry via VSCode
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

" Rename symbol
nmap gr <Cmd>call VSCodeCall('editor.action.rename')<CR>


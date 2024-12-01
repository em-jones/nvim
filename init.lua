if vim.g.vscode then
  vim.cmd [[
     nnoremap zM :call VSCodeNotify('editor.foldAll')<CR>
     nnoremap zR :call VSCodeNotify('editor.unfoldAll')<CR>
     nnoremap zc :call VSCodeNotify('editor.fold')<CR>
     nnoremap zC :call VSCodeNotify('editor.foldRecursively')<CR>
     nnoremap zo :call VSCodeNotify('editor.unfold')<CR>
     nnoremap zO :call VSCodeNotify('editor.unfoldRecursively')<CR>
     nnoremap za :call VSCodeNotify('editor.toggleFold')<CR>

     function! MoveCursor(direction) abort
         if(reg_recording() == '' && reg_executing() == '')
             return 'g'.a:direction
         else
             return a:direction
         endif
     endfunction

     nmap <expr> j MoveCursor('j')
     nmap <expr> k MoveCursor('k')
  ]]
end
require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"
-- end

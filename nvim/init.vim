
call plug#begin('~/.config/nvim/plugged/')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tveskag/nvim-blame-line'
Plug 'scrooloose/nerdcommenter'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'mhinz/vim-startify'
Plug 'christoomey/vim-system-copy'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'christoomey/vim-tmux-navigator'
Plug 'sheerun/vim-polyglot'
Plug 'dsznajder/vscode-es7-javascript-react-snippets'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim' 
Plug 'ryanoasis/vim-devicons'
Plug 'flazz/vim-colorschemes'
Plug 'tomasiser/vim-code-dark'
Plug 'alvan/vim-closetag'
Plug 'ap/vim-css-color'
Plug 'szw/vim-maximizer'
Plug 'supermaven-inc/supermaven-nvim'
Plug 'scottmckendry/cyberdream.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Avate.nvim deps
Plug 'stevearc/dressing.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'HakonHarnes/img-clip.nvim'
Plug 'yetone/avante.nvim', { 'branch': 'main', 'do': 'make' }
Plug 'robitx/gp.nvim'

call plug#end()

autocmd! User avante.nvim

lua << EOF
require("supermaven-nvim").setup({})

require('img-clip').setup ({})
require('avante_lib').load()
require('avante').setup ({})

require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "bash", "c", "cpp", "go", "html", "javascript", "json", "lua", "python", "rust", "typescript", "yaml", "sql", "tsx", "vim", "markdown" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    enable = true,
  },
}

require("cyberdream").setup({
    -- Enable transparent background
    transparent = true,

    -- Enable italics comments
    italic_comments = true,

    -- Modern borderless telescope theme - also applies to fzf-lua
    borderless_telescope = true,

    -- Set terminal colors used in `:terminal`
    terminal_colors = true,

    -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
    cache = false,

    -- Disable or enable colorscheme extensions
    extensions = {
        telescope = true,
        notify = true,
        mini = true,
    },
})

require("gp").setup({
  providers = {
		anthropic = {
			endpoint = "https://api.anthropic.com/v1/messages",
			secret = os.getenv("ANTHROPIC_API_KEY"),
		},
	},
  agents = {
		{
			provider = "anthropic",
			name = "ChatClaude-3-5-Sonnet",
			chat = true,
			command = false,
			model = { model = "claude-3-5-sonnet-20241022" },
			system_prompt = require("gp.defaults").chat_system_prompt,
		},
    	{
			provider = "anthropic",
			name = "CodeClaude-3-5-Sonnet",
			chat = false,
			command = true,
			model = { model = "claude-3-5-sonnet-20241022" },
			system_prompt = require("gp.defaults").code_system_prompt,
		},
  }
})

EOF

nmap <C-n> :NERDTreeToggle<CR>
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle
let g:NERDTreeGitStatusWithFlags = 1
let g:NERDTreeIgnore = ['^node_modules$']

let g:startify_change_to_dir = 0

set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

set smarttab
set cindent
set tabstop=2
set shiftwidth=2
set expandtab

" allow scrolling in iTerm
set mouse=a

" Allow using system clipboard
set clipboard^=unnamed,unnamedplus

" Better split defaults
set splitbelow
set splitright

" Setting leader
" -----------------------------------------------------
let g:mapleader=","

" Trigger autoread when switching buffers or focusing vim
au FocusGained,BufEnter *.{js,jsx,ts,tsx} :silent! !
au FocusLost,WinLeave *.{js,jsx,ts,tsx} :silent! w

" Colors in tmux
let &t_8f = "<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "<Esc>[48;2;%lu;%lu;%lum"

set background=dark
set termguicolors     " enable true colors support

set t_Co=256
set t_ut=

colorscheme cyberdream

hi Quote ctermbg=109 guifg=#83a598

nnoremap <tab> :noh<CR>

" Don't cancel visual select when shifting
xnoremap < <gv
xnoremap > >gv

" Yank and paste from clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>yy "+yy
nnoremap <leader>p "+p

" Autoclose quotes, braces, and parens 
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()        
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

augroup settab
  autocmd!
  autocmd BufNewFile,BufRead *.go set noexpandtab
augroup END

" Force vim to rescan entire buffer when syntax highlighting

augroup highlightsync 
  autocmd!
  autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
augroup end

" coc config
let g:coc_global_extensions = [
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-prettier', 
  \ 'coc-json', 
  \ ]

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx,*.tsx,*.js,*.ts"
let g:closetag_xhtml_filetypes = 'xhtml,javascript.jsx,jsx,typescript.tsx,tsx'

let g:closetag_regions =  {
\ 'typescript.tsx': 'jsxRegion,tsxRegion',
\ 'javascript.jsx': 'jsxRegion',
\ }

autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx

let g:fugitive_pty = 0

" vim-go config
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1

let g:go_auto_type_info = 1

autocmd FileType go nmap <leader>t  <Plug>(go-test)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <Leader>i <Plug>(go-info)
autocmd FileType go nmap <leader>e  <Plug>(go-diagnostics)
autocmd FileType go nmap <leader>d :GoDecls<CR>
autocmd FileType go nmap gr :GoReferrers<CR>

" from readme
" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

function! ShowDocIfNoDiagnostic(timer_id)
  if (coc#util#has_float() == 0)
    silent call CocActionAsync('doHover')
  endif
endfunction

function! s:show_hover_doc()
  call timer_start(500, 'ShowDocIfNoDiagnostic')
endfunction

" Automatically show documentation or diagnostic when cursoring over a word
" autocmd CursorHoldI * :call <SID>show_hover_doc()
" autocmd CursorHold * :call <SID>show_hover_doc()

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocActionAsync('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>ac  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction-selected)

vmap <leader>aa  <Plug>(AvanteAsk)
nmap <leader>aa  <Plug>(AvanteAsk)

vmap <leader>ae  <Plug>(AvanteEdit)
nmap <leader>ae  <Plug>(AvanteEdit)

vmap <leader>ar  <Plug>(AvantRefresh)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

nnoremap <silent> <leader>b :ToggleBlameLine<CR>

nmap <leader>n :NERDTreeFind<CR>

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" Move to beginning of code not line
map 0 ^

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocActionAsync('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete\ 11

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Go to definition in a split
nmap <leader>gd :vs<CR>gd
nmap <leader>gx :sp<CR>gd

" Vim fugitive and git 
nmap <leader>d :G diff<CR><CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gj :diffget //3<CR>
nmap <leader>gs :G<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

nmap <C-p> :Files<CR>
nnoremap <leader>gr :Rg<CR>
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', '~/.config/nvim/plugged/fzf.vim/bin/preview.sh {}']}, <bang>0)

" Get text in files with Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

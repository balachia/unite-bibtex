"=============================================================================
" FILE: autoload/unite/source/bibtex.vim
" AUTHOR:  Toshiki TERAMUREA <toshiki.teramura@gmail.com>
" Last Modified: 8 Oct 2015.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

call unite#util#set_default('g:unite_bibtex_bib_files', [])

let s:source = {
      \ 'name': 'bibtex',
      \ 'hooks': {},
      \ }

function! unite#sources#bibtex#define() 
    return s:source
endfunction 

pyfile <sfile>:h:h:h:h/src/unite_bibtex.py

function! s:source.gather_candidates(args,context)
    let l:candidates = []
python << EOF
import vim
bibpaths = vim.eval("g:unite_bibtex_bib_files")
entries = unite_bibtex.get_entries(bibpaths)
for k, v in entries.items():
    vim.command("call add(l:candidates,['{}','{}'])".format(k, v))
EOF
    return map(l:candidates,'{
    \   "word": v:val[0]." ".v:val[1],
    \   "source": "bibtex",
    \   "kind": "word",
    \   "action__text": "\\cite{" . v:val[0] . "}",
    \ }')
endfunction

function! s:source.hooks.on_syntax(args, context)
  syntax match uniteSource__Doxygen_DocType /^\s\+\w\+/
  highlight uniteSource__Doxygen_DocType ctermfg=green
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: foldmethod=marker

"
" File Name:	smartfile.vim
" Author:	Aditya Ramesh
" Date:		05/30/2012
" Contact:	_@adityaramesh.com
"
" The default settings for the features managed by this plugin are those that
" are specifed in the .vimrc file; this plugin only affects settings local to
" the current buffer or window. In order to provide custom flag names, flag
" values, and rule definitions, create the appropriate entries in the
" g:sf_names, g:sf_values, and g:sf_rules variables, respectively. Note that the
" following variables are also used by Smartfile, though, depending on the user
" settings, they may not have to be set.
" 	g:sf_author
" 	g:sf_dateformat
" 	g:sf_contact
" 	g:sf_website
" 	g:sf_headerformat
"

"
" The code used here to check whether compatible mode is set, and to
" subsequently issue a message if the verbose setting is on, is copied from the
" Tabular plugin written by Matthew Wozniski.
"
if &cp || exists("g:smartfile_loaded")
	if &cp && &verbose
		echoerr "Smartfile: Not loading Smartfile in compatible mode."
	endif
	finish
endif

let g:smartfile_loaded = 1
let s:savecpo = &cpo
set cpo&vim

let g:smartfile_flag_names =
\ {
\	"a":"Author",
\	"b":"Body",
\	"c":"Contact",
\	"d":"Date",
\	"f":"File Name",
\	"h":"Header",
\	"n":"Newline",
\	"t":"Footer",
\	"w":"Website"
\ }

let g:smartfile_flag_values =
\ {
\	"a":"g:sf_author",
\	"b":"s:CreateBody(a:rule)",
\	"c":"g:sf_contact",
\	"d":"strftime(g:sf_dateformat)",
\	"f":"expand('%:t')",
\	"h":"s:CreateHeader(a:rule)",
\	"n":'"\n"',
\	"t":"s:CreateFooter(a:rule)",
\	"w":"g:sf_website"
\ }

let g:smartfile_rules =
\ {
\ 	"asm":
\ 	{
\ 		"filetypes":["*.s"],
\ 		"comments":"b:;",
\ 		"indent":"autoindent",
\ 		"header":
\ 		"smartfile#CreateHeader(
\ 			g:smartfile_flag_names,
\ 			g:smartfile_flag_values,
\ 			g:sf_headerformat, ';'
\ 		)",
\ 		"template":"h2n"
\ 	},
\ 	"cpp":
\ 	{
\ 		"filetypes":["*.{cc,cxx,cpp}"],
\ 		"comments":"s0:/*,mb:**,ex:*/,b://",
\ 		"indent":"cindent",
\ 		"header":
\ 		"smartfile#CreateHeader(
\ 			g:smartfile_flag_names,
\ 			g:smartfile_flag_values,
\ 			g:sf_headerformat, '/*', '**', '*/'
\ 		)",
\ 		"template":"h2n"
\ 	},
\ 	"css":
\ 	{
\ 		"filetypes":["*.css"],
\ 		"comments":"s0:/*,mb:**,ex:*/",
\ 		"indent":"autoindent",
\ 		"header":
\ 		"smartfile#CreateHeader(
\ 			g:smartfile_flag_names,
\ 			g:smartfile_flag_values,
\ 			g:sf_headerformat, '/*', '**', '*/'
\ 		)",
\ 		"template":"h2n"
\ 	},
\ 	"cuda":
\ 	{
\		"filetypes":["*.cuda"],
\		"comments":"s0:/*,mb:**,ex:*/,b://",
\		"indent":"cindent",
\		"header":
\		"smartfile#CreateHeader(
\			g:smartfile_flag_names,
\			g:smartfile_flag_values,
\			g:sf_headerformat, '/*', '**', '*/'
\		)",
\		"template":"h2n"
\ 	},
\ 	"hpp":
\ 	{
\ 		"filetypes":["*.{h,hh,hpp,hxx}"],
\ 		"comments":"s0:/*,mb:**,ex:*/,b://",
\ 		"indent":"cindent",
\ 		"header":
\ 		"smartfile#CreateHeader(
\ 			g:smartfile_flag_names,
\ 			g:smartfile_flag_values,
\ 			g:sf_headerformat, '/*', '**', '*/'
\ 		)",
\ 		"body":"smartfile#CreateUUIDIncludeGuard()",
\ 		"template":"hnb",
\		"carat":"?define\<cr>2j"
\ 	},
\ 	"make":
\ 	{
\		"filetypes":["{Makefile,makefile}"],
\		"comments":"b:#",
\		"indent":"autoindent",
\		"header":
\		"smartfile#CreateHeader(
\			g:smartfile_flag_names,
\			g:smartfile_flag_values,
\			g:sf_headerformat, '#'
\		)",
\		"template":"h2n"
\ 	},
\ 	"readme":
\ 	{
\		"filetypes":["{README,readme}"],
\		"comments":"s0:/*,mb:**,ex:*/,b://",
\		"header":
\ 		"smartfile#CreateHeader(
\ 			g:smartfile_flag_names,
\ 			g:smartfile_flag_values,
\ 			g:sf_headerformat, '/*', '**', '*/'
\ 		)",
\ 		"template":"h2n"
\ 	},
\ 	"tex":
\ 	{
\ 		"filetypes":["*.tex"],
\ 		"comments":"b:%",
\ 		"indent":"autoindent",
\ 		"header":
\ 		"smartfile#CreateHeader(
\ 			g:smartfile_flag_names,
\ 			g:smartfile_flag_values,
\ 			g:sf_headerformat, '%'
\ 		)",
\ 		"template":"h2n"
\ 	},
\	"vim":
\	{
\		"filetypes":["*.vim"],
\		"comments":"b:\\\",b:\\",
\		"indent":"autoindent",
\		"header":
\		"smartfile#CreateHeader(
\			g:smartfile_flag_names,
\			g:smartfile_flag_values,
\			g:sf_headerformat,'\"'
\		)",
\		"template":"h2n"
\	}
\ }

function! s:CreateHeader(rule)
	if !has_key(g:smartfile_rules[a:rule], "header")
		throw "Smartfile: rule " . a:rule . " has no 'header' key."
	endif
	exe "let var = " . g:smartfile_rules[a:rule]["header"]
	return var
endfunction

function! s:CreateBody(rule)
	if !has_key(g:smartfile_rules[a:rule], "body")
		throw "Smartfile: rule " . a:rule . " has no 'body' key."
	endif
	exe "let var = " . g:smartfile_rules[a:rule]["body"]
	return var
endfunction

function! s:CreateFooter(rule)
	if !has_key(g:smartfile_rules[a:rule], "footer")
		throw "Smartfile: rule " . a:rule . " has no 'footer' key."
	endif
	exe "let var = " . g:smartfile_rules[a:rule]["footer"]
	return var
endfunction

function! s:ApplySettings(rule, event)
	if has_key(g:smartfile_rules[a:rule], "comments")
		let s = g:smartfile_rules[a:rule]["comments"]
		exe "au " . a:event . " set comments=" . s
	endif
	if has_key(g:smartfile_rules[a:rule], "indent")
		let s = g:smartfile_rules[a:rule]["indent"]
		exe "au " . a:event . " set " . s
	endif
endfunction

function! GenerateTemplate(rule)
	let buf = ""
	let rep = 1
	for c in split(g:smartfile_rules[a:rule]["template"], "**")
		if match(c, "[0-9]") != -1
			let rep = str2nr(c)
			continue
		endif
		if !has_key(g:smartfile_flag_values, c)
			throw "Smartfile: flag " . c . " is undefined."
		endif
		for i in range(1, rep)
			exe "let buf = buf . " . g:smartfile_flag_values[c]
		endfor
		let rep = 1
	endfor
	call append(0, split(buf, "\n"))
	exe ":d"
endfunction

function! s:ApplyRule(rule)
	exe "augroup " . " smartfile_" . a:rule . "_group"
	if !has_key(g:smartfile_rules, a:rule)
		throw "Smartfile: cannot find rule " . a:rule . "."
	endif
	if !has_key(g:smartfile_rules, a:rule)
		throw "Smartfile: no key 'filetype' for rule " . a:rule . "."
	endif
	for ft in g:smartfile_rules[a:rule]["filetypes"]
		if has_key(g:smartfile_rules[a:rule], "comments")
			let s = g:smartfile_rules[a:rule]["comments"]
			exe "au BufEnter " . ft . " setlocal comments=" . s
		endif
		if has_key(g:smartfile_rules[a:rule], "indent")
			let s = g:smartfile_rules[a:rule]["indent"]
			exe "au BufEnter " . ft . " setlocal " . s
		endif
		if has_key(g:smartfile_rules[a:rule], "template")
			exe "au BufNewFile " . ft . " call GenerateTemplate("
				\ . "\"" . a:rule . "\")"
		endif
		if has_key(g:smartfile_rules[a:rule], "carat")
			exe "au BufNewFile " . ft . " norm " .
				\ g:smartfile_rules[a:rule]["carat"]
		endif
	endfor
	augroup end
endfunction

if exists("g:sf_names")
	for key in keys(g:sf_names)
		g:smartfile_flag_names[key] = g:sf_names[key]
	endfor
endif
if exists("g:sf_values")
	for key in keys(g:sf_values)
		g:smartfile_flag_values[key] = g:sf_values[key]
	endfor
endif
if exists("g:sf_rules")
	for key in keys(g:sf_rules)
		g:smartfile_flag_names[key] = g:sf_rules[key]
	endfor
endif

for rule in keys(g:smartfile_rules)
	call s:ApplyRule(rule)
endfor

let &cpo = s:savecpo
unlet s:savecpo
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

"
" This is a dictionary that is used to interpret the DSL for file headers. The
" keys are the abbreviations that are used in the DSL, and the values are the
" names of the fields that actually appear in the file type header, each
" followed by a colon. Entries in g:sf_names, g:sf_values, and g:sf_rules
" override those that are given in this file. The intent is for the end user to
" provide personal information by adding entries to the three aforementioned
" variables.
"
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

"
" This dictionary is a mapping from file header DSL flags to pieces of code that
" are lazily evaluated each time a specific flag is mentioned. As we iterate
" through all of the flags in the DSL string used to construct the header for
" each filetype, we append the result of executing the code corresponding to
" each DSL flag to the end of a string. After the procedure terminates, the
" string will contain the file header.
"
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

"
" This is the main dictionary of rules that are defined for each file type. Each
" rule maps a filetype to a set of event-action pairs.
"
let g:smartfile_rules =
\ {
\ 	"asm":
\ 	{
\ 		"extensions":["*.{asm,s}"],
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
\ 		"extensions":["*.{cc,cxx,cpp}"],
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
\ 		"extensions":["*.css"],
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
\		"extensions":["*.cuda"],
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
\ 		"extensions":["*.{h,hh,hpp,hxx}"],
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
\ 	"js":
\ 	{
\		"extensions":["*.js"],
\ 		"comments":"s0:/*,mb:**,ex:*/,b://",
\ 		"indent":"autoindent",
\ 		"header":
\ 		"smartfile#CreateHeader(
\ 			g:smartfile_flag_names,
\ 			g:smartfile_flag_values,
\ 			g:sf_headerformat, '/*', '**', '*/'
\ 		)",
\ 		"template":"h2n"
\ 	},
\ 	"less":
\ 	{
\ 		"extensions":["*.less"],
\ 		"filetype":"css",
\ 		"comments":"s0:/*,mb:**,ex:*/,b://",
\ 		"indent":"autoindent",
\ 		"header":
\ 		"smartfile#CreateHeader(
\ 			g:smartfile_flag_names,
\ 			g:smartfile_flag_values,
\ 			g:sf_headerformat, '/*', '**', '*/'
\ 		)",
\ 		"template":"h2n"
\ 	},
\ 	"make":
\ 	{
\		"extensions":["{*.mk,Makefile,makefile}"],
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
\ 	"markdown":
\ 	{
\		"extensions":["*.md"],
\		"comments":"s0:<!--,mb:\\ \\ **,ex:-->",
\		"header":
\		"smartfile#CreateHeader(
\			g:smartfile_flag_names,
\			g:smartfile_flag_values,
\			g:sf_headerformat, '<!--', '  **', '-->'
\		)",
\		"template":"h2n"
\ 	},
\ 	"readme":
\ 	{
\		"extensions":["{README,readme}"],
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
\ 		"extensions":["*.tex"],
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
\		"extensions":["*.vim"],
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

"
" These following functions are dispatched by s:ApplyRule().
"
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
		exe "au " . a:event . " setlocal comments=" . s
	endif
	if has_key(g:smartfile_rules[a:rule], "indent")
		let s = g:smartfile_rules[a:rule]["indent"]
		exe "au " . a:event . " setlocal " . s
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

"
" This function takes an input a rule dictionary (like g:smartfile_rules), and
" executes all of the rules. This has no immediate effect, since the purpose of
" all of the rules is to set up autocommand groups.
"
function! s:ApplyRule(rule)
	exe "augroup " . " smartfile_" . a:rule . "_group"
	if !has_key(g:smartfile_rules, a:rule)
		throw "Smartfile: cannot find rule " . a:rule . "."
	endif
	if !has_key(g:smartfile_rules, a:rule)
		throw "Smartfile: no key 'filetype' for rule " . a:rule . "."
	endif
	for ft in g:smartfile_rules[a:rule]["extensions"]
		if has_key(g:smartfile_rules[a:rule], "filetype")
			let s = g:smartfile_rules[a:rule]["filetype"]
			exe "au BufEnter " . ft . " setlocal ft=" . s
		endif
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

"
" These functions keep the promise that any settings defined in the .vimrc file
" will override those in the g:smartile_rules dictionary.
"
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

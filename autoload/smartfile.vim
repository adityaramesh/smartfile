"
" File Name:	smartfile.vim
" Author:	Aditya Ramesh
" Date:		05/30/2012
" Contact:	_@adityaramesh.com
"
" This library script implements some functions used to generate various blocks
" of text, such as headers and include guards.
"

let s:savecpo = &cpo
set cpo&vim

function! smartfile#CreateHeader(names, values, format, ...)
	if a:0 == 0
		throw "Smartfile: too few arguments given to CreateHeader()."
	endif
	
	let buf = a:1 . "\n"
	let col = a:0 == 1 ? a:1 : a:2
	let max = 0
	for c in split(a:format, "**")
		" Add one for the space, and another for the colon.
		let max = max([max, len(col) + 2 + len(a:names[c])])
	endfor
	
	let delta = &ts - max % &ts
	let delta = delta ? delta : &ts
	for c in split(a:format, "**")
		let len = len(col) + 2 + len(a:names[c])
		let tab = max + delta - len
		let tab = tab / &ts + (tab % &ts != 0)
		exe "let var = " . a:values[c]
		let buf = buf . col . " " . a:names[c] . ":" .
			\ repeat("\t", tab) . var . "\n"
	endfor
	let buf = buf . (a:0 == 1 ? a:1 : a:3) . "\n"
	return buf
endfunction

function! smartfile#CreateUUIDIncludeGuard()
	let guard = "Z" . toupper(substitute(matchstr(system("uuidgen"),
		\ "[^\n\r]*"), "-", "_", "g"))
	return "#ifndef " . guard . "\n#define " . guard . "\n\n\n\n#endif"
endfunction

let &cpo = s:savecpo
unlet s:savecpo

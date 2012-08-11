<!--
  ** File Name: README.md
  ** Author:	Aditya Ramesh
  ** Date:      08/10/2012
  ** Contact:   _@adityaramesh.com
-->

## Introduction

Smartfile is a Vim package designed to alleviate the process of defining a set
of actions to be executed upon creating a new file. For instance, depending on
whether you are editing an HTML file or a C++ header file, you will need to
change the content of the file header. (And in the process of adapting to a new
set of comment characters, the number of tabs that need to be inserted after
each field in the file header may also change.) Perhaps in the HTML file header,
you want to disclose less personal information than you would in the C++ file
header. In the C++ header file, you may want to insert a few newlines after the
file heading, and automatically write an include guard using a
randomly-generated UUID. The cursor position will also need to be set to the
right location (between the `#define` and the `#endif`), so that you can get
typing right away.

One way to take care of all this would be to write code for each new behavior in
your `.vimrc`, which would gradually get longer, messier, and harder to
maintain.  Smartfile handles these things by providing an associative array of
event names to actions.  When a new file is created, its extension is used to
look up to determine the set of actions to take.  Depending on its corresponding
event, each action may either be a small DSL, function call, or something else.
Smartfile comes with predefined utilities for several common tasks, and can be
extended to perform more specialized tasks. This system makes defining behaviors
for new files types an enjoyable experience, rather than something that seems to
impede your workflow.

## Installation

This package requires Vundle. If you do not have Vundle installed already, you
can get it [here](https://github.com/gmarik/vundle/). Just add

	Bundle 'adityaramesh/smartfile'

to your list of repositories in `.vimrc`. The next time you start up Vim, use
`:BundleInstall` to have Vundle install Smartfile.

## Uninstallation

Remove

	Bundle 'adityaramesh/smartfile'

from your `.vimrc`, and remove `~/.vim/bundle/smartfile`.

## Setup

To take advantage of the default rules that are already defined by Smartfile,
you need to give it some of your personal information. Otherwise, it has no way
of knowing what to put in the headers it will automatically create for you.

	let g:sf_author = "John Snow"
	let g:sf_contact = "get@thehelloffmylawn.com"
	let g:sf_dateformat = "%m/%d/%Y"
	let g:sf_website = "hello.com"
	let g:sf_headerformat = "fadc"

To learn more about the DSL for `g:sf_dateformat`, see `help:strftime`. The DSL
for `g:sf_headerformat` is of my own invention, and in general is an
alphanumeric sequence. Each letter, or _flag_, pastes a global variable or
causes the execution of some method. A number _n_ before a flag indicates that
the result of evaluating the next flag should be appended _n_ times. The
complete set of header format flags is tabulated below.

<table>
	<tr>
		<th>Flag</th>
		<th>Meaning</th>
	</tr>
	<tr>
		<td>a</td>
		<td>Author</td>
	</tr>
	<tr>
		<td>b</td>
		<td>Body</td>
	</tr>
	<tr>
		<td>c</td>
		<td>Contact</td>
	</tr>
	<tr>
		<td>d</td>
		<td>Date</td>
	</tr>
	<tr>
		<td>f</td>
		<td>File Name</td>
	</tr>
	<tr>
		<td>h</td>
		<td>Header</td>
	</tr>
	<tr>
		<td>n</td>
		<td>Newline</td>
	</tr>
	<tr>
		<td>t</td>
		<td>Footer</td>
	</tr>
	<tr>
		<td>w</td>
		<td>Website</td>
	</tr>
</table>

In order to modify the names of existing header format flags or define your own,
place an entry for the corresponding key in `g:sf_names`. To modify the behavior
of an existing flag or define the behavior of a new flag, place an entry for the
corresponding key in `g:sf_values`.

Automatically creating file headers is only one of many actions that Smartfile
is capable of taking. Each filetype that Smartfile supports has a default set of
actions stored in a dictionary called `g:smartfile_rules` in
`plugin/smartfile.vim`. If you wish to modify existing rules or add your own, I
suggest that you study the structure of this dictionary. However, instead of
modifying `g:smartfile_rules` directly, modify `g:sf_rules` in your `.vimrc`.
Entries places in `g:sf_rules` override those defined in `g:smartfile_rules`, so
that upgrading to a newer version of Smartfile will not destroy any of your
modifications. That said, if you feel that any modifications you have made would
benefit others by being incorporated into the default behavior of Smartfile, I
encourage you to submit a pull request. Suggestions and improvements are always
welcome!

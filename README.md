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

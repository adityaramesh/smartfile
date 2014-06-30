<!--
  -- File Name: README.md
  -- Author:    Aditya Ramesh
  -- Date:      08/10/2012
  -- Contact:   _@adityaramesh.com
--->

# Introduction

Smartfile is a Vim plugin that allows you to automate file-specific actions
like:

  - Generating headers
  - Setting the line and block comments
  - Changing the default identation mode
  - Setting the default position of the cursor

The same JSON files are used to define behavior across all file types. So
a C++ header might look like this:

	/*
	** File Name: test.cpp
	** Author:    Jane Doe
	** Date:      08/10/2012
	** Contact:   jane@doe.com
	*/

The equivalent HTML header might look like this:

	<!--
	  -- File Name: test.html
	  -- Author:    Jane Doe
	  -- Date:      08/10/2012
	  -- Contact:   jane@doe.com
	--->

Consult the [documentation](documentation.md) for more details and some
examples.

# Features

Each time a buffer is entered, the following actions can be configured:

  - File extensions associated with file type.
  - A new filetype, if the default filetype is not desired (e.g. `.less` files
  should be treated as `.css` files).
  - Line and block comment characters so that word wrapping using `gq` works
  properly.
  - Default indentation.

Each time a new file is created, the following actions can be configured:

  - Format of the header.
  - Default content (e.g. for C++ header files, automatically insert include
  guard using `uuidgen`).
  - Position of the carat (by executing a predetermined Vim command).

These settings are specified by the configuration files located in
`~/smartfile`. Many of these settings (e.g. the file header structure) will be
the same for most of file types that you will edit. Smartfile allows you to
define global settings in your `.vimrc` file, and override these settings on a
per-filetype basis, when you desire specialized behavior.

Smartfile also allows you to define new keys that map to custom actions, and use
these keys in the configuration file. Further details are provided in the
[documentation](documentation.md).

# Prerequisites

Vim needs to be configured with support for Python 3 in order for Smartfile to
work. You can check if this is the case by examining the output of `:version`,
and checking to ensure that it has `+python3` or `+python3/dyn`. If your version
of Vim does not have support for Python 3, you have the following options:

  - If your package manager has a variant of Vim with support for Python 3,
  install this variant, and set this variant as your active Vim version.
  - Compile Vim from the sources. Make sure that you supply the following flags
  when you run `./configure`:
    - `--with-pythoninterp` (for Python 2 support)
    - `--with-python3interp` (for Python 3 support)
  You may also have to specify the paths to the Python configuration directories
  using:
    - `--with-python-config-dir` (for Python 2)
    - `--with-python3-config-dir` (for Python 3)

# Installation

This package requires Vundle. If you do not have Vundle installed already, you
can get it [here](https://github.com/gmarik/vundle/). Then, add

	Bundle 'adityaramesh/smartfile'

to your list of repositories in `.vimrc`. The next time you start up Vim, use
`:BundleInstall` to have Vundle install Smartfile.

# Uninstallation

Remove

	Bundle 'adityaramesh/smartfile'

from your `.vimrc`, and remove `~/.vim/bundle/smartfile`.

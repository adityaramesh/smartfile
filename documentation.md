<!--
  ** File Name: documentation.md
  ** Author:    Aditya Ramesh
  ** Date:      01/20/2014
  ** Contact:   _@adityaramesh.com
-->

# Warning

This documentation is for an upcoming version of Smartfile that is still in
development. Please disregard this page for now.

# Introduction

If you sign your files, you can begin by giving Smartfile some some of your
personal information. Here's an example of what you might put in your `.vimrc`
file.

	let g:sf_author     = "Jon Snow"
	let g:sf_contact    = "get@thehelloffmylawn.com"
	let g:sf_website    = "example.com"
	let g:sf_date_fmt   = "%Y-%m-%d"
	let g:sf_header_fmt = "{f}{a}{d}{c}"
	let g:sf_template   = "{h}2{e}"

The DSL for `g:sf_dateformat` is described by the help page brought up by `:h
strftime`. In Vim regex, the DSL for `g:sf_header_fmt` is of the form

	\([0-9]\={[a-zA-Z-_]\+}\)\+

That is, the DSL consists of repetitions of bracketed keys, where each key
consists of lowercase and uppercase symbols, and dashes and underscores. Each
key can optionally be preceeded by a number, which indicates the number of times
the action associated with that key is applied.

Smartfile associates each of the following attributes with its own set of
private keys:

  - Header and footer for files (`g:sf_header_fmt` and `g:sf_footer_fmt`).
  - Template used to define default content (`g:sf_template`).
  - Each filetype defined in the Smartfile configuration.

Here is the set of default keys for `g:sf_header_fmt` and `g:sf_footer_fmt`:

| Key   | Action                                    |
| ----- | ----------------------------------------- |
| f     | Insert file name                          |
| a     | Insert author                             |
| d     | Insert date                               |
| c     | Insert contact                            |
| w     | Insert website                            |
| b     | Insert blank line (with comment sequence) |
| n     | Insert newline (without comment sequence) |
| g     | Global header/footer format string        |
| none  | No header/footer                          |

Here is the set of default keys for `g:sf_template`.

| Key   | Action           |
| ----- | ---------------- |
| f     | Insert footer    |
| h     | Insert header    |
| n     | Insert newline   |

We describe keys in more detail in a later section. Finally, here is a list of
the configurable global variables:

  - `g:sf_author`
  - `g:sf_contact`
  - `g:sf_website`
  - `g:sf_date_fmt`
  - `g:sf_header_fmt`
  - `g:sf_footer_fmt`
  - `g:sf_template`
  - `g:sf_indent`

Smartfile allows you to define the following filetype-specific behaviors by
adding or editing configuration files in `~/smartfile/filetypes`. Each JSON file
in this directory is an array of records. Each record associates a set of file
names with a set of actions. The keys and values that can be used within each
record are documented below:

| Key            | Default Value       | Example Value     |
| -------------- | ------------------- | ----------------- |
| `"name"`       | N/A; required       | "C++ header"      |
| `"matches"`    | N/A                 | ["*.{h,hpp,hxx}"] |
| `"filetype"`   | `&ft` (see `:h ft`) | ".hpp"            |
| `"comments"`   | N/A                 | See below.        |
| `"identation"` | `g:sf_indent`       | "autoindent"      |
| `"date"`       | `g:sf_date_fmt`     | "%Y-%m-%d"        |
| `"header"`     | `g:sf_header_fmt`   | See below.        |
| `"footer"`     | `g:sf_footer_fmt`   | See below.        |
| `"template"`   | `g:sf_template`     | "{h}2{n}{f}"      |

An example of a value for the `"comments"` key (for C++) is given below.  At
least one of `"line"` or `"block"` must be included; otherwise, Smartfile will
assume that the language does not support comments.

	"comments": {
		"line": "//",
		"block": {
			"start": "/*",
			"middle": "**",
			"end": "*/"
		}
	}

Here is an example value for `"header"` and `"footer"` keys (for HTML or
Markdown). The `"start"`, `"middle"`, and `"end"` fields are 

	"header": {
		"format": "{f}{a}{d}{c}",
		"start": "<!--",
		"middle": "  --",
		"end": "--->"
	}

Smartfile attempts to infer the starting sequence, middle sequence, and ending
sequence for headers and footers based on the comments configured for the
filetype. For instance, if block comments are given by

	(start, middle, end) = (/*, **, */),

then Smartfile would generate headers that look like this:

	/*
	** Author: Jane Doe
	*/

If only the line comment character is defined, Smartfile sets the starting,
middle, and ending sequences to the line comment character. For example, if the
line comment character is `;`, the header will look like this:

	;
	; Author: Jane Doe
	;

If the blank starting and ending lines are undesired, then the `"start"` and
`"end"` can be set to the empty string literal, `""`.

# Keys

Smartfile supports three kinds of keys:

  - Keys that append variables.
  - Keys that execute commands in normal/command mode.
  - Keys that call Vim or Python functions.

New keys are defined in the configuration file `~/smartfile/keys.json`.

For headers and footers, only variable-based and function-based keys are
allowed. Function-based keys should either return a string or a key-value pair.

- API for setting carat position.
- Use the C++ include guard as an example for function-based key.
- Example for variable-based key.
- Example for command-based key.

# Extending Smartfile

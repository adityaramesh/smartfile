#
# File Name:	Makefile
# Author:	Aditya Ramesh
# Date:		08/09/2012
# Contact:	_@adityaramesh.com
#

.PHONY : install uninstall

install :
	rm -rf ~/.vim/bundle/smartfile
	cp -R . ~/.vim/bundle/smartfile

uninstall :
	rm -rf ~/.vim/bundle/smartfile

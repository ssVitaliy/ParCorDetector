#!/bin/bash

if [ "$#" -eq 0 ]; then
	echo 'Tip: fdef.sh <file_name> [<function_name>] [-a]'
	echo 'Only <file_name> show function names from file'
	echo 'With <function_name> - show func defenition' 
	echo 'Flag -a show function body'
elif [ "$#" -eq 1 ]; then
	sed -n "/^function/p" $1
elif [ "$#" -eq 2 ]; then
	sed -n "/^function $2/,/)/p" $1
elif [ "$#" -eq 3 ] && [ "$3" = '-a' ]; then
	sed -n "/function $2/,/^function/p" $1
else
	echo 'Too much arguments. Try 1 or 2.'
fi


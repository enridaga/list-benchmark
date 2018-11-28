#!/bin/bash


# Prepare data
for file in ../data/*
do
	# there should be only files anyway
    if [[ -f $file ]]; then
		# PUT into virtuoso
		data=$(basename "${file%.*}")
		./put-in-virtuoso.sh $(realpath $file) "data:$data"
		sleep 1
    fi
done


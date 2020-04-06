#!/bin/bash


datasets="${@}"
[ -z "$datasets" ] && echo "Specify datasets to be setup" && exit 1

# Prepare data
for d in $datasets
do 
	echo "Setting up dataset $d"
	for file in ../data/$d-*.ttl
	do
		echo "Loading "$file
		# there should be only files anyway
	    if [[ -f $file ]]; then
			# PUT into virtuoso
			data=$(basename "${file%.*}")
			./put-in-virtuoso.sh $(realpath $file) "data:$data"
			sleep 1
	    fi
	done
done


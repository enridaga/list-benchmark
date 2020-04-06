#!/bin/bash

datasets="${@}"
[ -z "$datasets" ] && echo "Specify datasets to be setup" && exit 1

# Prepare data
for d in $datasets
do 
	echo "Setting up dataset $d"
	for file in ../data/$d-*.ttl
	do
	    # there should be only files anyway
		echo "Loading "$file
	    if [[ -f $file ]]; then
			# PUT into fuseki
			data=$(basename "${file%.*}")
			curl -X PUT http://localhost:3030/ds/data -G -T $(realpath $file) --data-urlencode graph="data:$data" -H "Content-Type: text/turtle"
			sleep 1
	    fi
	done
done


#!/bin/bash


# Prepare data
for file in ../data/*
do
    # there should be only files anyway
    if [[ -f $file ]]; then
		# PUT into fuseki
		data=$(basename "${file%.*}")
		curl -X PUT http://localhost:3030/ds/data -G -T $(realpath $file) --data-urlencode graph="data:$data" -H "Content-Type:text/turtle"
		sleep 1
    fi
done


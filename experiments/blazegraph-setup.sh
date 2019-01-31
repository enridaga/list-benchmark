#!/bin/bash

[ -z "$1" ] && echo "Specify Blazegraph Home directory" && exit 1

home=$1
properties=$(realpath blazegraph.properties)
# Prepare data
for file in ../data/*
do
	# there should be only files anyway
    if [[ -f $file ]]; then
		# PUT into virtuoso
		data=$(basename "${file%.*}")
		graph="data:$data"
		location=$(realpath $file)
		cd $home
		java -cp blazegraph.jar -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 com.bigdata.rdf.store.DataLoader -defaultGraph $graph $properties $location
		sleep 1
    fi
done

#!/bin/bash

[ -z "$1" ] && echo "Specify Blazegraph Home directory" && exit 1

home=$1
properties=$(realpath blazegraph.properties)
# Prepare data
for file in ../data/*.ttl
do 
    echo "Loading $file"
    # there should be only files anyway
    if [[ -f $file ]]; then
		# PUT into blazegraph
		data=$(basename "${file%.*}")
		graph="data:$data"
		location=$(realpath $file)
		
		$(cd $home && java -cp blazegraph.jar -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 com.bigdata.rdf.store.DataLoader -defaultGraph $graph $properties $location > blazegraph-setup-load.log 2>&1)
		sleep 1
    fi
done

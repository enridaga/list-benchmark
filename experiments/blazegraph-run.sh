#!/bin/bash

[ -z "$1" ] && echo "Specify Blazegraph PID" && exit 1

server_pid=$1

# Run experiments
export QUERY_ENDPOINT=http://localhost:9999/blazegraph/namespace/kb/sparql
for file in $(ls -Sr ../data/*)
do
    echo "Performing tests on data $file"
	# there should be only files anyway
    if [[ -f $file ]]; then
		data=$(basename "${file%.*}")
		export QUERY_GRAPH="data:$data"
		line="${data//-/$IFS}"
		arr=($line)
		eid=blazegraph-$data
		suite=${arr[1]}.txt
		# script PID experimentID suite times interval timeout
		./run-experiment.sh $server_pid $eid suite/$suite 1 5 300
    fi
done

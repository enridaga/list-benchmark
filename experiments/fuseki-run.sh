#!/bin/bash

[ -z "$1" ] && echo "Specify PID" && exit 1

fuseki_pid=$1
prefix=${2:-fuseki}
# Run experiments
export QUERY_ENDPOINT=http://localhost:3030/ds/sparql
for file in $(ls -Sr ../data/*)
do
    echo "Performing tests on data $file"
    # there should be only files anyway
    if [[ -f $file ]]; then
		data=$(basename "${file%.*}")
		export QUERY_GRAPH="data:$data"
		line="${data//-/$IFS}"
		arr=($line)
		eid=$prefix-$data
		suite=${arr[1]}.txt
		# script PID experimentID suite times interval timeout
		#echo $eid
		./run-experiment.sh $fuseki_pid $eid suite/$suite 10 5 300
    fi
done

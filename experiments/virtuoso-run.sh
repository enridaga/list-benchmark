#!/bin/bash

[ -z "$1" ] && echo "Specify Virtuoso PID" && exit 1 
[ -z "$2" ] && grep=".ttl" || grep="$2" 

virtuoso_pid=$1

# Run experiments
export QUERY_ENDPOINT=http://localhost:8890/sparql
export UPDATE_ENDPOINT=http://localhost:8890/sparql-graph-crud-auth
for file in $(ls -Sr ../data/*.ttl|grep "$grep")
do
    echo "Performing tests on data $file"
    # there should be only files anyway
    if [[ -f $file ]]; then
		data=$(basename "${file%.*}")
		export QUERY_GRAPH="data:$data"
		echo "Graph: "$QUERY_GRAPH
		export QUERY_TRACK=$(./get_query_track.sh $data)
		echo "Track: "$QUERY_TRACK
		export QUERY_RANDOM=$(./get_query_random_number.sh $data)
		echo "Random: "$QUERY_RANDOM
		line="${data//-/$IFS}"
		arr=($line)
		eid=virtuoso-$data
		suite=${arr[1]}.txt
		# script PID experimentID suite times interval timeout
		# ./run-experiment.sh $virtuoso_pid $eid suite/$suite 10 5 300
		./run-experiment.sh $virtuoso_pid $eid suite/$suite 10 5 300
    fi
done

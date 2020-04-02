#!/bin/bash
source prepare_query_functions.sh

[ -z "$1" ] && echo "Specify Blazegraph PID" && exit 1
[ -z "$2" ] && grep=".ttl" || grep="$2" 

server_pid=$1

# Run experiments
for file in $(ls -Sr ../data/*.ttl|grep -E "$grep")
do
    echo "Performing tests on data $file"
	# there should be only files anyway
    if [[ -f $file ]]; then
		data=$(basename "${file%.*}")
		prepareEnvironment $data blazegraph
 		#echo " > params: "$QUERY_GRAPH" "$QUERY_TRACK" "$QUERY_RANDOM
		line="${data//-/$IFS}"
		arr=($line)
		eid=blazegraph-$data
		suite=${arr[1]}.txt
		# script PID experimentID suite times interval timeout
		echo "./run-experiment.sh $server_pid $eid suite/$suite 10 5 300"
		#./run-experiment.sh $server_pid $eid suite/$suite 10 5 300
		#./run-experiment.sh $server_pid $eid suite/$suite 1 1 10
    fi
done

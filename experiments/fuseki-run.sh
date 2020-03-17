#!/bin/bash
source prepare_query_functions.sh
[ -z "$1" ] && echo "Specify PID" && exit 1
[ -z "$3" ] && grep=".ttl" || grep="$3" 
fuseki_pid=$1
prefix=${2:-fuseki}
# Run experiments
export QUERY_ENDPOINT=http://localhost:3030/ds/sparql
export UPDATE_ENDPOINT=http://localhost:3030/ds/update
for file in $(ls -Sr ../data/*.ttl|grep "$grep")
do
    echo "Performing tests on data $file"
    # there should be only files anyway
    if [[ -f $file ]]; then
		data=$(basename "${file%.*}")
		prepareEnvironment $data
 		echo " > params: "$QUERY_GRAPH" "$QUERY_TRACK" "$QUERY_RANDOM
		line="${data//-/$IFS}"
		arr=($line)
		eid=$prefix-$data
		suite=${arr[1]}.txt
		# script PID experimentID suite times interval timeout
		#echo "./run-experiment.sh $fuseki_pid $eid suite/$suite 10 5 300"
		./run-experiment.sh $fuseki_pid $eid suite/$suite 10 5 300
    fi
done

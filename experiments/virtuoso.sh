#!/bin/bash

[ -z "$1" ] && echo "Specify Virtuoso PID" && exit 1

virtuoso_pid=$1

# Prepare data
for file in ../data/*
do
	# there should be only files anyway
    if [[ -f $file ]]; then
		# PUT into virtuoso
		./put-in-virtuoso.sh $file "file:$file"
    fi
done

# Run experiments
export QUERY_ENDPOINT=http://localhost:8890/sparql
for file in ../data/*
do
	# there should be only files anyway
    if [[ -f $file ]]; then
		export QUERY_GRAPH="file:$file"
		eid=virtuoso-$(basename "${file%.*}")
		./run-experiment.sh $virtuoso_pid $eid suite/test.txt 1 3 10
    fi
done

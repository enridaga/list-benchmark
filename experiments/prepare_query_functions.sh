#!/bin/bash
function encodeURIComponent {
	perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'
}
function prepareEnvironment {
	data=$1
	db=${2:-fuseki}
	export QUERY_GRAPH="data:$data"
#	echo "Graph: "$QUERY_GRAPH
	export QUERY_TRACK=$(getQueryTrack $data)
#	echo "Track: "$QUERY_TRACK
	export QUERY_RANDOM=$(getDataRandomNumber $data)
#	echo "Random: "$QUERY_RANDOM

	if [[ "$2" = "blazegraph" ]]; then
		export QUERY_ENDPOINT=http://localhost:9999/blazegraph/namespace/kb/sparql
		export UPDATE_ENDPOINT=http://localhost:9999/blazegraph/namespace/kb/sparql
	elif [[ "$2" = "virtuoso" ]]; then
		export QUERY_ENDPOINT=http://localhost:8890/sparql
		export UPDATE_ENDPOINT=http://localhost:8890/sparql
	elif [[ "$2" = "fuseki" ]]; then
		export QUERY_ENDPOINT=http://localhost:3030/ds/sparql
		export UPDATE_ENDPOINT=http://localhost:3030/ds/update
	 elif [[ "$2" = "fuseki_mem" ]]; then
                export QUERY_ENDPOINT=http://localhost:3030/ds/sparql
                export UPDATE_ENDPOINT=http://localhost:3030/ds/update
	elif [[ "$2" = "fuseki_hdt" ]]; then
		export QUERY_ENDPOINT=http://localhost:3030/hdtservice/query
		export UPDATE_ENDPOINT=http://localhost:3030/hdtservice/update
	fi
	
	echo "Environment ($1, $2): graph:$QUERY_GRAPH track$QUERY_TRACK random:$QUERY_RANDOM endpoint:$QUERY_ENDPOINT update:$UPDATE_ENDPOINT"
}
function getQueryTrack {
	h=""
	if [[ "$1" =~ ^1k ]]; then
		h=8cf9897535d79e68c33a3076aa06d073
	elif [[ "$1" =~ ^30k ]]; then
		h=2473e18eec6cc55b82c5dddab3bea353
	elif [[ "$1" =~ ^60k ]]; then
		h=b77cd0a13a67bba8797d39a4e6ccd0d3
	elif [[ "$1" =~ ^90k ]]; then
		h=067dffc37b3770b4f1c246cc7023b64d
	elif [[ "$1" =~ ^120k ]]; then
		h=c45ada306052e9b8cd0a377c42679f8e
	fi

	echo "http://purl.org/midi-ld/piece/$h/track00"
}
function getDataRandomNumber {
	h=""
	if [[ "$1" =~ ^1k ]]; then
		h=0657
	elif [[ "$1" =~ ^30k ]]; then
		h=19432
	elif [[ "$1" =~ ^60k ]]; then
		h=46789
	elif [[ "$1" =~ ^90k ]]; then
		h=62987
	elif [[ "$1" =~ ^120k ]]; then
		h=78234
	fi

	echo "$h"
}
function setGraph {
	ghost="http://purl.org/midi-ld/piece/2eb43ce7edf27b505bcc0dfb6c283784"
	graph=$QUERY_GRAPH
	sed "s,$ghost,$graph,g"
}
function setTrack {
	ghost="http://purl.org/midi-ld/piece/2473e18eec6cc55b82c5dddab3bea353/track00"
	track=$QUERY_TRACK
	sed "s,$ghost,$track,g"	
}
function setOffset {
	ghost="OFFSET 23789"
	random=$QUERY_RANDOM
	random="OFFSET $(($random-1))"
	sed "s,$ghost,$random,g"
}
function setRandom {
	ghost="23789"
	random=$QUERY_RANDOM
	sed "s,$ghost,$random,g"
}
function setSeq {
	ghost="23789"
	number=${QUERY_RANDOM#0}
	sed "s,:_$ghost,:_$number,g"
}
function prepareQuery {
	setGraph|setTrack|setOffset|setSeq|setRandom
}

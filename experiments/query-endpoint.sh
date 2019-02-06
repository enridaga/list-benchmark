#!/bin/bash
function encodeURIComponent {
	perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'
}
function setGraph {
	ghost="http://purl.org/midi-ld/piece/2eb43ce7edf27b505bcc0dfb6c283784"
	graph=$QUERY_GRAPH
	sed "s,$ghost,$graph,g"
}
queryfile=$1
endpoint=$QUERY_ENDPOINT
query=`cat $queryfile|setGraph`
>&2 echo "-----------------------------------"
>&2 echo "Querying $endpoint, file $queryfile"
>&2 echo "Query: $query"
>&2 echo "-----------------------------------"
query=`echo $query|encodeURIComponent`
# TODO There is a problem, sometimes time is not written to the error file
time (
	curl -s -v "$endpoint" -d query="$query"
)

#!/bin/bash
function encodeURIComponent {
	perl -pe 's/([^a-zA-Z0-9_.!~*()'\''-])/sprintf("%%%02X", ord($1))/ge'
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

queryfile=$1
endpoint=$UPDATE_ENDPOINT
query=`cat $queryfile|setGraph|setTrack`
>&2 echo "-----------------------------------"
>&2 echo "Querying $endpoint, file $queryfile"
>&2 echo "Query: $query"
>&2 echo "-----------------------------------"
query=`echo $query|encodeURIComponent`
time (
	curl -s -v "$endpoint" -d update="$query" -H "Accept:application/xml,application/sparql-results+xml,application/rdf+xml"
)

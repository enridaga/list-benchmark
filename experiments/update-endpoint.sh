#!/bin/bash

source ./prepare_query_functions.sh

queryfile=$1
endpoint=$UPDATE_ENDPOINT
query=`cat $queryfile|prepareQuery`
>&2 echo "-----------------------------------"
>&2 echo "Querying $endpoint, file $queryfile"
>&2 echo "Query: $query"
>&2 echo "-----------------------------------"
query=`echo $query|encodeURIComponent`
time (
	curl --connect-timeout 300 -m 300 -s -v "$endpoint" -d update="$query" -H "Accept:application/xml,application/sparql-results+xml,application/rdf+xml"
)

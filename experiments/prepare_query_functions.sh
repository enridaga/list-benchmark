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
	setGraph|setTrack|setSeq|setRandom
}
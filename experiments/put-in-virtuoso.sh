#!/bin/bash

endpoint=http://localhost:8890/sparql-graph-crud-auth
graph=$2
file=$1
curl --digest --user dba:dba --verbose --url "${endpoint}?graph-uri=${graph}" -T $file 

#!/bin/bash
[ -z "$1" ] && echo "Specify Blazegraph Home directory" && exit 1

home=$1
properties=$(realpath blazegraph.properties)
cd $home
java -server -Xmx2G -jar -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8 blazegraph.jar
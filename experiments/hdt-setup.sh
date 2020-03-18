#!/bin/bash
[ -z "$1" ] && echo "Specify HDT Fuseki Distribution directory" && exit 1

BASE=$1
BASE=$( cd $BASE ; pwd )
CP=$( echo "$BASE/lib/*" )
CP=$( echo $CP | sed 's/ /:/g' )
export CLASSPATH=".:$CP:$CLASSPATH"
#echo $CLASSPATH

for hdtfile in $(ls -Sr ../data/*.hdt)
do
    # there should be only files anyway
	if [ -n "$hdtfile" -a ! -f "$hdtfile.index" ]; then
	    echo "Index file creation for $hdtfile"
		java -Xmx8g org.rdfhdt.hdt.fuseki.HDTGenerateIndex $hdtfile || exit $?
	fi
done

#!/bin/bash
[ -z "$1" ] && echo "Specify HDT Fuseki Distribution directory" && exit 1
BASE="$1"
BASE=$( cd $BASE ; pwd )
CP=$( echo "$BASE/lib/*" )
CP=$( echo $CP | sed 's/ /:/g' )
#CP=$( echo "$BASE/target/*.jar" "$BASE/target" "$BASE/target/classes" "$BASE"/target/dependency/*.jar . | sed 's/ /:/g')

export CLASSPATH=".:$CP:$CLASSPATH"
#echo $CLASSPATH
assembly="hdt-assembly.ttl"
java -server -Xmx4G org.rdfhdt.hdt.fuseki.FusekiHDTCmd --pages=$BASE/pages --config="$assembly" /dataset

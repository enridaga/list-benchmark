#!/bin/bash
source prepare_query_functions.sh

for file in ../data/1k*.ttl; do
	data=$(basename "${file%.*}")
	prepareEnvironment $data blazegraph
	#echo " > params: "$QUERY_GRAPH" "$QUERY_TRACK" "$QUERY_RANDOM
	line="${data//-/$IFS}"
	arr=($line)
	# 	eid=blazegraph-$data
	suite=${arr[1]}.txt
	model=$(echo ${arr[1]}|tr '[:lower:]' '[:upper:]' )
	echo "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	echo "\subsection{Queries with the ${model/_/ } data model.}"
	echo "\label{queries:${model/_/-}}"
	echo ""
	# echo "Data model: ${model}"
	while IFS= read -r experiment
	do
		#echo $experiment
	# 		count=$((count+1))
	# 		if [ ! -z "$experiment" ]; then
	 	exp=($experiment)
		type=${exp[0]}
		query=${exp[1]}
		operation=$(echo $query|cut -d'/' -f3|cut -d'-' -f1)
		echo "\subsubsection{Operation: ${operation/_/ } (${model/_/ })}"
		echo "\label{query:${model/_/\-}:$operation}"
		echo ""
		echo "\begin{lstlisting}[language=sparql]"
		cat ${query}|grep -v -E '^prefix\s'
		echo ""
		echo "\end{lstlisting}"
		echo ""
	done < "suite/$suite"
	echo ""
done
#!/bin/bash


function errcho {
    >&2 echo "$@"
}
# function experiment {
# 	sh "$@"
# }

function monitor {
    # sleep 0.1
	process=$1 #$(pgrep -P $1)      #$1 #$(ps -a -o pid,command|sed 1d|grep java|grep experiment|cut -d " " -f 1)
    MS=$2
	MPID=$3
	errcho "Monitoring $MPID for experiment $process (will interrupt in $MS seconds)"
	#trap "kill $process" EXIT
	kill="pkill -TERM -P $process"
	if [ ! -z "$process" ]
	then
	  SECONDS=0
	  while kill -0 $process 2> /dev/null; do
		[ "$SECONDS" -gt "$MS" ] && break || errcho -n "."
		ps -p $MPID -o pid,%cpu,%mem,vsz,rss|sed 1d
		#sleep 0.2
	  done
	  [ "$SECONDS" -gt "$MS" ] && $kill && errcho " Interrupted." || errcho " Done."
	fi
}

[ -z "$1" ] && echo "Missing arg 1: PID to monitor!" && exit 1
[ -z "$2" ] && echo "Missing arg 2: experiment ID (e.g. blazegraph, fuseki-mem)!" && exit 1
[ -z "$3" ] && echo "Missing arg 3: suite to execute (e.g. suite/seq.txt)!" && exit 1

mpid=$1

if [ -n "$(ps -p $mpid -o pid=)" ]; then
    echo "Monitoring PID: $mpid"
else
    echo "Process $mpid does not exists" >&2 && exit 2
fi

experimentID=${2}
suite=${3}
times=${4:-1}
interval=${5:-5}
interrupt=${6:-300} # almost 5 minutes
doonly=($7)
result="results/$experimentID."$(basename "${suite%.*}")

[[ -d results ]] || mkdir results
rm $result.* 2> /dev/null

printf "Experiment ID: $experimentID \n\
Suite: $suite \n\
Repeating $times times \n\
Wait $interval seconds between each run \n\
Timeout: $interrupt seconds \n\
Writing to $result*\n"

doall=true
if [ ${#doonly[@]} -eq 0 ]; then
        echo "Doing all experiments in suite"
else
        echo "Doing experiments: "$7
	doall=false
fi

count=0
while IFS= read -r experiment
do
  count=$((count+1))

  if [[ ( ! "$doall" = true ) && ( ! " ${doonly[@]} " =~ " ${count} " ) ]]; then
     continue
  fi

  if [ ! -z "$experiment" ]; then
  for a in `seq $times`
  do
    sleep $interval
    exec 1<&-
    exec 1<>$result.monitor.$count.$a
    errcho "$count $a - $experiment - $experimentID - $suite"
    echo "#$count #$a - $experiment - $experimentID - $suite"
    $experiment > $result.output.$count.$a 2>$result.error.$count.$a &
	epid=$!
    monitor $epid $interrupt $mpid
  done
  fi
done < "$suite"

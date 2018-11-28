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
	if [ ! -z "$process" ]
	then
	  SECONDS=0
	  while kill -0 $process 2> /dev/null; do
		[ "$SECONDS" -gt "$MS" ] && break || errcho -n "."
		ps -p $MPID -o pid,%cpu,%mem,vsz,rss|sed 1d
		#sleep 0.2
	  done
	  [ "$SECONDS" -gt "$MS" ] && kill $process && errcho " Interrupted." || errcho " Done."
	fi
}

[ -z "$1" ] && echo "Missing arg 1: PID to monitor!" && exit 1
[ -z "$2" ] && echo "Missing arg 2: suite to execute!" && exit 1
[ -z "$3" ] && echo "Missing arg 3: query endpoint!" && exit 1
[ -z "$4" ] && echo "Missing arg 4: target graph!" && exit 1

mpid=$1

if [ -n "$(ps -p $mpid -o pid=)" ]; then
    echo "Monitoring PID: $mpid"
else
    echo "Process $mpid does not exists" >&2 && exit 2
fi

suite=${2}
endpoint=${3}
graph=${4}
export QUERY_ENDPOINT=$endpoint
export QUERY_GRAPH=$graph
times=${5:-1}
interval=${6:-5}
interrupt=${7:-300} # almost 5 minutes
result=results/$(basename "$suite")
rm $result.* 2> /dev/null

printf "Running suite: $suite \n\
Querying endpoint: $endpoint \n\
Target graph: $graph \n\
Repeating $times times \n\
Wait $interval seconds between each run \n\
Timeout: $interrupt seconds \n\
Writing to $result*"

count=0
while IFS= read -r experiment
do
  count=$((count+1))
  if [ ! -z "$experiment" ]; then
  for a in `seq $times`
  do
    sleep $interval
    exec 1<&-
    exec 1<>$result.monitor.$count.$a
    errcho "$count $a - $experiment"
    echo "#$count #$a - $experiment"
    $experiment > $result.output.$count.$a 2>$result.error.$count.$a &
	epid=$!
    monitor $epid $interrupt $mpid
  done
  fi
done < "$suite"

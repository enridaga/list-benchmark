Supplementary material for SWJ submission: "Sequential Linked Data: the state of affairs."

# EXPERIMENT RESULTS
These files include the results reported in the paper:

RDFSeqExperiments - BVFM-MASTER.csv

# REPRODUCE EXPERIMENTS
The experiment setting has been executed on a Linux CENTOS 7 VM. 
However, setup has been mostly done on a Mac-OS system so there is good chance scripts would work with a Macbook as well.

The code is in the archive: list-benchmark-experiments.tar.gz

Download and unpack teh archive:

$ tar -xzf list-benchmark-experiments.tar.gz

## Blazegraph:

### Preparation
Install Blazegraph. Download from:

https://sourceforge.net/projects/bigdata/files/bigdata/2.1.5/blazegraph.jar/download

See instructions at: https://www.blazegraph.com/download/

$ java -server -Xmx12g -jar blazegraph.jar > blazegraph.log 2>&1 &

The experiments assume a SPARQL endpoint is running at:
http://localhost:9999/blazegraph/namespace/kb/sparql

### Load Data
This should be done with blazegraph NOT running.

Move in the list-benchmark-experiments/experiments/ folder

$ cd list-benchmark-experiments/experiments/
$ ./blazegraph-setup.sh </path/to/blazegraph/home> 500k 1k 2k 3k 5k 10k

"/path/to/blazegraph/home" is the folder where blazegraph.jar and the blazegraph.jnl are placed. 
This will load the data included in list-benchmark-experiments/data/ into Blazegraph.
A log of the operation is recorded in the blazegraph folder: ~/blazegraph-setup-load.log

### Run experiments

Start Blazegraph (from the blazegraph directory):
$ java -server -Xmx12g -jar blazegraph.jar > blazegraph.log 2>&1 &

Write down the related PID (ex. 22356).

$ cd list-benchmark-experiments/experiments/
$ ./blazegraph-run.sh 22356 500k

This will execute tests on the 500k suite of datasets and write the output files for each one to the folder "list-benchmark-experiments/experiments/results/"

## Virtuoso:

### Preparation

Download and install Virtuoso Open Source 7
http://vos.openlinksw.com/owiki/wiki/VOS/VOSDownload

Setup Virtuoso for using 12G of memory. In virtuoso.ini:

;; 12G
NumberOfBuffers          = 1020000
MaxDirtyBuffers          = 750000

Also, include the benchmark data folder with the DirsAllowed directive:

DirsAllowed              = ., /full-path-to/virtuoso/virtuoso-opensource/vad, /full-path-to/list-benchmark-experiments/data

Run Virtuoso:
$ cd /full-path-to-virtuoso-db/
$ /full-path-to/virtuoso/virtuoso-opensource/bin/virtuoso-t

The scripts assume Virtuoso 7 with default credentials running at: http://localhost:8890

To load the data:

$ cd list-benchmark-experiments/experiments/
$ ./virtuoso-setup.sh  500k 1k 2k 3k 5k 10k

### Run experiments
The scripts assume Virtuoso 7 running at: http://localhost:8890
Obtain the Virtuoso PID, for example from:

$ ps -eaf|grep virtuoso-t

and run the experiments:

$ cd list-benchmark-experiments/experiments/
$ ./virtuoso-run.sh <PID>  500k

This will execute tests and write the output files for each one to the folder "list-benchmark-experiments/experiments/results/"

## Fuseki (TDB and In-Memory)

### Preparation

The experiments assume a SPARQL endpoint backed by either a Fuseki TDB or In Memory instance, running at:

http://localhost:3030/ds/sparql

$ cd list-benchmark-experiments/experiments/
$ ./fuseki-setup.sh  500k 1k 2k 3k 5k 10k

and run the experiments:

$ ./fuseki-run.sh <PID>  500k


# COLLECT THE RESULTS

$ python2 collect-results.py reviewer1

this will generate the file results-reviewer1.csv that includes statistics of all experiments in folder 'results', particularly:

ENGINE: database (e.g blazegraph)
SIZE: dataset size (e.g. 120k)
MODEL: list model (e.g. list)
PREFIX: prefix of the related files in the result folder (e.g. blazegraph-500k-list.list*)
QUERY: use case query (1 for CQ1, 2 for CQ2, and 3 for CQ3)
BROKEN: number of failed queries (usually 0.00, 10.0 if all failed)
TIME_AVG: average response time in milliseconds
TIME_STD: response time standard deviation in millisecond
CPU_MAX_AVG: max CPU consumption average
CPU_MAX_STD: max CPU consumption standard deviation
CPU_AVG_AVG: average CPU consumption - average
CPU_AVG_STD: average CPU consumption - standard deviation
RSS_MAX_AVG: max RSS average
RSS_MAX_STD: max RSS, standard deviation
RSS_AVG_AVG: average RSS - average
RSS_AVG_STD: average RSS - standard deviation



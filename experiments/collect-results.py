#!/usr/bin/python

import sys
import os.path
import glob
import re
from datetime import datetime
from statistics import mean
from statistics import pstdev
###################
def timeToMs(t):
    # print t
    ms = '-1'
    try:
        minutes = t.split("m")[0]
        seconds = t.split("m")[1].split('.')[0]
        milliseconds = t.split("m")[1].split('.')[1].replace('s','')
        ms = (int(minutes) * 60 * 1000) + (int(seconds) * 1000) + int(milliseconds)
    except IndexError as err:
        print '[ERROR] ' + str(err)
        ms = -1
    return ms
    
def makeTimeStats(collection):
    # Duration of each execution
    print 'Collecting time stats for collection:' + collection[0]
    fileOb = open("suite/" + collection[1][2] + ".txt","r")
    experiments = fileOb.read().splitlines()
    eprefix = collection[0] + '.' + collection[1][2] 
    i = 1
    while i <= len(experiments):
        print "Experiment", str(i), ":", experiments[i-1]
        statFile = "results/" + eprefix + ".stats." + str(i) + ".csv"
        try:
            os.remove(statFile)
        except OSError:
            pass
        print "Experiment time stats", statFile
        x = 1
        while True:
            errorFile = "results/" + eprefix + ".error." + str(i) + "." + str(x)
            if(os.path.exists(errorFile)):
                print "Execution", errorFile
                with open(statFile, 'a') as the_file:
                    timeInfo = os.popen("tail -3 " + errorFile).readlines()
                    try:
                        timeInfo = "".join(timeInfo).split("\n")
                        timeInfo = "\t".join(timeInfo).split("\t")
                        # print timeInfo
                        ms1 = timeToMs(timeInfo[1])
                        ms2 = timeToMs(timeInfo[3])
                        ms3 = timeToMs(timeInfo[5])
                        timeInfo = [str(ms1),str(ms2),str(ms3)]
                        line = str(x) + "," + ",".join(timeInfo)
                        #print line
                    except IndexError as err:
                        line = str(x) +',E,E,E'
                    the_file.write(line + "\n")
            else:
                break;
            x += 1
        i += 1
    
        
def makeStats(collection):
    # Duration of each execution
    print 'Collecting stats for collection:' + collection[0]
    fileOb = open("suite/" + collection[1][2] + ".txt","r")
    experiments = fileOb.read().splitlines()
    eprefix = collection[0] + '.' + collection[1][2] 
    i = 1
    results = []
    while i <= len(experiments):
        print "Experiment", str(i), ":", experiments[i-1]
        timeStatFile = "results/" + eprefix + ".stats." + str(i) + ".csv"
        print "Time stats file", timeStatFile
        try:
            trows = open(timeStatFile,"r")
            rt_seq=[]
            for trow in trows:
                rt=int(trow.split(',')[1])
                rt_seq.append(rt)
            rt_mean = mean(rt_seq)
            rt_pstdev = pstdev(rt_seq)
        except ValueError as err:
            print str(err)
            rt_mean = -1
            rt_pstdev = -1

        # Collect data from executions
        cpu_max = []
        cpu_avg = []
        rss_max = []
        rss_avg = []
        x = 1
        isOK = True
        while True:
            monitorFile = "results/" + eprefix + ".monitor." + str(i) + "." + str(x)
            if(os.path.exists(monitorFile)):
                outputFile = "results/" + eprefix + ".output." + str(i) + "." + str(x)
                print "Output file", outputFile
                print "Monitor file", monitorFile                                
                # Check Query returned some output
                output_as_string = open(outputFile, 'r').read()
                if '<binding' not in output_as_string:
                    # Experiment must return some output
                    print "[ERROR] Empty result set!"
                    isOK = False
                    break
                # Compute values for each execution
                mrows = open(monitorFile,"r")
                _cpu_max = -1
                _cpu_values = []
                _rss_max = -1
                _rss_values = []                
                for mrow in mrows:
                    if mrow.startswith('#'):
                        continue
                    mrow_ = mrow.strip()
                    mrow_ = re.split(" +",mrow_)
                    # pid,%cpu,%mem,vsz,rss
                    _cpu_val = float(mrow_[1])
                    _cpu_values.append(_cpu_val)
                    if _cpu_val > _cpu_max:
                        _cpu_max = _cpu_val
                    _rss_val = float(mrow_[4])
                    _rss_values.append(_rss_val)
                    if _rss_val > _rss_max:
                        _rss_max = _rss_val
                    # print mrow_
                cpu_max.append(_cpu_max)
                cpu_avg.append(mean(_cpu_values))
                rss_max.append(_rss_max)
                rss_avg.append(mean(_rss_values))
            else:
                break;
            x += 1
        if isOK :
            results.append([collection[1][0],collection[1][1],collection[1][2], eprefix, str(i), str(isOK), rt_mean, rt_pstdev, mean(cpu_max),pstdev(cpu_max),mean(cpu_avg),pstdev(cpu_avg),mean(rss_max),pstdev(rss_max),mean(rss_avg),pstdev(rss_avg)])
        else:
            results.append([collection[1][0],collection[1][1],collection[1][2], eprefix, str(i), str(isOK),'0','0','0','0','0','0','0','0','0','0'])
        i += 1
        # Move to next query
    return results
####################

#eprefix = sys.argv[1]
#print 'eprefix:', eprefix
print 'Argument List:', str(sys.argv)
# fileOb = open(eprefix,"r")
# experiments = fileOb.read().splitlines()
if len(sys.argv) < 2:
    print "provide results- postfix file name."
    exit(1)
resultsFile = "results-"+sys.argv[1]+".csv"
try:
    os.remove(resultsFile)
except OSError:
    pass

# LIST OF EXPERIMENTS (BACKEND+MODEL+SUITE) BEING EXECUTED
fnames = glob.glob("results/*.output.*") 
collectionIds = [re.sub(r'results/([^\.]+)\..*', r'\1', x) for x in fnames]
collectionIds = set(collectionIds)
# print experimentIds
collections = tuple((element, element.split('-')) for element in collectionIds)
for collection in collections:
    makeTimeStats(collection)

with open(resultsFile, 'a') as res_file:
    headers = ['ENGINE','SIZE','MODEL','PREFIX','QUERY','RESULTS','TIME_AVG','TIME_STD','CPU_MAX_AVG','CPU_MAX_STD','CPU_AVG_AVG','CPU_AVG_STD','RSS_MAX_AVG','RSS_MAX_STD','RSS_AVG_AVG','RSS_AVG_STD']
    line = ",".join(str(x) for x in headers)
    res_file.write(line + "\n")
    for collection in collections:
        rows = makeStats(collection)
        for row in rows:
            line = ",".join(str(x) for x in row)
            res_file.write(line + "\n")

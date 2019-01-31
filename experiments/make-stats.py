#!/usr/bin/python

import sys
import os.path
import glob
import re
from datetime import datetime
###################
def timeToMs(t):
    print t
    try:
        minutes = t.split("m")[0]
        seconds = t.split("m")[1].split('.')[0]
        milliseconds = t.split("m")[1].split('.')[1].replace('s','')
    except OSError:
        print t
        exit(1)
    print '- milliseconds ' + milliseconds + ' ' + str(int(milliseconds))
    print '- seconds ' + seconds + ' ' + str(int(seconds))
    print '- minutes ' + minutes + ' ' + str(int(minutes))
    ms = (minutes * 60 * 1000) + (seconds * 1000) + milliseconds
    return ms
    
def makeTimeStats(experiment):
    # Duration of each execution
    repetitions = glob.glob('suite/' + experiment[0] + ".*.output.1")
    print 'Building stats for:' + experiment[0]
    fileOb = open("suite/" + experiment[1][2] + ".txt","r")
    experiments = fileOb.read().splitlines()
    eprefix = experiment[0] + '.' + experiment[1][2] 
    i = 1
    while i <= len(experiments):
        print "Experiment ", str(i), ": ", experiments[i-1]
        statFile = "results/" + eprefix + ".stats." + str(i) + ".csv"
        try:
            os.remove(statFile)
        except OSError:
            pass
        print "Writing to ", statFile
        x = 1
        experiment = experiments[i-1]
        while True:
            outputFile = "results/" + eprefix + ".error." + str(i) + "." + str(x)
            print "Reading from ", outputFile
            if(os.path.exists(outputFile)):
                with open(statFile, 'a') as the_file:
                    timeInfo = os.popen("tail -3 " + outputFile).readlines()
                    timeInfo = "".join(timeInfo).split("\n")
                    timeInfo = "\t".join(timeInfo).split("\t")
                    timeToMs(timeInfo[1])
                    timeInfo = [timeInfo[1], timeInfo[3], timeInfo[5]]
                    line = str(x) + "," + ",".join(timeInfo)
                    #print line
                    the_file.write(line + "\n")
            else:
                break;
            x += 1
        i += 1

####################

#eprefix = sys.argv[1]
#print 'eprefix:', eprefix
print 'Argument List:', str(sys.argv)
print "TODO!"
# fileOb = open(eprefix,"r")
# experiments = fileOb.read().splitlines()
fnames = glob.glob("results/*.output.*") 

experimentIds = [re.sub(r'results/([^\.]+)\..*', r'\1', x) for x in fnames]

# print experimentIds

experiments = tuple((element, element.split('-')) for element in experimentIds)
for experiment in experiments:
    makeTimeStats(experiment)


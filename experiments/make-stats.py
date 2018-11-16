#!/usr/bin/python

import sys
import os.path

suite = sys.argv[1]
print 'Suite:', suite
print 'Argument List:', str(sys.argv)

fileOb = open(suite,"r")
experiments = fileOb.read().splitlines()

# Duration of each execution
i = 1
while i <= len(experiments):
    print "Experiment ", str(i), ": ", experiments[i-1]
    statFile = "results/" + suite + ".stats." + str(i) + ".csv"
    try:
        os.remove(statFile)
    except OSError:
        pass
    print "Writing to", statFile
    x = 1
    experiment = experiments[i-1]
    while True:
        outputFile = "results/" + suite + ".output." + str(i) + "." + str(x)
        if(os.path.exists(outputFile)):
            with open(statFile, 'a') as the_file:
                timeInfo = os.popen("tail -3 " + outputFile).readlines()
                timeInfo = "".join(timeInfo).split("\n")
                timeInfo = "\t".join(timeInfo).split("\t")
                timeInfo = [timeInfo[1], timeInfo[3], timeInfo[5]]
                line = str(x) + "," + ",".join(timeInfo)
                print line
                the_file.write(line + "\n")
        else:
            break;
        x += 1
    i += 1

#!/usr/bin/env python

import sys
import os
import mido
from mido import MidiFile
import hashlib

# print("Processing {}".format(sys.argv[1]))

for root, dirs, files in os.walk(sys.argv[1], topdown=False):
   for name in files:
       filename = os.path.join(root, name)
       md5_id = hashlib.md5(open(filename, 'rb').read()).hexdigest()
       uri = "http://purl.org/midi-ld/pattern/" + str(md5_id)
       # print("File: {}".format(filename))
       try:
           mid = MidiFile(filename)
           # print("Tracks: {}".format(len(mid.tracks)))
           for i,tr in enumerate(mid.tracks):
               print("{} {} {}".format(len(tr), i, uri))
       except:
           continue

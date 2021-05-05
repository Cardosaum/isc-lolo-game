#!/usr/bin/env python

with open('map') as f:
    c = f.read()

for line in c.splitlines():
    line = line.strip()
    #print(line)
    for i in range(16):
        a = ''.join([x.strip()*16 for x in line.split(',') if x])
        print(','.join([x for x in a]))

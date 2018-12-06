#!/usr/bin/env python
import fileinput
import re
Lookup = {}
for line in fileinput.input(['/Users/lyn/Final_Project/Step3. Data analysis/namelist.txt']):
   # patient = re.findall('(\w..*)', line)
   # if patient:
     
       #print patient[0]
#for line in patient[0]:
   # print line
    line = re.sub(r"-", '', line)
    line = re.sub(r"\s+", '_',line)
    if line:
       print line[0]

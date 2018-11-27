#!/usr/bin/env python

import fileinput
import re
import json

Lookup_geneID={}

for line in fileinput.input(['/Users/lyn/Final_Project/Step2.Looking up Gene name in Homo Sapiens file/Homo_sapiens.GRCh37.75 (1).gtf']):
    gene_name_matches = re.findall('gene_name \"(.*?)\";',line)
   #print line#
    gene_id_matches = re.findall('gene_id \"(.*?)\";',line)
    text_in_columns = re.split('\t',line)
    if len(text_in_columns) >3:
       if text_in_columns[2] == "gene":
          #print text_in_columns[2]#
          if gene_name_matches:
            # print gene_name_matches#
             if gene_id_matches:
              # print gene_id_matches[0] + ' ' + gene_name_matches[0]
               Lookup_geneID[gene_id_matches[0]] = gene_name_matches[0]
# The second part to check the geneID in my txt file #
for line in fileinput.input(['/Users/lyn/Final_Project/significantgenes_id.txt']):
    text_in_columns = re.findall('(^..*)',line)
    if text_in_columns[0] in Lookup_geneID:
       #text_in_columns[4]=re.sub('\n','',text_in_columns[4].rstrip());
        print text_in_columns[0] + ' ' + Lookup_geneID[text_in_columns[0]]

#!/usr/bin/env python
# coding: utf-8

# In[22]:


# Labels for reading JSON file
id_label = '"id":'
seq_label = '"sequence":'
topology_label = '"labels":'

# Counters for topology labels:
S = 0
P = 0
B = 0
O = 0
I = 0
M = 0

# Find distribution of topology labels
infile = open('../DeepTMHMM.partitions.json', 'r')
for line in infile:
    line = line.split()
    if line[0] == topology_label:
        for lab in line[1]:
            if lab == 'S':
                S += 1
            elif lab == 'P':
                P += 1
            elif lab == 'B':
                B += 1
            elif lab == 'O':
                O += 1
            elif lab == 'I':
                I += 1
            elif lab == 'M':
                M += 1
            elif lab =='"':
                pass
            else: 
                print('Error: unknown label found')
infile.close()

tot = S + P + B + O + I + M

print('Distribution of topology classes')
print('S:', S, '(', S/tot*100, '%)')
print('P:', P, '(', P/tot*100, '%)')
print('B:', B, '(', B/tot*100, '%)')
print('O:', O, '(', O/tot*100, '%)')
print('I:', I, '(', I/tot*100, '%)')
print('M:', M, '(', M/tot*100, '%)')


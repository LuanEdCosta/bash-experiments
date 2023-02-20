#!/bin/bash

wc -lwcmL $1 | awk '{print "Number of Lines: " $1 "\nNumber of Words: " $2 "\nSize in Bytes: " $3 "\nNumber of Chars: " $4 "\nLongest Line Length: " $5}'

#!/bin/bash

IN="raw"
OUT="unzip"

mkdir -p $OUT

cat raw_list.txt | sed 's/\.gz$//' | awk '{printf "mkdir -p %s/%s; gunzip -c %s/%s/%s.gz > %s/%s/%s\n", "'$OUT'", $1, "'$IN'", $1, $2, "'$OUT'", $1, $2}' | parallel -j 15

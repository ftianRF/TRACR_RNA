#!/bin/bash

IN="raw"

ls $IN | awk '{printf "cd %s/%s; echo -ne \"%s\t\"; ls | wc -l; md5sum --ignore-missing --quiet -c md5checksums.txt\n", "'$IN'", $1, $1}' | parallel -j 4

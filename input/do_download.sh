#!/bin/bash

IN="."
OUT="raw"

mkdir -p $OUT

function do_url {
# obtain url
cat assembly_list.txt | tail -n +2 | cut -f 2,21 | while read acc file_path
do
	code=$(echo $file_path | sed 's#.*/##')
	for suffix in genomic.fna.gz genomic.gtf.gz cds_from_genomic.fna.gz protein.faa.gz
	do
		url="$file_path/${code}_${suffix}"
		echo -e "$acc\t$url\tY"
	done
	url="$file_path/md5checksums.txt"
	echo -e "$acc\t$url\tY"
done > url.txt
}

function xxx {
comm -23 ../assembly_list.txt <(cut -f 1 $summ_file | sort) | while read acc
do
	file_path=$(esearch -db assembly -query $acc </dev/null | esummary | xtract -pattern DocumentSummary -element FtpPath_GenBank)
	code=$(echo $file_path | sed 's#.*/##')
	url="$file_path/${code}_genomic.fna.gz"
	echo -e "$acc\t$url\tN"
done >> url.txt
}

# download genomes
cut -f 1,2 url_sel.txt | awk '{printf "mkdir -p %s/%s; echo %s; wget -c -P %s/%s %s\n", "'$OUT'", $1, $2, "'$OUT'", $1, $2}' | parallel -j 15

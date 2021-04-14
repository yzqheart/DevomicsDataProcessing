#!/bin/bash
index=/home/yanzhiqiang/DB/Mus_musculus/UCSC/mm10/Sequence/bismarkIndex

outdir=$1
fq1=$2
fq2=$3

bismark --bowtie2 -p 2  -quiet --non_directional --temp_dir $outdir -o $outdir $index $fq1
bismark --bowtie2 -p 2  -quiet --non_directional --temp_dir $outdir -o $outdir $index $fq2
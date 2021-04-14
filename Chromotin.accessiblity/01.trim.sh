#!/bin/bash

outdir=$1
fq1=$2
fq2=$3


trim_galore --fastqc --paired --quality 20 --phred33 --stringency 3 --gzip --length 36  --output_dir $outdir $fq1 $fq2



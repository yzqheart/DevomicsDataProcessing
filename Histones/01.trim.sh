#!/bin/bash

outdir=$1
fq1=$2
fq2=$3

# pair-end
trim_galore --paired --fastqc --quality 20 --phred33 --stringency 3 --gzip --length 36  --output_dir $outdir $fq1 $fq2

# single-end
trim_galore --fastqc --quality 20 --phred33 --stringency 3 --gzip --length 36  --output_dir $outdir $fq1
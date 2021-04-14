#!/bin/bash

outdir=$1
fq=$2

trim_galore --fastqc --clip_R1 11 --quality 20 --phred33 --stringency 3 --gzip --length 30  --output_dir $outdir  $fq
#!/bin/bash
rRNABed=/home/yanzhiqiang/DB/Mus_musculus/UCSC/mm10/Sequence/bed/mm10_rRNA.bed.for.RSeQC

outdir=$1
sample=$2
bam=$3

split_bam.py -i $bam -r $rRNABed -o $outdir/${sample}_split_bam

samtools index $outdir/${sample}_split_bam.ex.bam
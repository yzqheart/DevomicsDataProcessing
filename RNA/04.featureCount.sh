#!/bin/bash
gtf=/home/yanzhiqiang/DB/Mus_musculus/UCSC/mm10/Annotation/Genes/genes.gtf

outdir=$1
sample=$2
bam=$3

featureCounts -p -t exon -g gene_id -a $gtf -o ${outdir}/${sample}/${sample}.counts.txt $bam
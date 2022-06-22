bam=$1


#histon
bamCoverage --bam $bam -o ${bam}.bw \
    --binSize 10 \
    --normalizeUsing RPKM \
    --extendReads 250

#RNA
bamCoverage --bam $bam -o ${bam}.bw \
    --binSize 10 \
    --normalizeUsing RPKM

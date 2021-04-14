PICARD="java -Xmx4g -jar /home/yanzhiqiang/software/picard-tools-1.141/picard.jar"

sampledir=$1
sample=$2

bam1=$3
bam2=$4

samtools sort -o ${bam1}.sort.bam $bam1 
samtools sort -o ${bam2}.sort.bam $bam2


samtools index ${bam1}.sort.bam
samtools index ${bam2}.sort.bam

samtools merge ${sampledir}/${sample}.merged.bam ${bam1}.sort.bam ${bam2}.sort.bam
samtools index ${sampledir}/${sample}.merged.bam


$PICARD MarkDuplicates I=${sampledir}/${sample}.merged.bam O=${sampledir}/${sample}.rmdup.bam M=${sampledir}/${sample}.rmdup.txt REMOVE_DUPLICATES=true 2> ${sampledir}/${sample}.picard.log

samtools index ${sampledir}/${sample}.rmdup.bam
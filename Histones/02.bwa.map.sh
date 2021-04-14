fq1=$1
fq2=$2
outdir=$3
sample=$4

mkdir -p ${outdir}/${sample}

PICARD="java -Xmx120g -jar /mnt/data/yanzhiqiang/142/software/picard-tools-1.141/picard.jar"
index=/mnt/data/yanzhiqiang/138/DB/Mus_musculus/UCSC/mm10/Sequence/BWAIndex/genome.fa

ID=$sample
PL=ILLUMINA
LB=$sample
SM=$sample
rg="@RG\tID:$ID\tPL:$PL\tLB:$LB\tSM:$SM"

bwa mem -v 1 -R $rg -M -t 8 $index $fq1 $fq2 > ${outdir}/${sample}/${sample}.sam

samtools view -h -b -q 30 ${outdir}/${sample}/${sample}.sam > ${outdir}/${sample}/${sample}.uniq.bam
samtools sort -o ${outdir}/${sample}/${sample}.uniq.sort.bam ${outdir}/${sample}/${sample}.uniq.bam
samtools index ${outdir}/${sample}/${sample}.uniq.sort.bam

$PICARD MarkDuplicates I=${outdir}/${sample}/${sample}.uniq.sort.bam O=${outdir}/${sample}/${sample}.rmdup.bam M=${outdir}/${sample}/${sample}.rmdup.txt REMOVE_DUPLICATES=true 2> ${outdir}/${sample}/${sample}.picard.log
samtools index ${outdir}/${sample}/${sample}.rmdup.bam
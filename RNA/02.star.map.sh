index=/mnt/data/yanzhiqiang/138/DB/Mus_musculus/UCSC/mm10/Sequence/StarIndex

fq1=$1
fq2=$2
out=$3


STAR --runThreadN 4 --genomeDir $index --outSAMtype BAM SortedByCoordinate --readFilesCommand zcat --readFilesIn $fq1 $fq2 --outFileNamePrefix $out

samtools view -bq 30 ${out}Aligned.sortedByCoord.out.bam >${out}Aligned.sortedByCoord.out.uniq.bam
samtools index ${out}Aligned.sortedByCoord.out.uniq.bam
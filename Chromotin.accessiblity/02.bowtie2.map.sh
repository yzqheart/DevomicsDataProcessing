index=/mnt/data/yanzhiqiang/138/DB/Mus_musculus/UCSC/mm10/Sequence/Bowtie2Index/genome

fq1=$1
fq2=$2

out=$3

bowtie2 -t -q -N 1 -L 25 -X 2000 -p 2 --no-mixed --no-discordant -x $index -1 $fq1 -2 $fq2 -S $out

$samtools view -h -b -q 30 $out >${out}.uniq.bam
$samtools sort -o ${out}.uniq.sort.bam ${out}.uniq.bam
$samtools index ${out}.uniq.sort.bam
$samtools rmdup -s ${out}.uniq.sort.bam ${out}.rmdup.bam
$samtools index ${out}.rmdup.bam
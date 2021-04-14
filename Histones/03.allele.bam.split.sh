sname=$1 #out name
bam=$2
chrom=$3

exontagSNPbed=mouse.H3K4me3.XieWei.snp.origin.bed.chr${chrom}

awk '{print $1"\t"$2"\t"$2+1}' $exontagSNPbed | samtools view -b -q 10 -L - $bam > $sname.$chrom.SNP.unique.bam 

samtools index $sname.$chrom.SNP.unique.bam

cut -f1,2 $exontagSNPbed | samtools mpileup -O -Q 0 -l - $sname.$chrom.SNP.unique.bam  > $sname.$chrom.pileup

perl Extract_AlleleSupportReads_from_SEbam_20170315.pl $sname.$chrom $exontagSNPbed $sname.$chrom.SNP.unique.bam  $sname.$chrom.pileup

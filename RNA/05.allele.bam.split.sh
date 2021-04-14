sname=$1 #out name 
bam=$2
chrom=$3

exontagSNPbed=/mnt/data/yanzhiqiang/138/DB/Mus_musculus/UCSC/mm10/Strain.mgp/mouse.2020nc.rna.and.met.snp.origin/mouse.2020nc.rna.and.met.snp.origin.bed.chr${chrom}

awk '{print $1"\t"$2"\t"$2+1}' $exontagSNPbed | samtools view -b -q 10 -L - $bam > $sname.$chrom.SNP.unique.bam #generate bam file contains reads unique and cover SNP. less than 5min. got 5565261 reads

samtools index $sname.$chrom.SNP.unique.bam

cut -f1,2 $exontagSNPbed | samtools mpileup -O -Q 0 -l - $sname.$chrom.SNP.unique.bam  > $sname.$chrom.pileup                    #143646 SNPs

perl Extract_AlleleSupportReads_from_SEbam_20170315.pl $sname.$chrom $exontagSNPbed $sname.$chrom.SNP.unique.bam  $sname.$chrom.pileup

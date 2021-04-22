sample=$1

bash juicer/scripts/juicer.sh \
-z juicer/references/hg38.genome.fa \
-p juicer/restriction_sites/hg38.chrom.sizes \
-y juicer/restriction_sites/hg38_MboI.txt \
-s  MboI \
-t  80 \
-d /home/yanzhiqiang/project/human.hic.liujiang/rawdata.stage.merge/$sample \
-D /home/yanzhiqiang/software/juicer
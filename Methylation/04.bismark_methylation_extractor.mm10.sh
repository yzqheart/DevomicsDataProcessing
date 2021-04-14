genome_folder=/home/yanzhiqiang/DB/Mus_musculus/UCSC/mm10/Sequence/bismarkIndex

bam=$1
outdir=$2

bismark_methylation_extractor -s --multicore 4 --gzip --cytosine_report --CX --genome_folder $genome_folder -o $outdir $bam
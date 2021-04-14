#!/usr/bin/bash

ref=/home/yanzhiqiang/DB/Mus_musculus/UCSC/mm10/Sequence/bismarkIndex/genome.fa

cxfile=$1

perl make.triBase.context.pl $ref $cxfile > ${cxfile}.tri.context
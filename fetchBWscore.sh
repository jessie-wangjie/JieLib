for j in /home/wangj2/scratch/bw_from_Anshul/*.bw
do

i=$(basename $j .bw)

echo """#!/bin/sh 
	
#$ -V
#$ -cwd
#$ -pe single 4
#$ -o \$HOME/sge_jobs_output/sge_job.\$JOB_ID.out -j y
#$ -S /bin/bash

mkdir \$HOME/scratch/jobid_\$JOB_ID
cd \$HOME/scratch/jobid_\$JOB_ID/

cp \$HOME/anearline/encode_round6/Gencodev3c_hg19_TSS.bed \$HOME/scratch/jobid_\$JOB_ID/

fetchBWscore.pl ../bw_from_Anshul/$i.bw Gencodev3c_hg19_TSS.bed 2000 20 > Gencodev3c_hg19_TSS.$i.bw2k.step20

cp -rf \$HOME/scratch/jobid_\$JOB_ID/*.step20 \$HOME/anearline/encode_round6/
rm $i*""" > fetchBWscore.$i.sge

qsub fetchBWscore.$i.sge
sleep 5

done

#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=sort_trimmed_bam      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=10    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load samtools

for f in $(ls *.trimmed.bam | sed 's/.trimmed.bam//' | sort -u)
do
samtools sort ${f}.trimmed.bam -@ 30 > ${f}.trimmed.sorted.bam 
done

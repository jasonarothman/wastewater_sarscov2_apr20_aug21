#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=picard_remove_duplicates      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=30    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load picard-tools/2.24.1

for f in $(ls *.trimmed.sorted.bam | sed 's/.trimmed.sorted.bam//' | sort -u); do picard MarkDuplicates I=${f}.trimmed.sorted.bam M=${f}.trimmed.sorted.bam.markdup_metrics.txt O=${f}.trimmed.sorted.nodup.bam REMOVE_DUPLICATES=true; done
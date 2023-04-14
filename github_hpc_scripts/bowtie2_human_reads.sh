#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=bowtie2_human      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=15    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load bowtie2

for f in $(ls *_READ1.dedupe.fastq.gz | sed 's/_READ1.dedupe.fastq.gz//' | sort -u)
do
bowtie2 -x /dfs5/bio/rothmanj/databases/hg19 -1 ${f}_READ1.dedupe.fastq.gz -2 ${f}_READ2.dedupe.fastq.gz -p 15 -S ${f}_human_reads.sam --no-unal
done
#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=bowtie2_sarscov2      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=30    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load bowtie2

for f in $(ls *_READ1.clean.fastq.gz | sed 's/_READ1.clean.fastq.gz//' | sort -u)
do
bowtie2 -x /dfs5/bio/rothmanj/databases/sars_cov2_bowtie_db -1 ${f}_READ1.clean.fastq.gz -2 ${f}_READ2.clean.fastq.gz -p 30 -S ${f}_sars_cov_2_only.sam --no-unal
done
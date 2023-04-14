#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=ivar_trim_sarscov2      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=1    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load anaconda/2020.07

eval "$(conda shell.bash hook)"

conda activate /data/homezvol0/rothmanj/.conda/envs/ivar

module load samtools

for f in $(ls *.sorted.nodup.bam | sed 's/.sorted.nodup.bam//' | sort -u)
do
ivar trim -i ${f}.sorted.nodup.bam -b /dfs5/bio/rothmanj/databases/QIAseq_SARS-CoV-2_Primer_Panel_2_2.bed -p ${f}_ivar.trimmed -e
done
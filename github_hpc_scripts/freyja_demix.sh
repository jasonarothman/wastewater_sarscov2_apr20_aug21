#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=freyja_sarscov2      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=1    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file

module load anaconda/2020.07

eval "$(conda shell.bash hook)"

conda activate /data/homezvol0/rothmanj/.conda/envs/freyja

module load samtools

for f in $(ls *.trimmed.sorted.bam | sed 's/.trimmed.sorted.bam//' | sort -u); do freyja demix ${f}_freyja_variants.tsv ${f}_freyja_depth --output ${f}_freyja_demix.tsv ; done
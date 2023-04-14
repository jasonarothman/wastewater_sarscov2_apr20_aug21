#!/bin/bash
#--------------------------SBATCH settings------

#SBATCH --job-name=kraken_run      ## job name
#SBATCH -A katrine_lab     ## account to charge
#SBATCH -p standard          ## partition/queue name
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=30    ## number of cores the job needs
#SBATCH --error=slurm-%J.err ## error log file
#SBATCH --output=slurm-%J.out ##output info file


module load anaconda/2020.07

eval "$(conda shell.bash hook)"

conda activate /data/homezvol0/rothmanj/.conda/envs/conda_software

for f in $(ls *.nohuman.fastq.1.gz | sed 's/.nohuman.fastq.1.gz//' | sort -u)
do
kraken2 --db /dfs5/bio/rothmanj/databases/kraken_db_complete --gzip-compressed -t 30 -P --report ${f}.nohuman.report --output ${f}.nohuman.kraken --use-names --report-zero-counts ${f}.nohuman.fastq.1.gz ${f}.nohuman.fastq.2.gz
done
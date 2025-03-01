#!/usr/bin/env bash
#SBATCH -A NAISS2024-5-450 -p alvis # Give our project credentials
#SBATCH -N 1  # We're launching a single node
#SBATCH -t 0-8:00:00 
#SBATCH -C NOGPU # <-- this gives alvis-cpu1
#SBATCH --cpus-per-task=31
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jameshbailie@gmail.com

rm -r /usr/share/lmod/

cd /mimer/NOBACKUP/groups/globalpoverty1/bailie/rawOutputFromHansPackage28Feb25
export LC_ALL=C.UTF-8

apptainer exec /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalDHSHarmonisationApptainer.sif R --version
#apptainer exec /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalDHSHarmonisationApptainer.sif Rscript /cephyr/users/bailie/Alvis/git/DHS-harmonisation/minimalAlvisRun.R

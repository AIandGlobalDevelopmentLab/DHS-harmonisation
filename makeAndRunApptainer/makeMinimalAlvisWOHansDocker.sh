#!/usr/bin/env bash
#SBATCH -A NAISS2024-5-450 -p alvis # Give our project credentials
#SBATCH -N 1  # We're launching a single node
#SBATCH -t 0-8:00:00 
#SBATCH -C NOGPU # <-- this gives alvis-cpu1
#SBATCH --cpus-per-task=31
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jameshbailie@gmail.com

cd /cephyr/users/bailie/Alvis/git/DHS-harmonisation/makeAndRunApptainer
export LC_ALL=C.UTF-8
apptainer build --fakeroot --force /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalAlvisWOHansDocker.sif minimalAlvisWOHansDocker.def

#!/usr/bin/env bash
#SBATCH -A NAISS2024-5-450 -p alvis # Give our project credentials
#SBATCH -N 1  # We're launching a single node
#SBATCH -t 0-5:00:00 # We're allocating the resources for 3 hours
#SBATCH -C NOGPU # <-- this gives alvis-cpu1
#SBATCH --cpus-per-task=31

cd "/cephyr/users/bailie/Alvis/git/DHS-harmonisation/makeApptainerTesting(Old)"
export LC_ALL=C.UTF-8
apptainer exec /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalAlvisDocker.sif Rscript -e "library(knitr); knit('/cephyr/users/bailie/Alvis/git/DHS-harmonisation/makeApptainerTesting(Old)/test.Rnw')"
#apptainer shell --fakeroot --writable-tmpfs /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalAlvisDocker.sif
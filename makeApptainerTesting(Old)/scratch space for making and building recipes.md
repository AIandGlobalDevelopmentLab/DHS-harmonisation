apptainer build --fakeroot /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalTestV5.sif V5.def

apptainer shell --fakeroot --writable-tmpfs /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalTestV5.sif
apptainer shell --fakeroot --writable-tmpfs /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalTestV6.sif

apptainer build --fakeroot /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalTestV6.sif V6.def %> logV6.log

apptainer build --fakeroot /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalTestV7.sif V7.def





COMMANDS TO PUT IN RECIPES:


apt-get install -y libxml2-dev libfontconfig1-dev libssl-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev cmake libudunits2-dev netcdf-bin libnetcdf-dev libgdal-dev


sed -i 's|# options(repos.*$|options(repos = c(CRAN="https://cloud.r-project.org/"))|' /usr/lib/R/library/base/R/Rprofile

   R --slave -e 'library("devtools"); 

   install.packages(c("devtools", "magrittr", "readr", "lubridate", "purrr")); install_bitbucket(repo = "hansekbrand/iwi", ref = "99e59a070b914d392faef34bc9e22028b3df03e7", upgrade = "always"); 

   library("devtools")
   install_bitbucket(repo = "hansekbrand/DHSharmonisation", ref = "733e7c92127369f886608bd168840b9c6373768d", upgrade = "always")'



   Commands run:


sed -i 's|# options(repos.*$|options(repos = c(CRAN="https://cloud.r-project.org/"))|' /usr/lib/R/library/base/R/Rprofile
install.packages(c("devtools", "magrittr", "readr", "lubridate", "purrr"))


TO RUN:

apt-get install -y libxml2-dev

library("devtools")
install_bitbucket(repo = "hansekbrand/iwi", ref = "99e59a070b914d392faef34bc9e22028b3df03e7", upgrade = "always")
install_bitbucket(repo = "hansekbrand/DHSharmonisation", ref = "733e7c92127369f886608bd168840b9c6373768d", upgrade = "always")




COMMANDS FOR PUTTING IN A BATCH COMMAND:

#!/usr/bin/env bash
#SBATCH -A NAISS2024-5-450 -p alvis # Give our project credentials
#SBATCH -N 1  # We're launching a single node
#SBATCH -t 0-8:00:00 
#SBATCH -C NOGPU # <-- this gives alvis-cpu1
#SBATCH --cpus-per-task=31
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jameshbailie@gmail.com

cd /cephyr/users/bailie/Alvis/git/DHS-harmonisation/apptainerTesting
export LC_ALL=C.UTF-8
apptainer build --fakeroot /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalTestV6.sif V6.def
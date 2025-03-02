List of files:
- `makeMinimalAlvisDocker.sh`: slurm batch file for running `minimalAlvisDocker.def`
- `minimalAlvisDocker.def`: creates apptainer image `/mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalAlvisDocker.sif` which is a minimal environment for running Hans's packages iwi and [globallivingconditions](https://bitbucket.org/hansekbrand/dhsharmonisation/src/master/), and [James's repo DHS-harmonisation](https://github.com/AIandGlobalDevelopmentLab/DHS-harmonisation)
- `minimalAlvisRun.sh`: slurm batch file for running `minimalAlvisRun.R`
- `minimalAlvisRun.R`: runs James's DHS-harmonisation wrapper to download and harmonise the DHS data.
	- [More details are here](https://portal.c3se.chalmers.se/pun/sys/dashboard/files/fs//mimer/NOBACKUP/groups/globalpoverty1/bailie/rawOutputFromHansPackage28Feb25/README.md)
- `makeMinimalAlvisWOHansDocker.sh`: slurm batch file for running `minimalAlvisWOHansDocker.def`
- `minimalAlvisWOHansDocker.def`: creates an apptainer image which is exactly like `minimalAlvisDocker` except it does not install Hans's packages.
	- This apptainer is stored here: `/mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalAlvisWOHansDocker.sif`.
	- All of the dependencies of Hans's packages are installed.
	- What is the purpose of this apptainer? The idea is that we will want to remake the apptainers when Hans's packages are updated. It would be annoying to create a new apptainer from scratch every time we want to install an update to Hans's package. Instead, we can bootstrap off this image by using a recipe that starts with:
```
bootstrap: localimage
from: /mimer/NOBACKUP/groups/globalpoverty1/bailie/images/minimalAlvisWOHansDocker.sif
...
```
- `slurm-3710886.out`: this is the output of `sbatch makeMinimalAlvisDocker.sh`
- `slurm-3710885.out`: this is the output of `sbatch makeMinimalAlvisWOHansDocker.sh`






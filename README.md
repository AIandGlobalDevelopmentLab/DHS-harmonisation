This code collects and aggregates data from all DHS surveys (that the user has access to via [https://dhsprogram.com/data/](https://dhsprogram.com/data/)). It compiles all DHS surveys into a single dataset at the person-level. We call this dataset the *harmonised dataset*. This dataset contains the international wealth index (IWI) for each DHS household, along with survey design information and some other key DHS variables. This person-level dataset can be aggregated to produce cluster-level IWI estimates, which are used as the training/test labels for our satellite image prediction algorithms. 

This code is basically just a wrapper function for Hans's package [`globallivingconditions`](https://bitbucket.org/hansekbrand/dhsharmonisation/src/master/) which downloads and harmonises data from the DHS. There is also some draft code for bootstrapping to account for survey uncertainty.

The data which this package produces is documented in this repo: https://github.com/AIandGlobalDevelopmentLab/DHS-Data

### TODOs:

See [the repo's issues](https://github.com/AIandGlobalDevelopmentLab/DHS-harmonisation/issues/1).

### Set up:

#### Step 1: 

Make a new file (in the same folder as this README) `auth.R` which declares five variables:
1. `username` - the username of your DHS account
1. `pass` - your DHS password
1. `downloaded_DHS_data_file_path` - where you want your DHS raw data to be stored. `downloaded_DHS_data_file_path` is passed as the argument `directory` to the `download.and.harmonise` function.
1. `harmonised_DHS_data_file_path` - where you want your harmonised data to be stored, by default. (If the argument `cacheFolderPath` to `getDHSData` is `NULL`, then a new folder will automatically be created in `harmonised_DHS_data_file_path`. The cached and harmonised data of download.and.harmonize are stored in this folder. (This folder is the working directory in which download.and.harmonize is started.))
1. `repo_file_path` - the head directory of your Git repository (i.e. where all of the R code is stored).
And which sets your working directory to the folder `repo_file_path`. (Update: using a working directory is now depreciated in this project, since it is brittle. There is still some internal handling of working directories, since this is necessary for `download.and.harmonise` to run. But all of my code uses absolute file paths.)

##### Example 'auth.R' file:

	username <- "my_username"
	pass <- "a_password"
	
	downloaded_DHS_data_file_path <- "~/DHS_Data"
	harmonised_DHS_data_file_path <- "~/git/poverty-prediction/harmonised"
	repo_file_path <- "~/git/poverty-prediction"
	setwd(repo_file_path)


#### Step 2: 
Run the R script `auth.R`

Run the R script `set-up.R`. (You only need to do this once -- although it doesn't hurt to run it multiple times.) This downloads the QoG dataset and saves it in the appropriate folder.

#### Step 3
Follow the instructions in `main.R`. Alternatively -- for a completely automated solution, on an Alvis apptainer -- run `sbatch makeAndRunApptainer/minimalAlvisRun.sh`. For more details see [this readme](https://portal.c3se.chalmers.se/pun/sys/dashboard/files/fs//mimer/NOBACKUP/groups/globalpoverty1/bailie/rawOutputFromHansPackage28Feb25/README.md).

### Notes:
- Because of how the paralellisation is implemented, I think it is much faster to run this code in a non-interactive mode of R (i.e. off terminal, not in R Studio) and on a unix-like system (including OSX).
- You will need >16Gb of RAM (Hans estimates 40Gb) to run this code. (Assuming you are using the default settings -- `countries = NULL` and `waves = NULL` -- so that you are downloading all the DHS data.)
- Some files are largely irrelevant:
	- There are some debugging/validation files (`debugging.R`, `debugging_helpers.R` and `finding bugs for Hans.R`) which are very rough code, and were trying to debug Hans's globallivingconditions package, and validate the data outputted by this package.
	- The bootstrap files (`modified_boot_function.R`, `bootstrap_helpers.R` , `bootstrap_functions.R` and `bootstrap.R`) are draft code for implementing the idea of bootstrapping over clusters to account for uncertainty due to the DHS survey procedure.
	- `Pragya data.R` contains some code to answer a question Pragya had when we were discussing collaborating with her (in 2023-ish, from memory?)

#### Dataset variables:
- `country.code.ISO.3166.alpha.3` is the country code given by [this standard]{https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes). (This is different to the country codes used by the DHS.)


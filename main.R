debugSource(file.path(dirname(rstudioapi::getSourceEditorContext()$path), 
                      "auth.R"))
#debugSource("set-up.R") -- only run this once

library("devtools")
library("tidyverse")
`%<>%` <- magrittr::`%<>%`
library("lubridate")

library("boot")
library("tictoc") #Only needed for testing
library("stringi")

debugSource("helpers.R")
debugSource("global_vars.R")
debugSource("get_DHS_data_functions.R")
debugSource("bootstrap_functions.R")
debugSource("bootstrap_helpers.R")
debugSource("modified_boot_function.R")

#Now run "get_DHS_data.R" manually
get_DHS_data.R

#Bootstrapping:
#Then run "bootstrap.R" manually
bootstrap.R

#Then need to recalculate IWI on each bootstrap sample

#################################
#     OTHER BITS AND PIECES     #
#################################

#DEBUGGING:
debugSource("debugging_helpers.R")
#See debugging.R



#Have a look at one dataset to see what it looks like:
library(haven)
CMPR71FL <- read_sav(file.path(living_conditions_file_path, 
                               "DHS-VII/Cameroon 2018/Standard DHS/CMPR71FL.SAV"))
CMPR61FL <- read_sav(file.path(living_conditions_file_path,
                               "DHS-VI/Cameroon 2011/Standard DHS/CMPR61FL.SAV"))

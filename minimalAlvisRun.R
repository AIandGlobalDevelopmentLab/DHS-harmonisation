#Minimal run on Alvis:

source("/cephyr/users/bailie/Alvis/git/DHS-harmonisation/auth.R")
# debugSource(file.path(dirname(rstudioapi::getSourceEditorContext()$path), 
#                       "auth.R"))
source("set-up.R")

install.packages(c("devtools", "magrittr", "readr", "lubridate"))

library("devtools") #Needed to install Hans's packages
install_bitbucket(repo = "hansekbrand/iwi", 
                  ref = "99e59a070b914d392faef34bc9e22028b3df03e7",
                  upgrade = "never")
install_bitbucket(repo = "hansekbrand/DHSharmonisation", 
                  ref = "0af6dc57d8ec5799e6339c5c1c8128018d133952",
                  upgrade = "never")
library("globallivingconditions")

`%<>%` <- magrittr::`%<>%`
`%>%` <- magrittr::`%>%`
write_lines <- readr::write_lines
library("lubridate")

debugSource("helpers.R")
debugSource("global_vars.R")
debugSource("get_DHS_data_functions.R")

l <- getDHSData(dhs.user = username,
                dhs.password = pass,
                log.filename = "living-conditions.log",
                cacheFolderPath = NULL,
                harmonised.DHS.data.file.path = harmonised_DHS_data_file_path,
                vars.to.keep = vars_to_keep,
                variable.packages = variable_packages,
                superclusters = FALSE,
                living.conditions.file.path = living_conditions_file_path,
                qog.file.path = qog_file_path,
                updateSurveyInfoVars = TRUE,
                countries = NULL,
                waves = NULL,
                project.id = "168008") #Specify a DHS project ID to pass to download.and.harmonise (optional) 




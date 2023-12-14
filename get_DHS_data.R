
install_bitbucket(repo = "hansekbrand/iwi")
install_bitbucket(repo = "hansekbrand/DHSharmonisation")

library(globallivingconditions)
library(iwi)

# Test download.and.harmonise (on one wave in Cameroon, assuming DHS data is
# already downloaded).
# getDHSDataQuick()

#Full run:
living_conditions_file_path <- file.path(downloaded_DHS_data_file_path, "global-living-conditions")

setwd(repo_file_path) #reset wd in case of errors -- UPDATE: I no longer use wd since this is brittle

dt <- getDHSData(dhs.user = username,
                 dhs.password = pass,
                 log.filename = "living-conditions.log",
                 cacheFolderPath = NULL,
                 harmonised.DHS.data.file.path = harmonised_DHS_data_file_path,
                 vars.to.keep = vars_to_keep,
                 variable.packages = variable_packages,
                 superclusters = FALSE,
                 living.conditions.file.path = living_conditions_file_path,
                 qog.file.path = qog_file_path,
                 updateSurveyInfoVars = FALSE,
                 countries = NULL,
                 waves = NULL)



setwd(repo_file_path) #reset wd in case of errors
getDHSData(countries = "Senegal", check.dhs.for.more.data = F,
           cacheFolderPath = here("cache_220619_092818"),
           variable.packages = NULL)

setwd(repo_file_path) #reset wd in case of errors
getDHSData(countries = "Senegal", check.dhs.for.more.data = F,
           variable.packages = NULL,
           cacheFolderPath = here("cache_Senegal220619_123454"),
           make.pdf = T)

setwd(repo_file_path) #reset wd in case of errors
dt <- getDHSData(countries = "Senegal", 
                 check.dhs.for.more.data = F,
                 variable.packages = NULL,
                 living.conditions.file.path = living_conditions_minimal_file_path)

#Testing:
dt <- download.and.harmonise(dhs.user= username,
                             dhs.password= pass,
                             log.filename="living-conditions.log",
                             vars.to.keep = vars_to_keep,
                             variable.packages = variable_packages,
                             superclusters = F,
                             directory = living_conditions_file_path,
                             qog.file.path = qog_file_path,
                             #countries = "Tanzania", #Try with "Guinea" and get an error
                             check.dhs.for.more.data = T,
                             #waves = list("Tanzania" = c("7I")),
                             make.pdf = F)







dt <- download.and.harmonise(dhs.user= username,
                             dhs.password= pass,
                             log.filename="living-conditions.log",
                             variable.packages = c("wealth"),
                             superclusters = FALSE,
                             qog.file.path = paste(normalizePath("~"), 
                                                   "qog_std_ts_jan22.sav", 
                                                   sep = "/"),
                             countries = "Guinea",
                             check.dhs.for.more.data = F)

str(dt)


dt <- download.and.harmonise(dhs.user= username,
                             dhs.password= pass,
                             log.filename="living-conditions.log")

#Calculate the IWI too:
dt <- download.and.harmonise(dhs.user= username,
                             dhs.password= pass,
                             log.filename="living-conditions.log",
                             variable.packages = c("wealth"),
                             directory = living_conditions_file_path,
                             superclusters = FALSE,
                             qog.file.path = qog_file_path)

        
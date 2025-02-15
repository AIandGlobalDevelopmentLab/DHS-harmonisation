
install_bitbucket(repo = "hansekbrand/iwi")

################################################################################
# hansekbrand/DHSharmonisation requires rgdal and rgeos packages, which have been
# depreciated. 

# One option: Install old versions
# rgdal and rgeos require an old version of sf package
# See https://github.com/AIandGlobalDevelopmentLab/FrontPage/issues/125#issuecomment-2659902123
# You may need to install geos and gdal on your machine first, before installing these
# R packages. To do this on MacOS, run `homebrew install geo gdals.`
remove.packages(c("sp", "rgdal", "rgeos"))
remotes::install_version("sp", version = "1.6-1")
remotes::install_version("rgeos", version = "0.6-4") #Make sure not to update sp package when prompted
remotes::install_version("rgdal", version = "1.6-7") #Make sure not to update sp package when prompted
install_bitbucket(repo = "hansekbrand/DHSharmonisation") #Make sure not to update sp package when prompted


# Second option: Install from the branch fewer_dependencies
# As of Feb 2025, this is the most up-to-date branch
# And it does not depend on rgdal or rgeos packages:
remove.packages("globallivingconditions")
install_bitbucket(repo = "hansekbrand/DHSharmonisation",
                  #ref = "fewer_dependencies") 
                  ref = "fewer_dependencies_custom_project_ids") #Use this branch for now, until it is merged onto fewer_dependencies (then use the fewer_dependencies branch) -- see the PR https://bitbucket.org/hansekbrand/dhsharmonisation/pull-requests/3

#Custom: load forked version of DHSharmonisation package: -- THIS IS DEPRECIATED
remove.packages("globallivingconditions")
install_bitbucket(repo = "jameshbailiebb/dhsharmonisationcustomprojectid")

################################################################################

library(globallivingconditions)
library(iwi)

# Test download.and.harmonise (on one wave in Cameroon, assuming DHS data is
# already downloaded).
# getDHSDataQuick()

#Full run:
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
                updateSurveyInfoVars = FALSE,
                countries = NULL,
                waves = NULL,
                project.id = "168008") #Specify a DHS project ID to pass to download.and.harmonise (optional) 

final_output_data_file_path <- l$dt_file_path
final_output_data <- dt <-l$dt

######################
#Testing/OLD:
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

        
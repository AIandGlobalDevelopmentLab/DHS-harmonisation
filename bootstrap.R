DHSData <- readRDS("C:/Users/User/Documents/git/poverty-prediction/cache_220705_215028/DHS_harmonised_data71325998.RDS")
DHSData %<>% slice_head(n = 1e6) #just look at the first 1mil records for now, so testing is faster

DHSData$survey_info.stratified <- DHSData$survey_info.stratum2 #Remove once I've rerun download.and.harmonise

preppedDHSData <- prepDHSForBootstrap(DHSData = DHSData, RPSU = 2, RHh = 2)

#Set some bootstrap options:
options(boot.parallel = "snow",
        boot.ncpus = parallel::detectCores())
#options(boot.parallel = "no") #Don't parallelise


set.seed(1001)
bootstrapSamples <- bootstrapDHS(DHSData = preppedDHSData, RPSU = 2, RHh = 2)

#Have a look:
View(bootstrapSamples[[1]])

#Recompute the IWI on each of the bootstrap samples:
#See IWI documentation in Hans's package "iwi"
# (To do this, I need to export more variables from download.and.harmonise
# I need to export all of the IWI input variables.
# To do this I should define another variable.package 
# See ?download.and.harmonise)

#Then compute the average IWI within each (uniquePSUBootIndexB, uniqueUAUB) pair


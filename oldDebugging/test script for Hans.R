#Trying to debug download.and.harmonise with Hans
# July 2023
# (outdated)

vars_to_keep <- c("m49.region", "country.code.ISO.3166.alpha.3",
                  "version", "RegionID", "district", "ClusterID", "HouseholdID",
                  "year.of.interview", "month.of.interview", "age", "sex",
                  "sample.weight", "lon", "lat", "iwi", "survey_info.ultimate_area_unit",
                  "survey_info.psu", "survey_info.stratum", "survey_info.stratified",
                  "survey_info.region","survey_info.HH_weight")

superclusters <- FALSE
countries <- NULL
waves <- NULL
check.dhs.for.more.data <- TRUE
variable.packages <- c("wealth", "survey_info")
check.dhs.for.more.data <- TRUE


download.and.harmonise(dhs.user = dhs.user,
                       dhs.password = dhs.password,
                       vars.to.keep = vars.to.keep,
                       variable.packages = variable.packages,
                       superclusters = superclusters,
                       countries = countries,
                       waves = waves,
                       check.dhs.for.more.data = check.dhs.for.more.data)

## FILE PATH VARIABLES:
#downloaded_DHS_data_file_path is set in auth.R
dir.create(file.path(downloaded_DHS_data_file_path, "qog"), showWarnings = FALSE)
qog_file_path <- paste(normalizePath(file.path(downloaded_DHS_data_file_path, "qog")), 
                       "qog_std_ts_jan22.sav", 
                       sep = "/") #Need to do something weird with filepath to avoid error in download.and.harmonize

#UPDATE THIS IF YOU WANT TO RE-DOWNLOAD DATA:
living_conditions_file_path <- file.path(downloaded_DHS_data_file_path,
                                         "global-living-conditions") 
living_conditions_minimal_file_path <- file.path(downloaded_DHS_data_file_path,
                                                 "global-living-conditions-minimal")
survey_info_vars_file_path <- file.path(repo_file_path,
                                        "survey_info.csv")



## DHS DATA VARIABLES:
vars_to_keep <- c("m49.region", "country.code.ISO.3166.alpha.3",
                  "version", "RegionID", "district", "ClusterID", "HouseholdID",
                  "year.of.interview", "month.of.interview", "age", "sex",
                  "sample.weight", "lon", "lat", "iwi")

survey_info_vars <- read.csv2(survey_info_vars_file_path, 
                              header = T,
                              sep = ",")[,1] %>%
  paste0("survey_info.", .)

vars_to_keep %<>% append(survey_info_vars)

variable_packages <- c("wealth", "survey_info")





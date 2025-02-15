

makeDHSCacheFolder <- function(parentDir, options = "_") {
  folderName <- paste0("cache", options, getReadableSaveTime())
  folderPath <- file.path(parentDir, folderName)
  dir.create(folderPath)
  
  return(folderPath)
}

saveArguments <- function(file = "~/getDHS_fn_parameter_values.txt", 
                          argg = "") {
  sink(file = file, append = TRUE)
  print(paste0("Start time: ", getReadableSaveTime()))
  print(argg)
  print("---------------------------------------------------------------")
  sink()
}

getDHSDataQuick <- function(dhs.user = username,
                            dhs.password = pass,
                            log.filename = "living-conditions.log",
                            vars.to.keep = vars_to_keep,
                            variable.packages = variable_packages,
                            superclusters = FALSE,
                            living.conditions.file.path = living_conditions_file_path,
                            qog.file.path = qog_file_path,
                            updateSurveyInfoVars = TRUE,
                            check.dhs.for.more.data = FALSE,
                            countries = "Cameroon",
                            waves = list("Cameroon" = c("71")),
                            ...) {
  #Documentation:
  #... - other arguments to pass to download.and.harmonise
  
  dt <- getDHSData(dhs.user = dhs.user,
                   dhs.password = dhs.password,
                   log.filename = log.filename,
                   vars.to.keep = vars.to.keep,
                   variable.packages = variable.packages,
                   superclusters = superclusters,
                   living.conditions.file.path = living.conditions.file.path,
                   qog.file.path = qog.file.path,
                   updateSurveyInfoVars = updateSurveyInfoVars,
                   check.dhs.for.more.data = check.dhs.for.more.data,
                   countries = countries,
                   waves = waves,
                   ...)
  return(dt)
}

getDHSData <- function(dhs.user = username,
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
                       ...) {
  #Documentation:
  #If cacheFolderPath is NULL then a new folder will be created in harmonised.DHS.data.file.path.
  #   The cached harmonised data will be stored in this new folder.
  #... - other arguments to pass to download.and.harmonise
  
  #Record parameter arguments in a file:
  argg <- c(as.list(environment()), list(...)) %>%
    list_modify(dhs.user = NULL, dhs.password = NULL)
  
  
  #Save current working directory
  curWD <- getwd()
  
  #Move wd to cache folder (create cache folder first if necessary):
  if (is.null(cacheFolderPath)) {
    options <- "_"
    if (!is.null(countries)) {
      options %<>% paste0(countries, collapse = "")
      
      if (!is.null(waves)) {
        if (length(waves) == 1)
          options %<>% paste0(waves)
      }
    }
    cacheFolderPath <- makeDHSCacheFolder(parentDir = harmonised.DHS.data.file.path, 
                                          options = options)
  }
  
  saveArguments(file = file.path(cacheFolderPath,
                                 "DHS_fn_parameter_values.txt"),
                argg = argg)
  
  setwd(cacheFolderPath)
  
  #Reset the survey_info.PR package if required:
  surveyInfoPackagePath <- system.file(package="globallivingconditions") %>%
    file.path("survey_info.PR.csv")
  
  if (updateSurveyInfoVars) {
    #Push survey_info_vars.csv into the correct folder so that it is findable
    #by the globallivingconditions package:
    file.copy(from = survey_info_vars_file_path, 
              to = surveyInfoPackagePath,
              overwrite = T)
  } else if(!file.exists(surveyInfoPackagePath) & 
             "survey_info" %in% variable.packages) {
    stop("Survey_info csv not stored in globallivingconditions package.")
  }
  
  
  withCallingHandlers( #Basic error handing 
    # in case RStudio window freezes -- write error output to a file
    {
      dt <- download.and.harmonise(dhs.user = dhs.user,
                                   dhs.password = dhs.password,
                                   log.filename = log.filename,
                                   vars.to.keep = vars.to.keep,
                                   variable.packages = variable.packages,
                                   superclusters = superclusters,
                                   directory = living.conditions.file.path,
                                   qog.file.path = qog.file.path,
                                   countries = countries,
                                   waves = waves,
                                   ...)
      dt_file_path <- paste0("DHS_harmonised_data", 
                             getSaveTime(), 
                             ".RDS") %>%
        file.path(cacheFolderPath, .) 
      saveRDS(dt, dt_file_path)
    },
    error = function(e) {
      errorFile <- file.path(cacheFolderPath,
                             "error_output.txt")
      write_lines(as.character(e), file = errorFile)
      
      write_lines("TRACEBACK:", file = errorFile, append = T)
      as.character(sys.calls()) %>% 
        paste0(1:length(.), ": ", ., collapse = "\n") %>%
        write_lines(file = errorFile, append = T)
    }
  )

  #Go back to working directory:
  setwd(curWD)
  
  return(list(dt = dt, dt_file_path = dt_file_path))
}
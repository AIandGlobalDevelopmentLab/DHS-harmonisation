#HELPER FUNCTIONS for debugging:
stripNames <- function(links) { #Grab dataset names out of the URLs
  links %>% 
    substr(start = regexpr(text = links, pattern = "Filename=", ignore.case = T) + 9,
           stop = regexpr(text = links, pattern = ".ZIP", ignore.case = T) - 1) %>%
    toupper() %>%
    return()
}

getCountryCode <- function(names, links) {
  #Get the links with the right names
  links <- links[which(stripNames(links) %in% names)] 
  countryCodeIndicesStart <- regexpr(text = links, 
                                     pattern = "Ctry_Code=",
                                     ignore.case = T) + 10
  countryCodes <- substr(links,
                         start = countryCodeIndicesStart,
                         stop = countryCodeIndicesStart + 1)
  return(countryCodes)
}

getEmptyFoldersAndAllDataNames <-
  function(livingConditionsFilePath = living_conditions_file_path) {
    #Notes if any folders in livingConditionsFilePath are empty
    #And collects the names of all the datasets in livingConditionsFilePath
    
    DHSPhases <- paste0("DHS-", as.roman(1:8))
    emptyFolders <- character()
    allData <- character() #Store all dataset names for checking later
    
    for (phase in DHSPhases) {
      countryYears <- list.files(path = file.path(livingConditionsFilePath,
                                                  phase))
      for (countryYear in countryYears) {
        surveys <- list.files(path = file.path(livingConditionsFilePath,
                                               phase,
                                               countryYear))
        if (length(surveys) == 0) {
          emptyFolders %<>% append(countryYear) #Store empty folder
        }
        
        for (survey in surveys) {
          listedFiles <- list.files(path = file.path(livingConditionsFilePath,
                                                     phase,
                                                     countryYear,
                                                     survey))
          data <- listedFiles %>%
            toupper() %>%
            grep(pattern = ".SAV", x = ., value = TRUE) %>%
            sub(pattern = "FL.SAV", replacement = "SV", x = .)
          
          if (length(data) == 0) {
            emptyFolders %<>% append(countryYear) #store empty folder
          }
          
          allData %<>% append(data) #store dataset name
          
          #Store any GIS data if available:
          if ("GIS" %in% listedFiles) {
            GISData <- list.files(path = file.path(livingConditionsFilePath,
                                                   phase,
                                                   countryYear,
                                                   survey,
                                                   "GIS")) %>%
              toupper() %>%
              grep(pattern = ".SHP$", x = ., value = TRUE) %>%
              sub(pattern = ".SHP", x = ., replacement = "")
            
            allData %<>% append(GISData)
          }
        }
      }  
    }
    
    return(list(emptyFolders = emptyFolders,
                allDataNames = allData))
  }

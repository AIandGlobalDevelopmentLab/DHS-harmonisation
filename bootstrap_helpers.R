
getUniquePSUs <- function(DHSDataPSUs, bootStrapIndices) {
  `%>%` <- magrittr::`%>%` #Must import functions within parallel Bootstrap cluster
  DHSDataPSUs %>% dplyr::select(uniquePSU) %>%
    dplyr::slice(bootStrapIndices) %>%
    return()
}

getUniqueHh <- function(DHSDataHh, bootStrapIndices) {
  `%>%` <- magrittr::`%>%` #Must import functions within parallel Bootstrap cluster
  DHSDataHh %>% dplyr::select(uniqueHh, uniqueUAU, uniquePSUBootIndex) %>%
    dplyr::slice(bootStrapIndices) %>%
    return()
}

collapseToHh <- function(DHSData, replaceNAsWithinHhs = T) {
  #Collapses the DHS Data down to a single row for each unique household
  
  if (replaceNAsWithinHhs) {
    
    selectNonNAValue <- function(x) {
      v <- unique(x[!is.na(x)]) 
      if (length(v) == 0) {
        return(NA)
      } else {
        return(v[1]) # MUST REMOVE [1] ONCE I HAVE CORRECT DHS DATA
      } 
    }
    
    #Some of the rows have NAs when other rows from the same household
    #have non-NAs. Replace these NAs with the nonNA value:
    DHSData %<>%
      group_by(HouseholdID) %>%
      mutate(across(c("survey_info.ultimate_area_unit", 
                      "survey_info.psu",
                      "survey_info.stratum",
                      "survey_info.stratified",
                      "survey_info.region",
                      "survey_info.HH_weight"),
                    selectNonNAValue)) %>% 
      ungroup()
    
  }
  
  collapsedDHSData <- DHSData %>% 
    group_by(across(-c(sex,age))) %>% #sex and age are the only individual-level variables, all other DHSData variables are household level
    summarise() %>%
    ungroup()
  
  #Some error checking
  # collapsedDHSData %>% 
  #   group_by(HouseholdID) %>% 
  #   filter(n() > 1) %>%
  #   View()
  #What to do with the duplicated households?
  
  return(collapsedDHSData)
}

makeBootstrapKeys <- function(DHSData, RPSU, RHh) {
  #Returns a DHS dataset containing keys:
  # uniqueSurvey:       a variable that uniquely identifies the survey
  # uniqueStratum:      uniquely identifies the strata (across different surveys)
  # uniquePSU
  # uniqueUAU/uniqueHh: (only created if there are household replications 
  #                     - i.e. RHh > 0)
  
  DHSData %<>% within({
    uniqueSurvey <- 
      paste0("C", country.code.ISO.3166.alpha.3, ".V", 
             version) %>% 
      as.factor()
    
    uniqueStratum <- 
      paste0(uniqueSurvey, ".S", 
             (survey_info.stratified != 0)*survey_info.stratum) %>%
      as.factor()
    
    uniquePSU <- 
      paste0(uniqueStratum, ".P",
             survey_info.psu) %>% 
      as.factor()
    
  })
  
  if (RHh) { #If we are bootstrapping over household, then make UAU and HH keys
    DHSData %<>% within({
      uniqueUAU <-
        paste0(uniqueStratum, ".U",
               survey_info.ultimate_area_unit) %>% 
        as.factor()
    })
    
    #Extract household number from HouseholdID:
    #Assumption: household number is the characters following the final '.' in
    #HouseholdID
    HHIDLen <- nchar(levels(DHSData$HouseholdID))
    
    HouseholdNum <- levels(DHSData$HouseholdID) %>% 
      stri_reverse %>%
      regexpr(".", ., fixed = T) %>%
      `-`(HHIDLen+2, .) %>%
      substr(x = levels(DHSData$HouseholdID), 
             start = ., 
             stop = HHIDLen)
    
    #Start by assigning household numbers as uniqueHh
    DHSData$uniqueHh <- DHSData$HouseholdID
    levels(DHSData$uniqueHh) <- HouseholdNum
    
    #Then prepend uniqueUAU to household numbers:
    DHSData$uniqueHh %<>% as.character() %>%
      paste0(DHSData$uniqueUAU, ".H", .) %>%
      as.factor()
  }
  
  return(DHSData)
}
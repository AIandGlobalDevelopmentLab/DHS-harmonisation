
#Reminder: tic() code toc() for timing evaluation

prepDHSForBootstrap <- function(DHSData, RPSU, RHh,
                                collapseToHhLogical = T) {
  #Prepare DHSData (i.e. output from download.and.harmonise) for bootstrapping
  #1. collapse the DHSData down to one row per household (instead of individual
  #   level data)
  #2. make unique keys for DHSData which will be used for bootstrapping
  
  if (collapseToHhLogical) {
    DHSData %<>% collapseToHh()
  }
  
  DHSData %<>% makeBootstrapKeys(RPSU, RHh)
  
  return(DHSData)
}

bootstrapDHS <- function(DHSData, RPSU, RHh, prepDHSForBootstrapLogical = F,
                         collapseToHhLogical = T) {
  #Takes DHS data (which must be prepped beforehand if prepDHSForBootstrapLogical
  #   is F) and generates bootstrap samples of PSU/households.
  #RPSU:    the number of PSU bootstrap samples to generate
  #RHh:     the number of household bootstrap samples (within the PSU bootstrap
  #            samples) to generate
  #If you don't want to bootstrap households, set RHh = 0.
  
  #Output:
  #  1. If there are no household bootstraps (i.e. RHh = 0), a list of tibbles 
  #        containing bootstrapped uniquePSU keys. There is one tibble for each
  #        bootstrap (so RPSU tibbles in total). The ith tibble has a single 
  #        column - uniquePSUs - which lists the PSUs selected in the ith bootstrap.
  #  2. If there are household bootstraps (i.e. RHh > 0), then a list of RPSU 
  #        tibbles. Each tibble has RHh columns, and each column is a vector of 
  #        uniqueHh keys. The jth column in the ith tibble lists the households
  #        selected in the jth household bootstrap, where the households are
  #        bootstrapped over the ith PSU bootstrap.

  stopifnot(RPSU > 0)
  stopifnot(RHh >= 0)
  
  DHSData %<>% ungroup()
  
  if (prepDHSForBootstrapLogical) {
    DHSData %<>% prepDHSForBootstrap(RPSU, RHh, collapseToHhLogical)
  }
  
  DHSData %<>% ungroup()
  
  bsamplePSUs <- DHSData %>% 
    group_by(uniquePSU,
             uniqueStratum) %>% 
    #Make PSU weights
    #(NEED TO UPDATE WEIGHT CALCULATION ONCE THEORY WORKED OUT)
    #and collapse DHSData to the PSUs, their weights and strata
    summarise(PSUWeights = sum(survey_info.HH_weight)) %>% 
    ungroup() %>%
    bootstrapPSUs(DHSDataPSUs = .,
                  R = RPSU) #get bootstrap samples of PSUs

  #Each element of bsamplePSUs is a bootstrap sample of PSUs
  #   -- i.e. a tibble of uniquePSU keys
  
  if (RHh) { #Do household bootstraps if requested:
    DHSDataHh <- DHSData %>% 
      select(uniquePSU, uniqueUAU, uniqueHh)
    
    bsampleHhs <- list()
    
    for (i in 1:length(bsamplePSUs)) {
      bsamplePSUs[[i]] %<>% group_by(uniquePSU) %>%
        mutate(uniquePSUBootIndex = as.factor(paste0(uniquePSU, ".B", 
                                                     row_number()))) %>%
        ungroup() 
      
      #Make a DHSDataHh set with the PSUs selected 
      #in the bootstrap sample bsamplePSUs:
      bsampleHh <- inner_join(bsamplePSUs[[i]], DHSDataHh, by = "uniquePSU") %>%
        group_by(uniquePSUBootIndex, uniqueUAU) %>% #Now make strata for hh bootstrap
        mutate(uniqueUAUxPSUBootIndex = cur_group_id()) %>%
        ungroup() %>%
        bootstrapHouseholds(DHSDataHh = ., #Get bootstrap replications
                            R = RHh) %>%
        bind_cols()
      
      colnames(bsampleHh) <- paste0(c("uniqueHhB", "uniqueUAUB", "uniquePSUBootIndexB"), 
                                    rep(1:RHh, 3))
      
      bsampleHhs[[i]] <- bsampleHh
    }
    
    return(bsampleHhs)
  } else{
    return(bsamplePSUs)
  }
}


bootstrapPSUs <- function(DHSDataPSUs, R) {
  #Returns the uniquePSU keys for R bootstrap samples of the PSUs
  modifiedBootFunction(data = DHSDataPSUs, 
                       statistic = getUniquePSUs, 
                       R = R,
                       strata = DHSDataPSUs$uniqueStratum, 
                       weights = DHSDataPSUs$PSUWeights) %>%
    .$t %>%
    return()
}

bootstrapHouseholds <- function(DHSDataHh, R) {
  #Returns the uniqueHh keys for R bootstrap samples of the Hhs 
  modifiedBootFunction(data = DHSDataHh, 
                       statistic = getUniqueHh, 
                       R = R,
                       strata = DHSDataHh$uniqueUAUxPSUBootIndex) %>%
    #weights = DHSDataHh$survey_info.HH_weight, #no weights required as every HH has equal probability of selection within UAUs
    .$t %>%
    return()
}

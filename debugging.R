debugSource("debugging_helpers.R")

#################

#First issue:
#What links do I have access to (DHSLinks)
#which are not listed as processed (i.e. in processed.links) 
#by download.and.harmonise?

#NEED TO CHANGE FILE PATH OF THESE TWO FILES:
DHSLinks <- read_lines(file = file.path(downloaded_DHS_data_file_path, "../debugging", "DHS-data-links.txt"))
load(file.path(download_DHS_data_file_path, "global-living-conditions/processed_links.RData"))
#write_lines(x = processed.links, file = file.path(DHS_data_file_path, "processed_links.txt"))

processedLinkNames <- stripNames(processed.links)
DHSLinkNames <- stripNames(DHSLinks)

#Look at the files that globallivingconditions package says should not be 
#downloaded:
#https://bitbucket.org/hansekbrand/dhsharmonisation/src/master/data/never.download.these.RData
load("C:/Users/User/Documents/DHS_Data/Some old debugging files/never.download.these.RData")
neverDownloadNames <- stripNames(never.download.these)

#Are there links I have access to (i.e. in DHSLinks) but were not processed:
DHSLinkNames %>% 
  setdiff(neverDownloadNames) %>%
  setdiff(processedLinkNames)
#Output: LBPR51SV (now downloaded) and FLSR files (which can be ignored)
#Output: "PEIR5ASV"   "PEKR5ASV"   "PEPR5ASV" - I think these can be ignored
# but I am double checking with Hans.

DHSLinkNames %>%
  setdiff(processedLinkNames) %>%
  getCountryCode(links = DHSLinks) #Double check

processedLinkNames %>% setdiff(DHSLinkNames)
#(just double checking:) no processed links that I don't have access to.

#Can lookup by survey ID:
#https://dhsprogram.com/methodology/survey/survey-display-538.cfm

###################

#ANOTHER ISSUE:
#There are files listed in processed.links which were not downloaded:

#Example:
any(grepl("TZIR7I", processed.links))
any(grepl("TZIR7I", neverDownloadNames))
#TZIR7I in processed.links (and not in never.download.these)
# but nothing in the folder:
# C:\Users\User\Documents\DHS_Data\global-living-conditions\DHS-VII\Tanzania 2017
# So processed.links is not accurate.

#Look which data folders are empty in globallivingconditions:
l <- getEmptyFoldersAndAllDataNames(livingConditionsFilePath = 
                                      living_conditions_file_path)
  
l$emptyFolders #See which folders are empty and manually download
#Should be empty (as they are not Standard DHS or 
#Continuous DHS or MIS suveys):
shouldBeEmpty <- c("Nepal 1987", "Cambodia 1998", "Egypt 1996-97", 
                   "Malawi 1996", "Morocco 1995", "Tanzania 1994",
                   "Uganda 1995-96", "Bangladesh 2001", "Uzbekistan 2002",
                   "Ghana 2007", "Afghanistan 2010", "Rwanda 2011", 
                   "Egypt 2015", "Ghana 2017", "Pakistan 2019")
                   

#These are Standard DHS but don't have PR, IR, KR or MR datasets:
shouldBeEmpty2 <- c("Senegal 1999")
                    
#Countries that I have manually added:
#"Niger 1992"
#"Niger 1998"
#"Niger 2006"
#"Niger 2012"
#"Senegal 2014" (see comments immediately below)
#"Senegal 2016" (see comments immediately below)
#"Tanzania 2017"

#Error in C:\Users\User\Documents\DHS_Data\global-living-conditions\DHS-VII\Senegal 2014\Continuous DHS
#In this folder, download.and.harmonise downloaded 
# SN**6RSV.ZIP files (which shouldn't be downloaded? Maybe?)
# (These are recodes of Senegal Continuous DHS 2012 which are SN**6D -
# Should I replace SN**6D with SN**6R?)
#download.and.harmonise also didn't unzip the files SN**70SV.ZIP files.

#The same thing happened for DHS-VII\Senegal 2016 
# This folder included SN**G0SV.ZIP files (which is strange behaviour)

#Also, the Senegal 2014 GIS data is SNGE71FL.SHP which is the same 
#filename as the GIS for Senegal 2016! Not sure if this is an error.

#Check that all the empty folders have been fixed:
l <- getEmptyFoldersAndAllDataNames(livingConditionsFilePath = 
                                      living_conditions_file_path)

l$emptyFolders %>% setdiff(shouldBeEmpty) %>% setdiff(shouldBeEmpty2)
#Returns vector of zero length -- so we have fixed all the empty folders
## EDIT: Now returns "Peru 2007-08" since we deleted the duplicates in this folder 
## (see comments below for details)

#Check that no allDataNames are in never.download.these
intersect(l$allDataNames, neverDownloadNames)
#Includes "KEIR42SV" "KEKR42SV"
#     -- these are both Indian state datasets (exclude)
#         and Kenya datasets (include). 
# There is an error in never.download.these -- we should download the Kenyan
# datasets, just not the Indian ones.

#What datasets are missing from the available datasets:
setdiff(DHSLinkNames, l$allDataNames) %>% 
  setdiff(neverDownloadNames) %>% sort() %>%
  grep(pattern = "FLSR", x = ., value = TRUE, invert = TRUE) #Can ignore the FLSR files - these are SPA surveys
#Returned:
# [1] "NGGE23FL"X "NGGE4BFL"X "NGGE52FL"X "NGGE61FL"X "NGGE6AFL"X "NGGE71FL"X "NGGE7BFL"X
# [8] "NGIR21SV"X "NGIR4BSV"X "NGIR53SV"X "NGIR61SV"X "NGIR6ASV"X "NGIR71SV"X "NGIR7BSV"X
# [15] "NGPR21SV"X "NGPR4CSV"X "NGPR53SV"X "NGPR61SV"X "NGPR6ASV"X "NGPR71SV"X "NGPR7BSV"X
# [22] "PEIR5ASV"Y "PEKR5ASV"Y "PEPR5ASV"Y "TZGE43FL"X "TZGE4CFL"X "TZGE52FL"X "TZGE61FL"X
# [29] "TZGE6AFL"X "TZGE7AFL"X
#X = has now been manually downloaded
#Y = DHS recoding error - ZIP files PE**5ASV actually contain PE**51SV files

#ACTION: Delete duplicate files in DHS-V\Peru 2007-08
#(These files PE**51SV are in Peru 2004-06 and are duplicated in 07-08 due to
# a DHS recoding error.)

#Double check
setdiff(l$allDataNames, DHSLinkNames) #Nothing returned, as expected

#Update processed_links.RData
## What are the actual processed datasets:
actualProcessedDataNames <- DHSLinkNames %>% 
  grep(pattern = "PEIR5ASV|PEKR5ASV|PEPR5ASV|FLSR", 
       x = ., value = T, invert = T) %>% #Should be DHSLinkNames except for "PEIR5ASV" "PEKR5ASV" "PEPR5ASV" and FLSR files
  setdiff(neverDownloadNames) %>% 
  append(c("KEIR42SV","KEKR42SV")) #We didn't download any from neverDownloadNames, except for "KEIR42SV","KEKR42SV"

#Now backconvert these names into links:
actualProcessedDataLinks <- DHSLinks[which(stripNames(DHSLinks) %in% actualProcessedDataNames)] %>%
  #Remove Indian datasets which shouldn't be here but have same name as Kenyan data
  setdiff(c("https://dhsprogram.com/customcf/legacy/data/download_dataset.cfm?Filename=KEIR42SV.zip&Tp=1&Ctry_Code=IA&surv_id=156&dm=1&dmode=nm",
            "https://dhsprogram.com/customcf/legacy/data/download_dataset.cfm?Filename=KEKR42SV.zip&Tp=1&Ctry_Code=IA&surv_id=156&dm=1&dmode=nm")) %>%
  sub(pattern = "&dm=1&dmode=nm", 
      replacement = "&dmode=normal",
      x = .)

#Save the actual processed links in the appropriate spot:                                 
processed.linksBackup <- processed.links
processed.links <- actualProcessedDataLinks
save(processed.links, file = file.path(living_conditions_file_path, "processed_links.RData"))
processed.links <- processed.linksBackup

################################

#ANOTHER ISSUE:
# GIS borders not fully downloaded:

#Look at GIS Borders downloaded:
list.files(path = file.path(DHS_data_file_path, 
                            "global-living-conditions-3", #NEED TO CHANGE THIS
                            "GIS-borders")) %>%
  grep(pattern = ".rds", x = ., value = T) %>%
  substr(start = 1, stop = 3) %>%
  unique()
#Only 18 countries downloaded data. 

#Plan: Rerun the relevant globallivingconditions function to 
# attempt to download GPS data again:

#First get the countries with GIS data:
l <- getEmptyFoldersAndAllDataNames(livingConditionsFilePath = 
                                      living_conditions_file_path)
countriesWithGIS <- l$allDataNames %>% 
  grep(pattern = "GE", x = ., value = TRUE) %>%
  substr(1,2) %>%
  unique()

#Second get the 3letter ISO codes for these countries:
#install.packages("countrycode")
countriesWithGIS %<>% sub(pattern = "BU", replacement = "BI", x = .) %>%
  sub(pattern = "NM", replacement = "NA", x = .) %>%
  sub(pattern = "LB", replacement = "LR", x = .) %>%
  sub(pattern = "NI", replacement = "NE", x = .) %>%
  sub(pattern = "MD", replacement = "MG", x = .) #Fix up non-standard ISO2c codes (I have only corrected African country codes -- this will not work for non-African countries!)


countriesWithGISISO3Letter <- countrycode::countrycode(countriesWithGIS,
                                                       origin = 'iso2c',
                                                       destination = 'iso3c')
#Third: get ISO numeric country codes
coords.dt <- iso.3166 %>% 
  filter(String.code %in% countriesWithGISISO3Letter) %>%
  select(numeric) %>%
  rename(country.code.ISO.3166.alpha.3 = numeric)

#Save them so they can be accessed by my.borders.outer.f as desired
save(coords.dt, file = "coords.dt.without.gadm.RData")
my.borders.outer.f(gis.path = paste0(living_conditions_file_path, 
                                        "/GIS-borders/"))

#Check that all border data downloaded:
lfiles <- list.files(path = file.path(living_conditions_file_path, 
                                      "GIS-borders")) %>%
  grep(pattern = ".rds", x = ., value = T) %>%
  substr(1,3) %>%
  unique() 

setdiff(lfiles, countriesWithGISISO3Letter) 
setdiff(countriesWithGISISO3Letter, lfiles)
#Looks good - all boundaries are downloaded!

#See which files weren't originally downloaded:
details <- file.info(list.files(path = file.path(living_conditions_file_path, 
                                                "GIS-borders"),
                               pattern = "*.rds",
                               full.names = TRUE))
details[with(details, order(as.POSIXct(mtime))), ] %>%
  filter(mtime >= parse_date_time("2022-06-20 02:30", 
                                  orders = "ymdHM", 
                                  tz = "Australia/Sydney"),
         mtime <= parse_date_time("2022-06-20 05:30", 
                                  orders = "ymdHM", 
                                  tz = "Australia/Sydney")) %>%
  row.names() %>%
  grep(pattern = ".rds", x = ., value = T) %>%
  substr(x = ., 
                     start = regexpr(pattern = ".rds", 
                                     text = ., 
                                     ignore.case = T)-8,
                     stop = regexpr(pattern = ".rds", 
                                   text = ., 
                                   ignore.case = T)-6) %>%
  unique()

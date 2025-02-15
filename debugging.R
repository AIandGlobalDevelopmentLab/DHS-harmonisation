debugSource("debugging_helpers.R")

#################

#First issue:
#What links do I have access to (i.e. in DHS-data-links.txt)
#which are not listed as processed (i.e. in processed.links) 
#by download.and.harmonise?


#First: Create the file DHS-data-links.txt 
## Go to https://dhsprogram.com/data/dataset_admin/index.cfm
## -> Download manager
## -> Check all countries
## -> Check Data Types: Children's Recode (KR), Household Member Recode (PR), 
##            Individual Recode (Women 15-49, IR), Men's Recode (Men 15-54, MR), 
## -> Check File Format: SPSS (SV)
## -> Check Surveys: All
## -> Save the downloaded file at
##  file.path(downloaded_DHS_data_file_path, "../debugging", "DHS-data-links.txt")
## -> Go back to the Download Manager 
## -> Check all countries, Geographic Data, Flat file, All surveys
## -> Take the downloaded file and append it to DHS-data-links.txt 

DHSLinks <- read_lines(file.path(downloaded_DHS_data_file_path, 
                                 "../debugging", "DHS-data-links.txt"))
load(file.path(downloaded_DHS_data_file_path, 
               "global-living-conditions/processed_links.RData"))

processedLinkNames <- stripNames(processed.links)
DHSLinkNames <- stripNames(DHSLinks)

#Look at the files that globallivingconditions package says should not be 
#downloaded:
#https://bitbucket.org/hansekbrand/dhsharmonisation/src/master/data/never.download.these.RData
load(file.path(downloaded_DHS_data_file_path,
               "../debugging",
               "never.download.these.RData"))
neverDownloadNames <- stripNames(never.download.these)

#Sanity check: no processed links that I don't have access to.
processedLinkNames %>% setdiff(DHSLinkNames)


#Are there links I have access to (i.e. in DHSLinks) but were not processed:
DHSLinkNames %>% 
  setdiff(neverDownloadNames) %>%
  setdiff(processedLinkNames)
#This should be empty, except for FLSR files (which can be ignored)

#If necessary, see which countries these datasets belong to:
# DHSLinkNames %>%
#   setdiff(neverDownloadNames) %>%
#   setdiff(processedLinkNames) %>%
#   getCountryCode(links = DHSLinks) #Double check



#Can lookup by survey ID:
#https://dhsprogram.com/methodology/survey/survey-display-538.cfm

###################

#ANOTHER ISSUE:
#Are there files listed in processed.links which were not downloaded:

#Look which data folders are empty in globallivingconditions:
l <- getEmptyFoldersAndAllDataNames(livingConditionsFilePath = 
                                      living_conditions_file_path)

l$emptyFolders #See which folders are empty and manually download

#Some folders should be empty (as they are not Standard DHS or 
#Continuous DHS or MIS suveys):
shouldBeEmpty <- c("Nepal 1987", "Cambodia 1998", "Egypt 1996-97", 
                   "Malawi 1996", "Morocco 1995", "Tanzania 1994",
                   "Uganda 1995-96", "Bangladesh 2001", "Uzbekistan 2002",
                   "Ghana 2007", "Afghanistan 2010", "Rwanda 2011", 
                   "Egypt 2015", "Ghana 2017", "Pakistan 2019")


#These are Standard DHS but don't have PR, IR, KR or MR datasets:
shouldBeEmpty <- c(shouldBeEmpty, "Senegal 1999")

#Check whether there are any empty folders which should be non-empty:
l$emptyFolders %>% setdiff(shouldBeEmpty)
#This should return an empty vector.

## EDIT: Now returns "Peru 2007-08" since we deleted the duplicates in this folder 
## (see comments below for details)

#Check that no allDataNames are in never.download.these
intersect(l$allDataNames, neverDownloadNames)
#This should return the vector 
#"KEIR42SV" "KEKR42SV"
#     -- these are both Indian state datasets (exclude)
#         and Kenya datasets (include). (i.e. the keys are duplicate)
# We should download the Kenyan datasets, just not the Indian ones.

#What datasets are missing from the available datasets:
setdiff(DHSLinkNames, l$allDataNames) %>% 
  setdiff(neverDownloadNames) %>% sort() %>%
  grep(pattern = "FLSR", x = ., value = TRUE, invert = TRUE) #Can ignore the FLSR files - these are SPA surveys
#This should return an empty vector
#Currently it is returning the vector
# "PEIR5ASV" "PEKR5ASV" "PEPR5ASV"
# due to a DHS naming error
# Hans is looking into this (email sent around 5 Dec 2022)

#Double check
setdiff(l$allDataNames, DHSLinkNames) #Nothing returned, as expected


### The following commented out code needs to be updated.
# #Update processed_links.RData
# ## What are the actual processed datasets:
# actualProcessedDataNames <- DHSLinkNames %>% 
#   grep(pattern = "PEIR5ASV|PEKR5ASV|PEPR5ASV|FLSR", 
#        x = ., value = T, invert = T) %>% #Should be DHSLinkNames except for "PEIR5ASV" "PEKR5ASV" "PEPR5ASV" and FLSR files
#   setdiff(neverDownloadNames) %>% 
#   append(c("KEIR42SV","KEKR42SV")) #We didn't download any from neverDownloadNames, except for "KEIR42SV","KEKR42SV"
# 
# #Now backconvert these names into links:
# actualProcessedDataLinks <- DHSLinks[which(stripNames(DHSLinks) %in% actualProcessedDataNames)] %>%
#   #Remove Indian datasets which shouldn't be here but have same name as Kenyan data
#   setdiff(c("https://dhsprogram.com/customcf/legacy/data/download_dataset.cfm?Filename=KEIR42SV.zip&Tp=1&Ctry_Code=IA&surv_id=156&dm=1&dmode=nm",
#             "https://dhsprogram.com/customcf/legacy/data/download_dataset.cfm?Filename=KEKR42SV.zip&Tp=1&Ctry_Code=IA&surv_id=156&dm=1&dmode=nm")) %>%
#   sub(pattern = "&dm=1&dmode=nm", 
#       replacement = "&dmode=normal",
#       x = .)
# 
# #Save the actual processed links in the appropriate spot:                                 
# processed.linksBackup <- processed.links
# processed.links <- actualProcessedDataLinks
# save(processed.links, file = file.path(living_conditions_file_path, "processed_links.RData"))
# processed.links <- processed.linksBackup

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



#########

#Another issue: Are all the data which is in processed links actually in the 
# final output data file?

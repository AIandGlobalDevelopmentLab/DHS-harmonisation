
setwd("~/Desktop")
library(devtools)
install_bitbucket(repo = "hansekbrand/iwi", ref = "ad44f166b61578f924be1b06615d1563bf5c816b") ## install iwi first, since DHSharmonisation depends on it.                                                                                      
install_bitbucket(repo = "hansekbrand/DHSharmonisation", ref = "fixing_james_bug")

library(globallivingconditions)
                                  
username <- XXX
pass <- XXX


vars.to.keep <- c("m49.region", "country.code.ISO.3166.alpha.3", "version", "RegionID",
                  "district", "ClusterID", "HouseholdID", "year.of.interview",
                  "month.of.interview", "age", "sex", "sample.weight", "lon", "lat",
                  "iwi", "survey_info.ultimate_area_unit", "survey_info.psu", "survey_info.stratum",
                  "survey_info.stratified", "survey_info.region", "survey_info.HH_weight",
                  "survey_info.urban_rural", "survey_info.HH_men_weight")

my.dt <- download.and.harmonise(
  dhs.user=username,
  dhs.password=pass,
  countries = NULL, 
  waves = NULL,
  superclusters = FALSE,
  vars.to.keep = vars.to.keep, # see above                                                                                                                                                                                                   
  variable.packages = c("wealth", "survey_info"),
  directory = "~/Desktop",
  project.id = "168008",
  check.dhs.for.more.data = FALSE
)

library("tidyverse")
surveyInfoPackagePath <- system.file(package="globallivingconditions") %>%
  file.path("survey_info.PR.csv")
read.csv(surveyInfoPackagePath)

# Check DHS running properly:
my.base.uri <- 'https://dhsprogram.com'
my.uri <- paste0(my.base.uri, '/data/dataset_admin/login_main.cfm')

r.1 <- httr::GET(my.uri)
body <- list(Submitted = 1, UserType = 2, UserName = username,
             UserPass= pass, RememberMe = "Yes", submit = "Sign in")

r.2 <- httr::POST(my.uri, body = body, encode = "form")
r.2

user.project.ids <- as.character(XML::xpathSApply(XML::xmlRoot(XML::htmlParse(
  httr::content(r.2, "text"))), "//select[@name = 'proj_id']/option[@value > 0]",
  XML::xmlAttrs))
user.project.ids


setwd("~/Desktop/globallivingconditions_cached_R_files/")
for(file in gsub(".rdx$", "", list.files(path="cache", pattern="rdx$", full.names=T))) { lazyLoad(file) }
big.files.found

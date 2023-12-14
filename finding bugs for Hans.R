library("tidyverse")

#require("fst")

#Load Hans's version of the harmonised data:
#load("Hans data/With survey variables/living-conditions.RData")
DHSData2 <- fst::read.fst("Hans data/With survey variables/DHSData.fst")

#DHSData <- my.dt
colnames(DHSData)
#colnames(DHS_harmonised_data71325998) %>% dput

DHSData <- DHSData2 |> select(all_of(c("country.code.ISO.3166.alpha.3", "year.of.interview", "version", 
                                       "m49.region", "RegionID", "district", "ClusterID", "sex", "HouseholdID", 
                                       "age", "month.of.interview", "sample.weight", "iwi", "survey_info.ultimate_area_unit", 
                                       "survey_info.psu", "survey_info.stratum", "survey_info.stratified", 
                                       "survey_info.region", "survey_info.HH_weight")))

summary(DHSData2$survey_info.stratified)
class(DHSData2$survey_info.stratified)

summary(DHSData2$survey_info.stratum)
class(DHSData2$survey_info.stratum)

sum(DHSData2$survey_info.stratified != DHSData2$survey_info.stratum, na.rm = T)



#1. country.code.ISO.3166.alpha.3 is numeric rather than a three letter code (character or factor).
DHSDataSelect |> filter(HouseholdID == "BF.North.31.91.15") |>
  View()

#### Variables not in Hans's current dataset:
#2. Why do some individuals have NA for PSU while others in the same household have non NA PSUs
collapsedDHSData <- DHSData |> 
  group_by(across(-c(sex,age))) |>
  summarise()
collapsedDHSData |> 
  group_by(HouseholdID) |> 
  filter(n() > 1) |>
  View()
#See for example HouseHoldID BF.North.31.91.15
DHSData |> filter(HouseholdID == "BF.North.31.91.15") |>
  View()

#Same problem with IWI:
#See for example HouseHoldID CI.East.51.185.18
DHSData |> filter(HouseholdID == "CI.East.51.185.18") |>
  View()

####

#3. HouseholdID is computed incorrectly in some places. E.g. householdID BR.Nordeste.21.10.1 has data from two households
DHSData |> filter(HouseholdID == "BR.Nordeste.21.10.1") |>
  View()
myDHSData |> filter(HouseholdID == "BR.Nordeste.21.10.1") |>
  View()
#Survey weights, IWI, stratum, HHID are different within householdID == "BR.Nordeste.21.10.1"
#But all these variables should be constant within households.

#Also test a bit on a copy of my data:
myDHSData <- readRDS("C:/Users/User/Documents/git/poverty-prediction/cache_220623_000334/DHS_harmonised_data70214091.RDS")
DHSData <- myDHSData

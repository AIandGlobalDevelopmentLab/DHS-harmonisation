numClustersPerStratum <- dt %>% 
  group_by(ClusterID) %>%
  slice_head() %>%
  group_by(country.code.ISO.3166.alpha.3, version, survey_info.stratum) %>%
  summarise(n = n()) %>%
  ungroup()

numPeoplePerCluster <- dt %>% 
  group_by(ClusterID) %>%
  summarise(n = n()) %>%
  ungroup()

numClustersPerCountry <- dt %>%
  group_by(ClusterID) %>%
  slice_head() %>%
  group_by(country.code.ISO.3166.alpha.3, version) %>%
  summarise(n = n()) %>%
  ungroup()

numClustersPerStratum %>% 
  mutate(n = replace(n, which(n > 50), 50)) %>%
  ggplot(aes(x = n)) +
  geom_histogram(breaks = c(seq(0,50,by=1))) +
  scale_x_continuous(limits=c(0, 50), breaks=c(seq(-0.5, 49.5, by=10)), labels=c(seq(0,40, by=10), "50+")) +
  labs(title = "Number of clusters per stratum", x= "", y = "")
ggsave("plots/Pragya1.png")


numClustersPerCountry %>% 
  mutate(n = replace(n, which(n > 2000), 2000)) %>%
  ggplot(aes(x = n)) +
  geom_histogram() +
  scale_x_continuous(labels=c(seq(0,1500, by=500), "2000+")) +
  labs(title = "Number of clusters per country", x= "", y = "")
ggsave("plots/Pragya2.png")

require(dplyr)
require(tidyr)
require(ggplot2)

df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from recalls;"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_cjs2599', PASS='orcl_cjs2599', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


df %>% filter(grepl("[Cc]hild|CHILD", COMMENT_ETXT)) %>% filter(CATEGORY_ETXT != "Child Car Seat" & CATEGORY_ETXT != "Booster Seat") %>% filter(YEAR > 1900) %>% mutate(decade = ntile(YEAR,5)) %>% group_by(MAKE_NAME_NM, YEAR, UNIT_AFFECTED_NBR, CATEGORY_ETXT, decade) %>%  ggplot(aes(x=MAKE_NAME_NM, y=UNIT_AFFECTED_NBR, color=CATEGORY_ETXT)) + geom_point() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) + labs(title="Think Of The Children:\nRecalls Affecting Child Safety") + labs(x="Company(Child Seat Mfrs Excluded)", y="Scope of Recall (# Units Affected)") + facet_grid(~CATEGORY_ETXT~decade)

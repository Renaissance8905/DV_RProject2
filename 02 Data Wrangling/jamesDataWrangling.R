require(tidyr)
require(dplyr)
require(ggplot2)

dfjames <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from recalls;"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_jht585', PASS='orcl_jht585', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

dfjames2 <-data.frame(dfjames)

dfjames2 %>% filter(CATEGORY_ETXT %in% c("Car") | grepl("Truck", CATEGORY_ETXT)) %>% View

dfjames2 %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, UNIT_AFFECTED_NBR, COMMENT_ETXT) %>% filter(CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV", "Bus") |  grepl("Truck", CATEGORY_ETXT),YEAR != -9999, SYSTEM_TYPE_ETXT %in% c("Brakes", "Structure", "Engine", "Airbag") | grepl("Brakes", COMMENT_ETXT) | grepl("Airbag", COMMENT_ETXT) | grepl("Structure", COMMENT_ETXT) | grepl("Engine", COMMENT_ETXT) ) %>% arrange(YEAR) %>% ggplot(aes(x = as.character(SYSTEM_TYPE_ETXT), y = as.numeric(as.character(YEAR)), color = MAKE_NAME_NM)) + facet_grid(.~CATEGORY_ETXT) + geom_point()
  
  
  ggplot () +
  coord_cartesian() +
  scale_x_discrete() +
  scale_y_continuous() +
  facet_grid(CATEGORY_ETXT)+
  labs(title="Recall by Company") +
  labs (x='system', y='year') +
  layer(data=dfjames2,
         mapping=aes(x=as.character(SYSTEM_TYPE_ETXT), y=as.numeric(as.character(YEAR)), color=MAKE_NAME_NM),
         stat="identity", 
         stat_params=list(), 
         geom="point",
         geom_params=list(), 
         #position=position_identity()
         position=position_jitter(width=0.3, height=0)

         )
  
  
  
  

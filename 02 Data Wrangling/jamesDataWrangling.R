require(tidyr)
require(dplyr)
require(ggplot2)

dfjames <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from recalls;"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_jht585', PASS='orcl_jht585', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))


#create new datasets for each particular system failure to study. Use grepl to search for keywords in the comments col, and mutate to make new col that combines info from comments and system col. 

dfbrake <- data.frame(dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter (CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV") |  grepl("Truck", CATEGORY_ETXT),YEAR != -9999, SYSTEM_TYPE_ETXT == "Brake" | grepl("Brake", COMMENT_ETXT) | grepl("BRAKE", COMMENT_ETXT) | grepl("brake", COMMENT_ETXT) ) %>% mutate (SYS_FAIL = "brake"))

dfairbag <- data.frame(dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter (CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV") |  grepl("Truck", CATEGORY_ETXT), YEAR != -9999, SYSTEM_TYPE_ETXT == "airbag" | grepl("airbag", COMMENT_ETXT) | grepl("air bag", COMMENT_ETXT) | grepl("AIRBAG", COMMENT_ETXT) | grepl("AIR BAG", COMMENT_ETXT) ) %>% mutate (SYS_FAIL = "airbag"))

dfstructure <- data.frame(dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter (CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV") |  grepl("Truck", CATEGORY_ETXT),YEAR != -9999, SYSTEM_TYPE_ETXT == "Structure", SYSTEM_TYPE_ETXT != "Brake", SYSTEM_TYPE_ETXT != "Engine", SYSTEM_TYPE_ETXT != "Airbag"| grepl("fracture", COMMENT_ETXT) | grepl("weld", COMMENT_ETXT) | grepl("crack", COMMENT_ETXT) | grepl("CRACK", COMMENT_ETXT) | grepl("CLIPS", COMMENT_ETXT) | grepl("hood", COMMENT_ETXT) | grepl("HOOD", COMMENT_ETXT) | grepl("pin", COMMENT_ETXT) | grepl("PIN", COMMENT_ETXT) | grepl("frame", COMMENT_ETXT) | grepl("mount", COMMENT_ETXT) ) %>% mutate(SYS_FAIL = "structure"))


dfengine <- data.frame(dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter (CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV") |  grepl("Truck", CATEGORY_ETXT),YEAR != -9999, SYSTEM_TYPE_ETXT == "engine" | grepl("ENGINE", COMMENT_ETXT) | grepl("cylinder", COMMENT_ETXT) | grepl("CYLINDER", COMMENT_ETXT)) %>% mutate (SYS_FAIL = "engine"))


#Use Union set operator to connect all into one dataframe

dfsysfail <- dplyr::union(dfengine, dfbrake)

dfsysfail <- dplyr::union(dfsysfail, dfairbag)

dfsysfail <- dplyr::union(dfsysfail, dfstructure)
View (dfsysfail)

#pass into ggplot
dfsysfail %>% ggplot(aes(x = as.character(SYS_FAIL), y = as.numeric(as.character(YEAR)), color = MAKE_NAME_NM)) + facet_grid(.~CATEGORY_ETXT) + geom_point() + theme(axis.text.x=element_text(angle=50, size=10, vjust=0.5))



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
  
  
  
  

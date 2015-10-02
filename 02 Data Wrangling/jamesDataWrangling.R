require(tidyr)
require(dplyr)
require(ggplot2)

dfjames <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from recalls;"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_jht585', PASS='orcl_jht585', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter(CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV") |  grepl("Truck", CATEGORY_ETXT),YEAR != -9999, SYSTEM_TYPE_ETXT %in% c("Brakes", "Structure", "Engine", "Airbag") | grepl("Brake", COMMENT_ETXT) | grepl("BRAKE", COMMENT_ETXT) | grepl("brake", COMMENT_ETXT) | grepl("Airbag", COMMENT_ETXT) | grepl("Structure", COMMENT_ETXT) | grepl("Engine", COMMENT_ETXT) ) %>% arrange(YEAR) %>% ggplot(aes(x = as.character(SYSTEM_TYPE_ETXT), y = as.numeric(as.character(YEAR)), color = MAKE_NAME_NM)) + facet_grid(.~CATEGORY_ETXT) + geom_point() + theme(axis.text.x=element_text(angle=50, size=10, vjust=0.5))


 
dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter (CATEGORY_ETXT == "Car", YEAR != -9999) %>% View

#create new datasets to operate on

dfengine <- data.frame(dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter (CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV") |  grepl("Truck", CATEGORY_ETXT),YEAR != -9999,  )

dfbrake <- data.frame(dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter (CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV") |  grepl("Truck", CATEGORY_ETXT),YEAR != -9999))

dfstructure <- data.frame(dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter (CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV") |  grepl("Truck", CATEGORY_ETXT),YEAR != -9999))

dfengine <- data.frame(dfjames %>% select(CATEGORY_ETXT, MAKE_NAME_NM, SYSTEM_TYPE_ETXT, YEAR, COMMENT_ETXT) %>% filter (CATEGORY_ETXT %in% c("Car", "Motorcycle", "SUV") |  grepl("Truck", CATEGORY_ETXT),YEAR != -9999))




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
  
  
  
  

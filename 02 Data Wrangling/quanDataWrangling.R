require(tidyr)
require(dplyr)
require(ggplot2)
require("jsonlite")
require("RCurl")

df <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from recalls"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_qan74', PASS='orcl_qan74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

quandf <- df %>% select(MAKE_NAME_NM, SYSTEM_TYPE_ETXT, UNIT_AFFECTED_NBR, YEAR) %>% group_by(YEAR) %>% filter(MAKE_NAME_NM %in% c("HONDA", "ACURA"), SYSTEM_TYPE_ETXT != "Accessories", SYSTEM_TYPE_ETXT != "Label")

View(quandf)

ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  labs(title='Honda/Acura Recalls') +
  labs(x="YEAR", y="UNITS AFFECTED") +
  layer(data=quandf, 
        mapping=aes(x= as.numeric(as.character(YEAR)), y=as.numeric(as.character(UNIT_AFFECTED_NBR)), color=SYSTEM_TYPE_ETXT), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        position=position_jitter(width=0.3, height=0)
)
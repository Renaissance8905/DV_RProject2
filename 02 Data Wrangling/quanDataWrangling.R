require(tidyr)
require(dplyr)
require(ggplot2)
require("jsonlite")
require("RCurl")

dfquan <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from recalls"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_qan74', PASS='orcl_qan74', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

View(dfquan)

dfquan %>% select(MAKE_NAME_NM, MODEL_NAME_NM, SYSTEM_TYPE_ETXT, UNIT_AFFECTED_NBR, YEAR) %>% group_by(MODEL_NAME_NM) %>% filter(MAKE_NAME_NM %in% c("HONDA", "ACURA"), SYSTEM_TYPE_ETXT != "Not Entered", SYSTEM_TYPE_ETXT != "Other", SYSTEM_TYPE_ETXT != "Accessories") %>% ggplot(aes(x = as.numeric(as.character(YEAR)), y = as.numeric(as.character(UNIT_AFFECTED_NBR)), color = SYSTEM_TYPE_ETXT)) + geom_point()
# ETL Script for Vehicle Recall Data for DV_RProject2
require(dplyr)

file_path <- ("~/DataVisualization/DV_RProject2/vrdb_full_monthly.csv")

# read raw csv into dataframe df
df <- read.csv(file_path, stringsAsFactors = FALSE)

# scrub column names for periods, replace with underscore
names(df) <- gsub("\\.+", "_", names(df))

# check your data
str(df)

# defined 3 measures
measures <- c("RECALL_NUMBER_NUM", "YEAR", "UNIT_AFFECTED_NBR")

# scrub special characters
for(n in names(df)) {
  df[n] <- data.frame(lapply(df[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(df), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}

# no dates to format


# Get rid of all characters in measures except for numbers, the - sign, and periods
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    df[m] <- data.frame(lapply(df[m], gsub, pattern="[^--.0-9]",replacement= ""))
  }
}

# pares data down to 1/14th of original size (with evenly-spaced row selection)
smalldf <- df %>% filter(row_number() %% 14 == 0)
summary(smalldf)


write.csv(smalldf, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)

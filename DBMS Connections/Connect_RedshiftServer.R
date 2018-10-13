#Connect_RedshiftServer.R
library(RJDBC)

# download Amazon Redshift JDBC driver if the file doesn't exist
if(!file.exists('/DBMS\ Connections/RedshiftJDBC41-1.1.9.1009.jar')) {
  download.file('http://s3.amazonaws.com/redshift-downloads/drivers/RedshiftJDBC41-1.1.9.1009.jar','DBMS\ Connections/RedshiftJDBC41-1.1.9.1009.jar')
}

# read username and password
source("keys.R")

# set up connection
path01 <- getwd()
drv <- JDBC("com.amazon.redshift.jdbc41.Driver", paste0(path01,"/DBMS\ Connections/RedshiftJDBC41-1.1.9.1009.jar", identifier.quote=""))

# connect to Amazon Redshift
# url <- "<JDBCURL>:<PORT>/<DBNAME>
url <- "jdbc:redshift://dq1-ohdsielasticbeanstalk-c5-redshiftclustermulti-48ubh6gmfltt.cycqgb2nm38n.us-east-1.redshift.amazonaws.com:5439/mycdm?ssl=true"
conn <- dbConnect(drv, url, usrnm, pss)

rm(pss)

#######
######## If you don't know your data base name and address, contact your server admin.
#######

##install/load required packages
source("DQe-c Functions/libs.R")

###identify data model PCORnet V3
###CDM = "PCORNET3" #set to PCORNET31, if you have the latest CDM

###identify data model
# Options
#   PCORNET3
#   PCORNET31
#   OMOPV5_0
#   OMOPV5_2
#   OMOPV5_3

CDM = "OMOPV5_0"

###identify SQL connection Oracle or SQL Server
## options: SQLServer, Oracle, PostgreSQL, Redshift
SQL = "Redshift" ## "PostgreSQL" ##  ## SET to "Oracle" is Oracle is your RDBMS

## if you have your tables in a particular SQL schema, identify the schema here:
#schema = "" ## default is that there is no schema. SET SCHEMA NAME, IF THERE IS ONE
#Options
#   "cmsdesynpuf1k"
#   "cmsdesynpuf23m"
#   "mimiciii100"
#
schema = "cmsdesynpuf23m"

## is there a prefix for table names in your database?
prefix = "" ## default at none. SET PREFIX, IF THERE IS ONE


## enter the organization name you are running the test on
org = "University of Washington" # SET Your Organization Name



##Now first run the test
source("without.R")

source("Comp_test.R")


options(bitmapType='cairo')
## then generate the html report
rmarkdown::render("Report.Rmd")



##source("DQe-v_queries.R")


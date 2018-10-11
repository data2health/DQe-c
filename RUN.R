
##install/load required packages
source("DQe-c Functions/libs.R")


###identify data model
# Options
#   PCORNET3
#   PCORNET31
#   OMOPV5_0
#   OMOPV5_2
#   OMOPV5_3

CDM = ""

###identify SQL connection
## options: SQLServer, Oracle, PostgreSQL, Redshift
SQL = "" 


## if you have your tables in a particular SQL schema, identify the schema here:
## default is that there is no schema. SET SCHEMA NAME, IF THERE IS ONE
#Options
#   "cmsdesynpuf1k"
#   "cmsdesynpuf23m"
#   "mimiciii100"
#
schema = ""

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


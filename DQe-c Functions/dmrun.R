source("DQe-c Functions/freq.R")

################################################################################################################################
################################################################################################################################
################################################################################################################################
########## THIS SCRIPT RUNS ORPHAN KEYS' TESTS
################################################################################################################################
################################################################################################################################



## create data frame to store only columns and tables that have related key and/or primary keys for data model test 
if (CDM %in% c("PCORNET3","PCORNET31")) {
  
  DQTBL_KEYS <- select(subset(DQTBL, ColNam %in% c("patid","encounterid","providerid","prescribingid","enc_type")),TabNam, ColNam, UNIQFRQ)
  ## creating an index for plotting: Count In means number rof unique frequencies that exist in the reference table
  DQTBL_KEYS$Index <- "Count_In"
  dmtest <- parse(file = "PCORI Functions/dmtest_pcornet3.R")

  } else 
  if (CDM %in% c("OMOPV5_0")) {
  
    DQTBL_KEYS <- select(subset(DQTBL, ColNam %in% c("person_id","care_site_id","visit_occurrence_id","location_id")),TabNam, ColNam, UNIQFRQ)
  ## creating an index for plotting: Count In means number rof unique frequencies that exist in the reference table
  DQTBL_KEYS$Index <- "Count_In"
  dmtest <- parse(file = "OMOP Functions/dmtest_omop5.R")

  } else 
  if (CDM %in% c("OMOPV5_2", "OMOPV5_3")) {
  
    DQTBL_KEYS <- select(subset(DQTBL, ColNam %in% c("person_id","care_site_id","visit_occurrence_id","location_id")),TabNam, ColNam, UNIQFRQ)
  ## creating an index for plotting: Count In means number rof unique frequencies that exist in the reference table
  DQTBL_KEYS$Index <- "Count_In"
  dmtest <- parse(file = "OMOP Functions/dmtest_omop5.R")
}
  

print ("Testing for orphan keys")
for (i in seq_along(dmtest)) {
  tryCatch(eval(dmtest[[i]]), 
           error = function(e) message("Error in dmrun: ", as.character(e)))
}


###### this test is working based on DQTBL_KEYS 


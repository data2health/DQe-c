################ OMOP V5 Data Model Orphan Keys test

orphan_key_query <- function(out_table, ref_table, ref_col) {
  data <- dbGetQuery(conn, paste0("SELECT COUNT (DISTINCT outtbl.",ref_col,")
                                    FROM ",prefix,schema,out_table," outtbl
                                    WHERE NOT EXISTS (
                                      SELECT *
                                      FROM ",prefix,schema,ref_table," ref_tbl
                                      WHERE ref_tbl.",ref_col,"=","outtbl.",ref_col,"
                                    );"))
  
  return (data$count)
}


# Reference means that the column value is reference for all other tables that have the same column
DQTBL_KEYS$Index <- ifelse(((DQTBL_KEYS$TabNam == "person" & DQTBL_KEYS$ColNam == "person_id") |
                              (DQTBL_KEYS$TabNam == "visit_occurrence" & DQTBL_KEYS$ColNam == "visit_occurrence_id") |
                              (DQTBL_KEYS$TabNam == "organization" & DQTBL_KEYS$ColNam == "organization_id") |
                              (DQTBL_KEYS$TabNam == "care_site" & DQTBL_KEYS$ColNam == "care_site_id") |
                              (DQTBL_KEYS$TabNam == "location" & DQTBL_KEYS$ColNam == "location_id") |
                              (DQTBL_KEYS$TabNam == "visit_detail" & DQTBL_KEYS$ColNam == "visit_detail_id")
                              ),
                           "Reference",
                           DQTBL_KEYS$Index)



#Copy the data frame to store not counted ids (the ones that are not available in the reference column)
DQTBL_KEYS2 <- subset(DQTBL_KEYS, DQTBL_KEYS$Index != "Reference")
DQTBL_KEYS2$Index <- "Count_Out"
DQTBL_KEYS2$UNIQFRQ <- 0

DQTBL_KEYS <- rbind(DQTBL_KEYS,DQTBL_KEYS2)

### Now let's count the number of unique ids that do not exist in the reference column and assign related values to them
## and then subtracting the number of counted outs from the number of counted ins

#person id
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("observation", "person", "person_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


DQTBL_KEYS[(DQTBL_KEYS$TabNam == "visit_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("visit_occurrence", "person", "person_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "visit_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "visit_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "visit_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("drug_exposure", "person", "person_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("procedure_occurrence", "person", "person_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("condition_occurrence", "person", "person_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "person_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


#care site id

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "provider" & DQTBL_KEYS$ColNam == "care_site_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("provider", "care_site", "care_site_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "provider" & DQTBL_KEYS$ColNam == "care_site_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "provider" & DQTBL_KEYS$ColNam == "care_site_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "provider" & DQTBL_KEYS$ColNam == "care_site_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


DQTBL_KEYS[(DQTBL_KEYS$TabNam == "visit_occurrence" & DQTBL_KEYS$ColNam == "care_site_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("visit_occurrence", "care_site", "care_site_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "visit_occurrence" & DQTBL_KEYS$ColNam == "care_site_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "visit_occurrence" & DQTBL_KEYS$ColNam == "care_site_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "visit_occurrence" & DQTBL_KEYS$ColNam == "care_site_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


#visit_occurrence_id
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("condition_occurrence", "visit_occurrence", "visit_occurrence_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("drug_exposure", "visit_occurrence", "visit_occurrence_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("observation", "visit_occurrence", "visit_occurrence_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("procedure_occurrence", "visit_occurrence", "visit_occurrence_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "visit_occurrence_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


# location_id
DQTBL_KEYS[(DQTBL_KEYS$TabNam == "person" & DQTBL_KEYS$ColNam == "location_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("person", "location", "location_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "person" & DQTBL_KEYS$ColNam == "location_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "person" & DQTBL_KEYS$ColNam == "location_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "person" & DQTBL_KEYS$ColNam == "location_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


DQTBL_KEYS[(DQTBL_KEYS$TabNam == "care_site" & DQTBL_KEYS$ColNam == "location_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
  orphan_key_query("care_site", "location", "location_id")

DQTBL_KEYS[(DQTBL_KEYS$TabNam == "care_site" & DQTBL_KEYS$ColNam == "location_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "care_site" & DQTBL_KEYS$ColNam == "location_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "care_site" & DQTBL_KEYS$ColNam == "location_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


if (CDM %in% c("")) {
  # visit_detail_id
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
    orphan_key_query("condition_occurrence", "visit_detail", "visit_detail_id")
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "condition_occurrence" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 


  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "device_exposure" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
    orphan_key_query("device_exposure", "visit_detail", "visit_detail_id")
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "device_exposure" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "device_exposure" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "device_exposure" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 
  
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
    orphan_key_query("drug_exposure", "visit_detail", "visit_detail_id")
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "drug_exposure" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 
  
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "measurement" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
    orphan_key_query("measurement", "visit_detail", "visit_detail_id")
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "measurement" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "measurement" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "measurement" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 
  
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "note" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
    orphan_key_query("note", "visit_detail", "visit_detail_id")
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "note" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "note" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "note" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 
  
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
    orphan_key_query("observation", "visit_detail", "visit_detail_id")
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "observation" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 
  
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] <- 
    orphan_key_query("procedure_occurrence", "visit_detail", "visit_detail_id")
  
  DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] <- 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_In"),"UNIQFRQ"] - 
    DQTBL_KEYS[(DQTBL_KEYS$TabNam == "procedure_occurrence" & DQTBL_KEYS$ColNam == "visit_detail_id" & DQTBL_KEYS$Index == "Count_Out"),"UNIQFRQ"] 
}


write.csv(DQTBL_KEYS, file = paste("reports/DM_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))

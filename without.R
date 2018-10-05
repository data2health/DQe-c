source("dmrun.R")

#########################################################################
### finding out how many patients don't have specific health variables.##
#########################################################################





if (CDM %in% c("PCORNET3","PCORNET31")) {
  
  ##gender
  
  #define the only wanted values
  gender <- c("M","F")
  
  without_gender <- withoutdem(table = demographic, col = "sex", ref_date2 = "2014-01-01" ,list = gender)
  
  ##race -- make sure we understand what values are in accepted list!
  race <- c("05","03","07","02","01","04","06","OT")
  
  without_race <- withoutdem(table = demographic, col = "race", ref_date2 = "2014-01-01" ,list = race)
  
  
  #ethnicity
  ethnicity <- c("Y") 
  
  without_ethnicity <- withoutdem(table = demographic, col = "hispanic", ref_date2 = "2014-01-01" ,list = ethnicity)
  
  
  
  ##################
  ##################
  ######### Using Function "WITHOUT"
  ####################
  ####################
  
  # medication
  #define the uwanted values in addition to NULLs...
  medication <- c("","%","$","#","@","NI")
  # 
  without_medication <- 
    without(table = "PRESCRIBING", col = "prescribingid", ref_date2 = "2014-01-01" ,list = medication)
  
  
  
  #Dx -------------
  #define the uwanted values in addition to NULLs...
  diagnosis <- c("","%","$","#","@","NI")
  # 
  without_diagnosis <- 
    without(table = "DIAGNOSIS", col = "dx", ref_date2 = "2014-01-01" ,list = diagnosis)
  
  
  #Encounter -------------
  #define the uwanted values in addition to NULLs...
  encounter <- c("","%","$","#","@","NI")
  # 
  without_encounter <- 
    without(table = "ENCOUNTER", col = "enc_type", ref_date2 = "2014-01-01" ,list = encounter)
  
  
  #Weight -------------
  #define the uwanted values in addition to NULLs...
  weight <- c("","%","$","#","@","NI")
  # 
  without_weight <- 
    without(table = "VITAL", col = "wt", ref_date2 = "2014-01-01" ,list = weight)
  
  
  
  #Height -------------
  #define the uwanted values in addition to NULLs...
  height <- c("","%","$","#","@","NI","NI")
  # 
  without_height <- 
    without(table = "VITAL", col = "ht", ref_date2 = "2014-01-01" ,list = height)
  
  
  #blood_pressure -------------
  #define the uwanted values in addition to NULLs...
  blood_pressure <- c("","%","$","#","@","NI")
  # 
  without_BP_sys <- 
    without(table = "VITAL", col = "systolic", ref_date2 = "2014-01-01" ,list = blood_pressure)
  
  without_BP_dias <- 
    without(table = "VITAL", col = "diastolic", ref_date2 = "2014-01-01" ,list = blood_pressure)
  
  # without_BP <- rbind(without_BP_sys,without_BP_dias)
  without_BP <- without_BP_sys
  
  #smoking -------------
  #define the uwanted values in addition to NULLs...
  smoking <- c("","%","$","#","@","NI")
  # 
  without_smoking <- 
    without(table = "VITAL", col = "smoking", ref_date2 = "2014-01-01" ,list = smoking)
  
  
  
  withouts <- rbind(without_encounter,without_diagnosis,without_medication,without_ethnicity,without_race,without_gender,without_weight,
                    without_height,without_BP,without_smoking)
  
  
  
  withouts$perc <- percent(withouts$missing.percentage)
  withouts$organization <- org
  withouts$test_date <- as.character(format(Sys.Date(),"%m-%d-%Y"))
  withouts$CDM <- CDM
  
  write.csv(withouts, file = paste("reports/withouts_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))
  
  ## make another copy in the comparison directory for comparison
  # write.csv(withouts, file = paste("PATH/withouts_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))
  
} else if (CDM %in% c("OMOPV5_0", "OMOPV5_2", "OMOPV5_3")) {
  
  
  #define the only wanted values
  gender <- dbGetQuery(conn, paste0("SELECT concept_id FROM ",schema,prefix,"CONCEPT WHERE domain_id='Gender';"))
  gender <- as.vector(gender[['concept_id']])
  without_gender <- withoutdem(table = person, col = "gender_concept_id", ref_date2 = "2018-10-01", list = gender)
  
  ##race -- make sure we understand what values are in accepted list!
  race <- dbGetQuery(conn, paste0("SELECT concept_id FROM ",schema,prefix,"CONCEPT WHERE domain_id='Race';"))
  race <- as.vector(race[['concept_id']])
  without_race <- withoutdem(table = person, col = "race_concept_id", ref_date2 = "2018-10-01" ,list = race)
  
  
  #ethnicity
  ethnicity <- c(38003563,38003564) 
  without_ethnicity <- withoutdem(table = person, col = "ethnicity_concept_id", ref_date2 = "2018-10-01" ,list = ethnicity)
  
  #weight-looking for concept_ids codes for observation of weight
  weight <- c(4178502, 4099154, 4310154, 40484200, 425024002)
  # 
  without_weight <- 
    isPresent(table = "MEASUREMENT", col = "measurement_concept_id", ref_date2 = "2018-10-01" ,list = weight)
  
  #height - looking for OMOP concept ids for observation of height
  height <- c(4177340, 4087492, 4154781)
  # 
  without_height <- 
    isPresent(table = "MEASUREMENT", col = "measurement_concept_id", ref_date2 = "2018-10-01" ,list = height)
  
  #blood_pressure
  blood_pressure <- c(4152194, 4154790, 4326744)
  # 
  without_BP_sys <- 
    isPresent(table = "MEASUREMENT", col = "measurement_concept_id", ref_date2 = "2018-10-01" ,list = blood_pressure)

  without_BP <- without_BP_sys
  
  #checks if patiets have a smoking status - looks for codes in this reference https://phinvads.cdc.gov/vads/ViewValueSet.action?id=E7943851-2633-E211-8ECF-001A4BE7FA90
  smoking <- c(4310250, # ex smoker
               40299112, # ex smoker
               40329177, # ex smoker
               40298672, # ex smoker
               40329167, # ex smoker
               42536346, # ex smoker
               46270534, # ex smoker
               4144272, # never smoked
               45879404, # never smoked
               42872410, # never smoked
               40298657, # never smoked
               45883537, # never smoked
               45884038, # heavy smoker
               4298794, #smoker (old code)
               40427925, #smoker (old code)
               40299110, # smoker
               45878118, # light smoker
               42709996, # smokes daily
               45884037, # current some day smoker)
               4141786 # unknown smoking status
              ) 
  # 
  without_smoking <- 
    isPresent(table = "MEASUREMENT", col = "measurement_concept_id", ref_date2 = "2018-10-01" ,list = smoking)
  
  
  ##################
  ##################
  ######### Using Function "WITHOUT"
  ####################
  ####################
  
  # medication
  without_medication <- 
    isPresent(table = "DRUG_EXPOSURE", col = "drug_exposure_id", concept="Drug", ref_date2 = "2018-10-01" ,list = c())
  
  #Dx
  without_diagnosis <- 
    isPresent(table = "CONDITION_OCCURRENCE", col = "condition_occurrence_id", concept="Condition", ref_date2 = "2018-10-01" ,list = c())
  
  #Encounter -------------
  #define the uwanted values in addition to NULLs...
  encounter <- c("","%","$","#","@","NI")
  # 
  without_encounter <- 
    without(table = "VISIT_OCCURRENCE", col = "visit_occurrence_id", ref_date2 = "2018-10-01" ,list = encounter)
  
  
  
  withouts <- rbind(without_encounter,without_diagnosis,without_medication,without_ethnicity,without_race,without_gender,without_weight,
                    without_height,without_BP,without_smoking)
  
  
  
  withouts$perc <- percent(withouts$missing.percentage)
  withouts$organization <- org
  withouts$test_date <- as.character(format(Sys.Date(),"%m-%d-%Y"))
  withouts$CDM <- CDM
  
  write.csv(withouts, file = paste("reports/withouts_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))
  
}



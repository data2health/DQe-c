
## these functions calculate the percentages of the different variables that patients are missing in the data

test <- dbGetQuery(conn, paste0("SELECT DISTINCT obs.observation_concept_id, co.concept_name, co.concept_code
                                FROM cmsdesynpuf23m.observation obs INNER JOIN cmsdesynpuf23m.concept co
                                on co.concept_id=obs.observation_concept_id
                                WHERE co.concept_name LIKE '%pulse%';"))
#print (test)
#stop()

## ====================================
## Gender
gender <- dbGetQuery(conn, paste0("SELECT concept_id FROM ",schema,prefix,"CONCEPT WHERE domain_id='Gender';"))
Gender <- as.vector(gender[['concept_id']])
without_gender <- withoutdem(table = person, col = "gender_concept_id", ref_date2 = "2018-10-01", list = Gender)


## ====================================
## Race
race <- dbGetQuery(conn, paste0("SELECT concept_id FROM ",schema,prefix,"CONCEPT WHERE domain_id='Race';"))
Race <- as.vector(race[['concept_id']])
without_race <- withoutdem(table = person, col = "race_concept_id", ref_date2 = "2018-10-01" ,list = Race)


## ====================================
## Ethnicity
Ethnicity <- c(38003563,38003564) 
without_ethnicity <- withoutdem(table = person, col = "ethnicity_concept_id", ref_date2 = "2018-10-01" ,list = Ethnicity)


## ====================================
#Weight -- looking for concept_ids codes for measurement of weight
weight_parents = c(4181041,4184608,45876171,4103471,44804668,4030015)
Weight <- getChildConcepts(weight_parents)
without_weight <- 
  isPresent(table = "MEASUREMENT", col = "measurement_concept_id", ref_date2 = "2018-10-01" ,list = Weight)


## ====================================
#Height -- looking for OMOP concept ids for observation of height
height_parents <- c(4177340,4087492,4154781,4275188,44804668)
Height <- getChildConcepts(height_parents)
without_height <- 
  isPresent(table = "MEASUREMENT", col = "measurement_concept_id", ref_date2 = "2018-10-01" ,list = Height)


## ====================================
#blood pressure -- gathers the descendant concepts from concept ancestor and then searches measurement
BP_parent <- c(45876174,4326744)
BP <- getChildConcepts(BP_parent)
without_BP <- 
  isPresent(table = "MEASUREMENT", col = "measurement_concept_id", ref_date2 = "2018-10-01" ,list = BP)


## ====================================
# Smoking Status
#checks if patients have a smoking status
#looks for codes in this reference https://phinvads.cdc.gov/vads/ViewValueSet.action?id=E7943851-2633-E211-8ECF-001A4BE7FA90
Smoker <- c(4310250, # ex smoker
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
            45884037, # current some day smoker
            43530634, # invalid code but is still used sometimes
            4141786 # unknown smoking status
) 
without_smoking <- 
  isPresent(table = "OBSERVATION", col = "observation_concept_id", ref_date2 = "2018-10-01" ,list = Smoker)


## ====================================
## Heart Rate -- Gathers the descendants of the HR parent code and searches measurement table
HR <- getChildConcepts(4239408)
without_HR <- 
  isPresent(table = "MEASUREMENT", col = "measurement_concept_id", ref_date2 = "2018-10-01" ,list = HR)


##################
##################
######### Using Function "WITHOUT"
####################
####################

# Medication -------------
# define the uwanted values in addition to NULLs...
Medication = c("","%","$","#","@","NI")
without_medication <- 
  without(table = "DRUG_EXPOSURE", col = "drug_exposure_id", ref_date2 = "2018-10-01" ,list = Medication)

# Dx -----------
# define the uwanted values in addition to NULLs...
Condition <- c("","%","$","#","@","NI")
without_diagnosis <- 
  without(table = "CONDITION_OCCURRENCE", col = "condition_occurrence_id", ref_date2 = "2018-10-01" ,list = Condition)

# Visit -------------
# define the uwanted values in addition to NULLs...
Visit <- c("","%","$","#","@","NI")
without_visit <- 
  without(table = "VISIT_OCCURRENCE", col = "visit_occurrence_id", ref_date2 = "2018-10-01" ,list = Visit)



withouts <- rbind(without_visit,without_diagnosis,without_medication,without_ethnicity,without_race,without_gender,without_weight,
                  without_height,without_BP,without_smoking, without_HR)



withouts$perc <- percent(withouts$missing.percentage)
withouts$organization <- org
withouts$test_date <- as.character(format(Sys.Date(),"%m-%d-%Y"))
withouts$CDM <- CDM

write.csv(withouts, file = paste("reports/withouts_",CDM,"_",org,"_",as.character(format(Sys.Date(),"%d-%m-%Y")),".csv", sep=""))

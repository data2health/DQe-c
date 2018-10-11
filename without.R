source("DQe-c Functions/dmrun.R")

#########################################################################
### finding out how many patients don't have specific health variables.##
#########################################################################


if (CDM %in% c("PCORNET3","PCORNET31")) {
  
  source("PCORI Functions/PCORI_without.R")
  
} else if (CDM %in% c("OMOPV5_0", "OMOPV5_2", "OMOPV5_3")) {
  
  source("OMOP Functions/OMOP_without.R")

}



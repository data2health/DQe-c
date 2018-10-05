#Connection string for the OMOP database on Redshift
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "redshift",
                                                                server = "ohdsitutorialtest2-ohdsielas-redshiftclustermulti-1sizz9gq0e4uq.cc8ltappgfjt.us-east-1.redshift.amazonaws.com/mycdm",
                                                                user = "master",
                                                                password = "Password1")

#Schema names for the CMS DeSynPUF 1,000 person dataset
cdmDatabaseSchema <- "CMSDESynPUF1k"
cohortsDatabaseSchema <- "CMSDESynPUF1kresults"

#Schema names for the CMS DeSynPUF 2.3 million person dataset
#cdmDatabaseSchema <- "CMSDESynPUF23m"
#cohortsDatabaseSchema <- "CMSDESynPUF23mresults"
### Install and load all libraries 

if (!require("devtools")) { install.packages('devtools', dependencies=TRUE, repos="http://cran.us.r-project.org") }
if (!require("DT")) devtools::install_github('rstudio/DT')
if (!require("plyr")) install.packages('plyr',repos = "http://cran.us.r-project.org")
if (!require("dplyr")) install.packages('dplyr',repos = "http://cran.us.r-project.org")
if (!require("data.table")) install.packages('data.table',repos = "http://cran.us.r-project.org")
if (!require("dtplyr")) install.packages('dtplyr',repos = "http://cran.us.r-project.org")
if (!require("ggplot2")) devtools::install_github('hadley/ggplot2')
if (!require("gridExtra")) install.packages('gridExtra',repos = "http://cran.us.r-project.org")
if (!require("RPostgreSQL")) install.packages('RPostgreSQL',repos = "http://cran.us.r-project.org")
if (!require("rmarkdown")) install.packages('rmarkdown',repos = "http://cran.us.r-project.org")
if (!require("plotly")) install.packages('plotly',repos = "http://cran.us.r-project.org")
if (!require("DT")) install.packages('DT',repos = "http://cran.us.r-project.org")
if (!require("treemap")) install.packages('treemap',repos = "http://cran.us.r-project.org")
if (!require("reshape2")) install.packages('reshape2',repos = "http://cran.us.r-project.org")
if (!require("RJDBC")) install.packages('RJDBC',repos = "http://cran.us.r-project.org")
if (!require("visNetwork")) install.packages('visNetwork',repos = "http://cran.us.r-project.org")
if (!require("xfun")) install.packages('xfun',repos = "http://cran.us.r-project.org")
if (!require("rmdformats")) devtools::install_github("juba/rmdformats")
if (!require("visNetwork")) devtools::install_github("datastorm-open/visNetwork")
if (!require("ggbeeswarm")) devtools::install_github("eclarke/ggbeeswarm")
#if (!require("tcltk")) install.packages('tcltk',repos = "http://cran.us.r-project.org")


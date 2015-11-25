require(reshape)
require(plyr)
require(parallel) 
library(nb2)
# Given a dataframe of (age + gender adjusted person year rates) values by 
# county fipscode in the US, this code shows an example for running 
# the nb2 algorithm and outputs various statistics for each value.

## Load in example data by fipscode
data(censusqf)  # sample dataframe constructued from census quick facts http://quickfacts.census.gov/qfd/download_data.html
values <- names(censusqf[,2:ncol(censusqf)])

## Set number of simulations to run
Nnum <- seq(1:10) # set to 10

## Set output filenames
run.mc.ttest = TRUE
ttest.outfile = 'nb2-ttest.txt'
run.mc.odds = TRUE
odds.outfile = 'nb2-odds.txt'

##################################################################
##################################################################
## Loading geospatial /neighbors data
data(contusa_counties)
## Chosen here: contiguity - queen
data(contusa_counties.wts)

## Combine data with geospatial /neighbors county information
rates_counties <- contusa_counties
rates_counties@data = data.frame(rates_counties@data, censusqf[match(rates_counties@data[,'fipscode'],censusqf[,'fipscode']),])
### getting rid of extra column
rates_counties@data$fipscode.1 <- NULL

##################################################################
## Monte Carlo neighbor influence - paired t-test
##################################################################
if (run.mc.ttest == TRUE) {

    # Run neighbor code in parallel
    set.seed(123456,"L'Ecuyer")
    mcResultsTtest <- lapply(values,runMCttest)
    row.names(mcResultsTtest) <- NULL
    dfResultsTtest <- do.call("rbind",mcResultsTtest)
    row.names(dfResultsTtest) <- NULL
    write.csv(dfResultsTtest, file=ttest.outfile,quote=F,row.names=F)

}

##################################################################
## Monte Carlo neighbor influence - odds
##################################################################
if (run.mc.odds == TRUE) {

    # Run neighbor code in parallel
    set.seed(123456,"L'Ecuyer")
    mcResultsOdds <- lapply(values,runMCodds)
    row.names(mcResultsOdds) <- NULL
    dfResultsOdds <- do.call("rbind",mcResultsOdds)
    row.names(dfResultsOdds) <- NULL
    write.csv(dfResultsOdds, file=odds.outfile,quote=F,row.names=F)

}





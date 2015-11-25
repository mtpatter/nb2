## Pick X random counties.  Must choose weight style, Q vs R, W vs B.
## For each county Y,   get N neighbors Z=log(Y) values
##                      get N random Z=log(Y) values
##      predict Z_neighb(Y)   (for now this will be average of N neighbors)
##      predict Z_random(Y)   (for now this will be average of N random)
##      have Z_actual(Y)
## As function of X,    get mean squared error
##                      get root mean squared error
##              plot above for Z_neighb
##              plot above for Z_random
## Look at paired t-test to see if neighbor's is improvement over random.
drawNeighborsTtest <- function(i,code,rates_counties) {
        i
        Xnum = nrow(rates_counties) # number of counties to draw with replacement (just number of counties)
        # Get list of indices for chosen counties
        chosen <- sample(1:nrow(rates_counties),Xnum,replace=TRUE)

        # Given a county index, get the log(Y+1) prediction from N neighbors with replacement
        predZ_neighbor <- function(countyindex){
                Nneighb <- length(contusa_counties.wts$neighbours[[countyindex]])
                indiceslist <- sample(contusa_counties.wts$neighbours[[countyindex]],Nneighb,replace=T)
                mean(log10(rates_counties[[code]][indiceslist]+1),na.rm=TRUE)
                }
        # Given a county index, get the log(Y+1) prediction from N random counties with replacement
        predZ_random <- function(countyindex){
                Nneighb <- length(contusa_counties.wts$neighbours[[countyindex]])
                indiceslist <- sample(1:nrow(rates_counties),Nneighb,replace=T)
                mean(log10(rates_counties[[code]][indiceslist]+1),na.rm=TRUE)
                }
        # Call the predictions for Z
        predZlist_neighbor <- sapply(chosen,predZ_neighbor)
        predZlist_random <- sapply(chosen,predZ_random)
        actual <- log10(rates_counties[[code]][chosen]+1)

        # Calc some stats
        se <- function(actual, predicted) { (actual - predicted)^2}
        mse <- function(actual, predicted) { mean(se(actual,predicted),na.rm=T) }
        rmse <- function(actual, predicted) { sqrt(mse(actual,predicted)) }
        mse_neighb <- round( mse(actual,predZlist_neighbor), 3)
        mse_random <- round( mse(actual,predZlist_random), 3)
        rmse_neighb <- round( rmse(actual,predZlist_neighbor), 3)
        rmse_random <- round( rmse(actual,predZlist_random), 3)

        diff_neighb <- abs(predZlist_neighbor - actual)
        diff_random <- abs(predZlist_random - actual)
        #print(paste('mse neighbors:',mse_neighb))
        #print(paste('rmse neighbors:',rmse_neighb))
        #print(paste('mse random:',mse_random))
        #print(paste('rmse random:',rmse_random))
        ttest <- t.test(diff_random,diff_neighb, paired=TRUE)
        #print(ttest)
        Xresults <- data.frame(rmse_neighb,rmse_random,ttest$p.value,ttest$estimate)
        }


## Pick X random counties.  Must choose weight style, Q vs R, W vs B.
## For each county Y,   get N neighbors Z=log(Y) values
##                      get N random Z=log(Y) values
##      predict Z_neighb(Y)   (for now this will be average of N neighbors)
##      predict Z_random(Y)   (for now this will be average of N random)
##      have Z_actual(Y)
## Look at odds ratio to see if neighbor's is improvement over random.

drawNeighborsOdds <- function(i,code,rates_counties) {
        i
        Xnum = nrow(rates_counties) # number of counties to draw with replacement
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

        # Which is better, neighbors or random?
        diff_neighb <- abs(predZlist_neighbor - actual)
        diff_random <- abs(predZlist_random - actual)

        results <- data.frame(predZlist_neighbor,predZlist_random,actual)
        neighbor.actual <- median(abs(results$predZlist_neighbor - results$actual), na.rm=T)
 	random.actual <- median(abs(results$predZlist_random - results$actual),na.rm=T)
        Xresults <- data.frame(neighbor.actual, random.actual)

        results$nbetter <- ifelse(abs(results$predZlist_neighbor - results$actual) < abs(results$predZlist_random - results$actual),TRUE, FALSE)

        Xresults$neighbor.better <- length(results$nbetter[results$nbetter==TRUE])
        #print(str(Xresults))
        #Xresults <- data.frame(1,2,3,4)
        Xresults$total.counties <- length(results$nbetter)
        Xresults
        }

#' Run mc with paired t-test
#'
#' NB2 function for t-test component.
#' @param values List of column names in dataframe to run.
#' @keywords nb2
#' @export
#' @examples
#' runMCttest(values)
 
runMCttest <- function(values) {
        mcresults <- Reduce(merge.all,mclapply(Nnum,code=values,rates_counties=rates_counties, drawNeighborsTtest,mc.cores=detectCores()))

        rmse <- melt(mcresults[1:2])
        ttest <- mcresults[3:4]

        names(ttest) <- c('p.value','t.estimate')
        pval.02 <- format(quantile(ttest$p.value,0.02),scientific=TRUE,digits=3)
        pval.98 <- format(quantile(ttest$p.value,0.98), scientific=TRUE,digits=3)
        pval.mean <- format(mean(ttest$p.value),scientific=TRUE,digits=3)
        pval.median <- format(median(ttest$p.value),scientific=TRUE,digits=3)
        ttest.02 <- format(quantile(ttest$t.estimate,0.02),digits=3)
        ttest.98 <- format(quantile(ttest$t.estimate,0.98),digits=3)
        ttest.mean <- format(mean(ttest$t.estimate),digits=3)
        ttest.median <- format(median(ttest$t.estimate),digits=3)

        rmse$variable <- ifelse(rmse$variable == 'rmse_random','random','neighbors')
        rmse.means <- ddply(rmse, "variable", summarise, rmse.mean = mean(value,na.rm=TRUE))
        neighb.mean <- format(rmse.means$rmse.mean[rmse.means$variable == 'neighbors'],digits=4)
        random.mean <- format(rmse.means$rmse.mean[rmse.means$variable == 'random'],digits=4)

        mcOutput <- data.frame(values, pval.02, pval.mean, pval.median, pval.98, neighb.mean, random.mean, ttest.02, ttest.98, ttest.mean, ttest.median)
        }

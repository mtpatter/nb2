runMCodds <- function(value) {
        mcresults <- Reduce(merge.all,mclapply(Nnum,code=value,rates_counties=rates_counties,drawNeighborsOdds,mc.cores=detectCores()))
        #neighbor.actual.02 <- format(quantile(mcresults$neighbor.actual,0.02,na.rm=T),scientific=TRUE,digits=3)
        #neighbor.actual.98 <- format(quantile(mcresults$neighbor.actual,0.98,na.rm=T), scientific=TRUE,digits=3)
        #neighbor.actual.mean <- format(mean(mcresults$neighbor.actual,na.rm=T),scientific=TRUE,digits=3)
        neighbor.actual.median <- median(mcresults$neighbor.actual,na.rm=T)
        random.actual.median <- median(mcresults$random.actual,na.rm=T)
        neighbor.better.median <- median(mcresults$neighbor.better,na.rm=T)
        total.counties <- median(mcresults$total.counties,na.rm=T)
        odds.ratio <- neighbor.better.median / (total.counties - neighbor.better.median)

        neighbor.actual.median <- format(neighbor.actual.median,digits=3)
        random.actual.median <- format(random.actual.median,digits=3)
        neighbor.better.median <- format(neighbor.better.median,digits=3)
        odds.ratio <- format(odds.ratio, digits=5)
        mcOutput <- data.frame(value, neighbor.actual.median, random.actual.median, neighbor.better.median,total.counties,odds.ratio )
        }

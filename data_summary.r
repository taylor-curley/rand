#' Data summary function
#' Returns mean, standard deviation,
#' and standard error estimates.
#' 
#' useful for using the geom_errorbar
#' function that requires either sd 
#' or se.
#' 
#' varname = dependent variable
#' groupnames = grouping variables
#' 
#' 
#' @author tcurley6
#' 
#' Example:
#' data_summary(data = iris, varname = "Petal.Width", groupnames = c("Species"))
#' 
#' 

data_summary <- function(data, varname, groupnames){
  require(plyr)
  summary_func <- function(x, col){
    c(mean = mean(x[[col]], na.rm=TRUE),
      sd = sd(x[[col]], na.rm=TRUE),
      se = sd(x[[col]], na.rm=TRUE)/sqrt(length(x[[col]])))
  }
  data_sum<-ddply(data, groupnames, .fun=summary_func,
                  varname)
  data_sum <- rename(data_sum, c("mean" = varname))
  return(data_sum)
}

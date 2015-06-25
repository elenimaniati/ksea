##' Enrichment of differentially regulated sites in a signature of kinase known targets
##'
##' The Kinase Set Enrichment Analysis is a established analysis statistical method to look
##' for an enrichment on differentially regulated genes/proteins belonging to a given category
##' in a ranked list usually based on gene expression.
##' 
##' @title Kinase Set Enrichment Analysis
##' @param ranking Vector of strings containing the ranking of all ids ordered based on
##' their quantifications.
##' @param norm_express Numeric vector with quantifications.
##' @param signature Vector of strings containing all ids in the signature.
##' @param p Numeric value indicating the power at which the weights are scaled.
##' @param display Logical. When TRUE prints the plot of the enrichment.Set to FALSE
##' when running in batch.
##' @param returnRS Logical. If TRUE a list with all the result attributes is returned.
##' If FALSE only a subset is printed based on the value of \code{significance}.
##' @param significance Logical. When \code{returnRS} is FALSE, if TRUE prints a list with the
##' ES and p-value. If FALSE only the Enrichment Score is printed. 
##' @param trial Integer with number of iterations to calculate significance.
##' @return Enrichment result. The output varies depends on the values of \code{returnRS}
##' and \code{significance}. 
##' @author David Ochoa (code adapted from Francesco Ioirio's version of the same function).
##' 
ksea <- function(ranking, norm_express, signature, p=1, display=TRUE,
                  returnRS=FALSE, significance=FALSE, trial=1000){

 
  #intersection between signature and ranked list
  signature <- unique(intersect(signature,ranking))
  ## Checks if there's some overlap between the ranking and the signature
  if(length(signature) == 0){
    return(NA)
  }

  #Numeric 1/0 of the hits on the ranked list
  HITS <- as.numeric(is.element(ranking,signature))
  #Multiplication of hits and norm_express
  R <- norm_express * HITS
  #Accumulation of absolute norm_express-hit numbers at the power of p
  hitCases <- cumsum(abs(R) ^ p)
  #Maximum value, would be the same as sum(abs(R)^p)
  NR <- max(hitCases)
  #This might happen if the HITS are in 0
  if(NR == 0) return(NA)
  #Vector with the accumulation of missed cases
  missCases <- cumsum(1 - HITS)
  #Total elements iin the ranking
  N <- length(ranking)
  #Total in the ranking that are not in the signature
  N_Nh <- length(ranking) - length(signature)
  #Accumulation of absolute norm_exprss-hit divided by their maximum value
  Phit <- hitCases / NR
  #Accumulation of the missed cases divided by their maximum possible value
  Pmiss <- missCases / N_Nh

  #Maximum difference between hit and miss
  m <- max(abs(Phit - Pmiss))
  #index where the maximum is produced
  t <- which(abs(Phit - Pmiss) == m)
  #In case there is more than one position with maximum values it takes the first one
  if (length(t) > 1){
    t <- t[1]
  }
  ES <- Phit[t] - Pmiss[t] #ES-score
  RS <- Phit - Pmiss #vector of RS-scores
  if (display){
    if (ES >= 0){
      c <- "red"
    }else{
      c <- "green"
    }

    plot(0:N,
         c(0,Phit - Pmiss),
         col=c,type="l",
         xlim=c(0,N),
         ylim=c(-(abs(ES) + 0.5 * (abs(ES))),abs(ES) + 0.5 * (abs(ES))),
         xaxs="i",
         bty="l",
         axes=FALSE,
         xlab="Gene Rank Position",
         ylab="Running Sum")

    par(new=TRUE)
    plot(0:N,
         rep(0,N + 1),
         col="gray",
         type="l",
         new=FALSE,
         xlab="",
         ylab="",
         ylim=c(-(abs(ES) + 0.5 * (abs(ES))),abs(ES) + 0.5 * (abs(ES))))
    axis(side=2)
  }

  P <- NA

  if(significance){
    EMPES <- computeSimpleEMPES(ranking,norm_express,signature,trial) #Calculate ES trial number of times by sampling
    P <- (ES >= 0) * (length(which(EMPES >= ES)) / trial) + (ES < 0) * (length(which(EMPES <= ES)) / trial)
  }

  if (returnRS){
    POSITIONS <- which(HITS == 1)
    names(POSITIONS) <- ranking[which(HITS == 1)]
    POSITIONS <- POSITIONS[order(names(POSITIONS))]
    names(POSITIONS) <- names(POSITIONS)[order(names(POSITIONS))]
    result <- list(ES=ES,RS=RS,POSITIONS=POSITIONS,PEAK=t)
    return(result)
  }else{
    if (significance){
      result <- list(ES=ES,p.value=P)
      return(result)
    }
    else{
      return(ES)
    }
  }
}

# Required to calculate the p-values in the GSEA.
# The p-values are calculated by suffling the signatures
computeSimpleEMPES <- function(ranking,exp_value_profile,signature,trials){
  ngenes <- length(ranking)
  siglen <- length(intersect(signature,ranking))
  ES <- rep(NA,trials)
  for (i in 1:trials){
    shuffled_signature <- ranking[sample(1:ngenes,siglen)]
    tmp <- ksea(ranking,exp_value_profile,shuffled_signature,display=FALSE,significance=FALSE)
    ES[i] <- tmp
  }
  return(ES)
}
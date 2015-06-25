### Introduction

This package contains an implementation of the Kinase Set Enrichment Analysis (KSEA) used to predict kinase activities based on quantitative phosphoproteomic studies. Using a quantitative phosphoproteomic profile and a list of known targets, the algorithms predicts the activity of the based on the enrichment on top regulated sites within the known targets of the kinase.

![kinase](./kinase_GSEA.svg)

###Installation

The `ksea` package can be installed directly from github (if public) or locally using the devtools package.


```r
install.packages('devtools')
```

```
## Installing package into '/nfs/gns/homes/ochoa/R/x86_64-unknown-linux-gnu-library/3.1'
## (as 'lib' is unspecified)
```

```
## Error in contrib.url(repos, type): trying to use CRAN without setting a mirror
```

#####Github installation


```r
require(devtools)
```

```
## Loading required package: devtools
```

```r
install_github("dogcaesar/ksea")
```

```
## Downloading github repo dogcaesar/ksea@master
```

```
## Error in download(dest, src, auth): client error: (404) Not Found
```

#####Local installation

You can clone this project and install it locally in your computer.


```r
require(devtools)
install("./ksea")
```

```
## Error: Can't find directory ./ksea
```

###Usage

First load the `ksea` package.


```r
library("ksea")
```

```
## Error in library("ksea"): there is no package called 'ksea'
```

Next create some fake data. `regulons` contains the kinase targets


```r
regulons <- list(kinaseA=sample(LETTERS, 5))
regulons
```

```
## $kinaseA
## [1] "E" "T" "H" "V" "K"
```

```r
sites <- rnorm(length(LETTERS))
names(sites) <- LETTERS
sites
```

```
##           A           B           C           D           E           F 
## -1.42560641 -2.01013653  0.56781578  0.68705298 -0.34661453  0.53071303 
##           G           H           I           J           K           L 
## -0.47827975  0.49009354 -0.76700075  1.23255658  1.23687349 -1.24953576 
##           M           N           O           P           Q           R 
##  0.16324517  0.22818519 -1.34276572  0.48517930  0.51982041 -0.91399740 
##           S           T           U           V           W           X 
##  0.01868971  0.67101621 -1.42381255  1.17525942 -0.38386569  1.47247947 
##           Y           Z 
## -0.26701826 -0.41339252
```

The function `ksea` will run the enrichment analysis for the provided quantifications and known kinase targets.


```r
ksea_result <- ksea(names(sites), sites, regulons[["kinaseA"]], trial=1000, significance = TRUE)
```

```
## Error in eval(expr, envir, enclos): could not find function "ksea"
```

```r
ksea_result
```

```
## Error in eval(expr, envir, enclos): object 'ksea_result' not found
```

The function `ksea_batchKinases` calculates the KSEA p-value for a list of kinases. To improve the performance of the function, it uses as many cores as possible using the `parallell` package.


```r
regulons[["kinaseB"]] <- sample(LETTERS, 3)
regulons[["kinaseC"]] <- sample(LETTERS, 7)
regulons
```

```
## $kinaseA
## [1] "E" "T" "H" "V" "K"
## 
## $kinaseB
## [1] "L" "E" "Q"
## 
## $kinaseC
## [1] "L" "F" "V" "Z" "C" "D" "P"
```

```r
kinases_ksea <- ksea_batchKinases(names(sites), sites, regulons, trial=1000)
```

```
## Error in eval(expr, envir, enclos): could not find function "ksea_batchKinases"
```

```r
kinases_ksea
```

```
## Error in eval(expr, envir, enclos): object 'kinases_ksea' not found
```


### Developers

The package is documented using [roxygen2](http://cran.r-project.org/web/packages/roxygen2/index.html). After changing the code located in the `R/` folder remember to run 'make' on the main directory to create the documentation following the roxygen2 rules.

To work on the code you will need the `devtools` package installed.

``r``
install.packages("devtools")  
``


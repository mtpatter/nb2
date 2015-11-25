# nb2

Neighbor-based bootstrapping algorithm in R

## Installing

Install this R package using devtools.

``` 
 $  git clone https://github.com/mtpatter/nb2.git
 $  cd nb2
 $  R
 R> library (devtools)
 R> install('.')
```

## Usage

Load as any other R module to access sample data and functions.
``` 
  library(nb2)
```

See `example.R` for sample code running the nb2 algorithm on sample census data by county.


### My sessionInfo(), for future reference

```
> sessionInfo()
R version 3.2.1 (2015-06-18)
Platform: x86_64-apple-darwin10.8.0 (64-bit)
Running under: OS X 10.8.5 (Mountain Lion)

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8

attached base packages:
[1] parallel  stats     graphics  grDevices utils     datasets  methods
[8] base

other attached packages:
[1] nb2_0.0.0.9000 sp_1.2-1       plyr_1.8.3     reshape_0.8.5  devtools_1.9.1

loaded via a namespace (and not attached):
[1] tools_3.2.1     Rcpp_0.12.1     memoise_0.2.1   grid_3.2.1
[5] digest_0.6.8    lattice_0.20-33
```

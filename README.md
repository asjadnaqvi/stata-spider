![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-spider) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-spider) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-spider) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-spider) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-spider)


# spider v1.0

This package provides the ability to draw spiders Stata. It is based on the [Spider plots](https://medium.com/the-stata-guide/stata-graphs-spider-plots-613808b51f73) guide on Medium


*The package is still beta. Please use it and report bugs, errors, enchancements, etc. in the [issue](https://github.com/asjadnaqvi/stata-spider/issues) section.*

## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

The SSC version ():
```
coming soon!
```

Or it can be installed from GitHub (**v1.0**):

```
net install spider, from("https://raw.githubusercontent.com/asjadnaqvi/stata-spider/main/installation/") replace
```


The `palettes` package is required to run this command:

```
ssc install palettes, replace
ssc install colrspace, replace
```

Even if you have the package installed, make sure that it is updated `ado update, update`.

If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:

```
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option. See the help file for details or the example below.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```
graph set window fontface "Arial Narrow"
```


## Syntax

The syntax for v1.0 is as follows:

```
spider variables [if] [in], over(categories) 
                [ alpha(num 0-100) rotate(num) smooth(num 0-1)  palette(str)
                  range(val1 val2) cuts(num) raformat(fmt) ralabsize(str) 
                  lwidth(str) msymbol(str) msize(str) mlwidth(str)
                  legend(str) displacelab(num) displacespike(num)
                  ccolor(str) cwidth(str) scolor(str) swidth(str) slabsize(str)
                  title(str) subtitle(str) note(str) scheme(str) name(str) 
				 ]
```

See the help file `help spider` for details.

The most basic use is as follows:

```
spider numeric variables, over(category variable)
```

where `numeric variables` are a set of variables where each corresponds to a spider plot, and `over()` defines the categories.



## Examples

Set up the data:

```
clear

use "https://github.com/asjadnaqvi/stata-spider/blob/main/data/spider_test.dta?raw=true", clear


drop index_AUS index_LAC // can also keep these
gen year = year(date)
```


```
spider index*, over(policy)
```

<img src="/figures/spider1.png" height="600">

```
spider index*, over(policy) alpha(0)
```

<img src="/figures/spider2.png" height="600">

```
spider index*, over(policy) alpha(0) msym(none)
```

<img src="/figures/spider3.png" height="600">

```
spider index*, over(policy) alpha(0) msym(none) ra(0 100)
```

<img src="/figures/spider4.png" height="600">

```
spider index*, over(policy) alpha(0) msym(none) ra(0 100) cuts(5)
```

<img src="/figures/spider5.png" height="600">

```
spider index*, over(policy) alpha(0) msym(none) ra(20 70) cuts(6)
```

<img src="/figures/spider5_1.png" height="600">

```
spider index*, over(policy) alpha(0) msym(none) ra(20 70) cuts(6) rot(45)
```

<img src="/figures/spider5_2.png" height="600">

```
spider index* if year==2021, over(policy) alpha(0) msym(none) ra(0 100) cuts(5)
```

<img src="/figures/spider6.png" height="600">

```
spider index* if year==2021, over(policy) msym(Oh) lw(0.4) ms(0.4) ra(0 100)
```

<img src="/figures/spider6_1.png" height="600">

### Smooth the spiders

```
spider index*, over(policy) ra(10 80) cuts(8) smooth(0)

spider index*, over(policy) ra(10 80) cuts(8) smooth(0.5)

spider index*, over(policy) ra(10 80) cuts(8) smooth(1)
```

<img src="/figures/spider7_1.png" height="200"><img src="/figures/spider7_2.png" height="200"><img src="/figures/spider7_3.png" height="200">

### Palettes

```
spider index*, over(policy) ra(10 80) cuts(8) smooth(0.1) palette(tol vibrant) lw(0.4) ms(0.6) alpha(2)
```

<img src="/figures/spider8_1.png" height="600">

```
spider index*, over(policy) ra(10 80) cuts(8) smooth(0.1) palette(CET C1) lw(0.4) ms(0.6) alpha(2)
```

<img src="/figures/spider8_2.png" height="600">

### Customize circles and rays


```
spider index*, over(policy) ra(10 80) cuts(8) smooth(0.1) cc(eltblue) cw(0.05)
```

<img src="/figures/spider9_1.png" height="600">

```
spider index*, over(policy) ra(10 80) cuts(8) smooth(0.1) cc(eltblue) cw(0.05) sc(gs8) sw(0.2)
```

<img src="/figures/spider9_2.png" height="600">

```
spider index*, over(policy) ra(10 80) cuts(8) smooth(0.1) cc(eltblue) cw(0.05) sc(eltblue) sw(0.3) displacelab(20) displacespike(10)
```

<img src="/figures/spider9_3.png" height="600">

### Try a different scaling

```
foreach x of varlist index_* {
	replace `x' = `x' / 100
}

spider index*, over(policy) ra(0.1 0.7) cuts(4) raformat(%5.1f) ralabs(2) smooth(0) alpha(0)
```

<img src="/figures/spider10.png" height="600">


## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-spider/issues) to report errors, feature enhancements, and/or other requests. 


## Acknowledgements

José Damas helped identify several issues with the first release.


## Versions

**v1.0 (13 October 2022)**
- First release. 







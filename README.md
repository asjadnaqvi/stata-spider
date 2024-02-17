
![spider-1](https://github.com/asjadnaqvi/stata-spider/assets/38498046/43b0aa06-726f-4f87-92b7-45c2fd653e79)

![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-spider) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-spider) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-spider) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-spider) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-spider)

---

[Installation](#Installation) | [Syntax](#Syntax) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)

---

# spider v1.3
(16 Feb 2024)

This package provides the ability to draw spiders Stata. It is based on the [Spider plots](https://medium.com/the-stata-guide/stata-graphs-spider-plots-613808b51f73) guide on Medium


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

The SSC version (**v1.23**):
```
ssc install spider, replace
```

Or it can be installed from GitHub (**v1.3**):

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

The syntax for the latest version is as follows:

```stata
spider var [if] [in], by(var) 
                [ over(var) alpha(num 0-100) rotate(num) smooth(num 0-1)  palette(str)
                  range(min max) cuts(num) lwidth(str) msymbol(str) rotatelabel
                  raformat(fmt) ralabsize(str) ralabcolor(str) ralabangle(str) 
                  msize(str) mlwidth(str) displacelab(num) displacespike(num) 
                  ccolor(str) cwidth(str) scolor(str) swidth(str) slabsize(str) slabcolor(str)
                  nolegend legpositon(num) legpositon(num) legcolumns(num) legsize(num) xsize(num) ysize(num)
                  title(str) subtitle(str) note(str) scheme(str) name(str) saving(str) 
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

use "https://github.com/asjadnaqvi/stata-spider/blob/main/data/spider_data2.dta?raw=true", clear


drop index_AUS index_LAC // can also keep these
gen year = year(date)
```


```
spider index, by(policy) 
```

<img src="/figures/spider1.png" width="100%">

```
spider index, by(policy) over(region)
```

<img src="/figures/spider1_2.png" width="100%">


```
spider index, by(policy) over(region) alpha(0)
```

<img src="/figures/spider2.png" width="100%">


```
spider index, by(policy) over(region) alpha(0) msym(none)
```

<img src="/figures/spider3.png" width="100%">


```
spider index, by(policy) over(region) alpha(0) msym(square) msize(0.2) ra(0 100)
```

<img src="/figures/spider4.png" width="100%">


```
spider index, by(policy) over(region) alpha(0) rot(30)
```

<img src="/figures/spider5.png" width="100%">

```
spider index, by(policy) over(region) alpha(0) rot(30) rotatelab
```

<img src="/figures/spider5_1.png" width="100%">


### Smooth the spiders

```
spider index if inlist(region,1,6), by(policy) over(region) ra(10 80) cuts(8) alpha(2)

spider index if inlist(region,1,6), by(policy) over(region) ra(10 80) cuts(8) alpha(2) smooth(0)

spider index if inlist(region,1,6), by(policy) over(region) ra(10 80) cuts(8) alpha(2) smooth(0.5)

spider index if inlist(region,1,6), by(policy) over(region) ra(10 80) cuts(8) alpha(2) smooth(1)
```

<img src="/figures/spider7.png" height="250"><img src="/figures/spider7_1.png" height="250"><img src="/figures/spider7_2.png" height="250"><img src="/figures/spider7_3.png" height="250">

### Palettes

```
spider index, by(policy) over(region) smooth(0.1) palette(tol vibrant) lw(0.4) msym(none) alpha(2)
```

<img src="/figures/spider8_1.png" width="100%">

```
spider index, by(policy) over(region) smooth(0.1) palette(carto Bold) lw(0.4) msym(none) alpha(2)
```

<img src="/figures/spider8_2.png" width="100%">


### Customize circles and rays


```
spider index, by(policy) over(region) ra(10 80) cuts(8) smooth(0.1) cc(eltblue) cw(0.05)
```

<img src="/figures/spider9_1.png" width="100%">

```
spider index, by(policy) over(region) ra(10 80) cuts(8) smooth(0.1) cc(eltblue) cw(0.05) sc(black) sw(0.1)
```

<img src="/figures/spider9_2.png" width="100%">

```
spider index, by(policy) over(region) ra(10 80) cuts(8) smooth(0.1) cc(eltblue) cw(0.05) sc(eltblue) sw(0.3) displacelab(20) displacespike(10) rotatelab
```

<img src="/figures/spider9_3.png" width="100%">

### Legends and custom dimensions (v1.2)

```
spider index, by(policy) over(region) smooth(0) alpha(5) xsize(4) ysize(3)
```

<img src="/figures/spider9_4.png" width="100%">

```
spider index, by(policy) over(region) smooth(0) alpha(5) xsize(4) ysize(3) legpos(3) legcol(1)
```

<img src="/figures/spider9_5.png" width="100%">


### Try a different scaling

```
gen index2 = index / 100

spider index2, by(policy) over(region) ra(0.1 0.8) raformat(%5.1f)  smooth(0) alpha(0) ralabs(2)
```

<img src="/figures/spider10.png" width="100%">

### Range label options (v1.21)

```
spider index2, by(policy) over(region) ra(0.1 0.8) raformat(%5.1f) smooth(0) alpha(0) ralabc(blue) ralabs(1.5) ralaba(-90)
```

<img src="/figures/spider11.png" width="100%">


### Bonus: Valentines day spending spider graph

```
set scheme white_tableau
graph set window fontface "Abel"

import delim using "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-02-13/gifts_gender.csv", clear

foreach x of varlist spendingcelebrating- giftcards {
	ren `x' y_`x'
}

drop y_spendingcelebrating

reshape long y_, i(gender) j(cat) string

replace cat = "Candy" if cat=="candy"
replace cat = "Clothing" if cat=="clothing"
replace cat = "Evening out" if cat=="eveningout"
replace cat = "Flowers" if cat=="flowers"
replace cat = "Gift cards" if cat=="giftcards"
replace cat = "Greeting cards" if cat=="greetingcards"
replace cat = "Jewelry" if cat=="jewelry"
replace cat = "Spending celebrating" if cat=="spendingcelebrating"


spider y_, by(cat) over(gender) smooth(0.2) alpha(15) lw(0.4) palette(w3 default, select(1 3)) rotatelab ///
	legcol(3) legsize(3) msize(0.1) sc(black) ccolor(gs13) range(0 60) displacelab(10) slabsize(2.2) ///
	title("{fontface Merriweather Bold:Candy crush ♥}", size(7) color(cranberry))  ///
	subtitle("(Percentage positive respones by spending category)", size(2)) ///
	note("Source: TidyTuesday, 14th Feb 2024.", size(1.5))
```

<img src="/figures/valentines2024.png" width="100%">


## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-spider/issues) to report errors, feature enhancements, and/or other requests. 


## Change log

**v1.3 (16 Feb 2024)**
- Complete rework of the package to take in the data in the long form. While this might be convinient for users who were using it for wide data, the newer version handle the data and labels better and is faster. The wide option might still be added back in later. Please note that change in the `by()` and `over()` options.
- `rotatelabel` option added.
- Better legend controls. Please make sure value labels are properly defined that are passed on to legends.

**v1.23 (12 Nov 2023)**
- Added support for `slabcolor()` (requested by Christian Gessinger).
- Added `saving()`.

**v1.22 (07 Jul 2023)**
- Fixed a bug where labeled `over()` categories were not passing correctly (reported by Kamala Kaghoma).

**v1.21 (10 Jun 2023)**
- Two options added for range labels: `ralabcolor()`, `ralabangle()`.

**v1.2 (20 May 2023)**
- Several legend options added (requested by Marc Kaulisch). These include `nolegend`, `legendpos()`, `legendsize()`, `legendcol()`.
- `xsize()` and `ysize()` added to allow users to control the dimensions.
- Minor code cleanups.
- Help file cleanup.

**v1.1 (24 Dec 2022)**
- Fixed some bugs.
- Better checks for merges.

**v1.0 (13 Oct 2022)**
- First release

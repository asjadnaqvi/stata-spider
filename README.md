![StataMin](https://img.shields.io/badge/stata-2015-blue) ![issues](https://img.shields.io/github/issues/asjadnaqvi/stata-spider) ![license](https://img.shields.io/github/license/asjadnaqvi/stata-spider) ![Stars](https://img.shields.io/github/stars/asjadnaqvi/stata-spider) ![version](https://img.shields.io/github/v/release/asjadnaqvi/stata-spider) ![release](https://img.shields.io/github/release-date/asjadnaqvi/stata-spider)

[Installation](#Installation) | [Syntax](#Syntax) | [Citation guidelines](#Citation-guidelines) | [Examples](#Examples) | [Feedback](#Feedback) | [Change log](#Change-log)


---

![spider-1](https://github.com/asjadnaqvi/stata-spider/assets/38498046/43b0aa06-726f-4f87-92b7-45c2fd653e79)



# spider v1.53
(14 Jan 2025)

This package provides the ability to draw spiders Stata. It is based on the [Spider plots](https://medium.com/the-stata-guide/stata-graphs-spider-plots-613808b51f73) guide on Medium


## Installation

The package can be installed via SSC or GitHub. The GitHub version, *might* be more recent due to bug fixes, feature updates etc, and *may* contain syntax improvements and changes in *default* values. See version numbers below. Eventually the GitHub version is published on SSC.

The SSC version (**v1.53**):

```
ssc install spider, replace
```

Or it can be installed from GitHub (**v1.53**):

```stata
net install spider, from("https://raw.githubusercontent.com/asjadnaqvi/stata-spider/main/installation/") replace
```


The following dependencies are required:

```stata
ssc install palettes, replace
ssc install colrspace, replace
ssc install graphfunctions, replace
```

Please note that `graphfunctions` is a new program with features rolling out regularly. In case the SSC version is not working, please update it directly from the [graphfunctions](https://github.com/asjadnaqvi/stata-graphfunctions) repository. See the link for instructions.

Even if you have the package installed, make sure that it is updated `ado update, update`.

If you want to make a clean figure, then it is advisable to load a clean scheme. These are several available and I personally use the following:

```stata
ssc install schemepack, replace
set scheme white_tableau  
```

You can also push the scheme directly into the graph using the `scheme(schemename)` option. See the help file for details or the example below.

I also prefer narrow fonts in figures with long labels. You can change this as follows:

```stata
graph set window fontface "Arial Narrow"
```


## Syntax

The syntax for the latest version is as follows:

```stata
spider var [if] [in] [weight], 
                [ by(var) over(var) alpha(num 0-100) rotate(num) smooth(num 0-1) palette(str)
                  range(numlist) cuts(num) lwidth(str) lpattern(list) msymbol(list) rotatelabel
                  format(fmt) wrap(num) msize(str) mlwidth(str) displacelab(num) displacespike(num) grid  
                  gcolor(str) gwidth(str) gpattern(str) glabsize(str) glabcolor(str) glabangle(str) glabopsition(str) 
                  rline(numlist) rlinecolor(str) rlinewidth(str) rlinepattern(str)
                  scolor(str) swidth(str) slabsize(str) slabcolor(str)
                  nolegend legpositon(num) legpositon(num) legcolumns(num) legsize(num) xsize(num) ysize(num)
                  stat(mean|sum) pad(num) * ]
```

See the help file `help spider` for details.

Basic syntax 1: Wide form

```stata
spider variables, over(var)
```

Basic syntax 2: Long form

```stata
spider variable, by(var) over(var)
```

See help file for details.

## Citation guidelines

Software packages take countless hours of programming, testing, and bug fixing. If you use this package, then a citation would be highly appreciated. 

The [SSC citation](https://ideas.repec.org/c/boc/bocode/s459136.html) is recommended. Please note that the GitHub version might be newer than the SSC version.


## Examples

Set up the data:

```stata
clear

use "https://github.com/asjadnaqvi/stata-spider/blob/main/data/spider_data2.dta?raw=true", clear
```

and test the command:

```stata
spider index, by(policy) 
```

<img src="/figures/spider1.png" width="100%">

```stata
spider index, by(policy) over(region)
```

<img src="/figures/spider1_2.png" width="100%">


```stata
spider index, by(policy) over(region) alpha(0)
```

<img src="/figures/spider2.png" width="100%">


```stata
spider index, by(policy) over(region) alpha(0) msym(none)
```

<img src="/figures/spider3.png" width="100%">


```stata
spider index, by(policy) over(region) alpha(0) msym(square) msize(0.2) ra(0(20)100)
```

<img src="/figures/spider4.png" width="100%">


```stata
spider index, by(policy) over(region) alpha(0) rot(30)
```

<img src="/figures/spider5.png" width="100%">

```stata
spider index, by(policy) over(region) alpha(0) rot(30) rotatelab
```

<img src="/figures/spider5_1.png" width="100%">


### Smooth the spiders

```stata
spider index if inlist(region,1,6), by(policy) over(region) ra(10(10)80) alpha(2) rot(30) format(%6.0f)

spider index if inlist(region,1,6), by(policy) over(region) ra(10(10)80) alpha(2) rot(30) format(%6.0f) smooth(0)

spider index if inlist(region,1,6), by(policy) over(region) ra(10(10)80) alpha(2) rot(30) format(%6.0f) smooth(0.5)

spider index if inlist(region,1,6), by(policy) over(region) ra(10(10)80) alpha(2) rot(30) format(%6.0f) smooth(1)
```

<img src="/figures/spider7.png"   width="50%"><img src="/figures/spider7_1.png" width="50%">
<img src="/figures/spider7_2.png" width="50%"><img src="/figures/spider7_3.png" width="50%">

### Palettes

```stata
spider index, by(policy) over(region) smooth(0.1) palette(tol vibrant) lw(0.4) msym(none) alpha(2) rot(30) format(%6.0f)
```

<img src="/figures/spider8_1.png" width="100%">

```stata
spider index, by(policy) over(region) smooth(0.1) palette(carto Bold) lw(0.4) msym(none) alpha(2) rot(30) format(%6.0f)
```

<img src="/figures/spider8_2.png" width="100%">


### Customize grids and spikes


```stata
spider index, by(policy) over(region) ra(10(10)80) smooth(0.1) gc(eltblue) gw(0.05) rot(30) format(%6.0f)
```

<img src="/figures/spider9_1.png" width="100%">

```stata
spider index, by(policy) over(region) ra(10(10)80) smooth(0.1) gc(eltblue) gw(0.05) sc(black) sw(0.1) rot(30) format(%6.0f)
```

<img src="/figures/spider9_2.png" width="100%">

```stata
spider index, by(policy) over(region) ra(10(10)80) smooth(0.1) gc(eltblue) gw(0.05) sc(eltblue) sw(0.3) displacelab(20) displacespike(10) rotatelab rot(30) format(%6.0f)
```

<img src="/figures/spider9_3.png" width="100%">

### Legends and custom dimensions (v1.2)

```stata
spider index, by(policy) over(region) smooth(0) alpha(5) rot(30) format(%6.0f) xsize(4) ysize(3) 
```

<img src="/figures/spider9_4.png" width="100%">

```stata
spider index, by(policy) over(region) smooth(0) alpha(5) rot(30) format(%6.0f) xsize(4) ysize(3) legpos(3) legcol(1)
```

<img src="/figures/spider9_5.png" width="100%">


Additional features from v1.5:

```stata
spider index if inlist(region,1,2), by(policy) over(region) smooth(0) alpha(10) rot(15) format(%6.0f) xsize(4) ysize(3) legpos(3) legcol(1) wrap(6) grid range(0 10 20 40 80) rline(35) msym(circle square) msize(0.8)
```

<img src="/figures/spider9_6.png" width="100%">

### Try a different scaling

```stata
gen index2 = index / 100

spider index2, by(policy) over(region) ra(0.1(0.1)0.8) format(%5.1f) rot(30)  smooth(0) alpha(0) glabs(2)
```

<img src="/figures/spider10.png" width="100%">

### Range label options (v1.21)

```stata
spider index2, by(policy) over(region) ra(0.1(0.1)0.8) format(%5.1f)  rot(30) smooth(0) alpha(0) glabc(blue) glabs(1.5) glaba(-90)
```

<img src="/figures/spider11.png" width="100%">


### v1.4 options

Word wrapping

```stata
spider index, by(policy) over(region) smooth(0) alpha(5) wrap(5) rot(30)
```

<img src="/figures/spider12.png" width="100%">


Let's make our data wide:

```stata
encode policy, gen(policy2)

summ policy2, meanonly
local items = r(max)

forval i = 1 /`items' {
	local val`i' : label policy2 `i' 
}



collapse (mean) index, by(policy2 region)


reshape wide index, i(region) j(policy2) 

forval i = 1 / `items' {
	lab var index`i' "`val`i''"
}


spider index*, over(region) smooth(0) alpha(5) wrap(5)  rot(30)
```

<img src="/figures/spider13.png" width="100%">


### v1.5 options: grid + lists + reference lines.

Reload the data:

```stata
use "https://github.com/asjadnaqvi/stata-spider/blob/main/data/spider_data2.dta?raw=true", clear
```


```stata
spider index, by(policy) over(region) alpha(0) wrap(8) ra(0(20)80) format(%5.0f) rot(30)
```

<img src="/figures/spider14.png" width="100%">

```stata
spider index, by(policy) over(region) alpha(0) wrap(8) ra(0 10 30 50 70 80) format(%5.0f) rot(30)
```

<img src="/figures/spider14_1.png" width="100%">


```stata
spider index, by(policy) over(region) alpha(0) wrap(8) ra(0(20)80) format(%5.0f) grid rot(30)
```

<img src="/figures/spider15.png" width="100%">

```stata
spider index, by(policy) over(region) alpha(0) wrap(8) ra(0(20)80) format(%5.0f) grid rline(25 50 70) rlinew(0.2) rlinec(black) rot(30)
```

<img src="/figures/spider16.png" width="100%">

```stata
spider index, by(policy) over(region) alpha(0) wrap(8) ra(0(20)80) cuts(5) format(%5.0f) ///
	msym(S T O +) msize(1.2) rot(30)
```

<img src="/figures/spider17.png" width="100%">

```stata
spider index, by(policy) over(region) alpha(0) wrap(8) ra(0(20)80) cuts(5) format(%5.0f) ///
	lp(dash dot solid -- -.-) rot(30)
```

<img src="/figures/spider18.png" width="100%">


### Bonus: Valentines day spending spider graph

Here is a proper example of data in wide form, which in previous versions (<v1.4) would have required reshaping the data:

```stata
set scheme white_tableau
graph set window fontface "Abel"

import delim using "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-02-13/gifts_gender.csv", clear

lab var spendingcelebrating "Spending celebrating"
lab var greetingcards "Greeting cards"
lab var eveningout "Evening out"
lab var giftcards "Gift cards"

spider spendingcelebrating- giftcards, over(gender) smooth(0.2) alpha(15) lw(0.4) palette(w3 default, select(1 4)) rotatelab ///
	legcol(3) legsize(3) msize(0.15) sc(black) ccolor(gs13) range(0 60) cuts(7) format(%5.0f) displacelab(15) slabsize(2) wrap(5) ///
	title("{fontface Merriweather Bold:♥ Candy crush ♥}", size(7) color(cranberry))  ///
	subtitle("(Percentage positive respones by spending category)", size(2)) ///
	note("Source: TidyTuesday, 14th Feb 2024.", size(1.5)) ///
	plotregion(margin(t-5 b-5 l-20 r-20))
```

<img src="/figures/valentines2024.png" width="100%">


Here is another version which showcases v1.5 updates:

```stata
spider spendingcelebrating- giftcards, over(gender) smooth(0.2) alpha(15) lw(0.4) palette(w3 default, select(1 4)) rotatelab  rline(25 50)  ///
	legcol(3) legsize(3) msize(0.15) sc(black) gcolor(gs13)  format(%5.0f) displacelab(20) glabsize(2) wrap(5) ///
	plotregion(margin(l-20 r-20)) ra(0(10)60) grid lp(solid dash) ///
	title("{fontface Merriweather Bold:Valentines day spending by gender}", size(5) color(cranberry))  ///
	note("Source: TidyTuesday, 14th Feb 2024.", size(1.5)) 
```
<img src="/figures/valentines2024_v2.png" width="100%">

## Feedback

Please open an [issue](https://github.com/asjadnaqvi/stata-spider/issues) to report errors, feature enhancements, and/or other requests. 


## Change log

**v1.53 (14 Jan 2025)**
- Several code updates.
- Added checks for dependencies.
- `legoptions()` added to allow users to micro finetune the legends.
- Several bug fixes.

**v1.52 (07 Jan 2025)**
- Fix a major bug where missing values were resulting in the wrong categories. 
- Various other bug fixes.

**v1.51 (09 Nov 2024)**
A minor release with some major changes
- Starting point is now the 12 o' clock (North) position. This has been requested countless times. One can still rotate by 90 degrees to start from the old (Stata) default 3 o' clock (East) position.
- Draw order is now clockwise. Again requested a lot. Users can change the direction to counter-clockwise by using the new option `flip`.
- Labels are now on the starting north-facing line.
- First category now correctly shows on the first position. Previously it was on the second position.
- Fix a bug where non-integer values under certain conditions were causing the program to crash.
- Minor Code cleanups.

**v1.5 (13 Oct 2024)**
- Now requires dependency [graphfunctions](https://github.com/asjadnaqvi/stata-graphfunctions) (check versions and update to the latest!). 
- Options `msymbol()` and `lwidth()` now take lists. If there are less elements than the number of lines, then the last values are inherited by the remaining lines.
- Added option `grid` which draws straight lines as grids rather than circles. 
- Added options `rline()`, `rlinec()`, `rlinep()`, `rlinew()` for reference lines. Can take lists.
- `c*()` options changes to `g*()` options to reflect grid line values. E.g. `ccolor()` changed to `gcolor()`.
- `ra*()` options renamed to `g*()` options to reflect grid label values. E.g. `ralabelsize()` changed to `glabelsize()`.
- Option `range()` now accepts numerical lists (numlist). This makes `cuts()` almost redundant but it can still be used if no custom range is specified and one needs to increase the number of cuts for auto-calculated ranges.
- Option `gwidth()` added.
- Several updates to defaults.
- Minor code cleanups.

**v1.4 (04 Oct 2024)**
- Weights are now allowed.
- Users can now specify variable lists (wide form) in addition to long form data. See help file.
- Added `pad()` to control minmax displacement of the axis range
- Added `wrap()` to allow text wrapping. Requires the `graphfunctions` package.
- Added `n()` to control how many points are generated to plot the splines between two points.
- Added `stat()` where users can choose between `stat(mean)` (default) or `stat(sum)` if the data is collapsed.
- Code cleanup.

**v1.33 (02 Jul 2024)**
- Fixed a minor error where numeric `over()` and `by()` were not being labeled correctly.

**v1.32 (11 Jun 2024)**
- Added `wrap()` to wrap labels.

**v1.31 (11 May 2024)**
- changed `raformat()` to just `format()` to standardize the use across packages.
- `format()` default improved to show decimals.
- Checks added for `by()` and `over()` to have minimum number of accepted categories.
- Stata default passthru options improved.

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

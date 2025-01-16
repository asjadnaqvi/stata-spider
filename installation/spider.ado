*! spider v1.53 (14 Jan 2025)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.53 (14 Jan 2025): bug fixes.
* v1.52 (07 Jan 2025): Data is now rectanguarlized properly.
* v1.51 (09 Nov 2024): added flip to change orientation. starting position is now by default on the top. fixed a bug in generating gaps.
* v1.5 	(13 Oct 2024): support for rline(). Grids are generated using graphfunctions rather than use internal Stata functions. Users can now specify marker and lp, lw lists.
*                       renamed ra*() to g*() and c*() to g*() to represet grids. Added grid. Added lpattern().
* v1.4  (04 Oct 2024): raformat() is now just format(), stat(mean|sum) added, weights allowed, varlist allowed, pad(), wrap()
* v1.33	(02 Jul 2024): passthru bugs
* v1.32	(11 Jun 2024): add wrap() for label wraps
* v1.31	(11 May 2024): changed raformat() to format(). Format default improved. by() and over() error checks added. passthru changed to *.
* v1.3	(16 Feb 2024): rewrite to suport long form, add rotate label, better legend controls.
* v1.23 (12 Nov 2023): Added slabcolor(), saving()
* v1.22 (03 Jul 2023): Fixed bug with numerical variables not passing correctly.
* v1.21 (10 Jun 2023): Options added: ralabcolor() ralabangle().
* v1.2  (20 May 2023): Major fixes to the legend.
* v1.1  (22 Dec 2022): Minor fixes.
* v1.0  (13 Oct 2022): Beta release.


// Based on this guide:
// Spider plots (26 Jan, 2021) https://medium.com/the-stata-guide/stata-graphs-spider-plots-613808b51f73

cap program drop spider

program spider, sortpreserve

version 15
 
	syntax varlist(numeric) [if] [in] [aw fw pw iw/] ///
		[ , by(varname) over(varname) alpha(real 10) ROtate(real 0) DISPLACELab(real 15) DISPLACESpike(real 2) palette(string) ] ///   	
		[ RAnge(numlist ascending) cuts(real 6) smooth(numlist max=1 >=0 <=1) format(string)  ] ///
		[ SColor(string) SWidth(string) SLABSize(string)								] /// // circle = C, spikes = S
		[ NOLEGend LEGPOSition(real 6) LEGCOLumns(real 3) LEGSize(real 2.2)  ] ///  // v1.2 updates.
		[ GLABColor(string) GLABSize(string) GLABAngle(string) SLABColor(string) ROTATELABel ] ///  // v1.2X options
		[ xsize(real 1) ysize(real 1)  * ]	///
		[ stat(string) unique pad(real 10) n(real 50) wrap(numlist >0 max=1) ] /// // v1.4 
		[ LWidth(string) LPattern(string) MSYMbol(string) MSize(string) MLWIDth(string) GColor(string) GWidth(string) GPattern(string) grid OFFSet(real 0) ] /// // v1.5 
		[ rline(numlist) RLINEColor(string) RLINEWidth(string) RLINEPattern(string) GLABPOSition(string) flip  ] /// // v1.5 cont.
		[ LEGOPTions(string) ] 
		
	// check dependencies
	cap findfile colorpalette.ado
	if _rc != 0 {
		display as error "The palettes package is missing. Please install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}

	cap findfile labmask.ado
		if _rc != 0 quietly ssc install labutil, replace
	
	cap findfile labsplit.ado
		if _rc != 0 quietly ssc install graphfunctions, replace	
	
	if "`stat'" != "" & !inlist("`stat'", "mean", "sum") {
		display as error "Valid options are {bf:stat(mean)} [default] or {bf:stat(sum)}."
		exit
	}	
	
	if "`unique'" != "" & "`range'" != "" {
		display as error "{bf:unique} and {bf:range} cannot be specified together."
		exit
	}

	marksample touse, strok
	

quietly {
preserve		

	keep if `touse'
	keep `varlist' `by' `over' `exp'
	
	local length : word count `varlist'
	
	
	if `length' == 1 & "`by'" == "" {
		di as error "Please specify a {bf:by()} variable with at least three categories."
		exit
	}
	
	if `length' == 1 & "`by'" != "" {
		levelsof `by'
		if r(r) < 3 {
			display as error "{bf:by()} variable should contain at least three categories."
			exit
		}
	}
		
	if `length' > 1 & "`by'" != "" {	
		di as error "{bf:by()} is not allowed if more than one variable is specified."
		exit
	}
	

	
	// parse varlists 
	if `length' > 1 {
		
		// store the info
		local i = 1
		
		foreach x of local varlist {
			*drop if missing(`x')
			
			// somewhere here preserve unique values
			ren `x' _val`i'

			if "`: var label _val`i''" != "" {
				local lab`i' : var label _val`i'
			}
			else {
				local lab`i' `x'
			}
					
			local ++i
		}	
		
		gen _id = _n
		reshape long _val, i(_id) j(_temp)
		
		gen _var=""
		
		forval i = 1/`length' {
			replace _var = "`lab`i''" if _temp==`i'
		}
		
		sort _var _id
		drop _temp _id
		
		local by _var
		local varlist _val
	}

	
	cap confirm numeric var `by'
	
	if _rc!=0 {  // if string
		encode `by', gen(_by)
		local by _by
	}
	else { // if numeric with value label
		egen _by = group(`by')
		if "`: value label `by''" != "" {
			tempvar tempov
			decode  `by', gen(`tempov')		
			labmask _by , val(`tempov')		
		}
		else { // if numeric with value label
			labmask _by, val(`by')
		}
		local by _by 
	}	
	
	
	if "`over'" == "" {
		gen _over = 1
		local over _over
		local overswitch = 1
	}
	else {
		
		levelsof `over'

		if r(r) < 2 {
			display as error "{bf:over()} variable should contain at least two categories."
			exit
		}		
		
		local overswitch = 0
		cap confirm numeric var `over'
		
		if _rc!=0 {  // if string
			encode `over', gen(_over)
			local over _over
		}
		else {
			egen _over = group(`over')
			if "`: value label `over''" != "" {
				tempvar tempov
				decode `over', gen(`tempov')		
				labmask _over, val(`tempov')	
			}
			else { // if numeric with value label
				labmask _over, val(`over')
			}
			
			local over _over 
		}	
	}

	if `length'==1 {
		fillin `by' `over'  // rectanguarlize
		drop _fillin
	}	
	
	foreach x of local varlist {
		recode `x' (.=0)  // fill the series
	}	

	
	if "`stat'" == "" local stat mean
	if "`weight'" != "" local myweight  [`weight' = `exp']
	
	collapse (`stat') `varlist' `myweight', by(`by' `over')

	

	/////////////////////
	// set the scales  //  
	/////////////////////
	
	if "`range'" != ""  {

		local pnum1 "`range'"
		local pnum2 : subinstr  local pnum1 " " "," , all
		
		local norm1 min(`pnum2')
		local norm2 max(`pnum2')
		
	}
	else {
		sum `varlist', meanonly
		local varmin = r(min)
		local varmax = r(max)
		
		local disp = (`varmax' - `varmin') * (`pad' / 100)  // displace minmax by 10%
		
		local norm1 = floor(`varmin' - `disp')
		local norm2 = ceil(`varmax' + `disp')
	}
	

	// rescale variables between [0,100] from their global min/max. This ensures that negative numbers are there as well
	
	replace `varlist' = ((`varlist' - `norm1') / (`norm2' - `norm1')) * 100


	sort `over' `by'  
	bysort `over': gen _seq = _n - 1
	
	levelsof `by'
	local items = r(r)

	
	if "`flip'"=="" {
		local pi = -1 * _pi // default is now clockwise
	}
	else {
		local pi = _pi
	}
	
	local ro = (`rotate' + 90) * _pi / 180  	// default starting is now North
	gen double angle = (_seq * 2 * `pi' / `items') + `ro'


	//////////////////////////
	// generate the points  //
	//////////////////////////
	
		gen double x = `varlist' * cos(angle)	
		gen double y = `varlist' * sin(angle)	

		sort _over _by 
		
		if "`smooth'" != "" {
			levelsof `over', local(lvls)
			
			foreach x of local lvls {
				cap drop _m
				smoother y x if `over'==`x' , rho(`smooth')	obs(`n')
				ren Cx x`x'_pts   // 
				ren Cy y`x'_pts   //
			}		
		}
	
	
	
	///////////////
	//   grids   //
	///////////////
	
	
	if "`gcolor'" 	== "" local gcolor gs12
	if "`gwidth'" 	== "" local gwidth 0.1
	if "`gpattern'" == "" local gpattern solid
	
	
	if "`range'"== "" {
		
		local gap = (`norm2' - `norm1') / (`cuts' - 1)
	
		if ceil(`gap') > _N 	set obs `=ceil(`gap') + 1'

		numlist "`norm1'(`gap')`norm2'"
		local pnum1 = "`r(numlist)'"
		local pnum2 : subinstr  local pnum1 " " "," , all
	}


	
	local rogrid = `rotate' + 90
	
	foreach x of local pnum1 {	

		local y = ((`x' - `norm1') / (`norm2' - `norm1')) * 100

		if "`grid'"!= "" {
			shapes circle, n(`items') rad(`y') rotate(`rogrid') genx(_gx) geny(_gy) genid(_gid) genorder(_go) stack		
		} 
		else {
			shapes circle, n(100) rad(`y') rotate(`rogrid') genx(_gx) geny(_gy) genid(_gid) genorder(_go) stack		
		}
	}
	
	local circle (line _gy _gx, cmissing(n) lc(`gcolor') lw(`gwidth') lp(`gpattern'))
	
	
	
	
	/////////////////////////
	//   reference lines   //
	/////////////////////////
	
	
	if "`rline'" != "" {
	
		if "`rlinecolor'" 	== "" local rlinecolor black
		if "`rlinewidth'" 	== "" local rlinewidth 0.3
		if "`rlinepattern'" == "" local rlinepattern solid
		
		foreach x of numlist `rline' {	
			
			local y = ((`x' - `norm1') / (`norm2' - `norm1')) * 100
			
			*local y = `x'
			
			if "`grid'"!= "" {
				shapes circle, n(`items') rad(`y') rotate(`rogrid') genx(_rx) geny(_ry) genid(_rid) genorder(_ro) stack		
			} 
			else {
				shapes circle, n(100) rad(`y')  rotate(`rogrid') genx(_rx) geny(_ry) genid(_rid) genorder(_ro) stack		
			}
		}
		
		local reflines (line _ry _rx, cmissing(n) lc(`rlinecolor') lw(`rlinewidth') lp(`rlinepattern'))	
	
	}
	
	
	

	///////////////////////
	//   grid labels    //
	///////////////////////			
	
	
	if "`format'" == "" local format %12.1f
	
	gen xvar = .
	gen yvar = .
	gen xlab = ""

	local i = 1

	foreach x of local pnum1 {	
		
		local y = ((`x' - `norm1') / (`norm2' - `norm1')) * 100
		
		replace xlab = string(`x', "`format'")  in `i' 
		replace yvar =  `y'  in `i'	
		replace xvar =  0  in `i'	
	   
		local ++i
	}			
	
		
	////////////////////
	//   grid spikes  //
	////////////////////	

	if "`scolor'" == "" local scolor gs12
	if "`swidth'" == "" local swidth 0.1
	
	
	gen spikes = _n in 1/`items'
	
	forval x = 1/`items' {
		local theta = `x' * 2 * _pi / `items'  
		
		local y = ((`norm2' - `norm1') / (`norm2' - `norm1')) * 100
		
		local liner = (`y' + `displacespike') * cos(`theta' + `ro')
		
		local spike `spike' (function (tan(`theta' + `ro')) * x, n(2) range(0 `liner') lw(`swidth') lc(`scolor') lp(solid)) 
		
		}	

		
	/////////////////
	//   labels	   //
	/////////////////
	
	if "`slabsize'"  == "" local slabsize  2.2
	if "`slabcolor'" == "" local slabcolor black
	
	gen double markerx = .
	gen double markery = .
	gen 	 markerlab = ""
	
	levelsof `by'
	local byitems = r(r)
		
	forval i = 1/`byitems' {
	
		local y = ((`norm2' - `norm1') / (`norm2' - `norm1')) * 100
	
		replace markerx   = (`y' + `displacelab') * cos(angle) in `i'
		replace markery   = (`y' + `displacelab') * sin(angle) in `i'	
	
		local varn : label `by' `i'
		replace markerlab = "`varn'" in `i'
	}	
	
	
	local labval markerlab
	
	if "`wrap'" != "" {
		labsplit markerlab, wrap(`wrap') gen(_lab2)
		local labval _lab2
	}		
		
		
	forval i = 1/`byitems' {
			if "`rotatelabel'" != "" {
				sum   angle in `i', meanonly
				local angle = (r(mean)  * (180 / _pi)) - 90
			} 
	
		local labs `labs' (scatter markery markerx in `i', mc(none) mlab(`labval') mlabpos(0) mlabcolor(`slabcolor') mlabangle(`angle')  mlabsize(`slabsize'))  
		  
	}
		
	/////////////////
	//   spiders   //
	/////////////////	
	
	
	if "`lwidth'"  	== "" local lwidth   0.3
	if "`lpattern'" == "" local lpattern solid
	
	if "`msymbol'" == "" local msymbol circle
	if "`msize'"   == "" local msize   0.3
	if "`mlwidth'" == "" local mlwidth 0.3
	if "`palette'" == "" {
		local palette tableau
	}
	else {
		tokenize "`palette'", p(",")
		local palette  `1'
		local poptions `3'
	}
	
	levelsof `over'
	local items = r(r)
	
	forval i = 1/`items' {
	
		// parse symbols
		local mcount : word count `msymbol'
		local mcount = min(`mcount', `i')
		local mysym : word `mcount' of `msymbol'
		
		// parse line patterns
		local lcount : word count `lpattern'
		local lcount = min(`lcount', `i')
		local myline : word `lcount' of `lpattern'		
	
		colorpalette `palette', nograph `poptions'
		
		if "`smooth'" == "" {
			local spider  `spider'  (area y x if `over'==`i', nodropbase fi(100) fcolor("`r(p`i')'%`alpha'") lc("`r(p`i')'") lw(`lwidth') lp(`myline')) 
		}
		else {
			local spider  `spider'  (area y`i'_pts x`i'_pts , nodropbase fi(100) fcolor("`r(p`i')'%`alpha'") lc("`r(p`i')'") lw(`lwidth') lp(`myline')) 
		}
		
		local spider2 `spider2' (scatter y x if `over'==`i' , msize(`msize') mc("`r(p`i')'") msymbol(`mysym') mlwidth(`mlwidth')) 
		
	}

	
	/////////////////
	//   legend	   //  
	/////////////////	
	
	
	if "`nolegend'" != "" | `overswitch' == 1  {
		local mylegend legend(off)
	}
	else {
		forval i = 1/`items' {
			
			local j = `i' + 1 + `byitems' 
			local varn : label `over' `i'
		
			local entries `" `entries' `j'  "`varn'"  "'
		}
	
		local mylegend legend(order("`entries'") pos(`legposition') size(`legsize') col(`legcolumns') `legoptions') 
		
	}
	
	
	//////////////////////
	//   final graph	//
	//////////////////////
	
	local axisr = 100 * (1 + (`offset' / 100))
	if "`glabsize'"  	== "" local glabsize  1.8
	if "`glabcolor'" 	== "" local glabcolor black
	if "`glabangle'" 	== "" local glabangle 0
	if "`glabposition'" == "" local glabposition 0
	
	
    twoway	///
			`circle' 	///
			`spike'	 	///
			`spider'	///
			`spider2'	///
			`labs' 		///
			(scatter yvar xvar, mc(none) mlab(xlab) mlabpos(`glabposition') mlabsize(`glabsize') mlabcolor(`glabcolor') mlabangle(`glabangle') )  ///
			`reflines'	///
						,    ///
						aspect(1) xsize(`xsize') ysize(`ysize') ///	
						xlabel(-`axisr' `axisr') ///
						ylabel(-`axisr' `axisr') ///
							xscale(off) yscale(off)	///
							xlabel(, nogrid) ylabel(, nogrid) ///
							`mylegend' ///
							`options'
								
								
	*/
		
restore						
}


end


*********************************
******* subroutines here ********
*********************************

cap program drop smoother

program smoother, sortpreserve

version 15
 
	syntax varlist(numeric min=2 max=2) [if] [in], [ rho(real 0.5) obs(real 50) ] 
 
	marksample touse, strok

	tokenize `varlist'
	local vary `1'
	local varx `2'
	

preserve	

	keep if `touse'
 
	cap drop _id
	keep `varlist'
	
	noi list `varlist'
	
	drop if `varx'==.
	gen pts = _n
	order pts
 
	set obs `obs'
 
	levelsof pts, local(points)
	local last = r(r)
	
	foreach x of local points {
	
	// define the four points based on positioning
			
			local pt0 = `x'		
			local pt1 = `x' + 1
			local pt2 = `x' + 2
			local pt3 = `x' + 3
			
			if `pt1' > `last' {
				local pt1 = `pt1' - `last'
			}
			
			if `pt2' > `last' {
				local pt2 = `pt2' - `last'
			}

			if `pt3' > `last' {
				local pt3 = `pt3' - `last'
			}
			
		// control points indexed 0, 1, 2, 3

		forval i = 0/3 {
			qui summ `varx' if pts==`pt`i'', meanonly
			local x`i' = r(mean)
			
			qui summ `vary' if pts==`pt`i'', meanonly
			local y`i' = r(mean)
		}
	

		// generate the ts	
		tempvar t0 t1 t2 t3

		gen `t0' = 0
		gen `t1' = (((`x1' - `x0')^2 + (`y1' - `y0')^2)^`rho') + `t0' 
		gen `t2' = (((`x2' - `x1')^2 + (`y2' - `y1')^2)^`rho') + `t1'
		gen `t3' = (((`x3' - `x2')^2 + (`y3' - `y2')^2)^`rho') + `t2'	
		
		gen t`x' = runiform(`t1',`t2')
		
			**** calculate the As
			
		forval i = 1/3 {
			local j = `i' - 1
				
			tempvar A`i'x A`i'y
				
			gen `A`i'x' = (((`t`i'' - t`x') / (`t`i'' - `t`j'')) * `x`j'') + (((t`x' - `t`j'') / (`t`i'' - `t`j'')) * `x`i'')
			gen `A`i'y' = (((`t`i'' - t`x') / (`t`i'' - `t`j'')) * `y`j'') + (((t`x' - `t`j'') / (`t`i'' - `t`j'')) * `y`i'')
				
		}

		**** calculate the Bs

		forval i = 1/2 {
			local j = `i' - 1
			local k = `i' + 1
			
			tempvar B`i'x B`i'y
			
			gen `B`i'x' = (((`t`k'' - t`x') / (`t`k'' - `t`j'')) * `A`i'x') + (((t`x' - `t`j'') / (`t`k'' - `t`j'')) * `A`k'x')
			gen `B`i'y' = (((`t`k'' - t`x') / (`t`k'' - `t`j'')) * `A`i'y') + (((t`x' - `t`j'') / (`t`k'' - `t`j'')) * `A`k'y')

		}
	
		**** calculate the Cs

		gen double Cx`x' = (((`t2' - t`x') / (`t2' - `t1')) * `B1x') + (((t`x' - `t1') / (`t2' - `t1')) * `B2x')
		gen double Cy`x' = (((`t2' - t`x') / (`t2' - `t1')) * `B1y') + (((t`x' - `t1') / (`t2' - `t1')) * `B2y')	
			
	}	
 
 
	cap drop `varlist' pts
 
	gen id = _n
	reshape long Cx Cy t, i(id) j(spline)
	sort spline t 
  
	drop id spline t
	gen _id = _n
	order _id
	
	
	
	tempfile mysplines
	save `mysplines', replace

restore	

	cap confirm var _id
	if _rc!=0 gen _id = .
	cap drop _merge
	merge m:1 _id using `mysplines'	
	cap drop _merge

	
end


*********************************
******** END OF PROGRAM *********
*********************************



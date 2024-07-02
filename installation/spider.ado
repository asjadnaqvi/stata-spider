*! spider v1.33 (02 Jul 2024)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

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

**********************************
* Step-by-step guide on Medium   *
**********************************

* Based on this guide:
* Spider plots (26 Jan, 2021) https://medium.com/the-stata-guide/stata-graphs-spider-plots-613808b51f73

cap program drop spider

program spider, sortpreserve

version 15
 
	syntax varlist(numeric max=1) [if] [in], by(varname) ///
		[ over(varname) alpha(real 10) ROtate(real 30) DISPLACELab(real 15) DISPLACESpike(real 2)  palette(string) 				] ///   	
		[ RAnge(numlist min=2 max=2) cuts(real 6) smooth(numlist max=1 >=0 <=1) format(string)  RALABSize(string) ] ///
		[ LWidth(string) MSYMbol(string) MSize(string) MLWIDth(string)  											] /// // spider properties
		[ CColor(string) CWidth(string)	SColor(string) SWidth(string) SLABSize(string)								] /// // circle = C, spikes = S
		[ NOLEGend LEGPOSition(real 6) LEGCOLumns(real 3) LEGSize(real 2.2)  ] ///  // v1.2 updates.
		[ RALABColor(string) RALABAngle(string) SLABColor(string) ROTATELABel ] ///  // v1.2X options
		[ xsize(real 1) ysize(real 1) wrap(numlist >=0 max=1) * ]
		
		
	// check dependencies
	cap findfile colorpalette.ado
	if _rc != 0 {
		display as error "The palettes package is missing. Install the {stata ssc install palettes, replace:palettes} and {stata ssc install colrspace, replace:colrspace} packages."
		exit
	}
	
	
	cap findfile labmask.ado
	if _rc != 0 {
		qui ssc install labutil, replace 
	}		
	
	marksample touse, strok
	

quietly {
preserve		
	keep if `touse'
	keep `varlist' `by' `over'
	
	levelsof `by'
	if r(r) < 3 {
		display as error "by() variable should contain at least three categories."
		exit
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
			display as error "over() variable should contain at least two categories."
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
	
	
	
	collapse (mean) `varlist', by(`by' `over')

	sum `varlist', meanonly
	local varmin = r(min)
	local varmax = r(max)
	
	
	/////////////////////
	// set the scales  //  
	/////////////////////
	
	if "`range'" != "" {
		tokenize `range'
		local norm1 `1'
		local norm2 `2'
		
	}
	else {
		
		local disp = (`varmax' - `varmin') * 0.1  // displace minmax by 10%
		
		local norm1 = `varmin' - `disp'
		local norm2 = `varmax' + `disp'
	}

	
	// rescale variables between [0,100] from their global min/max. This ensures that negative numbers are there as well
		replace `varlist' = ((`varlist' - `norm1') / (`norm2' - `norm1')) * 100

	
	sort `over' `by'  
	bysort `over': gen _seq = _n
	
	levelsof `by'
	local items = r(r)

	local ro = `rotate' * _pi / 180  	
	gen double angle = (_seq * 2 * _pi / `items') + `ro'


	//////////////////////////
	// generate the points  //
	//////////////////////////
	
		gen double x = `varlist' * cos(angle)	
		gen double y = `varlist' * sin(angle)	

		sort _over _by 
		
		if "`smooth'" != "" {
		
			*if _N < 50 set obs 50 // generate the points
		
			levelsof `over', local(lvls)
			
			foreach x of local lvls {
				
				cap drop _m
				
				smoother y x if `over'==`x' , rho(`smooth')		
				ren Cx x`x'_pts   // 
				ren Cy y`x'_pts   // 

			}		
		}
	

	
	/////////////////
	//   circles   //
	/////////////////	
	
	
	if "`ccolor'" == "" local ccolor gs12
	if "`cwidth'" == "" local cwidth 0.1
	
	// local sides = cond("`polygon'" == "",  300, `items')   // deal with later
	
	local gap = floor((100 - 0) / (`cuts' - 1))
	
		
	if `gap' > _N {
		local newobs = `gap' + 1
		set obs `newobs'
	}
	
	
	forval x = 0(`gap')100 {	
		local circle `circle' (function sqrt(`x'^2 - x^2), lc(`ccolor') lw(`cwidth') lp(solid) range(-`x' `x') n(`sides')) || (function -sqrt(`x'^2 - x^2), lc(`ccolor') lw(`cwidth') lp(solid) range(-`x' `x')  n(`sides')) ||

	}	

	///////////////////////
	//   circle labels   //
	///////////////////////			
	
	
	if "`format'" == "" local format %12.1f
	
	local gap2 = (`norm2' - `norm1') / (`cuts' - 1)
	
	gen xvar = .
	gen yvar = .
	gen xlab = ""

	local i = 1

	forval x = 0(`gap')100 {
		replace xlab = string(`norm1' + ((`i' - 1) * `gap2'), "`format'")  in `i' 
		replace xvar =  `x'  in `i'	
		replace yvar =  0  in `i'	
	   
		local i = `i' + 1 
	}			
	
		
	/////////////////
	//   spikes	   //
	/////////////////	

	if "`scolor'" == "" local scolor gs12
	if "`swidth'" == "" local swidth 0.1
	
	
	gen double spikes = _n in 1/`items'
	
	forval x = 1/`items' {
		local theta = `x' * 2 * _pi / `items'   
		local liner = (100 + `displacespike') * cos(`theta' + `ro')
		
		local spike `spike' (function (tan(`theta' + `ro'))*x, n(2) range(0 `liner') lw(`swidth') lc(`scolor') lp(solid)) ||
		
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
	
		replace markerx   = (100 + `displacelab') * cos(angle) in `i'
		replace markery   = (100 + `displacelab') * sin(angle) in `i'	
	
		local varn : label `by' `i'
		replace markerlab = "`varn'" in `i'
	}	
		
	if "`wrap'" != "" {
		gen _length = length(markerlab) if markerlab!= ""
		summ _length, meanonly		
		local _wraprounds = floor(`r(max)' / `wrap')
		
		forval i = 1 / `_wraprounds' {
			local wraptag = `wrap' * `i'
			replace markerlab = substr(markerlab, 1, `wraptag') + "`=char(10)'" + substr(markerlab, `=`wraptag' + 1', .) if _length > `wraptag' & _length!=. 
		}
		drop _length
	}			
		
		
	forval i = 1/`byitems' {
			if "`rotatelabel'" != "" {
				sum   angle in `i', meanonly
				local angle = (r(mean)  * (180 / _pi)) - 90
			} 
	
		local labs `labs' (scatter markery markerx in `i', mc(none) mlab("markerlab") mlabpos(0) mlabcolor(`slabcolor') mlabangle(`angle')  mlabsize(`slabsize'))  
		  
	}
		
	/////////////////
	//   spiders   //
	/////////////////	
	
	
	if "`lwidth'"  == "" local lwidth  = 0.3
	if "`msymbol'" == "" local msymbol circle
	if "`msize'"   == "" local msize   = 0.3
	if "`mlwidth'" == "" local mlwidth = 0.3
	if "`palette'" == "" {
		local palette tableau
	}
	else {
		tokenize "`palette'", p(",")
		local palette  `1'
		local poptions `3'
	}
	
	qui levelsof `over'
	local items = r(r)
	
	forval i = 1/`items' {
	
	
		colorpalette `palette', nograph `poptions'
		
		if "`smooth'" == "" {
			local spider  `spider'  (area y x if `over'==`i'    , nodropbase fi(100) fcolor("`r(p`i')'%`alpha'") lc("`r(p`i')'") lw(`lwidth')) 
		
		}
		else {
			local spider  `spider'  (area y`i'_pts x`i'_pts, nodropbase fi(100) fcolor("`r(p`i')'%`alpha'") lc("`r(p`i')'") lw(`lwidth')) 
			
		}
		
		
		local spider2 `spider2' (scatter y x if `over'==`i' , msize(`msize') mc("`r(p`i')'") msymbol("`msymbol'") mlwidth(`mlwidth')) 
		
		
	}

	
	/////////////////
	//   legend	   //  
	/////////////////	
	
	
	if "`nolegend'" != "" | `overswitch' == 1  {
		local mylegend legend(off)
				
	}
	else {
	
		forval i = 1/`items' {
			
			local j = `i' + (`cuts' * 2) + `byitems' 
			local varn : label `over' `i'
		
			local entries `" `entries' `j'  "`varn'"  "'
		}
	

		local mylegend legend(order("`entries'") pos(`legposition') size(`legsize') col(`legcolumns')) 
		
	}
	
	
	//////////////////////
	//   final graph	//
	//////////////////////
	
	local axisr = 100 * (1.3)
	if "`ralabsize'"  == "" local ralabsize = 1.8
	if "`ralabcolor'" == "" local ralabcolor black
	if "`ralabangle'" == "" local ralabangle 0

    twoway	///
			`circle' 	///
			`spike'	 	///
			`spider'	///
			`spider2'	///
			`labs' 		///
			(scatter yvar xvar, mc(none) mlab(xlab) mlabpos(0) mlabsize(`ralabsize') mlabcolor(`ralabcolor') mlabangle(`ralabangle') )  ///
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
 
	*list Cy Cy spline
 
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



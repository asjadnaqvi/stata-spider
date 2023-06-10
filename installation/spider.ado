*! spider v1.21 (10 June 2023)
*! Asjad Naqvi (asjadnaqvi@gmail.com)

* v1.21 (10 Jun 2023): Options added: ralabcolor() ralabangle().
* v1.2  (20 May 2023): Major fixes to the legend.
* v1.1  (22 Dec 2022): Minor fixes.
* v1.0  (13 Oct 2022): Beta release.

**********************************
* Step-by-step guide on Medium   *
**********************************

* if you want to go for even more customization, you can read this guide:
* Spider plots (26 Jan, 2021) https://medium.com/the-stata-guide/stata-graphs-spider-plots-613808b51f73

cap program drop spider


program spider, sortpreserve

version 15
 
	syntax varlist(numeric) [if] [in], over(varname) ///
		[ alpha(real 5) ROtate(real 30) DISPLACELab(real 15) DISPLACESpike(real 2)  palette(string) 				] ///   	
		[ RAnge(numlist min=2 max=2) cuts(real 6) smooth(numlist max=1 >=0 <=1) raformat(string)  RALABSize(string) ] ///
		[ LWidth(string) MSYMbol(string) MSize(string) MLWIDth(string)  											] /// // spider properties
		[ CColor(string) CWidth(string)	SColor(string) SWidth(string) SLABSize(string)								] /// // circle = C, spikes = S
		[ title(passthru) subtitle(passthru) note(passthru) scheme(passthru) name(passthru)		] /// 
		[ NOLEGend LEGPOSition(real 6) LEGCOLumns(real 5) LEGSize(real 2.2) xsize(real 1) ysize(real 1) ] ///  // v1.2 updates.
		[ RALABColor(string) RALABAngle(string) ]  // v1.21 options
		
		// TODO: 
		// ROTATELABel: allow label rotations
		// POLYgon    : replace circles with polygons
		// legend(passthru) not working. If labels have breaks, it breaks down. Check and fix.
		// add a by() option for long data
		
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
	

qui {
preserve		
	keep if `touse'
	
	keep `varlist' `over'
	
	local length : word count `varlist'
	
	cap confirm numeric var `over'

	if _rc!=0 {  // if string
		tempvar over2
		encode `over', gen(over2)
		local over over2 
	}
	else {
		egen   over2 = group(`over')
		
		if "`: value label `stack''" != "" {
			decode `over', gen(`tempov')		
			labmask over2, val(`tempov')
		}
		local over over2 
	}	
	
	collapse (mean) `varlist', by(`over')
	
	tempvar varmin varmax
	egen double `varmin' = rowmin(`varlist')
	egen double `varmax' = rowmax(`varlist')

	/////////////////////
	// set the scales  //  
	/////////////////////
	
	if "`range'" != "" {
		tokenize `range'
		local norm1 `1'
		local norm2 `2'
		
	}
	else {
		summ `varmin', meanonly
			local gmin = r(min)
		summ `varmax', meanonly
			local gmax = r(max)
		
		local disp = (`gmax' - `gmin') * 0.1  // displace minmax by 10%
		
		local norm1 = `gmin' - `disp'
		local norm2 = `gmax' + `disp'
	}

	
	// rescale variables between [0,100] from their global min/max. This ensures that negative numbers are there as well
	foreach x of varlist `varlist' {
		replace `x' = ((`x' - `norm1') / (`norm2' - `norm1')) * 100
	}
	
		
	levelsof `over'
	local items = r(r)


	local ro = `rotate' * _pi / 180  	
	gen double angle = (_n * 2 * _pi / `items') + `ro'

	
	//////////////////////////
	// generate the points  //
	//////////////////////////
	

		foreach x of varlist `varlist' {
			gen double x_`x' = `x' * cos(angle)	
			gen double y_`x' = `x' * sin(angle)	
		}
	
	
		if "`smooth'" != "" {
			foreach x of varlist `varlist' {
				cap drop _m
				smoother y_`x' x_`x', rho(`smooth')		
				ren Cx x_`x'_pts
				ren Cy y_`x'_pts
				sort `over' _id
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
	
	
	if "`raformat'" == "" local raformat %5.0f
	
	local gap2 = (`norm2' - `norm1') / (`cuts' - 1)
	
	gen xvar = .
	gen yvar = .
	gen xlab = ""

	local i = 1

	forval x = 0(`gap')100 {
		replace xlab = string(`norm1' + ((`i' - 1) * `gap2'), "`raformat'")  in `i' 
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
	
	if "`slabsize'" == "" local slabsize 2.2
	
	gen double markerx   = (100 + `displacelab') * cos(angle)
	gen double markery   = (100 + `displacelab') * sin(angle)	
	
	local labs
		
		forval i = 1/`items' {

			if "`rotatelabel'" != "" {
				sum   angle in `i', meanonly
				local angle = (r(mean)  * (180 / _pi)) + 255
			} 
		 
			local labs `labs' (scatter markery markerx in `i', mc(none) mlab(`over') mlabpos(0) mlabcolor(black) mlabangle(`angle')  mlabsize(`slabsize'))  ///  // 
		  
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
	
	forval i = 1/`length' {
	
	tokenize `varlist'
	
		local varn = "``i''"
		
		colorpalette `palette', nograph `poptions'
		
		if "`smooth'" == "" {
			local spider  `spider'  (area y_`varn'     x_`varn'    , nodropbase fi(100) fcolor("`r(p`i')'%`alpha'") lc("`r(p`i')'") lw(`lwidth')) ||
		
		}
		else {
			local spider  `spider'  (area y_`varn'_pts x_`varn'_pts, nodropbase fi(100) fcolor("`r(p`i')'%`alpha'") lc("`r(p`i')'") lw(`lwidth')) ||
			
		}
		
		
		local spider2 `spider2' (scatter y_`varn' x_`varn', msize(`msize') mc("`r(p`i')'") msymbol("`msymbol'") mlwidth(`mlwidth')) || 
		
		
	}

	/////////////////
	//   legend	   //  
	/////////////////	
	

	if "`nolegend'" != "" {
		local mylegend legend(off)
				
	}
	else {
	
		forval i = 1/`length' {
			
			local j = `i' + (`cuts' * 2) + `items'
			
			local varn = "``i''"
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
							`title' `subtitle' `note' `scheme' `name'
								
									
			
	
		
restore						
}


		
end


*********************************
******* subroutines here ********
*********************************

cap program drop smoother

program smoother // , sortpreserve

version 15
 
	syntax varlist(numeric min=2 max=2) [if] [in], [ rho(real 0.5) obs(real 50) ] 
 
	tokenize `varlist'
	local vary `1'
	local varx `2'
	

preserve	
 
	cap drop _id
	keep `varlist'
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

		gen Cx`x' = (((`t2' - t`x') / (`t2' - `t1')) * `B1x') + (((t`x' - `t1') / (`t2' - `t1')) * `B2x')
		gen Cy`x' = (((`t2' - t`x') / (`t2' - `t1')) * `B1y') + (((t`x' - `t1') / (`t2' - `t1')) * `B2y')	
			
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



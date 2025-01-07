{smcl}
{* 07Jan2025}{...}
{hi:help spider}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-spider":spider v1.52 (GitHub)}}

{hline}

{title:spider}: A Stata package for spider plots.

{p 4 4 2}
The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/stata-graphs-spider-plots-613808b51f73":Spider plots}.

{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:spider} {it:var} {ifin} {weight}, 
                {cmd:[} {cmd:by}({it:var}) {cmd:over}({it:var}) {cmd:alpha}({it:num 0-100}) {cmdab:ro:tate}({it:num}) {cmd:smooth}({it:num 0-1}) {cmd:palette}({it:str}) {cmd:flip}
                  {cmdab:ra:nge}({it:numlist}) {cmd:cuts}({it:num}) {cmdab:lw:idth}({it:str}) {cmdab:lp:attern}({it:list}) {cmdab:msym:bol}({it:list}) {cmdab:rotatelab:el}
                  {cmd:format}({it:fmt}) {cmd:wrap}({it:num}) {cmdab:ms:ize}({it:str}) {cmdab:mlw:idth}({it:str}) {cmdab:displacel:ab}({it:num}) {cmdab:displaces:pike}({it:num}) {cmdab:grid}  
                  {cmdab:gc:olor}({it:str}) {cmdab:gw:idth}({it:str}) {cmdab:gp:attern}({it:str}) {cmdab:glabs:ize}({it:str}) {cmdab:glabc:olor}({it:str}) {cmdab:glaba:ngle}({it:str}) {cmdab:glabops:ition}({it:str}) 
                  {cmd:rline({it:numlist})} {cmdab:rlinec:olor}({it:str}) {cmdab:rlinew:idth}({it:str}) {cmdab:rlinep:attern}({it:str})
                  {cmdab:sc:olor}({it:str}) {cmdab:sw:idth}({it:str}) {cmdab:slabs:ize}({it:str}) {cmdab:slabc:olor}({it:str})
                  {cmdab:noleg:end} {cmdab:legpos:ition}({it:num}) {cmdab:legcol:umns}({it:num}) {cmdab:legs:ize}({it:num}) {cmd:xsize}({it:num}) {cmd:ysize}({it:num})
                  {cmd:stat}({it:mean}|{it:sum}) {cmd:pad}({it:num}) * {cmd:]}

{p 4 4 2}

{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : Long form: {opt spider var, by(var)}}The command requires one numerical variable where the data is in long form. The data is split by {opt by()} categories.{p_end}

{p2coldent : Wide form: {opt spider varlist}}The command a list of numeric variables where the data is in wide form. For this case, the {opt by()} option cannot be specified.{p_end}

{p2coldent : {opt over(var)}}The {opt over()} defines the different spider categories. These variables show up in the legend.{p_end}

{p2coldent : {opt stat(mean|sum)}}If there are multiple observations per {opt by()} and {opt over()}, then by default the program will take the mean by triggering {opt stat(mean)}.
Users can also sum the data by using the {opt stat(sum)}. Weights are allowed here. As a note of caution, it is highly recommended to prepare the data before using this command.{p_end}

{p2coldent : {opt ro:tate(num)}}Rotate the graph by {it:num} degrees, e.g. {opt:ro(30)} is 30 degrees. The default value is {opt ro(0)}.{p_end}

{p2coldent : {opt smooth(num)}}This option allows users to smooth out the spider plots using splines. It can take on values between [0,1] where 0 = tighter curves and 1 = wider curves.
A value of 0.5 is a reasonable middle ground. If the points are close to each other or there are large data spikes, then the smoothing might result can "twist" the splines
creating a loop. In this case, it is advised to use a smaller {opt smooth()} values, or extend the range of the circles so points are reasonable better spaced.
If {opt smooth()} is not specified, then the figure will show a simple connected line plot.{p_end}

{p2coldent : {opt palette(name)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette tableau:{it:tableau}}.{p_end}

{p2coldent : {opt wrap(num)}}Wrap the labels after a specific number of characters. Word boundaries are respected. Requires the latest {stata help graphfunctions:graphfunctions} package.{p_end}

{p2coldent : {opt flip}}Flip the direction from clockwise (default) to counter-clockwise.{p_end}


   {ul:Spider lines and area}

{p2coldent : {opt alpha(num)}}The transparency of the spider area fills. The value ranges from 0-100, where 0 is no fill and 100 is fully filled. Default is {opt alpha(10)}.{p_end}

{p2coldent : {opt lw:idth(num)}}The outline width of the spider area fill. Default is {opt lw(0.3)}. Area fill lines can be turned off by defining {opt lw(none)}.{p_end}

{p2coldent : {opt lp:attern(list)}}The outline pattern of the spider area fill. Default is {opt lp(solid)}.
If a list is provided and the number of items are less than the number of lines, then the last line pattern option will be inherited for the remaining lines.{p_end}

{p2coldent : {opt msym:bol(list)}}The marker symbols for the lines. Default is {opt msym(circle)}. Markers can be turned off by defining {opt msymb(none)}.
If a list is provided and the number of items are less than the number of lines, then the last defined symbol will be inherited for the remaining markers.{p_end}

{p2coldent : {opt mlw:idth(str)}}The marker line size on the spider lines. Default is {opt mlw(0.3)}.{p_end}

{p2coldent : {opt ms:ize(str)}}The marker size on the spider lines. Default is {opt ms(0.3)}.{p_end}


   {ul:Spider grids}

{p2coldent : {opt ra:nge(numlist)}}Provide a list for the grids on the spider plot. Default range is the minimum and maximum of all the data
points that is offset by {opt pad()} percent of the minmax difference. This might not be optimal in all cases. For example, if you know that your data is between 0-100,
but the actual values are between 40-80, the graph range will automatically adjust the ranges to 36 and 84, or 40-0.1*(80-40) and 80+0.1*(80-40)
respectively using the default {opt pad(10)}. In this case, it is better to define a custom range e.g. {opt ra:nge(0(10)100)} to control the scaling.{p_end}

{p2coldent : {opt cuts(num)}}The number of cuts to show in the graph. Default value is {opt cuts(6)}. This option only works if
{opt range()} is not used.{p_end}

{p2coldent : {opt pad(num)}}Increase the min and max of the axis range by {opt pad()} percentage. Default is {opt pad(10)}.{p_end}

{p2coldent : {opt grid}}If {opt grid} is specified, then straight lines form the grid, otherwise circles are used.{p_end}

{p2coldent : {opt gc:olor(str)}}The color of the grids. The default is {opt gc(gs12)}.{p_end}

{p2coldent : {opt gw:idth(str)}}The width of the grids. The default is {opt gw(0.1)}.{p_end}

{p2coldent : {opt gp:attern(str)}}The line pattern of the grids. Default is {opt gp(solid)}.{p_end}

{p2coldent : {opt glabs:ize(str)}}The size of the grid labels. The default is {opt glabs(1.8)}.{p_end}

{p2coldent : {opt glabc:olor(str)}}The color of the grid labels. The default is {opt glabc(black)}.{p_end}

{p2coldent : {opt glaba:ngle(str)}}The angle of the grid labels. The default is {opt glaba(0)} for horizontal.{p_end}

{p2coldent : {opt glabpos:ition(str)}}The position of the grid labels. The default is {opt glabpos(0)}.{p_end}


   {ul:Reference lines}

{p2coldent : {opt rline(numlist)}}Define a list of reference lines.{p_end}

{p2coldent : {opt rlinec:olor(str)}}The color of the reference lines. Default is {opt rlinec(black)}.{p_end}

{p2coldent : {opt rlinew:idth(str)}}The width of the reference lines. Default is {opt rlinew(0.3)}.{p_end}

{p2coldent : {opt rlinep:attern(str)}}The line pattern of the reference lines. Default is {opt rlinep(solid)}.{p_end}


   {ul:Spikes}

{p2coldent : {opt sc:olor(str)}}The color of the spikes. Default is {opt sc(gs12)}.{p_end}

{p2coldent : {opt sw:idth(str)}}The width of the spikes. Default is {opt sw(0.1)}.{p_end}

{p2coldent : {opt slabs:ize(str)}}The width of the spike labels. Default is {opt slabs(2.2)}.{p_end}


   {ul:Spike labels}

{p2coldent : {opt slabc:olor(str)}}The color of the spike labels. Default is {opt slabc(black)}.{p_end}

{p2coldent : {opt rotatelab:el}}Rotate the spike labels by 90 degrees.{p_end}

{p2coldent : {opt displaces:pike(num)}}Defines how much the spikes should be extended beyond the circle extent.
The default value is {opt displaces(2)} for 2%.{p_end}

{p2coldent : {opt displacel:ab(num)}}Push {opt over()} labels away from the spikes. The default value is {opt displacel(15)} or 15% of spike length.{p_end}


   {ul:Legend}

{p2coldent : {opt legpos:ition(num)}}Clock position of the legend. Default is {opt legpos(6)}.{p_end}

{p2coldent : {opt legcol:umns(num)}}Number of legend columns. Default is {opt legcol(3)}.{p_end}

{p2coldent : {opt legs:ize(num)}}Size of legend entries. Default is {opt legs(2.2)}.{p_end}

{p2coldent : {opt nolegend}}Hide the legend.{p_end}



{p2coldent : {opt *}}All other standard twoway options not elsewhere specified.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}
{stata ssc install graphfunctions, replace}


{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-spider":GitHub} for examples.


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-spider/issues":GitHub} by opening a new issue.


{title:Citation guidelines}

See {browse "https://ideas.repec.org/c/boc/bocode/s459136.html"} for the official SSC citation. 
Please note that the GitHub version might be newer than the SSC version.


{title:Package details}

Version      : {bf:spider} v1.52
This release : 07 Jan 2025
First release: 13 Oct 2022
Repository   : {browse "https://github.com/asjadnaqvi/stata-spider":GitHub}
Keywords     : Stata, graph, spider plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter/X    : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}
BlueSky      : {browse "https://bsky.app/profile/asjadnaqvi.bsky.social":@asjadnaqvi.bsky.social}


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb graphfunctions}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb splinefit}, {helpb streamplot}, {helpb sunburst}, {helpb ternary}, {helpb treecluster}, {helpb treemap}, {helpb trimap}, {helpb waffle}

or visit {browse "https://github.com/asjadnaqvi":GitHub}.
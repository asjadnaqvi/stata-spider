{smcl}
{* 11Jun2024}{...}
{hi:help spider}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-spider":spider v1.32 (GitHub)}}

{hline}

{title:spider}: A Stata package for spider plots.

{p 4 4 2}
The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/stata-graphs-spider-plots-613808b51f73":Spider plots}.

{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:spider} {it:var} {ifin}, {cmd:by}({it:var}) 
                {cmd:[} {cmd:over}({it:var}) {cmd:alpha}({it:num 0-100}) {cmdab:ro:tate}({it:num}) {cmd:smooth}({it:num 0-1})  {cmd:palette}({it:str})
                  {cmdab:ra:nge}({it:min max}) {cmd:cuts}({it:num}) {cmdab:lw:idth}({it:str}) {cmdab:msym:bol}({it:str}) {cmdab:rotatelab:el}
                  {cmd:format}({it:fmt}) {cmdab:ralabs:ize}({it:str}) {cmdab:ralabc:olor}({it:str}) {cmdab:ralaba:ngle}({it:str}) {cmd:wrap}({it:num})
                  {cmdab:ms:ize}({it:str}) {cmdab:mlw:idth}({it:str}) {cmdab:displacel:ab}({it:num}) {cmdab:displaces:pike}({it:num}) 
                  {cmdab:cc:olor}({it:str}) {cmdab:cw:idth}({it:str}) {cmdab:sc:olor}({it:str}) {cmdab:sw:idth}({it:str}) {cmdab:slabs:ize}({it:str}) {cmdab:slabc:olor}({it:str})
                  {cmdab:noleg:end} {cmdab:legpos:iton}({it:num}) {cmdab:legpos:iton}({it:num}) {cmdab:legcol:umns}({it:num}) {cmdab:legs:ize}({it:num}) {cmd:xsize}({it:num}) {cmd:ysize}({it:num}) * 
                {cmd:]}

{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt spider var, by(var)}}The command requires a numerical variable where the data is in long form. The data is split by {opt by()} categories across the circle. 
If there are more observations per {opt by()} category, the command will collapse and average the data.
So make sure to control the data before using the {cmd:spider} command in case you to plot other summary statistics.{p_end}

{p2coldent : {opt over(var)}}The {opt over()} defines the different spider categories. These variables show up in the legend.{p_end}

{p2coldent : {opt alpha(num)}}The transparency control of the spider area fills. The value ranges from 0-100, where 0 is no fill and 100 is fully filled.
Default value is {it:10} or 10% transparency.{p_end}

{p2coldent : {opt ro:tate(num)}}Rotate the graph in degrees. The default value is {it:30} or 30 degrees to prevent overlab with range values.{p_end}

{p2coldent : {opt smooth(num)}}This option allows users to smooth out the spider plots using splines. It can take on values between [0,1] 
where 0 = tighter curves and 1 = wider curves. A value of 0.5 is a reasonable middle ground.
If the points are close to each other or there are large data spikes, then the smoothing might result in "twisting" or creating a loop for the splines.
In this case, it is advised to use a smaller {opt smooth()}} value, or extend the range of the circles so points are reasonable better spaced.{p_end}

{p2coldent : {opt palette(name)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package.
Default is {stata colorpalette tableau:{it:tableau}}.{p_end}

{p2coldent : {opt ra:nge(min max)}}Use this option to define the range of the graph. Default values are the minimum and maximum of all the data
points that are offset by 10% of the data range. This might not be optimal in all cases. For example, if you know that your data is between 0-100,
but the actual values are between 40-80, the graph range will automatically adjust the ranges to 36 and 84, or 40-0.1*(80-40) and 80+0.1*(80-40)
respectively. In this case, it is better to define {opt ra:nge(0 100)} to control the scaling.{p_end}

{p2coldent : {opt cuts(num)}}The number of cuts to show in the graph as rings. Default value is {opt cuts(6)}. For example, if the range is 
0-100, six cuts will split the data into 0,20,40,60,80,100. Or (100/5) + 1 because we also need to account for the starting value.
Please keep this in mind when defining this option.{p_end}

{p2coldent : {opt format(fmt)}}Format the values of the data range. The default format is {opt format(%12.1f)}.
If your data ranges has decimal values, then it is advised to change the display to a reasonable format.{p_end}

{p2coldent : {opt wrap(num)}}Wrap the labels after a number of characters. A good starting point for very long labels is {opt wrap(50)}.{p_end}

{p2coldent : {opt ralabs:ize(str)}}The size of the range labels. The default format is {opt ralabs(1.8)}.{p_end}

{p2coldent : {opt ralabc:olor(str)}}The color of the range labels. The default format is {opt ralabc(black)}.{p_end}

{p2coldent : {opt ralaba:ngle(str)}}The angle of the range labels. The default format is {opt ralaba(0)} for horizontal.{p_end}

{p2coldent : {opt lw:idth(num)}}The outline width of the spider area fill. Default is {opt lw(0.3)}.
Area fill lines can be turned off by defining {opt lw(none)}.{p_end}

{p2coldent : {opt msym:bol(str)}}The marker symbol on the spider lines. Default is {opt msym(circle)}.
Markers can be turned off by defining {opt msymb(none)}.{p_end}

{p2coldent : {opt wrap(num)}}Wrap the labels after a number of characters. For example, {opt wrap(50)} will wrap labels every 50 characters.{p_end}

{p2coldent : {opt ms:ize(str)}}The marker size on the spider lines. Default is {opt ms(0.3)}.{p_end}

{p2coldent : {opt mlw:idth(str)}}The marker line size on the spider lines. Default is {opt mlw(0.3)}.
For example, if you are using a hollow circle or {opt msym(Oh)}, then increasing its outline width makes it more prominent.{p_end}

{p2coldent : {opt nolegend}}Hide the legend.{p_end}

{p2coldent : {opt legpos:ition(num)}}Clock position of the legend. Default is {opt legpos(6)}.{p_end}

{p2coldent : {opt legcol:umns(num)}}Number of legend columns. Default is {opt legcol(3)}.{p_end}

{p2coldent : {opt legs:ize(num)}}Size of legend entries. Default is {opt legs(2.2)}.{p_end}

{p2coldent : {opt displaces:pike(num)}}Defines how much the spikes should be extended beyond the circle extent.
The default value is {opt displaces(2)} for 2%.{p_end}

{p2coldent : {opt displacel:ab(num)}}Push {opt over()} labels away from the spikes. The default value is {opt displacel(15)} or 15% of spike length.{p_end}

{p2coldent : {opt cc:olor(str)}}The color of the circles. Default is {opt cc(gs12)}.{p_end}

{p2coldent : {opt cw:idth(str)}}The width of the circles. Default is {opt cw(0.1)}.{p_end}

{p2coldent : {opt sc:olor(str)}}The color of the spikes. Default is {opt sc(gs12)}.{p_end}

{p2coldent : {opt sw:idth(str)}}The width of the spikes. Default is {opt sw(0.1)}.{p_end}

{p2coldent : {opt rotatelab:el}}Rotate the spike labels by 90 degrees.{p_end}

{p2coldent : {opt slabs:ize(str)}}The width of the spike labels. Default is {opt slabs(2.2)}.{p_end}

{p2coldent : {opt slabc:olor(str)}}The color of the spike labels. Default is {opt slabc(black)}.{p_end}

{p2coldent : {opt xsize(num)}, {opt ysize(num)}}Dimensions of the graph. Defaults are {opt xsize(1)} and {opt ysize(1)}.{p_end}

{p2coldent : {opt *}}All other standard twoway options.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018, 2022) is required for {cmd:spider}:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have these installed, it is highly recommended to update the dependencies:
{stata ado update, update}

{title:Examples}

See {browse "https://github.com/asjadnaqvi/stata-spider":GitHub} for examples.


{title:Package details}

Version      : {bf:spider} v1.32
This release : 11 Jun 2024
First release: 13 Oct 2022
Repository   : {browse "https://github.com/asjadnaqvi/stata-spider":GitHub}
Keywords     : Stata, graph, spider plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-spider/issues":GitHub} by opening a new issue.


{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.

{p 4 8 2}Jann, B. (2022). {browse "https://ideas.repec.org/p/bss/wpaper/43.html":Color palettes for Stata graphics: An update}. University of Bern Social Sciences Working Papers No. 43. 


{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-spider/issues":GitHub} by opening a new issue.


{title:Citation guidelines}

Suggested citation guidlines for this package:

Naqvi, A. (2024). Stata package "spider" version 1.32. Release date 11 June 2024. https://github.com/asjadnaqvi/stata-spider.

@software{spider,
   author = {Naqvi, Asjad},
   title = {Stata package ``spider''},
   url = {https://github.com/asjadnaqvi/stata-spider},
   version = {1.32},
   date = {2024-06-11}
}


{title:Other visualization packages}

{psee}
    {helpb arcplot}, {helpb alluvial}, {helpb bimap}, {helpb bumparea}, {helpb bumpline}, {helpb circlebar}, {helpb circlepack}, {helpb clipgeo}, {helpb delaunay}, {helpb joyplot}, 
	{helpb marimekko}, {helpb polarspike}, {helpb sankey}, {helpb schemepack}, {helpb spider}, {helpb streamplot}, {helpb sunburst}, {helpb treecluster}, {helpb treemap}, {helpb waffle}

or visit {browse "https://github.com/asjadnaqvi":GitHub} for detailed documentation and examples.	
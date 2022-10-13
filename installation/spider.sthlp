{smcl}
{* 13October2022}{...}
{hi:help spider}{...}
{right:{browse "https://github.com/asjadnaqvi/stata-spider":spider v1.0 (GitHub)}}

{hline}

{title:spider}: A Stata package for spider plots.

{p 4 4 2}
The command is based on the following guide on Medium: {browse "https://medium.com/the-stata-guide/stata-graphs-spider-plots-613808b51f73":Spider plots}.
The command is still {it:beta} and is subject to change and improvements. Please regularly check the {browse "https://github.com/asjadnaqvi/stata-spider":GitHub} page for version changes and updates.


{marker syntax}{title:Syntax}
{p 8 15 2}

{cmd:spider} {it:variables} {ifin}, {cmd:over}({it:cat var}) 
                {cmd:[} {cmd:alpha}({it:num 0-100}) {cmdab:ro:tate}({it:num}) {cmd:smooth}({it:num 0-1})  {cmd:palette}({it:str})
                  {cmdab:ra:nge}({it:val1 val2}) {cmd:cuts}({it:num}) {cmd:raformat}({it:fmt}) {cmdab:ralabs:ize}({it:str}) 
                  {cmdab:lw:idth}({it:str}) {cmdab:msym:bol}({it:str}) {cmdab:ms:ize}({it:str}) {cmdab:mlw:idth}({it:str}) 
                  {cmd:legend}({it:str}) {cmdab:displacel:ab}({it:num}) {cmdab:displaces:pike}({it:num}) 
                  {cmdab:cc:olor}({it:str}) {cmdab:cw:idth}({it:str}) {cmdab:sc:olor}({it:str}) {cmdab:sw:idth}({it:str}) {cmdab:slabs:ize}({it:str})
                  {cmd:title}({it:str}) {cmd:subtitle}({it:str}) {cmd:note}({it:str}) {cmd:scheme}({it:str}) {cmd:name}({it:str}) {cmd:]}

{p 4 4 2}


{synoptset 36 tabbed}{...}
{synopthdr}
{synoptline}

{p2coldent : {opt spider variables, over(cat var)}}The command requires a list of variables, each corresponding to a spider plot that contains numeric values.
The groups are determined by the {opt over()} variable. If there are more than one observations per {opt over()} variable, the command will collapse and average the data.
So make sure to control the data before using the {cmd:spider} command. See examples below.{p_end}

{p2coldent : {opt alpha(numeric)}}The transparency control of the spider area fills. The value ranges from 0-100, where 0 is no fill and 100 is fully filled.
Default value is {it:5} or 5% transparency.{p_end}

{p2coldent : {opt ro:tate(num)}}Rotate the graph in degrees. The default value is {it:30} or 30 degrees to prevent overlab with range values.{p_end}

{p2coldent : {opt smooth(num)}}This option allows users to smooth out the spider plots. It can take on values between [0,1], 
where 0 = tighter curves and 1 = wider curves. A value of 0.5 is a reasonable middle ground.{p_end}

{p2coldent : {opt palette(name)}}Color name is any named scheme defined in the {stata help colorpalette:colorpalette} package. Default is {stata colorpalette tableau:{it:tableau}}.{p_end}

{p2coldent : {opt ra:nge(val1 val2)}}Use this option to define the range of the graph. Default values are the minimum and maximum of all the data points that are offset by 10% of the data range.
This might not be optimal in all cases. For example, if you know that your data is between 0-100, but the actual values are between 40-80, the graph range will automatically adjust the ranges to 36 and 84, or 40-0.1*(80-40) and 80+0.1*(80-40) respectively.
In this case, it is better to define {opt ra:nge(0 100)} to control the scaling.
Note that scaling works even with negative ranges.{p_end}

{p2coldent : {opt cuts(num)}}The number of cuts to show in the graph as rings. Default value is {it:6}. For example, if the range is 
0-100, six cuts will split the data into 0,20,40,60,80,100. Or (100/5) + 1 because we also need to account for the starting value.
Keep this in mind when defining the {opt cuts()}.{p_end}

{p2coldent : {opt raformat(fmt)}}Format the values of the data range. The default format is {it:%5.0f}.
If your data ranges has decimal values, then it is advised to change the display to a reasonable format.{p_end}

{p2coldent : {opt ralabs:ize(str)}}The size of the range labels. The default format is {it:1.8}.{p_end}

{p2coldent : {opt lw:idth(num)}}The outline width of the spider area fill. Default is {it:0.3}.
Area fill lines can be turned off by defining {opt lw(none)}.{p_end}

{p2coldent : {opt msym:bol(str)}}The marker symbol on the spider lines. Default is {it:circle}.
Markers can be turned off by defining {opt msymb(none)}.{p_end}

{p2coldent : {opt ms:ize(str)}}The marker size on the spider lines. Default is {it:0.3}.{p_end}

{p2coldent : {opt mlw:idth(str)}}The marker line size on the spider lines. Default is {it:0.3}.
For example, if you are using a hollow circle or {opt msym(Oh)}, then increasing its outline width makes it more prominent.{p_end}

{p2coldent : {opt legend()}}{it:NOTE: Currently not available.} The default values are the names of the plotted variables shown at 6 o'clock position in a single row.
If there are more than five variables, the legend automatically adjusts to 2 rows.{p_end}

{p2coldent : {opt displacel:ab(num)}}Push {opt over()} labels away from the spikes. The default value is {it:15} or 15% of spike length.{p_end}

{p2coldent : {opt displaces:pike(num)}}Extend the length of the spikes beyond the outermost circle. The default value is {it:2} or 2% of outermost circle value.{p_end}

{p2coldent : {opt cc:olor(str)}}The color of the circles. Default is {it:gs12}.{p_end}

{p2coldent : {opt cw:idth(str)}}The width of the circles. Default is {it:0.1}.{p_end}

{p2coldent : {opt sc:olor(str)}}The color of the spikes. Default is {it:gs12}.{p_end}

{p2coldent : {opt sw:idth(str)}}The width of the spikes. Default is {it:0.1}.{p_end}

{p2coldent : {opt slabs:ize(str)}}The width of the spikes. Default is {it:2.2}.{p_end}

{p2coldent : {opt title}, {opt subtitle}, {opt note}}These are standard twoway graph options.{p_end}

{p2coldent : {opt scheme(string)}}Load the custom scheme. Above options can be used to fine tune individual elements.{p_end}

{p2coldent : {opt name(string)}}Assign a name to the graph.{p_end}

{synoptline}
{p2colreset}{...}


{title:Dependencies}

The {browse "http://repec.sowi.unibe.ch/stata/palettes/index.html":palette} package (Jann 2018) is required for {cmd:spider}:

{stata ssc install palettes, replace}
{stata ssc install colrspace, replace}

Even if you have these installed, it is highly recommended to update the dependencies:
{stata ado update, update}

{title:Examples}

See {browse "https://github.com/asjadnaqvi/spider":GitHub} for examples.



{hline}

{title:Version history}

- {bf:1.0} : First version.


{title:Package details}

Version      : {bf:spider} v1.0
This release : 13 Oct 2022
First release: 13 Oct 2021
Repository   : {browse "https://github.com/asjadnaqvi/spider":GitHub}
Keywords     : Stata, graph, spider plot
License      : {browse "https://opensource.org/licenses/MIT":MIT}

Author       : {browse "https://github.com/asjadnaqvi":Asjad Naqvi}
E-mail       : asjadnaqvi@gmail.com
Twitter      : {browse "https://twitter.com/AsjadNaqvi":@AsjadNaqvi}


{title:Acknowledgements}



{title:Feedback}

Please submit bugs, errors, feature requests on {browse "https://github.com/asjadnaqvi/stata-spider/issues":GitHub} by opening a new issue.

{title:References}

{p 4 8 2}Jann, B. (2018). {browse "https://www.stata-journal.com/article.html?article=gr0075":Color palettes for Stata graphics}. The Stata Journal 18(4): 765-785.


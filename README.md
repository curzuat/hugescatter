# hugescatter
transform scatterplot data into heatmap file for hugeheat. Which will then result in a scatterplot image.

#Required parameters

--input #A tab delimited table with two columns named x and y which correspond to desired axes.

#Optional parameters

--outdir #Location of output (default results/)
--resolution # a positive number that specifies the 2 dimensions of the generated scatterplot (default 1000)

--furthest # A number Which specifies the value furthest from zero that will be plotted (default all data)
--threshold # A number 0->1 that scpecifies the quantile to determine the furthest point to be plotted (ignores --furthest)

--bins #Bin size to use when pooling data for histogram when using --histogram flag (default 2).



#Optional flags

--histogram # also generate histogram grids for each dimension
--proportional # Maintain proportions among both axes of scatterplot. Histograms are always proportional

#Todo
Also specify the minimum value to be plotted separately for each axis?



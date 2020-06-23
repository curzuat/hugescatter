#!/usr/bin/env Rscript
library(data.table)
library(magrittr)

result_comparison <- fread("data.csv")

resolution <- ${params.resolution}

q <- ${params.threshold}
furthest_x = result_comparison[, quantile(abs(x), q)]
furthest_y = result_comparison[, quantile(abs(y), q)]
min_x = result_comparison[, min(x)]
min_y = result_comparison[, min(y)]

x_offset = 0
if (min_x < 0){
	x_offset = resolution
}
y_offset = 0
if (min_y < 0){
	y_offset = resolution
}

global_max = ifelse("${params.furthest}" == "NOT PROVIDED", max(furthest_x, furthest_y), as.numeric("${params.furthest}"))
global_min = ifelse("${params.minimum}" == "NOT PROVIDED", min(furthest_x, furthest_y), as.numeric("${params.minimum}"))

if ("${params.proportional}" != "NOT PROVIDED"){
	furthest_x <- global_max
	furthest_y <- global_max
}

result_comparison[,x:=floor(x/furthest_x * resolution) + x_offset]
result_comparison[,y:=floor(y/furthest_y * resolution) + y_offset]

grid <- CJ(1:(resolution + x_offset),1:(resolution + y_offset))
setnames(grid,c("V1","V2"),c("x","y"))

filled_grid <- result_comparison[,.N,by=.(x, y)][grid, on=c("x==x","y==y")]
filled_grid[is.na(N), N:=0]

filled_grid %>% dcast( y ~ x) %>% fwrite("grid.txt", sep="\t")
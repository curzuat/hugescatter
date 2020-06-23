#!/usr/bin/env Rscript
library(data.table)
library(magrittr)
library(optiRum)

filled_grid <- fread("grid.txt") %>% melt(id.vars = "y", variable.factor = FALSE)

filled_grid[, x := as.numeric(variable)]

bin_size = ${params.bins}
resolution <- ${params.resolution}

x_frequencies = filled_grid[,sum(value), by=x] # by x
x_frequencies[, bin_id := floor(x/bin_size)] # x / bin_size

y_frequencies = filled_grid[,sum(value), by=y]
y_frequencies[, bin_id := floor(y/bin_size)]

binned_frequencies_x = x_frequencies[, sum(V1), by = bin_id]
binned_frequencies_y = y_frequencies[, sum(V1), by = bin_id]

max_frequency = max(binned_frequencies_x[, max(V1)], binned_frequencies_y[, max(V1)])

create_histogram_matrix <- function(binned_frequencies, max_frequency)
{
  binned_frequencies[, hist_height := (V1/max_frequency) * resolution]

  dummy_table <- data.table(y = 1:resolution)
  
  x_histogram_data = CJ.dt(binned_frequencies, dummy_table)
  
  x_histogram_data[, value := 0]
  x_histogram_data[y < hist_height, value := 1]
  x_histogram_data[y == 1 & hist_height > 0, value := hist_height]
  
  dcast(x_histogram_data[,.(bin_id, y, value)],  y ~ bin_id)
}
create_histogram_matrix(binned_frequencies_y, max_frequency) %>%
  fwrite("y_histogram.txt", sep="\t")

create_histogram_matrix(binned_frequencies_x, max_frequency) %>%
  fwrite("x_histogram.txt", sep="\t")
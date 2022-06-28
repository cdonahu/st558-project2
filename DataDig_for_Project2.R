
library(tidyverse)
library(readr)

data <- readr::read_csv(file = "OnlineNewsPopularity.csv",
                        show_col_types = FALSE
)
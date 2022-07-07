# st558-project2

The purpose of this project is to automate the creation of documents using R Markdown, one for each type of article in the data set provided [here](https://archive.ics.uci.edu/ml/datasets/Online+News+Popularity). 

R packages used:  
- tidyverse  
- caret  
- readr  
- GGally  
- randomForest  
- 

Links to the generated analyses: 

- [Lifestyle](lifestyle.html)  
- [Entertainment](entertainment.html)  
- [Business](bus.html)  
- [Social Media](socmed.html)  
- [Tech](tech.html)  
- [World](world.html)  

Code used to render the analyses from a single .Rmd file: 
```
library(rmarkdown)

# A function to generate a report for each Channel

renderPages <- function(channel) {
  rmarkdown::render('./st558-project2.Rmd',
                    output_format = 'github_document',
                    output_file = paste(channel, '.md', sep = ""),
                    params = list(channel = channel),
                    output_dir = './',
                    output_options = list(
                      df_print = 'default',
                      html_preview = FALSE # to remove .html file creation
                    )
  )
}

# A for loop to generate all reports
channelList <- c("lifestyle", "entertainment", "bus", "socmed", "tech", "world")

for (channel in channelList) {
  renderPages(channel)
}
```
With help from the [R Markdown Cookbook, Section 17.4](https://bookdown.org/yihui/rmarkdown-cookbook/parameterized-reports.html)
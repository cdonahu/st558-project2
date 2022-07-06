# st558-project2

The purpose of this project is to automate the creation of documents using R Markdown, one for each type of article in the data set provided [here](https://archive.ics.uci.edu/ml/datasets/Online+News+Popularity). 

R packages used:  
- tidyverse  
- caret  

Links to the generated analyses: 

- [Lifestyle]()  
- [Entertainment]()  
- [Business]()  
- [Social Media]()  
- [Tech]()  
- [World]()  

Code used to render the analyses from a single .Rmd file: 
library(rmarkdown)
rmarkdown::render('./st558-project2.Rmd',
                  output_format = 'github_document',
                  output_file = 'document-title.md',
                  output_dir = './',
                  output_options = list(
                    df_print = 'default',
                    html_preview = FALSE # to remove .html file creation
                  )
)

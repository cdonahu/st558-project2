Analysis of an Online News Popularity Data Set
================
Claudia Donahue and Dane Korver
2022-06-28

-   [Introduction](#introduction)
-   [Data](#data)
-   [Summarizations](#summarizations)
-   [Modeling](#modeling)
-   [Comparison](#comparison)
-   [Automation](#automation)

## Introduction

For this project, the
[dataset](https://archive.ics.uci.edu/ml/datasets/Online+News+Popularity)
we are using summarizes a heterogeneous set of statistics about articles
published by Mashable over a period of two years. The goal is to predict
the number of shares in social networks (popularity). We wanted to look
at the patterns in the articles that were shared. For example, is the
timing of the article, the headline, and the article’s content all
relevent in determining the number of times the article gets shared.
What about whether an article had a polarizing title versus a generic
non-polarizing title. Then, we wanted to find out whether the number of
keywords associated with an article impacted the number of shares it
received. Here is our findings for studying how to predict the number of
shares in social networks (popularity).

## Data

We’ll begin by reading in the data set and looking at how it’s
structured.

``` r
data <- readr::read_csv(file = "OnlineNewsPopularity.csv",
                        show_col_types = FALSE
                        )
# Look at structure of data set
str(data)
```

    ## spec_tbl_df [39,644 × 61] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
    ##  $ url                          : chr [1:39644] "http://mashable.com/2013/01/07/amazon-instant-video-browser/" "http://mashable.com/2013/01/07/ap-samsung-sponsored-tweets/" "http://mashable.com/2013/01/07/apple-40-billion-app-downloads/" "http://mashable.com/2013/01/07/astronaut-notre-dame-bcs/" ...
    ##  $ timedelta                    : num [1:39644] 731 731 731 731 731 731 731 731 731 731 ...
    ##  $ n_tokens_title               : num [1:39644] 12 9 9 9 13 10 8 12 11 10 ...
    ##  $ n_tokens_content             : num [1:39644] 219 255 211 531 1072 ...
    ##  $ n_unique_tokens              : num [1:39644] 0.664 0.605 0.575 0.504 0.416 ...
    ##  $ n_non_stop_words             : num [1:39644] 1 1 1 1 1 ...
    ##  $ n_non_stop_unique_tokens     : num [1:39644] 0.815 0.792 0.664 0.666 0.541 ...
    ##  $ num_hrefs                    : num [1:39644] 4 3 3 9 19 2 21 20 2 4 ...
    ##  $ num_self_hrefs               : num [1:39644] 2 1 1 0 19 2 20 20 0 1 ...
    ##  $ num_imgs                     : num [1:39644] 1 1 1 1 20 0 20 20 0 1 ...
    ##  $ num_videos                   : num [1:39644] 0 0 0 0 0 0 0 0 0 1 ...
    ##  $ average_token_length         : num [1:39644] 4.68 4.91 4.39 4.4 4.68 ...
    ##  $ num_keywords                 : num [1:39644] 5 4 6 7 7 9 10 9 7 5 ...
    ##  $ data_channel_is_lifestyle    : num [1:39644] 0 0 0 0 0 0 1 0 0 0 ...
    ##  $ data_channel_is_entertainment: num [1:39644] 1 0 0 1 0 0 0 0 0 0 ...
    ##  $ data_channel_is_bus          : num [1:39644] 0 1 1 0 0 0 0 0 0 0 ...
    ##  $ data_channel_is_socmed       : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ data_channel_is_tech         : num [1:39644] 0 0 0 0 1 1 0 1 1 0 ...
    ##  $ data_channel_is_world        : num [1:39644] 0 0 0 0 0 0 0 0 0 1 ...
    ##  $ kw_min_min                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_max_min                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_avg_min                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_min_max                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_max_max                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_avg_max                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_min_avg                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_max_avg                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ kw_avg_avg                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ self_reference_min_shares    : num [1:39644] 496 0 918 0 545 8500 545 545 0 0 ...
    ##  $ self_reference_max_shares    : num [1:39644] 496 0 918 0 16000 8500 16000 16000 0 0 ...
    ##  $ self_reference_avg_sharess   : num [1:39644] 496 0 918 0 3151 ...
    ##  $ weekday_is_monday            : num [1:39644] 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ weekday_is_tuesday           : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_wednesday         : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_thursday          : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_friday            : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_saturday          : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ weekday_is_sunday            : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ is_weekend                   : num [1:39644] 0 0 0 0 0 0 0 0 0 0 ...
    ##  $ LDA_00                       : num [1:39644] 0.5003 0.7998 0.2178 0.0286 0.0286 ...
    ##  $ LDA_01                       : num [1:39644] 0.3783 0.05 0.0333 0.4193 0.0288 ...
    ##  $ LDA_02                       : num [1:39644] 0.04 0.0501 0.0334 0.4947 0.0286 ...
    ##  $ LDA_03                       : num [1:39644] 0.0413 0.0501 0.0333 0.0289 0.0286 ...
    ##  $ LDA_04                       : num [1:39644] 0.0401 0.05 0.6822 0.0286 0.8854 ...
    ##  $ global_subjectivity          : num [1:39644] 0.522 0.341 0.702 0.43 0.514 ...
    ##  $ global_sentiment_polarity    : num [1:39644] 0.0926 0.1489 0.3233 0.1007 0.281 ...
    ##  $ global_rate_positive_words   : num [1:39644] 0.0457 0.0431 0.0569 0.0414 0.0746 ...
    ##  $ global_rate_negative_words   : num [1:39644] 0.0137 0.01569 0.00948 0.02072 0.01213 ...
    ##  $ rate_positive_words          : num [1:39644] 0.769 0.733 0.857 0.667 0.86 ...
    ##  $ rate_negative_words          : num [1:39644] 0.231 0.267 0.143 0.333 0.14 ...
    ##  $ avg_positive_polarity        : num [1:39644] 0.379 0.287 0.496 0.386 0.411 ...
    ##  $ min_positive_polarity        : num [1:39644] 0.1 0.0333 0.1 0.1364 0.0333 ...
    ##  $ max_positive_polarity        : num [1:39644] 0.7 0.7 1 0.8 1 0.6 1 1 0.8 0.5 ...
    ##  $ avg_negative_polarity        : num [1:39644] -0.35 -0.119 -0.467 -0.37 -0.22 ...
    ##  $ min_negative_polarity        : num [1:39644] -0.6 -0.125 -0.8 -0.6 -0.5 -0.4 -0.5 -0.5 -0.125 -0.5 ...
    ##  $ max_negative_polarity        : num [1:39644] -0.2 -0.1 -0.133 -0.167 -0.05 ...
    ##  $ title_subjectivity           : num [1:39644] 0.5 0 0 0 0.455 ...
    ##  $ title_sentiment_polarity     : num [1:39644] -0.188 0 0 0 0.136 ...
    ##  $ abs_title_subjectivity       : num [1:39644] 0 0.5 0.5 0.5 0.0455 ...
    ##  $ abs_title_sentiment_polarity : num [1:39644] 0.188 0 0 0 0.136 ...
    ##  $ shares                       : num [1:39644] 593 711 1500 1200 505 855 556 891 3600 710 ...
    ##  - attr(*, "spec")=
    ##   .. cols(
    ##   ..   url = col_character(),
    ##   ..   timedelta = col_double(),
    ##   ..   n_tokens_title = col_double(),
    ##   ..   n_tokens_content = col_double(),
    ##   ..   n_unique_tokens = col_double(),
    ##   ..   n_non_stop_words = col_double(),
    ##   ..   n_non_stop_unique_tokens = col_double(),
    ##   ..   num_hrefs = col_double(),
    ##   ..   num_self_hrefs = col_double(),
    ##   ..   num_imgs = col_double(),
    ##   ..   num_videos = col_double(),
    ##   ..   average_token_length = col_double(),
    ##   ..   num_keywords = col_double(),
    ##   ..   data_channel_is_lifestyle = col_double(),
    ##   ..   data_channel_is_entertainment = col_double(),
    ##   ..   data_channel_is_bus = col_double(),
    ##   ..   data_channel_is_socmed = col_double(),
    ##   ..   data_channel_is_tech = col_double(),
    ##   ..   data_channel_is_world = col_double(),
    ##   ..   kw_min_min = col_double(),
    ##   ..   kw_max_min = col_double(),
    ##   ..   kw_avg_min = col_double(),
    ##   ..   kw_min_max = col_double(),
    ##   ..   kw_max_max = col_double(),
    ##   ..   kw_avg_max = col_double(),
    ##   ..   kw_min_avg = col_double(),
    ##   ..   kw_max_avg = col_double(),
    ##   ..   kw_avg_avg = col_double(),
    ##   ..   self_reference_min_shares = col_double(),
    ##   ..   self_reference_max_shares = col_double(),
    ##   ..   self_reference_avg_sharess = col_double(),
    ##   ..   weekday_is_monday = col_double(),
    ##   ..   weekday_is_tuesday = col_double(),
    ##   ..   weekday_is_wednesday = col_double(),
    ##   ..   weekday_is_thursday = col_double(),
    ##   ..   weekday_is_friday = col_double(),
    ##   ..   weekday_is_saturday = col_double(),
    ##   ..   weekday_is_sunday = col_double(),
    ##   ..   is_weekend = col_double(),
    ##   ..   LDA_00 = col_double(),
    ##   ..   LDA_01 = col_double(),
    ##   ..   LDA_02 = col_double(),
    ##   ..   LDA_03 = col_double(),
    ##   ..   LDA_04 = col_double(),
    ##   ..   global_subjectivity = col_double(),
    ##   ..   global_sentiment_polarity = col_double(),
    ##   ..   global_rate_positive_words = col_double(),
    ##   ..   global_rate_negative_words = col_double(),
    ##   ..   rate_positive_words = col_double(),
    ##   ..   rate_negative_words = col_double(),
    ##   ..   avg_positive_polarity = col_double(),
    ##   ..   min_positive_polarity = col_double(),
    ##   ..   max_positive_polarity = col_double(),
    ##   ..   avg_negative_polarity = col_double(),
    ##   ..   min_negative_polarity = col_double(),
    ##   ..   max_negative_polarity = col_double(),
    ##   ..   title_subjectivity = col_double(),
    ##   ..   title_sentiment_polarity = col_double(),
    ##   ..   abs_title_subjectivity = col_double(),
    ##   ..   abs_title_sentiment_polarity = col_double(),
    ##   ..   shares = col_double()
    ##   .. )
    ##  - attr(*, "problems")=<externalptr>

``` r
# Checking to see whether the data has missing values
sum(is.na(data))
```

    ## [1] 0

The data has just one column that is not numeric, and that column is the
first one and contains URLs for the Mashable articles for each
observation. We will keep it, but won’t use it in our models. The second
column, `timedelta`, is not useful for prediction either. We will drop
this one. The other columns contain numeric data that we may be able to
use to predict the number of shares. The last column is our target
variable, `shares`. The data is set up nicely for what we want to do.

``` r
# Dropping the timedelta column

library(plyr)
library(tidyverse)
data <- select(data, -timedelta)

#Converting categorical values from numeric to factor - Weekdays
data$weekday_is_monday <- factor(data$weekday_is_monday)
data$weekday_is_tuesday <- factor(data$weekday_is_tuesday)
data$weekday_is_wednesday <- factor(data$weekday_is_wednesday)
data$weekday_is_thursday <- factor(data$weekday_is_thursday)
data$weekday_is_friday <- factor(data$weekday_is_friday)
data$weekday_is_saturday <- factor(data$weekday_is_saturday)
data$weekday_is_sunday <- factor(data$weekday_is_sunday)

#Converting categorical values from numeric to factor - News subjects
data$data_channel_is_lifestyle <- factor(data$data_channel_is_lifestyle) 
data$data_channel_is_entertainment <- factor(data$data_channel_is_entertainment)
data$data_channel_is_bus <- factor(data$data_channel_is_bus)
data$data_channel_is_socmed <- factor(data$data_channel_is_socmed)
data$data_channel_is_tech <- factor(data$data_channel_is_tech)
data$data_channel_is_world <- factor(data$data_channel_is_world)
```

Next we will begin our look at one specific channel by subsetting the
data.

``` r
channel <- channel # set = to channel when ready to automate

channelNow <- paste("data_channel_is_", channel, sep = "")

cData <- data[data[channelNow] == 1, ] # Extract rows of interest
```

We then split the data into training and testing sets (70% and 30%,
respectively). We will only explore the training set, and will keep the
testing set in reserve to determine the quality of our predictions. We
will use the function `createDataPartition()` from the `caret` package
to split the data.

``` r
library(caret) # Using createDataPartition from caret

set.seed(33) # for reproducibility 

# Index to split on
idx <- createDataPartition(y = cData$shares, p = 0.7, list = FALSE)

# Subset
training <- cData[idx, ]
testing <- cData[-idx, ]
```

## Summarizations

Then we thought about the characteristics of an online article that
might be associated with someone deciding to “share” the article to
someone else.

We thought it was probably important to consider both the timing of the
article, the headline, and the article’s content. By timing, we mean
that perhaps some readers are more likely to click on an article and
share it on the weekend because they generally have more free time to
read. We looked at numbers of shares on weekends vs. weekdays to see if
that held true.

``` r
training %>% group_by(is_weekend) %>%
  summarise(avgShares = mean(shares),
            medianShares = median(shares),
            stdevShares = sd(shares)
            )
```

    ##   avgShares medianShares stdevShares
    ## 1  2935.502         1400    13407.15

The average and median calculations are measures of centrality, so that
we can compare shares on weekends vs. on weekdays. The standard
deviation of shares is a measure of the spread of the data, so that we
can see if the average number of shares per article is more consistent
on weekends or on weekdays. A higher standard deviation means the number
of shares varies more from the average.

Then we wanted to create a visualization that would show us how the
variable `title_sentiment_polarity` seemed to impact the number of
shares. Our thought was that maybe an article with a more polarizing
title would get more shares than one less polarizing, as people want to
have some justification for urging a friend to spend time reading the
article. A polarizing sentiment could provide that justification for
some people. We will plot the polarity of the title’s sentiment and
include information on the number of words in the title.

``` r
ggplot(training, aes(x = title_sentiment_polarity,
                     y = shares,
                     color = n_tokens_title)) +
  geom_point() +
  labs(title = "Title Sentiment vs Number of Shares",
       x = "Sentiment Polarity of Title",
       y = "Number of Shares",
       color = "# Words in Title")
```

![](./bus_images/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

Then we wanted to look at the outliers–the top articles by shares, so we
grabbed a list of those URLs, along with the number of shares.

``` r
head(training[order(training$shares, decreasing = TRUE), c("url", "shares")], 10)
```

    ## # A tibble: 10 × 2
    ##    url                                                                     shares
    ##    <chr>                                                                    <dbl>
    ##  1 http://mashable.com/2013/04/15/dove-ad-beauty-sketches/                 690400
    ##  2 http://mashable.com/2014/01/14/australia-heatwave-photos/               310800
    ##  3 http://mashable.com/2013/11/14/ibm-watson-brief/                        298400
    ##  4 http://mashable.com/2013/11/19/mapbox/                                  106400
    ##  5 http://mashable.com/2013/10/18/edward-snowden-dont-have-nsa-documents/  102200
    ##  6 http://mashable.com/2013/10/29/vampire-selfies/                          98700
    ##  7 http://mashable.com/2013/11/27/thanksgiving-times-square/                94400
    ##  8 http://mashable.com/2014/01/31/nsa-director-michael-rogers/              92100
    ##  9 http://mashable.com/2014/01/06/snapchat-hires-washington-lobbying-firm/  78600
    ## 10 http://mashable.com/2014/10/21/scientists-discover-the-origins-of-sex/   78600

Finally, we thought about how the content of an article might lead
someone to share it. Maybe people share shorter articles more than long
ones. Maybe people like to share links with images more than links
without images, we thought. So we took a look at an article’s length and
number of images vs. number of shares.

``` r
ggplot(training, aes(x = n_tokens_content,
                     y = shares,
                     color = num_imgs)) +
  geom_point() +
  labs(title = "Article Length vs Number of Shares",
       x = "Number of Words in Article",
       y = "Number of Shares",
       color = "# Images")
```

![](./bus_images/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

Within its metadata, a website can be assigned a number of keywords,
which used to give search engines more information about the content. We
wondered how the number of keywords related to the number of shares,
given that this data is several years old, and that used to be
considered a part of search engine optimization.

``` r
ggplot(training, aes(x = num_keywords,
                     y = shares)) +
  geom_count() +
  labs(title = "Number of Keywords vs. Shares",
       x = "Number of Keywords",
       y = "Number of Shares")
```

![](./bus_images/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

Before the modeling step, we took one final look at some of the other
variables we thought might be important in predicting number of shares,
based on the summaries above and our own experiences.

``` r
library(GGally)
training %>% 
  select(self_reference_avg_sharess, LDA_00, rate_negative_words, shares) %>%
  GGally::ggpairs()
```

    ## plot: [1,1] [==>---------------------------------------------------] 6% est: 0s
    ## plot: [1,2] [======>-----------------------------------------------] 12% est: 1s
    ## plot: [1,3] [=========>--------------------------------------------] 19% est: 1s
    ## plot: [1,4] [=============>----------------------------------------] 25% est: 1s
    ## plot: [2,1] [================>-------------------------------------] 31% est: 1s
    ## plot: [2,2] [===================>----------------------------------] 38% est: 1s
    ## plot: [2,3] [=======================>------------------------------] 44% est: 1s
    ## plot: [2,4] [==========================>---------------------------] 50% est: 0s
    ## plot: [3,1] [=============================>------------------------] 56% est: 0s
    ## plot: [3,2] [=================================>--------------------] 62% est: 0s
    ## plot: [3,3] [====================================>-----------------] 69% est: 0s
    ## plot: [3,4] [=======================================>--------------] 75% est: 0s
    ## plot: [4,1] [===========================================>----------] 81% est: 0s
    ## plot: [4,2] [==============================================>-------] 88% est: 0s
    ## plot: [4,3] [==================================================>---] 94% est: 0s
    ## plot: [4,4] [======================================================]100% est: 0s

![](./bus_images/exploratory%20graph-1.png)<!-- -->

Looking across the bottom row of graphs, we can see whether any
relationships between `shares` and another variable are evident.

## Modeling

### Linear Regression

Linear regression is a way of calculating the relationship between one
or more input/independent variables and an output/dependent variable.
(More than one input variable would make the model a multiple
regression) In this case, our output variables is `shares`, the number
of times a Mashable article was shared. A linear regression assumes that
one or more other variables are correlated with the number of shares,
and that the relationship can be visually represented as a straight
line. The mathematical equation for a basic linear regression is:

![y = B\*x+A](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;y%20%3D%20B%2Ax%2BA "y = B*x+A")

where y is the dependent variable, x is an independent variable, and A
and B are coefficients for the line’s y-intercept and slope. The values
for these coefficients are chosen to minimize the error between the
model’s predictions and the actual outcomes in the training data.

With that, here we go! We are using the `train()` function from the
`caret` package to make the model. We will use the results of 5-fold
cross-validation to evaluate the performance of all our models and,
later, to compare them.

This first multiple regression (linear regression model extended to
include more explanatory variables and/or higher order terms) will try
to predict the number of shares based on most of the available data in
our training dataset.

``` r
# building the model
fullFit <- train(shares ~ n_tokens_content + num_hrefs + num_self_hrefs +
                     average_token_length + num_keywords + 
                     kw_min_max + kw_max_max + kw_avg_max + kw_max_avg +
                     kw_avg_avg + self_reference_min_shares + weekday_is_monday +
                     weekday_is_tuesday + weekday_is_wednesday + 
                     weekday_is_thursday + weekday_is_friday +
                     global_subjectivity + title_sentiment_polarity, 
              data = training, 
              method = "lm", # linear regression
              preProcess = c("center", "scale", "nzv"),
              trControl = trainControl(method = "cv", number = 3)
              )
# look at the resulting coefficients
fullFit$finalModel
```

    ## 
    ## Call:
    ## lm(formula = .outcome ~ ., data = dat)
    ## 
    ## Coefficients:
    ##               (Intercept)           n_tokens_content                  num_hrefs  
    ##                   2935.50                      42.60                     233.19  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                    362.55                    -129.04                     594.04  
    ##                kw_max_max                 kw_avg_max                 kw_max_avg  
    ##                   -475.84                     201.92                   -1875.72  
    ##                kw_avg_avg  self_reference_min_shares         weekday_is_monday1  
    ##                   2653.14                     312.14                     215.74  
    ##       weekday_is_tuesday1      weekday_is_wednesday1       weekday_is_thursday1  
    ##                     24.31                    -293.27                    -167.89  
    ##        weekday_is_friday1        global_subjectivity   title_sentiment_polarity  
    ##                   -245.91                     426.31                    -286.60

``` r
fullFit
```

    ## Linear Regression 
    ## 
    ## 4382 samples
    ##   18 predictor
    ## 
    ## Pre-processing: centered (17), scaled (17), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 2922, 2921, 2921 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   12681.73  0.01110131  2602.375
    ## 
    ## Tuning parameter 'intercept' was held constant at a value of TRUE

The next multiple regresson model includes a smaller subset of variables
that we think would be important.

``` r
smallFit <- train(shares ~ n_tokens_content + num_hrefs + num_self_hrefs +
                     average_token_length + num_keywords + 
                     kw_min_max + kw_max_max + kw_avg_max + kw_max_avg +
                     kw_avg_avg + self_reference_min_shares +
                     global_subjectivity + title_sentiment_polarity,
              data = training, 
              method = "lm", 
              preProcess = c("center", "scale", "nzv"),
              trControl = trainControl(method = "cv", number = 3)
              )
# look at the resulting coefficients
smallFit$finalModel
```

    ## 
    ## Call:
    ## lm(formula = .outcome ~ ., data = dat)
    ## 
    ## Coefficients:
    ##               (Intercept)           n_tokens_content                  num_hrefs  
    ##                   2935.50                      55.15                     256.46  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                    350.88                    -127.22                     573.34  
    ##                kw_max_max                 kw_avg_max                 kw_max_avg  
    ##                   -468.59                     184.51                   -1891.70  
    ##                kw_avg_avg  self_reference_min_shares        global_subjectivity  
    ##                   2681.12                     321.40                     429.76  
    ##  title_sentiment_polarity  
    ##                   -271.58

``` r
smallFit
```

    ## Linear Regression 
    ## 
    ## 4382 samples
    ##   13 predictor
    ## 
    ## Pre-processing: centered (12), scaled (12), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 2921, 2921, 2922 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   11799.78  0.01939183  2540.344
    ## 
    ## Tuning parameter 'intercept' was held constant at a value of TRUE

### Random Forest

Random forest is a tree-based method of prediction. It does not use all
predictors available, but instead uses a random subset of predictors for
each of many bootstrap samples / tree fits.

``` r
# load required package
library(randomForest)
# set up the mtry parameter 
tunegrid <- expand.grid(.mtry=c(1:5))

#train model
rfFit <- train(x = select(training, -url, -shares), 
                y = training$shares,
                method = "rf",
                tuneGrid = tunegrid,
                preProcess = c("center", "scale", "nzv"),
                trControl = trainControl(method = "cv", 
                                         number = 3)
                )
rfFit
```

    ## Random Forest 
    ## 
    ## 4382 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (44), scaled (44), ignore (13), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 2921, 2922, 2921 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     12554.43  0.02237883  2446.137
    ##   2     12552.27  0.02027642  2451.941
    ##   3     12605.12  0.01836316  2496.430
    ##   4     12680.83  0.01231557  2554.714
    ##   5     12716.83  0.01427791  2549.951
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was mtry = 2.

### Boosted Tree

``` r
# Load required packages
library(gbm)

# set up the parameters
gbmGrid <-  expand.grid(interaction.depth = c(1, 2, 3), 
                        n.trees = c(25, 50, 100), 
                        shrinkage = 0.1,
                        n.minobsinnode = 10)

#train model
btFit <- train(x = select(training, -url, -shares), 
                y = training$shares,
                method = "gbm",
                tuneGrid = gbmGrid,
                preProcess = c("center", "scale", "nzv"),
                trControl = trainControl(method = "cv", 
                                         number = 3)
                )
```

    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 91317140.2361             nan     0.1000 183198.2755
    ##      2 90850384.2299             nan     0.1000 -36606.8550
    ##      3 90401978.3109             nan     0.1000 -13279.5586
    ##      4 90044182.8204             nan     0.1000 -144039.1255
    ##      5 89887361.3490             nan     0.1000 123092.1485
    ##      6 89748707.5962             nan     0.1000 -24982.0867
    ##      7 89501184.4204             nan     0.1000 -258527.1960
    ##      8 89425145.9672             nan     0.1000 18239.3186
    ##      9 89125805.0746             nan     0.1000 -68695.0744
    ##     10 89032194.0784             nan     0.1000 97614.0143
    ##     20 87297911.8079             nan     0.1000 -402779.1449
    ##     40 85480428.5406             nan     0.1000 -220301.0537
    ##     60 83573190.8740             nan     0.1000 -444091.0508
    ##     80 81997185.8060             nan     0.1000 -224268.3676
    ##    100 80884490.6100             nan     0.1000 -224336.8098
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 90925902.6273             nan     0.1000 72573.3323
    ##      2 90218244.1085             nan     0.1000 -63708.2275
    ##      3 90037768.0823             nan     0.1000 112656.2526
    ##      4 89847047.1354             nan     0.1000 -28434.8176
    ##      5 89360652.3141             nan     0.1000 -153908.9625
    ##      6 88648118.4386             nan     0.1000 -60384.3728
    ##      7 88037979.7376             nan     0.1000 -12972.3975
    ##      8 87798981.8652             nan     0.1000 33135.0476
    ##      9 86986380.1762             nan     0.1000 -105361.4574
    ##     10 86301411.5253             nan     0.1000 -13289.0037
    ##     20 84178094.4918             nan     0.1000 -504756.5735
    ##     40 78761577.4841             nan     0.1000 -106048.8282
    ##     60 75427996.4845             nan     0.1000 -536126.1365
    ##     80 71085851.0884             nan     0.1000 -350870.4399
    ##    100 68381721.4132             nan     0.1000 -103948.4873
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 90833176.0210             nan     0.1000 -50453.5686
    ##      2 89976330.6906             nan     0.1000 116506.6136
    ##      3 89230779.4388             nan     0.1000 -149910.7116
    ##      4 88049477.0052             nan     0.1000 -77790.1918
    ##      5 87723198.1524             nan     0.1000 -4561.9883
    ##      6 87399889.7815             nan     0.1000 82617.5985
    ##      7 86612494.9583             nan     0.1000 -200643.9154
    ##      8 86364619.3147             nan     0.1000 -148654.4942
    ##      9 86056336.0718             nan     0.1000 -104829.9811
    ##     10 85662664.6111             nan     0.1000 -177765.9297
    ##     20 81791730.7057             nan     0.1000 -403483.3083
    ##     40 73668672.7610             nan     0.1000 26281.7243
    ##     60 70614083.0973             nan     0.1000 75205.4386
    ##     80 67270757.9823             nan     0.1000 -170642.9341
    ##    100 63159452.1329             nan     0.1000 -434292.3006
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 227811208.7689             nan     0.1000 -88021.8524
    ##      2 224799592.5612             nan     0.1000 82940.8698
    ##      3 222367091.7340             nan     0.1000 -403617.8532
    ##      4 222293289.3136             nan     0.1000 -49873.9223
    ##      5 221238716.3340             nan     0.1000 -171243.8292
    ##      6 220836204.8397             nan     0.1000 -75112.7252
    ##      7 219124938.2784             nan     0.1000 -905365.2490
    ##      8 217938798.2947             nan     0.1000 -1409435.5740
    ##      9 218473352.5351             nan     0.1000 -1894975.0189
    ##     10 217433086.9607             nan     0.1000 -904992.5328
    ##     20 214975979.7948             nan     0.1000 -1143625.5915
    ##     40 207188386.5643             nan     0.1000 -1387563.7484
    ##     60 206340399.1366             nan     0.1000 -1162702.5215
    ##     80 204843136.6909             nan     0.1000 -1277544.2175
    ##    100 203082274.3605             nan     0.1000 -1268909.5392
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 227081242.5709             nan     0.1000 425874.9712
    ##      2 226633939.4727             nan     0.1000 388651.2831
    ##      3 223583634.8784             nan     0.1000 -514967.6565
    ##      4 221058535.4059             nan     0.1000 -180696.8866
    ##      5 219167269.8213             nan     0.1000 -1056417.1497
    ##      6 219405331.7106             nan     0.1000 -943427.7225
    ##      7 217925651.8483             nan     0.1000 -914379.3859
    ##      8 218124946.5554             nan     0.1000 -978380.3305
    ##      9 217162714.0362             nan     0.1000 -431806.7079
    ##     10 217338350.0176             nan     0.1000 -1016334.3572
    ##     20 213418691.1942             nan     0.1000 -1187644.1622
    ##     40 200271922.7276             nan     0.1000 -1993855.8134
    ##     60 194102265.8513             nan     0.1000 -959735.4816
    ##     80 182624276.6501             nan     0.1000 -990537.1155
    ##    100 169289343.4081             nan     0.1000 31557.4687
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 224033024.0419             nan     0.1000 -350214.3205
    ##      2 223715449.0935             nan     0.1000 -23322.0813
    ##      3 220812798.6236             nan     0.1000 -998489.9105
    ##      4 220944439.7489             nan     0.1000 -910336.9894
    ##      5 220464181.8335             nan     0.1000 -280989.2248
    ##      6 220635157.9046             nan     0.1000 -878786.9997
    ##      7 218777298.1572             nan     0.1000 -917341.2795
    ##      8 217337722.8071             nan     0.1000 -759721.1262
    ##      9 216515469.7208             nan     0.1000 -1916046.7008
    ##     10 216390812.3357             nan     0.1000 -1263917.8737
    ##     20 206615088.8035             nan     0.1000 -1395123.5498
    ##     40 189464101.0295             nan     0.1000 -948705.8886
    ##     60 177672035.5351             nan     0.1000 -1426639.4819
    ##     80 168582675.6733             nan     0.1000 88865.1065
    ##    100 161827818.1343             nan     0.1000 -1520102.9502
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 216429756.9961             nan     0.1000 -210361.7632
    ##      2 214410119.5804             nan     0.1000 -406568.5008
    ##      3 212737574.0648             nan     0.1000 -1170341.5804
    ##      4 213128342.5800             nan     0.1000 -1122840.4695
    ##      5 212648442.4290             nan     0.1000 -33284.6558
    ##      6 211356908.0676             nan     0.1000 -1478983.9654
    ##      7 211762106.9670             nan     0.1000 -1278883.5663
    ##      8 211452921.1937             nan     0.1000 -51713.0773
    ##      9 210410101.7416             nan     0.1000 -1613935.6931
    ##     10 210049557.8950             nan     0.1000 -167703.4442
    ##     20 210131893.4079             nan     0.1000 -919944.3922
    ##     40 203786762.0583             nan     0.1000 -1210576.5340
    ##     60 203827664.2004             nan     0.1000 -167774.2694
    ##     80 201167006.4315             nan     0.1000 -2770997.9703
    ##    100 199058355.0484             nan     0.1000 -1734084.6879
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 219266852.6626             nan     0.1000 318033.9644
    ##      2 215790530.6080             nan     0.1000 -158912.7105
    ##      3 212948920.2904             nan     0.1000 -745741.0778
    ##      4 210911948.5508             nan     0.1000 -652087.3326
    ##      5 209450075.5146             nan     0.1000 -653171.5102
    ##      6 209517743.6323             nan     0.1000 -1280492.5599
    ##      7 208347227.8341             nan     0.1000 -724366.3236
    ##      8 208648446.2979             nan     0.1000 -1838142.7726
    ##      9 207603992.9447             nan     0.1000 -90752.6675
    ##     10 205617450.4301             nan     0.1000 2523.3441
    ##     20 202269519.1788             nan     0.1000 -1721300.6090
    ##     40 193129185.6043             nan     0.1000 -582252.2428
    ##     60 190712608.8339             nan     0.1000 -1432767.7068
    ##     80 183495884.8315             nan     0.1000 -1412699.7450
    ##    100 176907403.6387             nan     0.1000 -496837.9921
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 215957909.8678             nan     0.1000 -262189.5552
    ##      2 214863761.5843             nan     0.1000 239949.6715
    ##      3 214627185.0651             nan     0.1000 94233.1933
    ##      4 212165078.5650             nan     0.1000 -535179.1707
    ##      5 209435162.1104             nan     0.1000 -1013239.7452
    ##      6 209241829.9234             nan     0.1000 -1337316.1044
    ##      7 206387859.1176             nan     0.1000 -590654.5452
    ##      8 203992149.1265             nan     0.1000 -989471.2183
    ##      9 202973304.0557             nan     0.1000 -1166004.4133
    ##     10 202069353.7486             nan     0.1000 -1213408.2507
    ##     20 195148164.3123             nan     0.1000 -1159703.7885
    ##     40 184290968.6793             nan     0.1000 -1776746.3810
    ##     60 178317552.6391             nan     0.1000 -792384.7392
    ##     80 163564806.9740             nan     0.1000 -713250.4398
    ##    100 145162225.5673             nan     0.1000 -1367178.1895
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 178600724.1734             nan     0.1000 -25027.1422
    ##      2 178002916.7592             nan     0.1000 -64566.5735
    ##      3 177709123.0112             nan     0.1000 188302.8243
    ##      4 177156894.3513             nan     0.1000 52802.9853
    ##      5 176490011.0677             nan     0.1000 -104209.8181
    ##      6 174420897.7343             nan     0.1000 -308448.0473
    ##      7 174248767.9255             nan     0.1000 139375.5538
    ##      8 172727756.0564             nan     0.1000 -792714.1306
    ##      9 171552995.1422             nan     0.1000 -933837.4007
    ##     10 170916512.7782             nan     0.1000 -1264951.2503
    ##     20 164582206.1561             nan     0.1000 -747083.8172
    ##     25 162321618.1804             nan     0.1000 -1196324.7412

## Comparison

All four of the models should be compared on the test set and a winner
declared (this should be automated to be correct across all the created
documents).

Test each model on our test set of data.

``` r
# full fit multiple regression model
fullPred <- predict(fullFit, newdata = testing)
# selected variable multiple regression model
smallPred <- predict(selectFit, newdata = testing)
# random forest
rfPred <- predict(rfFit, newdata = testing)
# boosted tree
btPred <- predict(btFit, newdata = testing)
```

Now we will compare the four candidate models and choose one.

``` r
# Create a named with results (Rsquared values) for each model
results <- c("Full Fit" = max(fullFit$results$Rsquared), 
           "Small Fit" = max(selectFit$results$Rsquared),
           "Random Forest" = max(rfFit$results$Rsquared),
           "Boosted Tree" = max(btFit$results$Rsquared))

# RSquared Values are: 
results
```

    ##      Full Fit     Small Fit Random Forest  Boosted Tree 
    ##   0.011101309   0.019401910   0.022378829   0.002441434

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ## Random Forest 
    ##    0.02237883

## Automation

We generated these reports automatically for each channel (“lifestyle”,
“entertainment”, “bus”, “socmed”, “tech”, and “world”) by creating a
function that uses the `rmarkdown` package to render a Github document
with a `params` option, and then using a for loop to execute that
function for each channel in a list. That’s how the page you’re reading
was generated!

The code we used to automate the rendering is visible at the main page
for this project [here](https://cdonahu.github.io/st558-project2/).

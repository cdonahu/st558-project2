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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/bus_files/figure-gfm/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/bus_files/figure-gfm/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/bus_files/figure-gfm/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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
    ## plot: [1,2] [======>-----------------------------------------------] 12% est: 0s
    ## plot: [1,3] [=========>--------------------------------------------] 19% est: 1s
    ## plot: [1,4] [=============>----------------------------------------] 25% est: 2s
    ## plot: [2,1] [================>-------------------------------------] 31% est: 2s
    ## plot: [2,2] [===================>----------------------------------] 38% est: 1s
    ## plot: [2,3] [=======================>------------------------------] 44% est: 1s
    ## plot: [2,4] [==========================>---------------------------] 50% est: 1s
    ## plot: [3,1] [=============================>------------------------] 56% est: 1s
    ## plot: [3,2] [=================================>--------------------] 62% est: 1s
    ## plot: [3,3] [====================================>-----------------] 69% est: 1s
    ## plot: [3,4] [=======================================>--------------] 75% est: 0s
    ## plot: [4,1] [===========================================>----------] 81% est: 0s
    ## plot: [4,2] [==============================================>-------] 88% est: 0s
    ## plot: [4,3] [==================================================>---] 94% est: 0s
    ## plot: [4,4] [======================================================]100% est: 0s

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/bus_files/figure-gfm/exploratory%20graph-1.png)<!-- -->

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
              trControl = trainControl(method = "cv", number = 5)
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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 3506, 3506, 3506, 3505, 3505 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared   MAE     
    ##   10741.51  0.0294422  2529.191
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
              trControl = trainControl(method = "cv", number = 5)
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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 3506, 3506, 3505, 3505, 3506 
    ## Resampling results:
    ## 
    ##   RMSE     Rsquared    MAE     
    ##   11391.5  0.02015383  2528.442
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
                                         number = 5)
                )
rfFit
```

    ## Random Forest 
    ## 
    ## 4382 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (44), scaled (44), ignore (13), remove (1) 
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 3506, 3504, 3506, 3506, 3506 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     11500.67  0.02275569  2454.992
    ##   2     11547.73  0.02352146  2464.851
    ##   3     11595.66  0.02079015  2498.074
    ##   4     11629.32  0.02160618  2531.175
    ##   5     11664.92  0.01883774  2549.609
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was mtry = 1.

### Boosted Tree

``` r
# Load required packages
library(gbm)

# set up the parameters
gbmGrid <-  expand.grid(interaction.depth = c(1, 2, 3), 
                        n.trees = c(25, 50, 100, 150), 
                        shrinkage = 0.1,
                        n.minobsinnode = 10)

#train model
btFit <- train(x = select(training, -url, -shares), 
                y = training$shares,
                method = "gbm",
                tuneGrid = gbmGrid,
                preProcess = c("center", "scale", "nzv"),
                trControl = trainControl(method = "cv", 
                                         number = 5)
                )
```

    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 216307830.1973             nan     0.1000 -216693.8331
    ##      2 216023403.1123             nan     0.1000 -4064.5421
    ##      3 214017501.0083             nan     0.1000 -246245.1015
    ##      4 213766952.0280             nan     0.1000 -37599.5571
    ##      5 212299461.3935             nan     0.1000 -713493.2060
    ##      6 211178535.6668             nan     0.1000 -1219701.6590
    ##      7 211005766.1702             nan     0.1000 -56955.8208
    ##      8 211330296.4292             nan     0.1000 -1109885.7986
    ##      9 210614238.6484             nan     0.1000 -1233416.8330
    ##     10 210884603.7306             nan     0.1000 -1034627.5961
    ##     20 209800342.5351             nan     0.1000 -1229392.8329
    ##     40 206442968.6243             nan     0.1000 -828225.8425
    ##     60 202858590.7539             nan     0.1000 -1204655.6776
    ##     80 200790760.2442             nan     0.1000 -981727.0292
    ##    100 197773524.7069             nan     0.1000 -1075389.3300
    ##    120 196652158.1149             nan     0.1000 -838132.6432
    ##    140 194110978.2300             nan     0.1000 -951218.1388
    ##    150 192325362.5110             nan     0.1000 -271709.3671
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 216039827.5106             nan     0.1000 -25387.6732
    ##      2 213737047.5908             nan     0.1000 -246214.2808
    ##      3 211719419.3577             nan     0.1000 -516629.3450
    ##      4 211903220.0814             nan     0.1000 -706446.2728
    ##      5 211155758.2334             nan     0.1000 -325675.1849
    ##      6 211031450.5032             nan     0.1000 -66614.6934
    ##      7 210218922.1779             nan     0.1000 -203509.9872
    ##      8 210363617.4790             nan     0.1000 -1025691.1542
    ##      9 209664169.0216             nan     0.1000 -60349.3736
    ##     10 209141559.1110             nan     0.1000 43808.2712
    ##     20 204246132.8129             nan     0.1000 -1181171.4368
    ##     40 192175990.8981             nan     0.1000 -2805453.7558
    ##     60 182488458.5101             nan     0.1000 -1405558.9986
    ##     80 171947664.8848             nan     0.1000 83908.9150
    ##    100 164969284.4501             nan     0.1000 -464211.2499
    ##    120 160215000.9329             nan     0.1000 -666466.8030
    ##    140 157166346.6526             nan     0.1000 -475247.2268
    ##    150 154342467.9938             nan     0.1000 -959711.1339
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 215457317.7593             nan     0.1000 -285835.5031
    ##      2 214378405.0484             nan     0.1000 4680.5947
    ##      3 213828921.5272             nan     0.1000 -61757.6713
    ##      4 213307439.1858             nan     0.1000 53521.3194
    ##      5 212249163.6574             nan     0.1000 -125807.9327
    ##      6 211526055.7227             nan     0.1000 -64280.9667
    ##      7 211072666.7976             nan     0.1000 104306.8926
    ##      8 208973959.5561             nan     0.1000 -473936.6683
    ##      9 207365670.6330             nan     0.1000 -1486778.8498
    ##     10 206927695.0802             nan     0.1000 -1242935.7810
    ##     20 195796249.6137             nan     0.1000 -996853.3109
    ##     40 188506539.8423             nan     0.1000 -714733.8478
    ##     60 176970736.8607             nan     0.1000 -1546528.3305
    ##     80 168709160.9037             nan     0.1000 -2051405.2680
    ##    100 165571584.5837             nan     0.1000 -1340746.3412
    ##    120 159168175.4259             nan     0.1000 -1837281.0870
    ##    140 150440519.7382             nan     0.1000 -668645.1852
    ##    150 148269562.6977             nan     0.1000 -1283141.9335
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 55317138.9632             nan     0.1000 152817.1507
    ##      2 55198513.8951             nan     0.1000 2619.4984
    ##      3 54665111.5737             nan     0.1000 -19081.8671
    ##      4 54603400.7705             nan     0.1000 -3372.5461
    ##      5 54466743.6525             nan     0.1000 149874.9047
    ##      6 54403019.6853             nan     0.1000 -11985.4129
    ##      7 54349746.6003             nan     0.1000 -20509.5525
    ##      8 54250167.1397             nan     0.1000 102758.8672
    ##      9 54152150.9282             nan     0.1000 102323.5425
    ##     10 54072906.4638             nan     0.1000 -20827.4056
    ##     20 52753212.8971             nan     0.1000 11708.0839
    ##     40 51357229.1625             nan     0.1000 -204488.8943
    ##     60 50895397.8541             nan     0.1000 -187721.1996
    ##     80 49806575.8513             nan     0.1000 -146776.7155
    ##    100 48567107.7205             nan     0.1000 151683.3417
    ##    120 48346151.5757             nan     0.1000 17815.2110
    ##    140 47546354.1219             nan     0.1000 -319777.7868
    ##    150 47325662.4600             nan     0.1000 46496.0297
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 54951773.8158             nan     0.1000 99257.7461
    ##      2 54586609.4311             nan     0.1000 28813.7914
    ##      3 54414943.1556             nan     0.1000 84738.7138
    ##      4 54165234.4976             nan     0.1000 -78481.2655
    ##      5 53821857.2568             nan     0.1000 -79214.4807
    ##      6 53004804.2769             nan     0.1000 -36940.2850
    ##      7 52896681.7144             nan     0.1000 80992.0599
    ##      8 52523692.9806             nan     0.1000 486199.5836
    ##      9 52433676.7583             nan     0.1000 39391.6595
    ##     10 52274288.8589             nan     0.1000 -61231.2029
    ##     20 50478107.8910             nan     0.1000 -333340.2745
    ##     40 44689254.7936             nan     0.1000 -70711.6777
    ##     60 41522652.1598             nan     0.1000 -70306.9388
    ##     80 38723284.3930             nan     0.1000 -117079.3389
    ##    100 36224936.0775             nan     0.1000 -85052.5052
    ##    120 35031909.6353             nan     0.1000 -94776.2944
    ##    140 33135588.7702             nan     0.1000 -238748.8048
    ##    150 32090661.8065             nan     0.1000 -113205.1208
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 54891474.7719             nan     0.1000 199073.5728
    ##      2 53871929.6789             nan     0.1000 -124936.5434
    ##      3 53690651.7880             nan     0.1000 52975.3200
    ##      4 53209594.9003             nan     0.1000 -141622.1888
    ##      5 52923688.0493             nan     0.1000 43994.4081
    ##      6 52751088.9101             nan     0.1000 67456.8281
    ##      7 51925152.7054             nan     0.1000 81006.6240
    ##      8 51488884.4626             nan     0.1000 -75293.4102
    ##      9 51244206.1725             nan     0.1000 49424.7923
    ##     10 51012992.2348             nan     0.1000 -77184.1284
    ##     20 48647996.6977             nan     0.1000 12318.5400
    ##     40 41586211.1278             nan     0.1000 29108.7122
    ##     60 38997798.9534             nan     0.1000 -35002.5887
    ##     80 35587704.6760             nan     0.1000 215544.1420
    ##    100 33778306.1998             nan     0.1000 -150907.6285
    ##    120 32162682.3348             nan     0.1000 -199748.8784
    ##    140 30152134.1299             nan     0.1000 -174662.2340
    ##    150 29013920.8713             nan     0.1000 -65831.4911
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 220145557.2008             nan     0.1000 -96633.7928
    ##      2 219596866.8987             nan     0.1000 234838.6819
    ##      3 219377383.3275             nan     0.1000 -61075.2806
    ##      4 216941226.5797             nan     0.1000 -248555.7829
    ##      5 215387366.2364             nan     0.1000 -163931.6543
    ##      6 213879918.9863             nan     0.1000 -883288.0430
    ##      7 212770732.5923             nan     0.1000 -999926.3460
    ##      8 213052398.7629             nan     0.1000 -976656.0690
    ##      9 212198084.7887             nan     0.1000 -1093252.5025
    ##     10 212480888.6842             nan     0.1000 -1049775.8543
    ##     20 210638452.0111             nan     0.1000 -118112.4546
    ##     40 203660628.2914             nan     0.1000 372788.2721
    ##     60 200178937.4156             nan     0.1000 -1744842.3153
    ##     80 197853409.3445             nan     0.1000 -1157682.5741
    ##    100 193903287.7049             nan     0.1000 -1499445.4558
    ##    120 190160580.1055             nan     0.1000 -1165599.4535
    ##    140 189860127.1828             nan     0.1000 -905595.2678
    ##    150 188224165.7766             nan     0.1000 -769983.8968
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 217802964.4584             nan     0.1000 -273185.2592
    ##      2 217272963.5867             nan     0.1000 -11027.1756
    ##      3 216992466.7692             nan     0.1000 178793.9076
    ##      4 217055084.1636             nan     0.1000 -347663.7181
    ##      5 216233384.8047             nan     0.1000 -166929.4352
    ##      6 216136997.3268             nan     0.1000 -99770.8093
    ##      7 214035574.6727             nan     0.1000 -672246.6917
    ##      8 212283104.6737             nan     0.1000 -637366.5615
    ##      9 212504834.8704             nan     0.1000 -915497.6210
    ##     10 211164743.8098             nan     0.1000 -1112665.9474
    ##     20 200503822.0878             nan     0.1000 -1036890.8721
    ##     40 192638684.6367             nan     0.1000 -1326012.1308
    ##     60 185913793.2270             nan     0.1000 -1242470.9149
    ##     80 180423158.2041             nan     0.1000 -211022.9126
    ##    100 175129058.5994             nan     0.1000 -1357937.3491
    ##    120 172626409.0394             nan     0.1000 -913483.1021
    ##    140 169061543.7637             nan     0.1000 -983933.5101
    ##    150 164239915.7553             nan     0.1000 -686548.0365
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 220262640.7332             nan     0.1000 63300.1514
    ##      2 219924593.9204             nan     0.1000 -27429.4250
    ##      3 218564875.9208             nan     0.1000 -127416.5694
    ##      4 217205727.6000             nan     0.1000 -265073.9484
    ##      5 213822744.7225             nan     0.1000 -435701.5487
    ##      6 211698874.8309             nan     0.1000 -403311.3749
    ##      7 211436670.3319             nan     0.1000 -878411.3215
    ##      8 209353965.8441             nan     0.1000 -905419.1487
    ##      9 208431166.1221             nan     0.1000 -522081.1784
    ##     10 208075614.7251             nan     0.1000 140949.1948
    ##     20 199712161.9734             nan     0.1000 -1155731.6669
    ##     40 187277761.9730             nan     0.1000 -1599673.3677
    ##     60 181543059.7219             nan     0.1000 -693435.1891
    ##     80 172707083.4307             nan     0.1000 -387347.0748
    ##    100 168414288.3942             nan     0.1000 -1004534.8656
    ##    120 155916698.5582             nan     0.1000 -353823.3765
    ##    140 151098756.8287             nan     0.1000 -1152403.6446
    ##    150 145892288.3383             nan     0.1000 -787904.8235
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 190295029.3430             nan     0.1000 253803.9452
    ##      2 187842950.8947             nan     0.1000 -128279.5920
    ##      3 187694409.0969             nan     0.1000 140828.7735
    ##      4 187525056.5019             nan     0.1000 -44156.6101
    ##      5 187488991.9552             nan     0.1000 -49430.1983
    ##      6 185919251.5724             nan     0.1000 -244690.0406
    ##      7 184814579.0340             nan     0.1000 -340441.2738
    ##      8 184721227.9737             nan     0.1000 -20071.7614
    ##      9 185045648.0055             nan     0.1000 -888986.7608
    ##     10 184678734.5727             nan     0.1000 7338.3606
    ##     20 178423011.3995             nan     0.1000 -553611.7962
    ##     40 176195934.2775             nan     0.1000 -848383.5881
    ##     60 173727580.5543             nan     0.1000 -597773.8456
    ##     80 169019358.1981             nan     0.1000 -1361123.7088
    ##    100 168048165.5461             nan     0.1000 -1673947.9029
    ##    120 164556852.3385             nan     0.1000 -1026842.4543
    ##    140 162791596.1374             nan     0.1000 -1399647.7719
    ##    150 162180154.9665             nan     0.1000 -443024.6968
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 187962648.2085             nan     0.1000 -82726.2188
    ##      2 187408194.2373             nan     0.1000 -51746.6058
    ##      3 187103000.8460             nan     0.1000 -39494.9027
    ##      4 185914711.2365             nan     0.1000 -295068.6119
    ##      5 185265110.1053             nan     0.1000 -95275.4752
    ##      6 183656072.9180             nan     0.1000 -207945.0781
    ##      7 182165507.1870             nan     0.1000 -654313.6999
    ##      8 181008895.1355             nan     0.1000 -977367.9904
    ##      9 181166779.5694             nan     0.1000 -903269.6376
    ##     10 180242100.3144             nan     0.1000 -845446.9597
    ##     20 172461676.6638             nan     0.1000 -1421101.5323
    ##     40 164460462.8561             nan     0.1000 -1219236.0215
    ##     60 155263962.1776             nan     0.1000 -253620.4490
    ##     80 145857732.9024             nan     0.1000 -1265736.7467
    ##    100 138373203.1777             nan     0.1000 -755638.3457
    ##    120 131696156.4805             nan     0.1000 -350108.8176
    ##    140 128714272.3522             nan     0.1000 -604732.4568
    ##    150 124707467.0420             nan     0.1000 -636955.1167
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 190308520.3311             nan     0.1000 126143.5024
    ##      2 189410821.9454             nan     0.1000 381199.2202
    ##      3 186694299.6308             nan     0.1000 -86468.7003
    ##      4 184701007.8771             nan     0.1000 -606068.0327
    ##      5 184658845.4283             nan     0.1000 -1057598.1433
    ##      6 182877738.1294             nan     0.1000 -945339.0649
    ##      7 181797043.5540             nan     0.1000 -1214388.8037
    ##      8 180535384.8454             nan     0.1000 -1766274.7574
    ##      9 180563418.1319             nan     0.1000 -1087830.2149
    ##     10 179776342.1477             nan     0.1000 -1202392.0679
    ##     20 169618777.6406             nan     0.1000 -175169.7678
    ##     40 160448076.0358             nan     0.1000 -797059.5719
    ##     60 142688796.5874             nan     0.1000 -776141.7190
    ##     80 138857075.0337             nan     0.1000 -1272421.6791
    ##    100 127649036.2638             nan     0.1000 -814145.8071
    ##    120 118812032.0826             nan     0.1000 164884.2237
    ##    140 107526618.7866             nan     0.1000 -368361.9365
    ##    150 106493770.4183             nan     0.1000 -704415.2963
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 210418247.6980             nan     0.1000 -331204.1941
    ##      2 210230348.5622             nan     0.1000 -19778.4095
    ##      3 210006595.8558             nan     0.1000 284954.2582
    ##      4 208387554.6984             nan     0.1000 -654812.6349
    ##      5 208072145.1237             nan     0.1000 2130.2175
    ##      6 207882279.0110             nan     0.1000 -30832.3337
    ##      7 206613550.4396             nan     0.1000 -638457.0031
    ##      8 205715189.9290             nan     0.1000 -724856.0339
    ##      9 206011267.5280             nan     0.1000 -1129880.8700
    ##     10 205188178.2409             nan     0.1000 -1081415.1755
    ##     20 202439375.5556             nan     0.1000 -350510.7392
    ##     40 200743961.1999             nan     0.1000 -35600.0203
    ##     60 198283961.3632             nan     0.1000 -1146463.1376
    ##     80 195695985.1400             nan     0.1000 852110.2825
    ##    100 193945577.4814             nan     0.1000 -812902.1984
    ##    120 190493249.0464             nan     0.1000 -1676402.5108
    ##    140 187430466.3436             nan     0.1000 792550.5652
    ##    150 188475063.4201             nan     0.1000 -995981.2559
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 209920903.6432             nan     0.1000 -213943.9423
    ##      2 209335176.6022             nan     0.1000 -16248.0723
    ##      3 207401321.6681             nan     0.1000 -333298.5337
    ##      4 206070355.3772             nan     0.1000 -363978.8979
    ##      5 204819972.4977             nan     0.1000 -714441.2401
    ##      6 204528417.6417             nan     0.1000 -349699.4386
    ##      7 204201691.3163             nan     0.1000 -206650.4410
    ##      8 204318175.0339             nan     0.1000 -743223.2524
    ##      9 203261658.7823             nan     0.1000 -1248796.2249
    ##     10 203361365.8600             nan     0.1000 -552758.9820
    ##     20 198815774.1534             nan     0.1000 -1120801.8889
    ##     40 183207711.4730             nan     0.1000 -1170075.3486
    ##     60 176027447.6305             nan     0.1000 -773686.2421
    ##     80 173309070.8283             nan     0.1000 -540514.1940
    ##    100 167975010.9786             nan     0.1000 -1077108.6620
    ##    120 164904872.7672             nan     0.1000 -682280.9173
    ##    140 157103234.9527             nan     0.1000 12874.3698
    ##    150 155258544.9201             nan     0.1000 -859130.9620
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 210183471.0924             nan     0.1000 -51441.4232
    ##      2 209299569.8327             nan     0.1000 -77071.6729
    ##      3 208546212.4250             nan     0.1000 -119200.9312
    ##      4 208322629.2915             nan     0.1000 145084.1466
    ##      5 206150729.4396             nan     0.1000 -437595.2598
    ##      6 204565310.7837             nan     0.1000 -927967.5433
    ##      7 203056076.9515             nan     0.1000 -835733.6747
    ##      8 202041469.7338             nan     0.1000 -1380737.0681
    ##      9 201604566.3688             nan     0.1000 -991294.0202
    ##     10 201481203.1605             nan     0.1000 -1625344.6353
    ##     20 191517720.3024             nan     0.1000 -2085328.0267
    ##     40 176851665.8668             nan     0.1000 -106841.4739
    ##     60 169374422.4664             nan     0.1000 -1086263.8688
    ##     80 160191582.0974             nan     0.1000 -1497775.8041
    ##    100 152622463.9455             nan     0.1000 -1211784.8820
    ##    120 145143896.4642             nan     0.1000 -1426538.2926
    ##    140 143014560.9064             nan     0.1000 -1049386.7904
    ##    150 140839136.9466             nan     0.1000 83309.8875
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 177301655.8948             nan     0.1000 -67221.3613
    ##      2 175266767.7075             nan     0.1000 -477467.7714
    ##      3 173413652.2542             nan     0.1000 -732529.4083
    ##      4 172827239.3003             nan     0.1000 -68992.9682
    ##      5 172851147.2601             nan     0.1000 -450896.6023
    ##      6 172027498.6879             nan     0.1000 -513368.2720
    ##      7 170849573.2743             nan     0.1000 -993994.1507
    ##      8 169934085.2679             nan     0.1000 -1411900.4840
    ##      9 169101146.4173             nan     0.1000 574377.4494
    ##     10 168691916.1237             nan     0.1000 -766956.6576
    ##     20 158649749.4973             nan     0.1000 345332.5302
    ##     25 157882019.8000             nan     0.1000 -1049512.7218

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
    ##    0.02944220    0.01940191    0.02352146    0.01107097

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ##  Full Fit 
    ## 0.0294422

## Automation

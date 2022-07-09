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
    ## 1  2344.577         1100    6533.892

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

![](./images/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

Then we wanted to look at the outliers–the top articles by shares, so we
grabbed a list of those URLs, along with the number of shares.

``` r
head(training[order(training$shares, decreasing = TRUE), c("url", "shares")], 10)
```

    ## # A tibble: 10 × 2
    ##    url                                                                        shares
    ##    <chr>                                                                       <dbl>
    ##  1 http://mashable.com/2014/10/22/ebola-cdc-active-monitoring/                284700
    ##  2 http://mashable.com/2014/04/14/travel-tax-refund/                          141400
    ##  3 http://mashable.com/2013/11/15/apple-ios-7-0-4/                            128500
    ##  4 http://mashable.com/2014/09/07/utopia-fox-tv-show/                         108400
    ##  5 http://mashable.com/2013/10/14/augmented-reality-glasses/                   96500
    ##  6 http://mashable.com/2014/10/07/children-ebola-orphans/                      84800
    ##  7 http://mashable.com/2014/01/07/people-who-dont-know-how-to-gym/             69300
    ##  8 http://mashable.com/2014/04/10/exxon-and-shell-take-dramatically-differen…  67700
    ##  9 http://mashable.com/2014/09/22/a-rogues-gallery-7-people/                   62000
    ## 10 http://mashable.com/2014/09/11/apple-u2-album-download/                     59400

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

![](./images/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](./images/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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

![](./images/exploratory%20graph-1.png)<!-- -->

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
    ##                   2344.58                    -187.17                     262.11  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                     65.78                    -668.76                     200.60  
    ##                kw_max_max                 kw_avg_max                 kw_max_avg  
    ##                    -54.37                     -58.34                    -532.57  
    ##                kw_avg_avg  self_reference_min_shares         weekday_is_monday1  
    ##                    951.45                     157.51                      58.79  
    ##       weekday_is_tuesday1      weekday_is_wednesday1       weekday_is_thursday1  
    ##                   -157.93                    -268.61                     -41.84  
    ##        weekday_is_friday1        global_subjectivity   title_sentiment_polarity  
    ##                   -181.07                     511.01                     135.31

``` r
fullFit
```

    ## Linear Regression 
    ## 
    ## 5900 samples
    ##   18 predictor
    ## 
    ## Pre-processing: centered (17), scaled (17), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 3934, 3934, 3932 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared   MAE     
    ##   6257.403  0.0197237  2007.803
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
    ##                   2344.58                    -185.44                     265.71  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                     63.07                    -668.34                     192.51  
    ##                kw_max_max                 kw_avg_max                 kw_max_avg  
    ##                    -46.92                     -61.60                    -540.60  
    ##                kw_avg_avg  self_reference_min_shares        global_subjectivity  
    ##                    958.87                     161.01                     504.64  
    ##  title_sentiment_polarity  
    ##                    135.93

``` r
smallFit
```

    ## Linear Regression 
    ## 
    ## 5900 samples
    ##   13 predictor
    ## 
    ## Pre-processing: centered (12), scaled (12), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 3934, 3933, 3933 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   6248.259  0.02060202  1992.344
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
    ## 5900 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (44), scaled (44), ignore (13), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 3933, 3934, 3933 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     6338.400  0.02798951  1983.650
    ##   2     6314.244  0.03061079  2006.523
    ##   3     6336.249  0.02788096  2043.283
    ##   4     6354.956  0.02674896  2065.033
    ##   5     6350.159  0.02923868  2069.113
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
    ##      1 29817794.9606             nan     0.1000 100278.1003
    ##      2 29720238.6567             nan     0.1000 34280.6956
    ##      3 29621678.3099             nan     0.1000 77293.5720
    ##      4 29503828.0243             nan     0.1000 109749.6978
    ##      5 29421746.2277             nan     0.1000 44562.8565
    ##      6 29364171.4121             nan     0.1000 22385.0745
    ##      7 29278995.5864             nan     0.1000 49321.7366
    ##      8 29211505.6228             nan     0.1000 9193.8740
    ##      9 29152649.3216             nan     0.1000 -2666.9049
    ##     10 29111428.1124             nan     0.1000 -13592.8080
    ##     20 28527864.7139             nan     0.1000 -5571.5414
    ##     40 27949271.8932             nan     0.1000 3684.3438
    ##     60 27647365.6863             nan     0.1000 -9265.3407
    ##     80 27446196.7112             nan     0.1000 -34867.5001
    ##    100 27197237.5009             nan     0.1000 12925.0286
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 29649636.1508             nan     0.1000 144959.6222
    ##      2 29512255.1505             nan     0.1000 85663.1755
    ##      3 29197418.2110             nan     0.1000 196100.4928
    ##      4 29015393.6353             nan     0.1000 8171.3049
    ##      5 28819588.4310             nan     0.1000 117790.8779
    ##      6 28660772.5227             nan     0.1000 72824.6159
    ##      7 28490551.5715             nan     0.1000 -38188.4245
    ##      8 28365268.3410             nan     0.1000 68553.5147
    ##      9 28096498.8407             nan     0.1000 -16242.2286
    ##     10 27947785.4466             nan     0.1000 -32591.8222
    ##     20 26775531.3344             nan     0.1000 34750.2562
    ##     40 25221321.4527             nan     0.1000 -73952.8488
    ##     60 24051426.0702             nan     0.1000 -34993.7505
    ##     80 23254172.0707             nan     0.1000 -26730.3511
    ##    100 22454260.0503             nan     0.1000 -19978.7552
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 29737934.7071             nan     0.1000 47374.9952
    ##      2 29568364.7555             nan     0.1000 117869.6189
    ##      3 29321179.2045             nan     0.1000 23162.9184
    ##      4 28894023.5878             nan     0.1000 173176.6565
    ##      5 28428108.1029             nan     0.1000 -39802.5028
    ##      6 28183595.1512             nan     0.1000 -13646.9738
    ##      7 27809753.0749             nan     0.1000 93823.2405
    ##      8 27630411.4965             nan     0.1000 -16397.3238
    ##      9 27385564.2901             nan     0.1000 22374.4226
    ##     10 27162209.6061             nan     0.1000 -25731.4247
    ##     20 25480363.5721             nan     0.1000 1749.3629
    ##     40 23591654.2839             nan     0.1000 -64854.5476
    ##     60 22437551.3616             nan     0.1000 -21819.1224
    ##     80 21217097.2702             nan     0.1000 -11064.6852
    ##    100 20129589.0648             nan     0.1000 -58631.3789
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 47851994.3049             nan     0.1000 46730.1530
    ##      2 47598292.1929             nan     0.1000 12854.3889
    ##      3 47504032.9489             nan     0.1000 65942.8689
    ##      4 47391153.2048             nan     0.1000 67436.7723
    ##      5 47068224.4993             nan     0.1000 103155.0046
    ##      6 46952243.8627             nan     0.1000 133539.2470
    ##      7 46723002.4811             nan     0.1000 -51176.0847
    ##      8 46477362.0221             nan     0.1000 66255.3052
    ##      9 46400279.9120             nan     0.1000 31543.8852
    ##     10 46315570.6753             nan     0.1000 66903.7012
    ##     20 45225667.1486             nan     0.1000 37270.5408
    ##     40 44102501.9471             nan     0.1000 -151040.8573
    ##     60 42913406.6684             nan     0.1000 -28092.2704
    ##     80 41689252.0094             nan     0.1000 97854.8701
    ##    100 40801626.7397             nan     0.1000 -128491.2758
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 47627124.3225             nan     0.1000 173420.3526
    ##      2 47382840.0553             nan     0.1000 54437.9777
    ##      3 47197437.6539             nan     0.1000 79798.7975
    ##      4 46579658.4948             nan     0.1000 -33352.3408
    ##      5 46448896.7389             nan     0.1000 41622.5340
    ##      6 46230162.1499             nan     0.1000 72166.2471
    ##      7 46114649.3785             nan     0.1000 -9562.4408
    ##      8 45597635.3115             nan     0.1000 -35734.1063
    ##      9 44872930.5894             nan     0.1000 -10660.5637
    ##     10 44642388.1188             nan     0.1000 179638.3761
    ##     20 42823720.8529             nan     0.1000 -44610.8924
    ##     40 40152957.2142             nan     0.1000 -151759.2332
    ##     60 37130091.4685             nan     0.1000 -128108.2279
    ##     80 35403432.3970             nan     0.1000 -204104.9537
    ##    100 34283991.3913             nan     0.1000 -57112.6474
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 47684102.2579             nan     0.1000 110460.6622
    ##      2 47555794.3223             nan     0.1000 44497.3952
    ##      3 46933697.5691             nan     0.1000 67611.4951
    ##      4 46426621.8628             nan     0.1000 -90465.0383
    ##      5 45554612.6339             nan     0.1000 -65716.4874
    ##      6 44802156.9431             nan     0.1000 -141754.5652
    ##      7 44629084.8371             nan     0.1000 115385.6347
    ##      8 44288908.9821             nan     0.1000 163693.5744
    ##      9 43872056.0598             nan     0.1000 -85709.7769
    ##     10 43597275.2729             nan     0.1000 2750.6807
    ##     20 41864827.3007             nan     0.1000 50433.5862
    ##     40 37461840.8788             nan     0.1000 -11435.9580
    ##     60 35169507.2201             nan     0.1000 26148.0650
    ##     80 32529934.7561             nan     0.1000 -58622.6169
    ##    100 31349806.0332             nan     0.1000 -171921.8738
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 49842251.1983             nan     0.1000 114089.6802
    ##      2 49728135.7702             nan     0.1000 21673.8500
    ##      3 49641924.8479             nan     0.1000 87324.4844
    ##      4 49235410.0961             nan     0.1000 106418.4854
    ##      5 48950647.8688             nan     0.1000 11530.8269
    ##      6 48732080.8566             nan     0.1000 70113.1814
    ##      7 48554820.8359             nan     0.1000 -244669.1967
    ##      8 48407377.9831             nan     0.1000 -12145.9801
    ##      9 48244873.5571             nan     0.1000 -134856.5273
    ##     10 48106671.7565             nan     0.1000 41332.9781
    ##     20 47383386.3045             nan     0.1000 -183909.8273
    ##     40 46327361.9754             nan     0.1000 19904.1940
    ##     60 45438005.0828             nan     0.1000 -224594.0913
    ##     80 44637364.5052             nan     0.1000 -148355.3826
    ##    100 43756108.8105             nan     0.1000 -163660.5450
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 49422928.0781             nan     0.1000 392068.8570
    ##      2 48824689.2539             nan     0.1000 11878.0138
    ##      3 48508630.9505             nan     0.1000 128942.7174
    ##      4 48414505.0636             nan     0.1000 42334.5349
    ##      5 47796292.4496             nan     0.1000 -69499.0810
    ##      6 47109679.5461             nan     0.1000 -115815.6581
    ##      7 46872266.4776             nan     0.1000 11426.2053
    ##      8 46532148.6533             nan     0.1000 -155137.4139
    ##      9 45818808.8155             nan     0.1000 45746.3292
    ##     10 45723876.2435             nan     0.1000 29711.0819
    ##     20 44084544.6175             nan     0.1000 -36140.2617
    ##     40 41003747.0141             nan     0.1000 -175346.1456
    ##     60 38986215.4713             nan     0.1000 -114209.1166
    ##     80 37422037.9524             nan     0.1000 -76911.5972
    ##    100 36257536.4112             nan     0.1000 -39084.0551
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 49453149.5802             nan     0.1000 209704.9342
    ##      2 49236217.4888             nan     0.1000 23950.7767
    ##      3 48372102.6344             nan     0.1000 20866.5605
    ##      4 47799391.9405             nan     0.1000 -94455.3827
    ##      5 47472790.6477             nan     0.1000 49304.1435
    ##      6 47140800.2535             nan     0.1000 36773.9481
    ##      7 46953143.8911             nan     0.1000 12929.3221
    ##      8 46789907.6842             nan     0.1000 -2315.2135
    ##      9 46602008.3665             nan     0.1000 -76586.1137
    ##     10 46248360.1920             nan     0.1000 -281038.4539
    ##     20 43376193.2862             nan     0.1000 -85972.3754
    ##     40 39873222.1859             nan     0.1000 -96991.9726
    ##     60 36669770.5733             nan     0.1000 -60750.1561
    ##     80 34495541.1106             nan     0.1000 -93667.2745
    ##    100 32655564.1143             nan     0.1000 -31557.1660
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 42554830.7991             nan     0.1000 54174.7797
    ##      2 42387276.0641             nan     0.1000 64500.9475
    ##      3 42251050.2770             nan     0.1000 5239.5717
    ##      4 42150209.8397             nan     0.1000 65539.2777
    ##      5 42015136.2967             nan     0.1000 -37020.0048
    ##      6 41900579.5568             nan     0.1000 44536.7980
    ##      7 41772326.3316             nan     0.1000 106966.2550
    ##      8 41685451.4967             nan     0.1000 -33794.7994
    ##      9 41623962.9401             nan     0.1000 43224.1201
    ##     10 41550959.4776             nan     0.1000 52133.9561
    ##     20 40977606.9141             nan     0.1000 -66059.5996
    ##     40 40203489.5806             nan     0.1000 -6700.7380
    ##     50 39878225.1172             nan     0.1000 -80338.4995

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
    ##    0.01972370    0.01940191    0.03061079    0.02327153

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ## Random Forest 
    ##    0.03061079

## Automation

We generated these reports automatically for each channel (“lifestyle”,
“entertainment”, “bus”, “socmed”, “tech”, and “world”) by creating a
function that uses the `rmarkdown` package to render a Github document
with a `params` option, and then using a for loop to execute that
function for each channel in a list. That’s how the page you’re reading
was generated!

The code we used to automate the rendering is visible at the main page
for this project [here](https://cdonahu.github.io/st558-project2/).

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
    ## 1  3658.866         2100    5888.288

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

![](./socmed_images/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

Then we wanted to look at the outliers–the top articles by shares, so we
grabbed a list of those URLs, along with the number of shares.

``` r
head(training[order(training$shares, decreasing = TRUE), c("url", "shares")], 10)
```

    ## # A tibble: 10 × 2
    ##    url                                                                        shares
    ##    <chr>                                                                       <dbl>
    ##  1 http://mashable.com/2013/11/26/sprout-battery/                             122800
    ##  2 http://mashable.com/2013/06/12/facebook-hashtag-advertising/                59000
    ##  3 http://mashable.com/2013/02/25/reddit-facts-2-25/                           57600
    ##  4 http://mashable.com/2013/11/29/marketing-wins-fails-2013/                   57000
    ##  5 http://mashable.com/2013/11/03/youtube-music-awards-watch-video-live-stre…  53100
    ##  6 http://mashable.com/2013/01/16/reddit-most-beautiful-songs/                 51900
    ##  7 http://mashable.com/2014/08/11/isee-3-buzzes-moon/                          47700
    ##  8 http://mashable.com/2013/08/09/12-doctor-who-episodes/                      47400
    ##  9 http://mashable.com/2014/02/24/gravity-brandspeak/                          41900
    ## 10 http://mashable.com/2014/06/04/jonah-hill-homophobic-slur-apology/          37500

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

![](./socmed_images/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](./socmed_images/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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
    ## plot: [2,4] [==========================>---------------------------] 50% est: 1s
    ## plot: [3,1] [=============================>------------------------] 56% est: 0s
    ## plot: [3,2] [=================================>--------------------] 62% est: 0s
    ## plot: [3,3] [====================================>-----------------] 69% est: 0s
    ## plot: [3,4] [=======================================>--------------] 75% est: 0s
    ## plot: [4,1] [===========================================>----------] 81% est: 0s
    ## plot: [4,2] [==============================================>-------] 88% est: 0s
    ## plot: [4,3] [==================================================>---] 94% est: 0s
    ## plot: [4,4] [======================================================]100% est: 0s

![](./socmed_images/exploratory%20graph-1.png)<!-- -->

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
    ##                   3658.87                     678.95                    -411.22  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                   -354.48                      32.33                     233.06  
    ##                kw_min_max                 kw_max_max                 kw_avg_max  
    ##                   -273.51                    -385.77                     -71.78  
    ##                kw_max_avg                 kw_avg_avg  self_reference_min_shares  
    ##                  -1136.98                    1665.49                     329.30  
    ##        weekday_is_monday1        weekday_is_tuesday1      weekday_is_wednesday1  
    ##                    173.77                     -77.05                      31.88  
    ##      weekday_is_thursday1         weekday_is_friday1        global_subjectivity  
    ##                   -257.71                     145.11                    -145.57  
    ##  title_sentiment_polarity  
    ##                    130.96

``` r
fullFit
```

    ## Linear Regression 
    ## 
    ## 1628 samples
    ##   18 predictor
    ## 
    ## Pre-processing: centered (18), scaled (18) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 1084, 1086, 1086 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   5850.876  0.01376713  2692.263
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
    ##                   3658.87                     657.53                    -415.03  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                   -361.20                      23.97                     244.78  
    ##                kw_min_max                 kw_max_max                 kw_avg_max  
    ##                   -284.17                    -413.09                     -37.84  
    ##                kw_max_avg                 kw_avg_avg  self_reference_min_shares  
    ##                  -1089.11                    1621.50                     335.40  
    ##       global_subjectivity   title_sentiment_polarity  
    ##                   -149.65                     153.68

``` r
smallFit
```

    ## Linear Regression 
    ## 
    ## 1628 samples
    ##   13 predictor
    ## 
    ## Pre-processing: centered (13), scaled (13) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 1085, 1085, 1086 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared     MAE     
    ##   5802.103  0.009630369  2671.171
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
    ## 1628 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (45), scaled (45), ignore (13) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 1085, 1086, 1085 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     5596.871  0.04715037  2646.704
    ##   2     5572.589  0.04593733  2649.713
    ##   3     5580.193  0.04485312  2669.141
    ##   4     5581.781  0.04569058  2677.697
    ##   5     5614.699  0.04275703  2695.213
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
    ##      1 25629755.9474             nan     0.1000 45606.3265
    ##      2 25513547.2704             nan     0.1000 14174.9109
    ##      3 25394108.3397             nan     0.1000 50824.2415
    ##      4 25200515.9284             nan     0.1000 169476.5916
    ##      5 25147104.3934             nan     0.1000 -26514.9547
    ##      6 25042337.6517             nan     0.1000 28943.1053
    ##      7 24920117.6061             nan     0.1000 -19517.8327
    ##      8 24873255.8090             nan     0.1000 -42595.2065
    ##      9 24741889.4081             nan     0.1000 69448.0608
    ##     10 24652850.8138             nan     0.1000 -22678.2909
    ##     20 23739971.9397             nan     0.1000 47831.1476
    ##     40 22740449.9524             nan     0.1000 -10682.6143
    ##     60 22229221.6520             nan     0.1000 -43448.5387
    ##     80 21583288.8656             nan     0.1000 -74965.6253
    ##    100 21187233.1643             nan     0.1000 -26943.8174
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 25297796.5220             nan     0.1000 307117.9459
    ##      2 25096323.2125             nan     0.1000 70107.0338
    ##      3 24900677.3557             nan     0.1000 22701.6347
    ##      4 24714694.6467             nan     0.1000 53548.0646
    ##      5 24554041.7622             nan     0.1000 4734.0703
    ##      6 24266739.3390             nan     0.1000 -82354.7988
    ##      7 24009653.2270             nan     0.1000 -3752.8397
    ##      8 23546772.7409             nan     0.1000 -78138.5395
    ##      9 23420278.0818             nan     0.1000 32399.9163
    ##     10 23062853.4366             nan     0.1000 201817.6153
    ##     20 21427313.2970             nan     0.1000 5825.3473
    ##     40 19448530.7178             nan     0.1000 -131498.7994
    ##     60 17510401.1589             nan     0.1000 -71611.0743
    ##     80 16645795.3065             nan     0.1000 -49257.9370
    ##    100 15892511.0087             nan     0.1000 -120423.7448
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 25433668.0419             nan     0.1000 266830.9144
    ##      2 24974836.4590             nan     0.1000 344849.9769
    ##      3 24540961.7184             nan     0.1000 340606.1235
    ##      4 24239390.6476             nan     0.1000 -13736.9240
    ##      5 23806910.7961             nan     0.1000 262971.5526
    ##      6 23161953.5232             nan     0.1000 164281.8353
    ##      7 22862965.0972             nan     0.1000 85672.2618
    ##      8 22643078.9652             nan     0.1000 1314.2447
    ##      9 22434352.2261             nan     0.1000 105943.7018
    ##     10 22128726.3712             nan     0.1000 66587.2789
    ##     20 20085597.3666             nan     0.1000 -76297.8884
    ##     40 17899628.8884             nan     0.1000 -101825.9302
    ##     60 15967067.7390             nan     0.1000 -130698.6416
    ##     80 14494950.8622             nan     0.1000 -122529.4756
    ##    100 13346026.7434             nan     0.1000 -85432.3771
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 37731772.7115             nan     0.1000 -30375.4006
    ##      2 37619510.0448             nan     0.1000 -171437.6527
    ##      3 37493977.1148             nan     0.1000 64195.8476
    ##      4 37436519.1788             nan     0.1000 -31115.2805
    ##      5 37383457.6655             nan     0.1000 5819.7204
    ##      6 37248808.4302             nan     0.1000 117814.2602
    ##      7 37191950.4027             nan     0.1000 -109363.7575
    ##      8 37123415.8162             nan     0.1000 -123508.4061
    ##      9 37069159.1500             nan     0.1000 -340485.6070
    ##     10 36959839.3959             nan     0.1000 63812.7182
    ##     20 36302187.7770             nan     0.1000 -89760.5709
    ##     40 35215271.3872             nan     0.1000 20609.4775
    ##     60 34640544.9022             nan     0.1000 -148047.9084
    ##     80 34100280.1725             nan     0.1000 -85570.7585
    ##    100 33714397.7109             nan     0.1000 -138710.0700
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 37723136.7624             nan     0.1000 -40654.0493
    ##      2 37320774.2819             nan     0.1000 -30495.2259
    ##      3 37155218.2869             nan     0.1000 -124350.2056
    ##      4 36905523.6590             nan     0.1000 65123.4187
    ##      5 36666656.9026             nan     0.1000 17121.8050
    ##      6 36194000.1837             nan     0.1000 -68307.3418
    ##      7 36044430.6848             nan     0.1000 -140416.4162
    ##      8 35764598.3100             nan     0.1000 120489.0782
    ##      9 35604270.0942             nan     0.1000 -244881.7087
    ##     10 35501723.1569             nan     0.1000 -32643.4408
    ##     20 34393109.4239             nan     0.1000 -163339.1188
    ##     40 31780245.2147             nan     0.1000 -47080.1458
    ##     60 30439301.6085             nan     0.1000 -213669.5872
    ##     80 29541579.1719             nan     0.1000 -313482.0989
    ##    100 28767593.0214             nan     0.1000 -196688.7111
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 37485531.1238             nan     0.1000 -8696.1569
    ##      2 36813454.1903             nan     0.1000 -188129.0922
    ##      3 36479423.2165             nan     0.1000 76456.7976
    ##      4 36096266.6699             nan     0.1000 -58836.8090
    ##      5 35778286.4243             nan     0.1000 -42346.7448
    ##      6 35545844.4475             nan     0.1000 -107951.3317
    ##      7 35332047.1414             nan     0.1000 29551.5879
    ##      8 35133414.1597             nan     0.1000 -7177.1640
    ##      9 34933226.4380             nan     0.1000 -168804.2677
    ##     10 34644913.6299             nan     0.1000 -49810.5261
    ##     20 32588977.2842             nan     0.1000 -159953.1013
    ##     40 30315380.7126             nan     0.1000 -53130.7935
    ##     60 28993837.6339             nan     0.1000 -249203.5484
    ##     80 27457720.5992             nan     0.1000 -36931.9359
    ##    100 25621942.2909             nan     0.1000 -97978.1988
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 39978596.4266             nan     0.1000 -143620.2202
    ##      2 39709067.8862             nan     0.1000 107837.7875
    ##      3 39560192.8492             nan     0.1000 -34859.7687
    ##      4 39422720.3547             nan     0.1000 104205.5685
    ##      5 39233896.0762             nan     0.1000 -103227.5225
    ##      6 39105374.4723             nan     0.1000 -91875.4641
    ##      7 39007102.5752             nan     0.1000 -126174.5139
    ##      8 38858968.7005             nan     0.1000 20771.6172
    ##      9 38757948.9002             nan     0.1000 -22579.0981
    ##     10 38483582.1686             nan     0.1000 141586.1603
    ##     20 37590590.2661             nan     0.1000 -156231.6347
    ##     40 36041339.6165             nan     0.1000 -146590.5528
    ##     60 35254060.6082             nan     0.1000 -27383.7808
    ##     80 34704478.3242             nan     0.1000 -20216.0789
    ##    100 34169232.5265             nan     0.1000 -159306.8589
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 39433897.0244             nan     0.1000 72204.0107
    ##      2 39050922.4001             nan     0.1000 131922.0833
    ##      3 38744981.2501             nan     0.1000 17090.9286
    ##      4 38347074.1912             nan     0.1000 -192854.2273
    ##      5 38033216.2137             nan     0.1000 146982.4146
    ##      6 37827633.1606             nan     0.1000 -32189.6071
    ##      7 37638518.9916             nan     0.1000 -161943.8723
    ##      8 37514672.3303             nan     0.1000 -170797.6735
    ##      9 37100839.1736             nan     0.1000 62225.5208
    ##     10 36879036.1036             nan     0.1000 -138877.9234
    ##     20 34665685.0195             nan     0.1000  528.3387
    ##     40 31522164.6857             nan     0.1000 -237875.5746
    ##     60 29014878.4480             nan     0.1000 -97098.0976
    ##     80 27300485.1706             nan     0.1000 -75813.1997
    ##    100 26120854.1605             nan     0.1000 -115330.8271
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 39436241.7515             nan     0.1000 445755.3093
    ##      2 38963942.7547             nan     0.1000 179394.7283
    ##      3 38578019.9005             nan     0.1000 24753.6137
    ##      4 37994534.1693             nan     0.1000 58688.3379
    ##      5 37661814.9311             nan     0.1000 -133972.1293
    ##      6 37324557.8593             nan     0.1000 226212.3596
    ##      7 37076372.6347             nan     0.1000 -35730.0028
    ##      8 36683815.5096             nan     0.1000 -181751.5546
    ##      9 36445475.1888             nan     0.1000 24165.6140
    ##     10 36231869.0259             nan     0.1000 -172532.0564
    ##     20 34155226.4810             nan     0.1000 -166396.3320
    ##     40 30979948.2514             nan     0.1000 -187129.0005
    ##     60 28294427.4417             nan     0.1000 -103161.2814
    ##     80 26269444.8627             nan     0.1000 -129018.8161
    ##    100 24014086.3110             nan     0.1000 -55132.5344
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 34533991.3142             nan     0.1000 -7612.9570
    ##      2 34428412.0991             nan     0.1000 -70649.1008
    ##      3 34262162.1771             nan     0.1000 140808.8119
    ##      4 34187950.6596             nan     0.1000 -69899.9219
    ##      5 34080198.7630             nan     0.1000 85834.1110
    ##      6 34026946.5653             nan     0.1000 -77101.2506
    ##      7 33898937.1849             nan     0.1000 95728.9956
    ##      8 33761121.9675             nan     0.1000 49593.8318
    ##      9 33729254.6947             nan     0.1000 -120889.5414
    ##     10 33568154.4349             nan     0.1000 53879.0984
    ##     20 32747361.7662             nan     0.1000 9928.3009
    ##     25 32511815.8469             nan     0.1000 -30854.6115

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
    ##    0.01376713    0.01940191    0.04715037    0.02773544

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ## Random Forest 
    ##    0.04715037

## Automation

We generated these reports automatically for each channel (“lifestyle”,
“entertainment”, “bus”, “socmed”, “tech”, and “world”) by creating a
function that uses the `rmarkdown` package to render a Github document
with a `params` option, and then using a for loop to execute that
function for each channel in a list. That’s how the page you’re reading
was generated!

The code we used to automate the rendering is visible at the main page
for this project [here](https://cdonahu.github.io/st558-project2/).

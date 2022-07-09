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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/socmed_files/figure-gfm/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/socmed_files/figure-gfm/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/socmed_files/figure-gfm/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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
    ## plot: [2,3] [=======================>------------------------------] 44% est: 2s
    ## plot: [2,4] [==========================>---------------------------] 50% est: 1s
    ## plot: [3,1] [=============================>------------------------] 56% est: 1s
    ## plot: [3,2] [=================================>--------------------] 62% est: 1s
    ## plot: [3,3] [====================================>-----------------] 69% est: 1s
    ## plot: [3,4] [=======================================>--------------] 75% est: 0s
    ## plot: [4,1] [===========================================>----------] 81% est: 0s
    ## plot: [4,2] [==============================================>-------] 88% est: 0s
    ## plot: [4,3] [==================================================>---] 94% est: 0s
    ## plot: [4,4] [======================================================]100% est: 0s

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/socmed_files/figure-gfm/exploratory%20graph-1.png)<!-- -->

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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 1302, 1302, 1302, 1303, 1303 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   5811.179  0.01872184  2678.261
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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 1303, 1302, 1303, 1302, 1302 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   5623.512  0.02166056  2655.532
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
    ## 1628 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (45), scaled (45), ignore (13) 
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 1303, 1303, 1302, 1302, 1302 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     5610.061  0.05048564  2641.619
    ##   2     5564.069  0.05430318  2634.886
    ##   3     5555.314  0.05798613  2653.101
    ##   4     5580.632  0.05031136  2670.072
    ##   5     5580.285  0.05385876  2674.164
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was mtry = 3.

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
    ##      1 27736612.5474             nan     0.1000 151993.2335
    ##      2 27566424.8658             nan     0.1000 90203.6419
    ##      3 27409646.6436             nan     0.1000 127467.8613
    ##      4 27341706.7506             nan     0.1000 -19897.7013
    ##      5 27188480.1200             nan     0.1000 20047.7938
    ##      6 27116817.3881             nan     0.1000 -26775.7194
    ##      7 26981710.1331             nan     0.1000 36115.6958
    ##      8 26848999.8799             nan     0.1000 37536.1737
    ##      9 26754939.1536             nan     0.1000 -48162.2887
    ##     10 26662550.3605             nan     0.1000 44224.9663
    ##     20 25895309.9975             nan     0.1000 -141534.7475
    ##     40 24840135.8269             nan     0.1000 -28735.0889
    ##     60 24321053.9842             nan     0.1000 3801.4318
    ##     80 23803687.5372             nan     0.1000 -2664.3766
    ##    100 23340119.0908             nan     0.1000 -103799.4396
    ##    120 23109578.5477             nan     0.1000 -68614.6036
    ##    140 22822248.0141             nan     0.1000 -63512.2232
    ##    150 22665776.6145             nan     0.1000 -14853.4767
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 27508007.6122             nan     0.1000 220098.2957
    ##      2 27362664.5313             nan     0.1000 -9808.5461
    ##      3 27147742.2410             nan     0.1000 104363.2353
    ##      4 26841893.6622             nan     0.1000 78659.3099
    ##      5 26590567.6575             nan     0.1000 42736.3720
    ##      6 26453740.6092             nan     0.1000 31796.8094
    ##      7 26328498.1408             nan     0.1000 23904.2387
    ##      8 26014948.5631             nan     0.1000 165194.2144
    ##      9 25827078.8557             nan     0.1000 -37373.4950
    ##     10 25612701.5148             nan     0.1000 55712.7584
    ##     20 23793021.5035             nan     0.1000 54997.9601
    ##     40 21573923.8684             nan     0.1000 -60609.2864
    ##     60 20523389.5285             nan     0.1000 -30338.8036
    ##     80 19315962.6207             nan     0.1000 -79228.4195
    ##    100 18341378.7590             nan     0.1000 -67201.6144
    ##    120 17751841.5342             nan     0.1000 -33585.0628
    ##    140 16785972.2919             nan     0.1000 -65190.9843
    ##    150 16508600.9292             nan     0.1000 -11191.3162
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 27490273.9886             nan     0.1000 160247.4895
    ##      2 27020474.8253             nan     0.1000 -17088.5800
    ##      3 26664181.9374             nan     0.1000 131207.1285
    ##      4 26328948.0107             nan     0.1000 57023.1238
    ##      5 25940453.8838             nan     0.1000 161680.9685
    ##      6 25576309.3800             nan     0.1000 -131018.8600
    ##      7 25275277.2845             nan     0.1000 36347.3092
    ##      8 25159429.6426             nan     0.1000 -140621.2807
    ##      9 24928533.9971             nan     0.1000 -107258.8769
    ##     10 24762015.5354             nan     0.1000 17593.2693
    ##     20 22485511.8914             nan     0.1000 -127534.6650
    ##     40 19815244.3727             nan     0.1000 -51978.3685
    ##     60 17733727.3590             nan     0.1000 -33196.4466
    ##     80 15784444.4461             nan     0.1000 -104169.2262
    ##    100 14645170.0912             nan     0.1000 -153745.0497
    ##    120 13716291.6989             nan     0.1000 -40058.5279
    ##    140 12780587.1167             nan     0.1000 -61242.7117
    ##    150 12403464.4491             nan     0.1000 -67250.9488
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 36043720.3852             nan     0.1000 165023.4996
    ##      2 35794352.5246             nan     0.1000 -249177.3481
    ##      3 35581221.3652             nan     0.1000 129324.0354
    ##      4 35485777.9915             nan     0.1000 -161742.8261
    ##      5 35396463.2992             nan     0.1000 26202.5137
    ##      6 35316623.9449             nan     0.1000 -222428.4657
    ##      7 35198265.9555             nan     0.1000 63802.3389
    ##      8 35044258.1517             nan     0.1000 81483.9784
    ##      9 34982436.3721             nan     0.1000 -35772.3795
    ##     10 34861222.8977             nan     0.1000 43079.8139
    ##     20 34144269.4846             nan     0.1000 -18799.0284
    ##     40 33322829.1046             nan     0.1000 -12974.8088
    ##     60 32725288.0585             nan     0.1000 -45985.2256
    ##     80 32402878.2056             nan     0.1000 -223906.9591
    ##    100 31844356.0214             nan     0.1000 -133984.2186
    ##    120 31604658.3634             nan     0.1000 -7734.7083
    ##    140 31369441.0918             nan     0.1000 -131077.6807
    ##    150 31224804.6274             nan     0.1000 -95687.2610
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 35984889.9065             nan     0.1000 64994.8110
    ##      2 35666636.2135             nan     0.1000 117082.6800
    ##      3 35503059.4376             nan     0.1000 -11161.3152
    ##      4 35181646.0586             nan     0.1000 158859.8718
    ##      5 34688350.4163             nan     0.1000 -47125.3890
    ##      6 34518759.7683             nan     0.1000 -150074.6276
    ##      7 34344175.7532             nan     0.1000 -25552.3485
    ##      8 34140182.4810             nan     0.1000 -8478.7910
    ##      9 33700622.5790             nan     0.1000 238175.7220
    ##     10 33570376.2547             nan     0.1000 -72145.2723
    ##     20 32165072.6791             nan     0.1000 -230873.2634
    ##     40 30757048.3725             nan     0.1000 -93999.2517
    ##     60 29491134.5242             nan     0.1000 -26857.6032
    ##     80 28646334.8656             nan     0.1000 -110849.9469
    ##    100 27609294.9455             nan     0.1000 16925.6351
    ##    120 26568873.4014             nan     0.1000 -171327.4350
    ##    140 25334535.2357             nan     0.1000 -79923.5642
    ##    150 25046080.2725             nan     0.1000 -140704.4323
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 35916114.3013             nan     0.1000 172562.2043
    ##      2 35413066.1658             nan     0.1000 -15742.1286
    ##      3 34959536.3721             nan     0.1000 -79458.3070
    ##      4 34574133.6525             nan     0.1000 148298.4248
    ##      5 34396417.3547             nan     0.1000 23774.1544
    ##      6 34124373.2070             nan     0.1000 100564.8215
    ##      7 33858714.1376             nan     0.1000 35851.7548
    ##      8 33628098.4448             nan     0.1000 -193835.4550
    ##      9 33324428.1789             nan     0.1000 -48890.0460
    ##     10 33071645.0744             nan     0.1000 2937.5802
    ##     20 31307912.0466             nan     0.1000 -118658.3101
    ##     40 28366276.3052             nan     0.1000 -148092.9092
    ##     60 26342367.7640             nan     0.1000 28939.0227
    ##     80 24884452.4057             nan     0.1000 -80737.8628
    ##    100 22828619.0345             nan     0.1000 36262.1629
    ##    120 21454831.2744             nan     0.1000 -40510.2874
    ##    140 20391836.3224             nan     0.1000 -111910.9055
    ##    150 19973909.2539             nan     0.1000 -149585.1004
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 39563131.9862             nan     0.1000 -41287.3429
    ##      2 39402399.7713             nan     0.1000 98495.4472
    ##      3 39256415.8901             nan     0.1000 -31840.6666
    ##      4 39098351.9126             nan     0.1000 103689.7195
    ##      5 38863250.2264             nan     0.1000 -62653.4696
    ##      6 38732071.7433             nan     0.1000 -104047.4598
    ##      7 38582267.2647             nan     0.1000 -185.7419
    ##      8 38466214.1982             nan     0.1000 -40910.9169
    ##      9 38314892.1706             nan     0.1000 91216.6591
    ##     10 38183832.5127             nan     0.1000 -61222.3295
    ##     20 37355023.6952             nan     0.1000 -45680.3548
    ##     40 36122865.5367             nan     0.1000 13015.4826
    ##     60 35216463.3482             nan     0.1000 -48658.2806
    ##     80 34781276.1118             nan     0.1000 -132614.7420
    ##    100 34253149.9589             nan     0.1000 -13991.0227
    ##    120 33970141.9829             nan     0.1000 -38711.0347
    ##    140 33599579.0546             nan     0.1000 -67241.0239
    ##    150 33497229.8127             nan     0.1000 -136850.2602
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 39494600.5608             nan     0.1000 -5512.2075
    ##      2 39096389.3077             nan     0.1000 257345.9500
    ##      3 38680281.6962             nan     0.1000 4305.4771
    ##      4 38412741.4943             nan     0.1000 64262.9364
    ##      5 38188011.5280             nan     0.1000 9108.9169
    ##      6 37706288.8396             nan     0.1000 -93402.2857
    ##      7 37542489.4531             nan     0.1000 69955.7351
    ##      8 37147695.7731             nan     0.1000 119704.5266
    ##      9 36946464.1282             nan     0.1000 -12677.5369
    ##     10 36852141.9456             nan     0.1000 -164488.1765
    ##     20 34306846.6519             nan     0.1000 -83967.3225
    ##     40 31349765.7079             nan     0.1000 -164805.0820
    ##     60 29719029.0986             nan     0.1000 -90226.0392
    ##     80 28145582.7467             nan     0.1000 -77334.5776
    ##    100 27061960.1019             nan     0.1000 -195029.0877
    ##    120 26356140.9392             nan     0.1000 -74112.1675
    ##    140 25638040.9037             nan     0.1000 -78086.2648
    ##    150 25376376.6526             nan     0.1000 -141133.9846
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 39112538.4331             nan     0.1000 -281505.2740
    ##      2 38823647.1730             nan     0.1000 -106711.0867
    ##      3 38094592.6689             nan     0.1000 278098.5190
    ##      4 37529841.6426             nan     0.1000 78219.9826
    ##      5 37305689.4006             nan     0.1000 12514.9255
    ##      6 36984454.3300             nan     0.1000 117437.8617
    ##      7 36770569.5238             nan     0.1000 26609.5533
    ##      8 36562822.0752             nan     0.1000 -75348.3985
    ##      9 36197673.4400             nan     0.1000 1381.7396
    ##     10 35762176.6641             nan     0.1000 -7744.9325
    ##     20 33053273.9475             nan     0.1000 227041.0895
    ##     40 29980901.3572             nan     0.1000 -171575.5369
    ##     60 27331717.4867             nan     0.1000 -96308.7660
    ##     80 25849690.5292             nan     0.1000 -6462.2244
    ##    100 24590970.8832             nan     0.1000 -132054.0246
    ##    120 23554167.7617             nan     0.1000 -146381.3032
    ##    140 22053447.2543             nan     0.1000 -131780.5696
    ##    150 21285397.9695             nan     0.1000 -165787.7774
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 29857119.6418             nan     0.1000 -30302.9810
    ##      2 29738543.8634             nan     0.1000 -26658.5821
    ##      3 29631498.1346             nan     0.1000 72988.0281
    ##      4 29534301.4605             nan     0.1000 34483.5416
    ##      5 29459871.8334             nan     0.1000 35329.9229
    ##      6 29389084.2210             nan     0.1000 15197.1052
    ##      7 29303115.4362             nan     0.1000 13557.2947
    ##      8 29211785.9566             nan     0.1000 -52618.6936
    ##      9 29132744.0075             nan     0.1000 -17059.3040
    ##     10 29078475.5101             nan     0.1000 3870.3872
    ##     20 28549876.4512             nan     0.1000 -234509.5529
    ##     40 27743730.3305             nan     0.1000 -6561.7164
    ##     60 27413932.7126             nan     0.1000 -85437.1234
    ##     80 27262611.8829             nan     0.1000 -120462.0556
    ##    100 26977065.1017             nan     0.1000 -41575.2217
    ##    120 26808396.6881             nan     0.1000 -9631.3252
    ##    140 26554630.2397             nan     0.1000 -24145.4106
    ##    150 26499372.5099             nan     0.1000 -45413.6671
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 29734745.1417             nan     0.1000 18733.5048
    ##      2 29567310.3989             nan     0.1000 -9257.6831
    ##      3 29359478.4490             nan     0.1000 136874.0074
    ##      4 29181150.1867             nan     0.1000 18742.6768
    ##      5 29067206.8180             nan     0.1000 -91128.0007
    ##      6 28968248.3653             nan     0.1000 -18558.5247
    ##      7 28820541.0384             nan     0.1000 -27130.4897
    ##      8 28724885.2369             nan     0.1000 -4639.3232
    ##      9 28573598.3785             nan     0.1000 18793.5361
    ##     10 28465786.8744             nan     0.1000 -15732.4630
    ##     20 26670512.5620             nan     0.1000 -152364.0329
    ##     40 25280444.5537             nan     0.1000 -148866.3731
    ##     60 24430834.6809             nan     0.1000 -133811.3777
    ##     80 23741915.6391             nan     0.1000 -109294.4824
    ##    100 22648337.3999             nan     0.1000 -34708.9730
    ##    120 22289311.7145             nan     0.1000 -106762.8399
    ##    140 21927826.9462             nan     0.1000 -66247.7624
    ##    150 21864938.5141             nan     0.1000 -24457.2118
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 29786781.2808             nan     0.1000 147111.2523
    ##      2 29428759.7198             nan     0.1000 65062.2524
    ##      3 29146666.4603             nan     0.1000 -26365.9971
    ##      4 28859551.7503             nan     0.1000 154218.1626
    ##      5 28656853.8891             nan     0.1000 -51050.3981
    ##      6 28355979.2679             nan     0.1000 -87680.3147
    ##      7 28210232.0744             nan     0.1000 -83221.7773
    ##      8 27909153.1366             nan     0.1000 -65890.6222
    ##      9 27475409.2015             nan     0.1000 -80153.0842
    ##     10 27294928.7423             nan     0.1000 -5131.2353
    ##     20 25459351.4629             nan     0.1000 -151806.9112
    ##     40 22423009.0824             nan     0.1000 -132757.3285
    ##     60 20092957.0715             nan     0.1000 -3436.4740
    ##     80 19169029.1453             nan     0.1000 -128929.6984
    ##    100 17821823.0905             nan     0.1000 -40995.7822
    ##    120 16785434.5157             nan     0.1000 -175592.7471
    ##    140 15868113.8609             nan     0.1000 -39235.4020
    ##    150 15680188.6377             nan     0.1000 -105527.4993
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 39001001.2484             nan     0.1000 71118.1156
    ##      2 38729970.6854             nan     0.1000 183308.7748
    ##      3 38589996.4104             nan     0.1000 29515.7189
    ##      4 38423450.6069             nan     0.1000 -87740.6545
    ##      5 38162878.9915             nan     0.1000 179821.5302
    ##      6 38068755.7496             nan     0.1000 55382.2825
    ##      7 37828996.0586             nan     0.1000 66924.5609
    ##      8 37717439.8276             nan     0.1000 -72413.4933
    ##      9 37645960.8118             nan     0.1000 -16325.7859
    ##     10 37556852.8518             nan     0.1000 -142838.8949
    ##     20 36631142.7909             nan     0.1000 42054.3097
    ##     40 35398991.1650             nan     0.1000 -10763.0589
    ##     60 34781774.0297             nan     0.1000 -35542.6733
    ##     80 34352355.6245             nan     0.1000 -32498.0356
    ##    100 34087942.0465             nan     0.1000 -40608.7119
    ##    120 33641122.8144             nan     0.1000 -54226.0765
    ##    140 33233276.8111             nan     0.1000 -48288.2313
    ##    150 33059810.5413             nan     0.1000 -142721.1934
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 39025261.5844             nan     0.1000 131416.3668
    ##      2 38699397.0227             nan     0.1000 252707.3862
    ##      3 38356236.8965             nan     0.1000 104647.1842
    ##      4 37884290.9378             nan     0.1000 362230.2980
    ##      5 37439419.0804             nan     0.1000 238353.9141
    ##      6 37123097.8165             nan     0.1000 -76069.6280
    ##      7 36873600.5373             nan     0.1000 123318.6461
    ##      8 36470458.7319             nan     0.1000 172653.7741
    ##      9 36213145.5041             nan     0.1000 -39669.2242
    ##     10 36006161.2000             nan     0.1000 -63913.3593
    ##     20 34565960.1526             nan     0.1000 -191765.4498
    ##     40 32075201.2992             nan     0.1000 -121204.6794
    ##     60 29931698.6959             nan     0.1000 -209753.7662
    ##     80 28493071.5513             nan     0.1000 -85933.9799
    ##    100 27476329.1962             nan     0.1000 -90444.4683
    ##    120 26521277.8312             nan     0.1000 -77666.4335
    ##    140 26013219.0818             nan     0.1000 -164585.7626
    ##    150 25517568.2931             nan     0.1000 -98306.7453
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 38703682.3984             nan     0.1000 103286.7044
    ##      2 37960134.0886             nan     0.1000 183046.5602
    ##      3 37728716.4087             nan     0.1000 48928.2341
    ##      4 37478690.1602             nan     0.1000 85342.7777
    ##      5 37278801.0620             nan     0.1000 -125788.6725
    ##      6 36907057.8635             nan     0.1000 -39370.4397
    ##      7 36764105.1949             nan     0.1000 -85310.9880
    ##      8 36601699.0473             nan     0.1000 -42623.5519
    ##      9 36268778.8762             nan     0.1000 57514.9394
    ##     10 36043235.2615             nan     0.1000 -6385.4583
    ##     20 33736848.2932             nan     0.1000 -111859.3480
    ##     40 30880029.9992             nan     0.1000 -113047.1388
    ##     60 28073868.0555             nan     0.1000 -154844.1815
    ##     80 25949039.3916             nan     0.1000 -197526.6209
    ##    100 24271177.9607             nan     0.1000 -123728.4812
    ##    120 22902265.4991             nan     0.1000 -50404.1075
    ##    140 21518442.8040             nan     0.1000 -176009.0066
    ##    150 20783323.4562             nan     0.1000 -140270.4400
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 34595212.9214             nan     0.1000 -12871.8006
    ##      2 34460592.8813             nan     0.1000 -82009.2317
    ##      3 34248641.7591             nan     0.1000 127619.2584
    ##      4 34160047.7675             nan     0.1000 23629.5481
    ##      5 34011251.7197             nan     0.1000 135098.3018
    ##      6 33911569.4602             nan     0.1000 -148349.2674
    ##      7 33783263.9700             nan     0.1000 30714.0725
    ##      8 33660142.1618             nan     0.1000 79670.6071
    ##      9 33597297.9719             nan     0.1000 -107423.8131
    ##     10 33545499.3241             nan     0.1000 -82112.5566
    ##     20 32911758.1209             nan     0.1000 24748.8608
    ##     40 32013060.2310             nan     0.1000 -141794.1033
    ##     50 31771193.5195             nan     0.1000 -28669.7074

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
    ##    0.01872184    0.01940191    0.05798613    0.03804703

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ## Random Forest 
    ##    0.05798613

## Automation

We generated these reports automatically for each channel (“lifestyle”,
“entertainment”, “bus”, “socmed”, “tech”, and “world”) by creating a
function that uses the `rmarkdown` package to render a Github document,
and then using a for loop to execute that function for each channel in a
list. That’s how the page you’re reading was generated!

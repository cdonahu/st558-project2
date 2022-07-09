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
    ## 1    3092.6         1700    10244.49

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

![](./tech_images/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

Then we wanted to look at the outliers–the top articles by shares, so we
grabbed a list of those URLs, along with the number of shares.

``` r
head(training[order(training$shares, decreasing = TRUE), c("url", "shares")], 10)
```

    ## # A tibble: 10 × 2
    ##    url                                                                 shares
    ##    <chr>                                                                <dbl>
    ##  1 http://mashable.com/2014/04/09/first-100-gilt-soundcloud-stitchfix/ 663600
    ##  2 http://mashable.com/2013/08/24/instagram-acquires-luma/              96100
    ##  3 http://mashable.com/2014/01/21/kiev-ukraine-protest-photos/          88500
    ##  4 http://mashable.com/2014/06/18/helloflo-first-moon-party-ad/         70200
    ##  5 http://mashable.com/2013/10/24/google-calico/                        55200
    ##  6 http://mashable.com/2014/09/08/whole-foods-instacart-delivery/       53200
    ##  7 http://mashable.com/2014/10/09/bees-men-arizona/                     52600
    ##  8 http://mashable.com/2014/10/27/bear-selfies/                         51000
    ##  9 http://mashable.com/2014/04/10/twitter-profile-pages-brands/         50700
    ## 10 http://mashable.com/2014/09/16/worst-things-itunes/                  48000

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

![](./tech_images/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](./tech_images/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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

![](./tech_images/exploratory%20graph-1.png)<!-- -->

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
    ##                   3092.60                     593.06                     878.68  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                   -709.48                    -118.12                      59.29  
    ##                kw_max_max                 kw_avg_max                 kw_max_avg  
    ##                    -24.19                    -232.10                    -442.73  
    ##                kw_avg_avg  self_reference_min_shares         weekday_is_monday1  
    ##                    800.89                      94.50                    -108.71  
    ##       weekday_is_tuesday1      weekday_is_wednesday1       weekday_is_thursday1  
    ##                   -133.47                     158.77                    -167.03  
    ##        weekday_is_friday1        global_subjectivity   title_sentiment_polarity  
    ##                   -103.83                    -102.64                     131.73

``` r
fullFit
```

    ## Linear Regression 
    ## 
    ## 5145 samples
    ##   18 predictor
    ## 
    ## Pre-processing: centered (17), scaled (17), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 3430, 3430, 3430 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   8330.193  0.01754847  2406.361
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
    ##                   3092.60                     605.41                     873.06  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                   -713.66                    -109.46                      61.01  
    ##                kw_max_max                 kw_avg_max                 kw_max_avg  
    ##                    -30.90                    -230.21                    -441.22  
    ##                kw_avg_avg  self_reference_min_shares        global_subjectivity  
    ##                    797.78                      91.66                     -96.59  
    ##  title_sentiment_polarity  
    ##                    133.25

``` r
smallFit
```

    ## Linear Regression 
    ## 
    ## 5145 samples
    ##   13 predictor
    ## 
    ## Pre-processing: centered (12), scaled (12), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 3430, 3430, 3430 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   8403.749  0.02128477  2396.853
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
    ## 5145 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (44), scaled (44), ignore (13), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 3430, 3430, 3430 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     8534.951  0.02346989  2350.700
    ##   2     8546.494  0.02536683  2385.903
    ##   3     8515.839  0.03787454  2395.242
    ##   4     8544.128  0.02956386  2394.875
    ##   5     8606.463  0.02200020  2430.792
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was mtry = 3.

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
    ##      1 148063823.3610             nan     0.1000 25650.1207
    ##      2 147977793.1383             nan     0.1000 -19851.1058
    ##      3 145740757.1765             nan     0.1000 -303134.4102
    ##      4 144005837.5751             nan     0.1000 -655502.2185
    ##      5 142753693.4282             nan     0.1000 -542546.8120
    ##      6 143042285.0628             nan     0.1000 -850361.7803
    ##      7 143288423.8487             nan     0.1000 -772966.3450
    ##      8 143543235.5344             nan     0.1000 -737343.0448
    ##      9 143381372.6093             nan     0.1000 102979.0239
    ##     10 141737086.7618             nan     0.1000 -378532.3291
    ##     20 138061686.5764             nan     0.1000 -1113724.8104
    ##     40 133960264.2083             nan     0.1000 -742950.0537
    ##     60 131567321.0428             nan     0.1000 -969770.0289
    ##     80 126105955.8717             nan     0.1000 684914.7973
    ##    100 121880862.0370             nan     0.1000 -1033734.6314
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 147983772.0331             nan     0.1000 37033.1670
    ##      2 145668854.2372             nan     0.1000 -323579.8875
    ##      3 145552262.3714             nan     0.1000 81362.6526
    ##      4 143679231.1466             nan     0.1000 -551342.6128
    ##      5 141905086.0651             nan     0.1000 -608816.7914
    ##      6 140618581.0521             nan     0.1000 -695703.1911
    ##      7 140799624.0339             nan     0.1000 -909118.3053
    ##      8 139749563.2060             nan     0.1000 -665778.0935
    ##      9 140007734.8512             nan     0.1000 -1104167.9770
    ##     10 140259024.7815             nan     0.1000 -890470.4735
    ##     20 137046777.9748             nan     0.1000 -934302.5606
    ##     40 130536691.6854             nan     0.1000 -1238712.5644
    ##     60 128121434.4854             nan     0.1000 -871976.6963
    ##     80 119817369.4357             nan     0.1000 231927.7242
    ##    100 114841963.3073             nan     0.1000 -1038696.0093
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 147873885.0333             nan     0.1000 160176.9574
    ##      2 145554122.3587             nan     0.1000 -364695.7043
    ##      3 145664481.8924             nan     0.1000 -478842.7165
    ##      4 143703302.6910             nan     0.1000 -498218.2673
    ##      5 141709419.4347             nan     0.1000 -435259.1078
    ##      6 141834807.2150             nan     0.1000 -528259.9855
    ##      7 140277644.7697             nan     0.1000 -703294.4399
    ##      8 139088413.9896             nan     0.1000 -691986.6033
    ##      9 137758940.6406             nan     0.1000 -460447.5674
    ##     10 136647930.1718             nan     0.1000 -1073561.2230
    ##     20 132187043.0032             nan     0.1000 -596226.1947
    ##     40 122352151.5234             nan     0.1000 -415216.6068
    ##     60 114863362.9689             nan     0.1000 -816923.6560
    ##     80 108691137.5007             nan     0.1000 -1128191.8454
    ##    100 100691624.1911             nan     0.1000 -178741.8077
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 148660944.2798             nan     0.1000 54184.9463
    ##      2 146655480.0825             nan     0.1000 -105853.4489
    ##      3 144843250.8186             nan     0.1000 -499754.7273
    ##      4 143469739.3180             nan     0.1000 -531411.9926
    ##      5 143371663.5634             nan     0.1000 66350.8020
    ##      6 142024037.8923             nan     0.1000 -220745.8739
    ##      7 141149567.5916             nan     0.1000 -909536.3660
    ##      8 140847214.7091             nan     0.1000 329429.6273
    ##      9 141061319.5840             nan     0.1000 -606956.2354
    ##     10 140330008.2843             nan     0.1000 -1022494.7043
    ##     20 138666107.0741             nan     0.1000 -1103009.9516
    ##     40 136545267.0252             nan     0.1000 389625.4878
    ##     60 134274212.7843             nan     0.1000 -762196.1156
    ##     80 125920906.3022             nan     0.1000 -973831.3922
    ##    100 124432377.4960             nan     0.1000 -1276542.6751
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 148561236.7979             nan     0.1000 62192.7512
    ##      2 148497369.2596             nan     0.1000 4763.0202
    ##      3 148364974.3516             nan     0.1000 55740.2458
    ##      4 145959423.1789             nan     0.1000 -179954.0954
    ##      5 144161295.9068             nan     0.1000 -452988.6000
    ##      6 142860695.8744             nan     0.1000 -674914.9235
    ##      7 141295358.0420             nan     0.1000 95928.2486
    ##      8 141442815.4376             nan     0.1000 -530165.4451
    ##      9 141350459.8525             nan     0.1000 54462.9189
    ##     10 140270312.5998             nan     0.1000 -728493.7516
    ##     20 135470301.7644             nan     0.1000 47388.1669
    ##     40 125720367.4410             nan     0.1000 -537019.3149
    ##     60 117640896.4102             nan     0.1000 -435709.5580
    ##     80 110771830.0305             nan     0.1000 -132504.2342
    ##    100 100716406.4208             nan     0.1000 -90483.7152
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 148641684.4413             nan     0.1000 5381.7102
    ##      2 148431894.0357             nan     0.1000 64107.4091
    ##      3 148265048.2455             nan     0.1000 -19028.0418
    ##      4 148119887.2486             nan     0.1000 -58857.8179
    ##      5 145706329.5288             nan     0.1000 -200352.6544
    ##      6 145568374.1020             nan     0.1000 36207.1647
    ##      7 143833125.4129             nan     0.1000 -611489.0974
    ##      8 142540418.9287             nan     0.1000 -317981.1121
    ##      9 141160871.0775             nan     0.1000 -180158.7563
    ##     10 141382620.5687             nan     0.1000 -732794.4086
    ##     20 135927152.3655             nan     0.1000 -1156775.2604
    ##     40 128804037.5123             nan     0.1000 -636382.9154
    ##     60 125246249.9829             nan     0.1000 -821269.9020
    ##     80 119637165.1089             nan     0.1000 -1045249.3532
    ##    100 116478054.5585             nan     0.1000 -1621162.1309
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 17833318.5829             nan     0.1000 63474.1888
    ##      2 17742313.3607             nan     0.1000 47117.9467
    ##      3 17671991.1795             nan     0.1000 19275.1833
    ##      4 17611974.0996             nan     0.1000 47973.5167
    ##      5 17568128.4101             nan     0.1000 41170.4875
    ##      6 17523733.3179             nan     0.1000 14118.2134
    ##      7 17483241.4813             nan     0.1000 5511.5838
    ##      8 17463406.9429             nan     0.1000 -2324.4415
    ##      9 17408741.1420             nan     0.1000 24656.8136
    ##     10 17381601.6910             nan     0.1000 19642.4716
    ##     20 17190065.3695             nan     0.1000 7981.5891
    ##     40 16900666.8297             nan     0.1000 -6745.8719
    ##     60 16726230.2320             nan     0.1000 -10601.8114
    ##     80 16590356.3095             nan     0.1000 -14456.7618
    ##    100 16475170.3631             nan     0.1000 -8569.4516
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 17766346.9806             nan     0.1000 56736.2051
    ##      2 17678133.7500             nan     0.1000 20630.7373
    ##      3 17598085.3548             nan     0.1000 58901.3388
    ##      4 17484103.1137             nan     0.1000 83815.1038
    ##      5 17438361.5365             nan     0.1000 26138.8624
    ##      6 17358460.4518             nan     0.1000 68064.3450
    ##      7 17296814.1009             nan     0.1000 52609.3753
    ##      8 17237106.2927             nan     0.1000 16804.5338
    ##      9 17146649.5729             nan     0.1000 32377.2155
    ##     10 17111460.3518             nan     0.1000 23311.1973
    ##     20 16660700.3761             nan     0.1000 -66099.4297
    ##     40 15945108.9211             nan     0.1000 -17707.0436
    ##     60 15553958.5983             nan     0.1000 -8915.8994
    ##     80 15252097.7148             nan     0.1000 -12191.8198
    ##    100 14752764.1638             nan     0.1000 -14133.4408
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 17742111.4583             nan     0.1000 124783.2633
    ##      2 17606469.2702             nan     0.1000 82431.4787
    ##      3 17501810.7437             nan     0.1000 54918.3504
    ##      4 17405072.8258             nan     0.1000 38631.6417
    ##      5 17330928.6339             nan     0.1000 27051.7200
    ##      6 17273886.5301             nan     0.1000 19550.2706
    ##      7 17136679.0916             nan     0.1000 -14515.4741
    ##      8 17040537.6341             nan     0.1000 29148.1239
    ##      9 16917748.1226             nan     0.1000 3455.6902
    ##     10 16807844.2593             nan     0.1000 -61544.5072
    ##     20 15916752.4508             nan     0.1000  892.9668
    ##     40 14796604.3371             nan     0.1000 -12186.5653
    ##     60 14046177.9806             nan     0.1000 -13658.7825
    ##     80 13478153.8763             nan     0.1000 -4501.0982
    ##    100 13081406.8759             nan     0.1000 1000.4777
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 103455401.9405             nan     0.1000 -8275.8478
    ##      2 103325530.7674             nan     0.1000 50686.4174
    ##      3 103209132.1938             nan     0.1000 65886.1164
    ##      4 103079877.5710             nan     0.1000 142583.7227
    ##      5 103012747.9923             nan     0.1000 41414.9735
    ##      6 102896140.2324             nan     0.1000 49929.3625
    ##      7 102836518.1760             nan     0.1000 47681.7552
    ##      8 101687160.3011             nan     0.1000 -368314.7176
    ##      9 101854403.0048             nan     0.1000 -530271.5802
    ##     10 101209097.6471             nan     0.1000 -321882.1916
    ##     20 98371000.3479             nan     0.1000 -479056.9093
    ##     25 97640338.3307             nan     0.1000 -988332.3644

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
    ##   0.017548472   0.019401910   0.037874540   0.009079709

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ## Random Forest 
    ##    0.03787454

## Automation

We generated these reports automatically for each channel (“lifestyle”,
“entertainment”, “bus”, “socmed”, “tech”, and “world”) by creating a
function that uses the `rmarkdown` package to render a Github document
with a `params` option, and then using a for loop to execute that
function for each channel in a list. That’s how the page you’re reading
was generated!

The code we used to automate the rendering is visible at the main page
for this project [here](https://cdonahu.github.io/st558-project2/).

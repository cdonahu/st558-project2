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
    ## 1  3569.505         1700    7795.238

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

![](./lifestyle_images/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

Then we wanted to look at the outliers–the top articles by shares, so we
grabbed a list of those URLs, along with the number of shares.

``` r
head(training[order(training$shares, decreasing = TRUE), c("url", "shares")], 10)
```

    ## # A tibble: 10 × 2
    ##    url                                                                 shares
    ##    <chr>                                                                <dbl>
    ##  1 http://mashable.com/2013/07/08/supercut-one-man-trailers/           196700
    ##  2 http://mashable.com/2013/06/11/wristband-mood-monitor/               81200
    ##  3 http://mashable.com/2013/05/29/summer-reading-list/                  73100
    ##  4 http://mashable.com/2013/07/11/tech-virtual-border-fence/            56000
    ##  5 http://mashable.com/2013/12/10/mock-netwars/                         54900
    ##  6 http://mashable.com/2013/10/15/apps-morning-commute/                 54200
    ##  7 http://mashable.com/2013/10/21/revenge-porn/                         49700
    ##  8 http://mashable.com/2014/05/29/beats-solo-2-review/                  45100
    ##  9 http://mashable.com/2014/07/18/sex-tape-cloud-mishap-not-plausible/  43000
    ## 10 http://mashable.com/2013/04/30/airfare-flight-deals/                 41700

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

![](./lifestyle_images/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](./lifestyle_images/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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
    ## plot: [1,2] [======>-----------------------------------------------] 12% est: 3s
    ## plot: [1,3] [=========>--------------------------------------------] 19% est: 2s
    ## plot: [1,4] [=============>----------------------------------------] 25% est: 2s
    ## plot: [2,1] [================>-------------------------------------] 31% est: 1s
    ## plot: [2,2] [===================>----------------------------------] 38% est: 1s
    ## plot: [2,3] [=======================>------------------------------] 44% est: 1s
    ## plot: [2,4] [==========================>---------------------------] 50% est: 1s
    ## plot: [3,1] [=============================>------------------------] 56% est: 1s
    ## plot: [3,2] [=================================>--------------------] 62% est: 1s
    ## plot: [3,3] [====================================>-----------------] 69% est: 0s
    ## plot: [3,4] [=======================================>--------------] 75% est: 0s
    ## plot: [4,1] [===========================================>----------] 81% est: 0s
    ## plot: [4,2] [==============================================>-------] 88% est: 0s
    ## plot: [4,3] [==================================================>---] 94% est: 0s
    ## plot: [4,4] [======================================================]100% est: 0s

![](./lifestyle_images/exploratory%20graph-1.png)<!-- -->

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
    ##                  3569.505                    783.124                    287.173  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                  -299.390                   -405.737                   -144.394  
    ##                kw_min_max                 kw_max_max                 kw_avg_max  
    ##                    -9.546                     23.413                   -439.902  
    ##                kw_max_avg                 kw_avg_avg  self_reference_min_shares  
    ##                  -468.484                    618.156                    685.362  
    ##        weekday_is_monday1        weekday_is_tuesday1      weekday_is_wednesday1  
    ##                    76.685                    -24.456                   -274.617  
    ##      weekday_is_thursday1         weekday_is_friday1        global_subjectivity  
    ##                   -55.793                   -340.010                    150.017  
    ##  title_sentiment_polarity  
    ##                   -64.114

``` r
fullFit
```

    ## Linear Regression 
    ## 
    ## 1472 samples
    ##   18 predictor
    ## 
    ## Pre-processing: centered (18), scaled (18) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 982, 982, 980 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared     MAE     
    ##   7220.967  0.006325506  3149.086
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
    ##                   3569.51                     764.41                     283.22  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                   -289.89                    -430.97                    -151.74  
    ##                kw_min_max                 kw_max_max                 kw_avg_max  
    ##                    -28.29                      38.35                    -428.57  
    ##                kw_max_avg                 kw_avg_avg  self_reference_min_shares  
    ##                   -508.90                     676.82                     686.85  
    ##       global_subjectivity   title_sentiment_polarity  
    ##                    169.55                     -45.46

``` r
smallFit
```

    ## Linear Regression 
    ## 
    ## 1472 samples
    ##   13 predictor
    ## 
    ## Pre-processing: centered (13), scaled (13) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 981, 982, 981 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   7475.803  0.00603033  3158.489
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
    ## 1472 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (45), scaled (45), ignore (13) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 982, 981, 981 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     7291.273  0.02590462  3117.392
    ##   2     7290.468  0.02645121  3179.197
    ##   3     7300.136  0.02576564  3210.751
    ##   4     7323.827  0.02344154  3232.912
    ##   5     7348.047  0.02149454  3251.074
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
    ##      1 69361995.7458             nan     0.1000 -13358.4837
    ##      2 69161059.0489             nan     0.1000 141657.5551
    ##      3 68224789.3494             nan     0.1000 -6782.7562
    ##      4 67847135.2793             nan     0.1000 -176381.7937
    ##      5 67655307.3890             nan     0.1000 -19223.4648
    ##      6 67063398.1337             nan     0.1000 95656.4884
    ##      7 66923164.8718             nan     0.1000 98906.0776
    ##      8 66504634.5513             nan     0.1000 55412.4394
    ##      9 66053513.1298             nan     0.1000 -410315.8235
    ##     10 65796121.0115             nan     0.1000 -215322.4933
    ##     20 64521063.8576             nan     0.1000 -234432.8171
    ##     40 63486437.5424             nan     0.1000 -541374.6866
    ##     60 62570833.5855             nan     0.1000 -25697.9190
    ##     80 62030743.6397             nan     0.1000 -465086.8905
    ##    100 61509401.7709             nan     0.1000 -236530.0469
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 68253220.9113             nan     0.1000 167281.6268
    ##      2 67156040.0500             nan     0.1000 145809.7513
    ##      3 66517048.5110             nan     0.1000 -37529.5018
    ##      4 66361935.3189             nan     0.1000 -65652.0655
    ##      5 65881048.2661             nan     0.1000 -138823.5685
    ##      6 65497929.3276             nan     0.1000 -245357.1074
    ##      7 64106899.0901             nan     0.1000 -262756.8362
    ##      8 63910890.2697             nan     0.1000 -4433.5829
    ##      9 63720188.5763             nan     0.1000 -231788.2278
    ##     10 62628851.8515             nan     0.1000 -469295.7715
    ##     20 59803865.1928             nan     0.1000 -281814.3043
    ##     40 58882657.6468             nan     0.1000 -221750.3755
    ##     60 55220990.3112             nan     0.1000 -635957.3135
    ##     80 52055408.8795             nan     0.1000 -321533.3267
    ##    100 50049854.6586             nan     0.1000 -565112.5664
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 68256394.3964             nan     0.1000 371635.3302
    ##      2 67268905.9089             nan     0.1000 -170028.6747
    ##      3 66687954.1060             nan     0.1000 197181.4232
    ##      4 66254283.4064             nan     0.1000 -31921.4824
    ##      5 65603756.0924             nan     0.1000 -917288.5735
    ##      6 65281878.2382             nan     0.1000 -130140.6309
    ##      7 65256091.5259             nan     0.1000 -356315.2880
    ##      8 65099128.4147             nan     0.1000 -284534.3134
    ##      9 65092472.4923             nan     0.1000 -333394.1151
    ##     10 64651272.1618             nan     0.1000 -329864.5676
    ##     20 61591469.3260             nan     0.1000 -760391.0325
    ##     40 56807598.4582             nan     0.1000 -455345.7610
    ##     60 54009174.3652             nan     0.1000 -311853.1841
    ##     80 48803768.2236             nan     0.1000 -150942.9228
    ##    100 45382289.0983             nan     0.1000 -216593.2862
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 35483727.5781             nan     0.1000 39986.3616
    ##      2 35316127.0337             nan     0.1000 51225.9353
    ##      3 35069629.7662             nan     0.1000 17429.7768
    ##      4 34935943.4961             nan     0.1000 57433.3213
    ##      5 34795918.5453             nan     0.1000 121852.0521
    ##      6 34555454.7069             nan     0.1000 -29071.9713
    ##      7 34516569.9080             nan     0.1000 -118564.1641
    ##      8 34441646.1028             nan     0.1000 -77571.8581
    ##      9 34412803.8809             nan     0.1000 -64801.5376
    ##     10 34274096.0219             nan     0.1000 -64734.3764
    ##     20 33365672.8808             nan     0.1000 -207497.1832
    ##     40 32264200.1385             nan     0.1000 -103057.3486
    ##     60 31643050.1014             nan     0.1000 -60457.9763
    ##     80 31079196.7068             nan     0.1000 -45898.8652
    ##    100 30592330.8763             nan     0.1000 -24745.3213
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 35395848.9338             nan     0.1000 29682.1280
    ##      2 35049612.5225             nan     0.1000 190696.6058
    ##      3 34730764.7327             nan     0.1000 -73218.7208
    ##      4 34569673.4328             nan     0.1000 -51836.6491
    ##      5 34295313.3707             nan     0.1000 -61125.1877
    ##      6 34034428.1326             nan     0.1000 -140418.7114
    ##      7 33815805.8526             nan     0.1000 21173.8755
    ##      8 33560570.9024             nan     0.1000 -38782.4597
    ##      9 33328337.8553             nan     0.1000 30008.6270
    ##     10 32934470.3129             nan     0.1000 98165.4303
    ##     20 31636577.9314             nan     0.1000 -96176.1459
    ##     40 28965661.6683             nan     0.1000 -70355.1142
    ##     60 26594884.1954             nan     0.1000 -105158.6887
    ##     80 25511161.7373             nan     0.1000 -235863.2828
    ##    100 24153733.9586             nan     0.1000 -68627.9784
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 35103337.7011             nan     0.1000 -59161.1813
    ##      2 34766295.5162             nan     0.1000 -101737.9013
    ##      3 34284665.0586             nan     0.1000 196103.7362
    ##      4 33713008.5338             nan     0.1000 46464.8959
    ##      5 33480462.4413             nan     0.1000 -148795.3717
    ##      6 32984166.6621             nan     0.1000 -101880.5582
    ##      7 32771936.2851             nan     0.1000 -73471.4970
    ##      8 32529991.4338             nan     0.1000 94088.7964
    ##      9 32121996.2243             nan     0.1000 -90062.1072
    ##     10 31755467.8411             nan     0.1000 4962.3506
    ##     20 29371332.3630             nan     0.1000 188526.9223
    ##     40 25948239.2571             nan     0.1000 -104756.0193
    ##     60 22562763.1737             nan     0.1000 -131738.2536
    ##     80 20555584.2798             nan     0.1000 -63940.7065
    ##    100 18806478.0283             nan     0.1000 -143488.0151
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 76653380.3924             nan     0.1000 -47853.5065
    ##      2 75981615.2582             nan     0.1000 -29265.2066
    ##      3 75318947.9752             nan     0.1000 -138024.5451
    ##      4 74802597.3890             nan     0.1000 -67801.9851
    ##      5 74622232.6449             nan     0.1000 -266266.2457
    ##      6 74151680.1574             nan     0.1000 151844.2597
    ##      7 73789993.2695             nan     0.1000 -631092.9877
    ##      8 73366335.2958             nan     0.1000 -48225.2996
    ##      9 73004349.4081             nan     0.1000 -27016.9961
    ##     10 72885755.3256             nan     0.1000 -15975.7703
    ##     20 71384293.2499             nan     0.1000 -372080.2495
    ##     40 70262161.5211             nan     0.1000 -66523.5770
    ##     60 69235065.2738             nan     0.1000 -296238.1397
    ##     80 68680436.9784             nan     0.1000 -136439.9229
    ##    100 68071887.5312             nan     0.1000 -237829.3605
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 76393654.5544             nan     0.1000 6823.1196
    ##      2 75433083.2682             nan     0.1000 570251.1392
    ##      3 74865753.0334             nan     0.1000 -299364.9757
    ##      4 74251668.3159             nan     0.1000 -58445.3290
    ##      5 72480750.8106             nan     0.1000 -402958.6479
    ##      6 72137277.9905             nan     0.1000 134024.5697
    ##      7 71530661.9859             nan     0.1000 -228501.6667
    ##      8 71422561.3354             nan     0.1000 -121049.0777
    ##      9 71095795.4495             nan     0.1000 -634891.9247
    ##     10 70619553.5790             nan     0.1000 -493312.3921
    ##     20 67123839.7079             nan     0.1000 -195966.6879
    ##     40 61950816.0990             nan     0.1000 -197736.1674
    ##     60 58886033.6251             nan     0.1000 -210151.2242
    ##     80 56424346.9331             nan     0.1000 -279867.0573
    ##    100 54485632.9007             nan     0.1000 -138472.5823
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 76510168.3140             nan     0.1000 41449.3545
    ##      2 75226819.1978             nan     0.1000 46900.4256
    ##      3 74759055.3062             nan     0.1000 -21243.1083
    ##      4 73509181.9757             nan     0.1000 -107142.3233
    ##      5 73182027.0900             nan     0.1000 52043.6874
    ##      6 72453586.4452             nan     0.1000 -161453.2035
    ##      7 71842865.0615             nan     0.1000 -470582.8137
    ##      8 70712114.5797             nan     0.1000 -290024.3358
    ##      9 70428748.7725             nan     0.1000 -280914.1757
    ##     10 69977763.7515             nan     0.1000 -252357.4338
    ##     20 65499698.8285             nan     0.1000 95976.1889
    ##     40 59804966.1336             nan     0.1000 -242354.5314
    ##     60 55272111.1387             nan     0.1000 -138207.5577
    ##     80 51545613.1529             nan     0.1000 -152504.4675
    ##    100 46572025.6022             nan     0.1000 -200172.1125
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 60187703.6208             nan     0.1000 29486.3404
    ##      2 59855207.2279             nan     0.1000 -132419.0641
    ##      3 59674863.5781             nan     0.1000 230573.9596
    ##      4 59576828.3446             nan     0.1000 -78521.4143
    ##      5 59360447.7197             nan     0.1000 -174769.2850
    ##      6 59298096.6754             nan     0.1000 -24932.4938
    ##      7 59118537.0763             nan     0.1000 -179967.5011
    ##      8 58862546.4296             nan     0.1000 92637.4341
    ##      9 58722135.1155             nan     0.1000 89198.9089
    ##     10 58638605.5567             nan     0.1000 -98421.6442
    ##     20 57748720.9208             nan     0.1000 -219023.7476
    ##     25 57341009.8763             nan     0.1000 -83803.4724

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
    ##   0.006325506   0.019401910   0.026451206   0.009887932

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ## Random Forest 
    ##    0.02645121

## Automation

We generated these reports automatically for each channel (“lifestyle”,
“entertainment”, “bus”, “socmed”, “tech”, and “world”) by creating a
function that uses the `rmarkdown` package to render a Github document
with a `params` option, and then using a for loop to execute that
function for each channel in a list. That’s how the page you’re reading
was generated!

The code we used to automate the rendering is visible at the main page
for this project [here](https://cdonahu.github.io/st558-project2/).

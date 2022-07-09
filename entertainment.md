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
    ## 1  2941.046         1200    7686.924

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

![](./entertainment_images/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

Then we wanted to look at the outliers–the top articles by shares, so we
grabbed a list of those URLs, along with the number of shares.

``` r
head(training[order(training$shares, decreasing = TRUE), c("url", "shares")], 10)
```

    ## # A tibble: 10 × 2
    ##    url                                                                        shares
    ##    <chr>                                                                       <dbl>
    ##  1 http://mashable.com/2013/12/25/xbox-one-getting-started/                   197600
    ##  2 http://mashable.com/2013/12/26/mcdonalds-kills-mcresource-line/            193400
    ##  3 http://mashable.com/2013/08/28/6000-video-launched-helloflo/               138700
    ##  4 http://mashable.com/2014/02/10/flappy-bird-typing-tutor/                   112600
    ##  5 http://mashable.com/2014/10/14/sandworm-russian-hackers-nato-with-microso… 109500
    ##  6 http://mashable.com/2014/05/28/lookout-theft-protection/                   109100
    ##  7 http://mashable.com/2014/11/23/employee-morale-holidays/                    87600
    ##  8 http://mashable.com/2014/09/05/fall-activity-guide-seattle/                 82200
    ##  9 http://mashable.com/2013/10/30/tesla-west-coast-free/                       77600
    ## 10 http://mashable.com/2014/03/31/google-plus-twitter-engagement/              75600

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

![](./entertainment_images/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](./entertainment_images/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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

![](./entertainment_images/exploratory%20graph-1.png)<!-- -->

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
    ##                   2941.05                    -163.15                     548.39  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                   -180.28                     -13.10                     -33.01  
    ##                kw_max_max                 kw_avg_max                 kw_max_avg  
    ##                    -80.14                    -253.49                     416.77  
    ##                kw_avg_avg  self_reference_min_shares         weekday_is_monday1  
    ##                   1418.83                     441.37                    -210.31  
    ##       weekday_is_tuesday1      weekday_is_wednesday1       weekday_is_thursday1  
    ##                   -280.13                    -135.36                    -127.44  
    ##        weekday_is_friday1        global_subjectivity   title_sentiment_polarity  
    ##                   -168.98                     259.18                    -143.50

``` r
fullFit
```

    ## Linear Regression 
    ## 
    ## 4941 samples
    ##   18 predictor
    ## 
    ## Pre-processing: centered (17), scaled (17), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 3293, 3294, 3295 
    ## Resampling results:
    ## 
    ##   RMSE     Rsquared    MAE     
    ##   7554.64  0.02577748  2867.415
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
    ##                  2941.046                   -149.345                    544.520  
    ##            num_self_hrefs       average_token_length               num_keywords  
    ##                  -185.028                     -6.769                    -13.864  
    ##                kw_max_max                 kw_avg_max                 kw_max_avg  
    ##                   -89.308                   -247.650                    406.873  
    ##                kw_avg_avg  self_reference_min_shares        global_subjectivity  
    ##                  1428.439                    441.518                    255.390  
    ##  title_sentiment_polarity  
    ##                  -147.249

``` r
smallFit
```

    ## Linear Regression 
    ## 
    ## 4941 samples
    ##   13 predictor
    ## 
    ## Pre-processing: centered (12), scaled (12), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 3295, 3293, 3294 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE    
    ##   7560.743  0.03682377  2858.36
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
    ## 4941 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (44), scaled (44), ignore (13), remove (1) 
    ## Resampling: Cross-Validated (3 fold) 
    ## Summary of sample sizes: 3293, 3295, 3294 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     7547.849  0.02682175  2852.231
    ##   2     7518.521  0.02775193  2887.736
    ##   3     7522.449  0.02972774  2924.141
    ##   4     7524.969  0.03083407  2957.297
    ##   5     7536.939  0.03006397  2961.959
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
    ##      1 62267141.9845             nan     0.1000 181076.2913
    ##      2 61929648.7625             nan     0.1000 63067.6450
    ##      3 61464542.7764             nan     0.1000 -13421.3948
    ##      4 61206303.0896             nan     0.1000 -86766.2430
    ##      5 60906098.3668             nan     0.1000 -67241.2623
    ##      6 60626874.0028             nan     0.1000 -166955.0141
    ##      7 60457931.4144             nan     0.1000 65793.7154
    ##      8 60154518.0214             nan     0.1000 213147.2346
    ##      9 59967822.5544             nan     0.1000 101458.9391
    ##     10 59738795.1367             nan     0.1000 -70365.2593
    ##     20 58220972.5142             nan     0.1000 -440840.3318
    ##     40 57074690.3222             nan     0.1000 15945.2020
    ##     60 56437489.0829             nan     0.1000 -57684.1172
    ##     80 55887497.5377             nan     0.1000 -276895.0276
    ##    100 55507860.0350             nan     0.1000 -1845.6100
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 61909645.5535             nan     0.1000 386047.7717
    ##      2 61475813.0207             nan     0.1000 142641.4171
    ##      3 60918248.5766             nan     0.1000 8133.8850
    ##      4 60553120.1772             nan     0.1000 68278.2471
    ##      5 60329435.5857             nan     0.1000 126515.6915
    ##      6 59933114.6158             nan     0.1000 357773.5168
    ##      7 59555774.9073             nan     0.1000 -80412.9417
    ##      8 59046182.5985             nan     0.1000 -2939.7438
    ##      9 58648316.3920             nan     0.1000 114241.1984
    ##     10 58447437.6980             nan     0.1000 57086.2591
    ##     20 55387788.8433             nan     0.1000 -201546.8549
    ##     40 52543063.6225             nan     0.1000 -206364.2169
    ##     60 50732591.0734             nan     0.1000 -313997.8699
    ##     80 49043827.8443             nan     0.1000 -43396.5769
    ##    100 47061221.4848             nan     0.1000 -123269.3730
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 61941837.1402             nan     0.1000 256248.6577
    ##      2 61644879.9267             nan     0.1000 -50415.5421
    ##      3 61315733.1936             nan     0.1000 308222.7726
    ##      4 60787793.9359             nan     0.1000 93151.3412
    ##      5 60556047.6069             nan     0.1000 76489.7796
    ##      6 59719264.5920             nan     0.1000 -12009.0604
    ##      7 59213324.1119             nan     0.1000 179425.2612
    ##      8 58771589.6010             nan     0.1000 -11978.1630
    ##      9 58449268.6986             nan     0.1000 194741.6647
    ##     10 58056520.6551             nan     0.1000 -190910.5552
    ##     20 54717701.1415             nan     0.1000 -202397.3869
    ##     40 51324254.4144             nan     0.1000 21193.3331
    ##     60 48228572.7868             nan     0.1000 -87338.4243
    ##     80 45743481.1842             nan     0.1000 -250865.5600
    ##    100 43764460.8559             nan     0.1000 -206719.1973
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 46936421.2704             nan     0.1000 81756.8709
    ##      2 46735038.2515             nan     0.1000 -58838.9460
    ##      3 46429550.4636             nan     0.1000 4620.3727
    ##      4 46380650.6904             nan     0.1000 -23058.2452
    ##      5 46158681.5147             nan     0.1000 200031.3210
    ##      6 46039699.5064             nan     0.1000 151495.3930
    ##      7 45844088.1371             nan     0.1000 -55255.0016
    ##      8 45781248.2072             nan     0.1000 2868.6288
    ##      9 45568582.1665             nan     0.1000 -99718.2438
    ##     10 45465863.6058             nan     0.1000 14923.1118
    ##     20 44518764.6111             nan     0.1000 -6578.5434
    ##     40 43640228.0685             nan     0.1000 -93369.0363
    ##     60 43208313.0627             nan     0.1000 26598.6448
    ##     80 43002906.6683             nan     0.1000 -19294.5517
    ##    100 42650459.6204             nan     0.1000 -83638.0422
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 47085809.5250             nan     0.1000 -35181.5045
    ##      2 46618904.7445             nan     0.1000 93025.6907
    ##      3 46196077.4272             nan     0.1000 19785.1237
    ##      4 45999032.2901             nan     0.1000 13797.4709
    ##      5 45825479.0833             nan     0.1000 51289.5685
    ##      6 45408430.3076             nan     0.1000 74852.9391
    ##      7 45197081.7751             nan     0.1000 135152.0388
    ##      8 44935553.5521             nan     0.1000 -25092.4994
    ##      9 44769274.6177             nan     0.1000 17789.3182
    ##     10 44643071.8815             nan     0.1000 73973.1118
    ##     20 43204659.3762             nan     0.1000 -99251.5966
    ##     40 41407774.1857             nan     0.1000 -232158.8183
    ##     60 40092318.2978             nan     0.1000 143144.4377
    ##     80 39106955.0176             nan     0.1000 -122848.1948
    ##    100 37914766.6652             nan     0.1000 -111840.6758
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 46719092.2235             nan     0.1000 215377.6368
    ##      2 46178189.3891             nan     0.1000 29960.5881
    ##      3 45978407.1154             nan     0.1000 -73552.2357
    ##      4 45530933.5919             nan     0.1000 144053.8689
    ##      5 45179991.6470             nan     0.1000 -57912.2005
    ##      6 44861408.4897             nan     0.1000 -32193.6109
    ##      7 44662725.3566             nan     0.1000 -73711.6194
    ##      8 44408438.8786             nan     0.1000 -241211.9786
    ##      9 44096966.8761             nan     0.1000 -47334.6314
    ##     10 43899692.5240             nan     0.1000 -32449.4621
    ##     20 42184032.9276             nan     0.1000 -156196.6083
    ##     40 39948166.0704             nan     0.1000 -102583.6561
    ##     60 38405220.8077             nan     0.1000 -147617.1293
    ##     80 36924783.4230             nan     0.1000 -44038.3896
    ##    100 35669611.9090             nan     0.1000 -53037.5834
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 66878754.5779             nan     0.1000 37798.7748
    ##      2 66206473.3161             nan     0.1000 -73626.7665
    ##      3 66093669.6661             nan     0.1000 8081.9655
    ##      4 65908128.6822             nan     0.1000 61136.0205
    ##      5 65637083.4487             nan     0.1000 -10027.8362
    ##      6 65218886.0110             nan     0.1000 -59191.5579
    ##      7 65100751.5997             nan     0.1000 -120439.5044
    ##      8 64897986.0535             nan     0.1000 4682.6318
    ##      9 64650855.8353             nan     0.1000 -54883.6684
    ##     10 64430132.9780             nan     0.1000 -78449.8722
    ##     20 63412046.9996             nan     0.1000 -85464.6161
    ##     40 62035562.4435             nan     0.1000 -323293.4399
    ##     60 61766286.5663             nan     0.1000 -167289.7061
    ##     80 61329690.3391             nan     0.1000 -170681.0080
    ##    100 60388242.5144             nan     0.1000 -10520.6850
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 66816328.1119             nan     0.1000 -57039.9190
    ##      2 65335707.6031             nan     0.1000 91466.9385
    ##      3 64934698.2824             nan     0.1000 95861.9456
    ##      4 64643721.6577             nan     0.1000 97559.6348
    ##      5 64306459.3759             nan     0.1000 43184.0212
    ##      6 63588157.5208             nan     0.1000 -113514.3236
    ##      7 63145687.9281             nan     0.1000 -180891.4969
    ##      8 62928228.8962             nan     0.1000 -188937.4398
    ##      9 62628266.8549             nan     0.1000 -779960.5167
    ##     10 61912952.4831             nan     0.1000 -330047.9533
    ##     20 60219134.0997             nan     0.1000 -147584.3384
    ##     40 57367632.0450             nan     0.1000 -35781.3430
    ##     60 55416449.3064             nan     0.1000 -386733.3454
    ##     80 53747046.4702             nan     0.1000 -335052.3581
    ##    100 51749251.8855             nan     0.1000 -120219.5685
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 66727258.1453             nan     0.1000 478094.0044
    ##      2 66528013.5180             nan     0.1000 104605.0080
    ##      3 65888367.4092             nan     0.1000 139698.5163
    ##      4 65349850.4810             nan     0.1000 303294.5476
    ##      5 65062800.9789             nan     0.1000 4184.5186
    ##      6 63969011.6350             nan     0.1000 -315758.0928
    ##      7 63692629.6821             nan     0.1000 -132725.7956
    ##      8 63049539.3612             nan     0.1000 -392603.8397
    ##      9 62355439.4715             nan     0.1000 -112576.9134
    ##     10 62187145.3078             nan     0.1000 -289520.8572
    ##     20 59316516.0681             nan     0.1000 -294380.0223
    ##     40 56152061.1996             nan     0.1000 -136335.0921
    ##     60 53537586.1528             nan     0.1000 -254969.0637
    ##     80 51626068.5960             nan     0.1000 -156834.1938
    ##    100 48827073.4906             nan     0.1000 -161211.7262
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 58864983.8663             nan     0.1000 -39582.7325
    ##      2 58451064.9890             nan     0.1000 -116465.5248
    ##      3 58280469.2730             nan     0.1000 187941.2288
    ##      4 58123986.9597             nan     0.1000 21897.6088
    ##      5 57943343.0067             nan     0.1000 89734.8130
    ##      6 57841015.9415             nan     0.1000 -93057.6727
    ##      7 57643267.1735             nan     0.1000 -89741.7341
    ##      8 57465176.5637             nan     0.1000 22088.6188
    ##      9 57219673.5477             nan     0.1000 -81656.3139
    ##     10 57076087.4362             nan     0.1000 -83764.2535
    ##     20 55986126.1983             nan     0.1000 -95750.7867
    ##     25 55664064.9758             nan     0.1000 -38898.3342

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
    ##    0.02577748    0.01940191    0.03083407    0.01695797

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ## Random Forest 
    ##    0.03083407

## Automation

We generated these reports automatically for each channel (“lifestyle”,
“entertainment”, “bus”, “socmed”, “tech”, and “world”) by creating a
function that uses the `rmarkdown` package to render a Github document
with a `params` option, and then using a for loop to execute that
function for each channel in a list. That’s how the page you’re reading
was generated!

The code we used to automate the rendering is visible at the main page
for this project [here](https://cdonahu.github.io/st558-project2/).

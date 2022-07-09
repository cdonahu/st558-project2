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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/tech_files/figure-gfm/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/tech_files/figure-gfm/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/tech_files/figure-gfm/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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
    ## plot: [3,1] [=============================>------------------------] 56% est: 1s
    ## plot: [3,2] [=================================>--------------------] 62% est: 1s
    ## plot: [3,3] [====================================>-----------------] 69% est: 0s
    ## plot: [3,4] [=======================================>--------------] 75% est: 0s
    ## plot: [4,1] [===========================================>----------] 81% est: 0s
    ## plot: [4,2] [==============================================>-------] 88% est: 0s
    ## plot: [4,3] [==================================================>---] 94% est: 0s
    ## plot: [4,4] [======================================================]100% est: 0s

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/tech_files/figure-gfm/exploratory%20graph-1.png)<!-- -->

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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 4115, 4117, 4116, 4117, 4115 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   7885.981  0.01810575  2390.089
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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 4115, 4115, 4118, 4115, 4117 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   7873.931  0.02059965  2386.029
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
    ## 5145 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (44), scaled (44), ignore (13), remove (1) 
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 4118, 4116, 4116, 4115, 4115 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     7717.447  0.02711795  2354.453
    ##   2     7707.716  0.04242549  2369.454
    ##   3     7732.635  0.03804612  2399.915
    ##   4     7826.149  0.02945940  2441.158
    ##   5     7908.622  0.02614072  2454.310
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was mtry = 2.

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
    ##      1 123191499.4666             nan     0.1000 36336.8551
    ##      2 121331674.4779             nan     0.1000 -137272.1985
    ##      3 121261347.0594             nan     0.1000 75883.8010
    ##      4 121229569.9740             nan     0.1000 15749.7633
    ##      5 121191332.9421             nan     0.1000 4019.8069
    ##      6 121183925.1372             nan     0.1000 -21063.3740
    ##      7 121160445.9157             nan     0.1000  976.4383
    ##      8 119638295.5481             nan     0.1000 -361169.8140
    ##      9 119566894.3271             nan     0.1000 77075.2873
    ##     10 118492937.6719             nan     0.1000 -994320.6884
    ##     20 114309025.0705             nan     0.1000 -546786.0777
    ##     40 112311600.2318             nan     0.1000 -1466023.1687
    ##     60 109177010.8087             nan     0.1000 -916019.4859
    ##     80 106927110.8914             nan     0.1000 -740296.4972
    ##    100 104704029.9738             nan     0.1000 -994399.8654
    ##    120 103107148.6159             nan     0.1000 -1147963.5990
    ##    140 102635772.9761             nan     0.1000 -733968.6687
    ##    150 102016482.9068             nan     0.1000 -644377.6678
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 123103199.7621             nan     0.1000 98250.5580
    ##      2 121172403.3126             nan     0.1000 -231938.2837
    ##      3 119759660.7835             nan     0.1000 -345827.2854
    ##      4 118711646.1389             nan     0.1000 -499619.0856
    ##      5 117960561.8849             nan     0.1000 -940196.2747
    ##      6 118182692.8622             nan     0.1000 -939950.1722
    ##      7 118293977.9942             nan     0.1000 -412955.3522
    ##      8 117958869.9680             nan     0.1000 299467.2886
    ##      9 117256054.3741             nan     0.1000 -1051368.2407
    ##     10 117494804.0562             nan     0.1000 -972757.7727
    ##     20 111186745.9240             nan     0.1000 -740306.6199
    ##     40 102410941.3262             nan     0.1000 -1291635.0815
    ##     60 96319030.4118             nan     0.1000 -635033.6184
    ##     80 94680530.5431             nan     0.1000 -665762.1162
    ##    100 93615513.7112             nan     0.1000 -458771.0008
    ##    120 90512319.2774             nan     0.1000 -1257184.8898
    ##    140 87091885.8030             nan     0.1000 -1314061.2602
    ##    150 86764414.1374             nan     0.1000 -589875.2609
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 121361133.2823             nan     0.1000 101082.4189
    ##      2 120017875.7935             nan     0.1000 -175249.4349
    ##      3 119855973.1865             nan     0.1000 124088.5897
    ##      4 118636727.5034             nan     0.1000 -852871.2504
    ##      5 118725721.4548             nan     0.1000 -503139.4511
    ##      6 117842713.2393             nan     0.1000 -838614.8979
    ##      7 117449830.0450             nan     0.1000 381827.9571
    ##      8 117572953.4839             nan     0.1000 -478205.3101
    ##      9 117746344.8574             nan     0.1000 -596870.0717
    ##     10 116963582.1069             nan     0.1000 -598341.4305
    ##     20 116641283.4504             nan     0.1000 -877228.3441
    ##     40 111063452.0081             nan     0.1000 -1269708.0117
    ##     60 99279123.0858             nan     0.1000 615156.1420
    ##     80 90761786.3204             nan     0.1000 -1051811.3829
    ##    100 83813781.0289             nan     0.1000 -413464.9375
    ##    120 80749410.1870             nan     0.1000 -656074.9890
    ##    140 74394300.1329             nan     0.1000 -475028.2886
    ##    150 73703783.9219             nan     0.1000 -465834.6163
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 18608138.1686             nan     0.1000 9346.7615
    ##      2 18543472.3802             nan     0.1000 49409.4119
    ##      3 18498191.6345             nan     0.1000 -3148.9178
    ##      4 18456224.7186             nan     0.1000 23940.6878
    ##      5 18411478.2823             nan     0.1000 43554.7415
    ##      6 18365899.5602             nan     0.1000 27921.9051
    ##      7 18332751.3290             nan     0.1000 23158.8856
    ##      8 18301367.0116             nan     0.1000 -12884.0884
    ##      9 18274155.5286             nan     0.1000 14609.9081
    ##     10 18244222.8995             nan     0.1000 -10631.0941
    ##     20 18019404.4449             nan     0.1000 9205.5471
    ##     40 17757702.1248             nan     0.1000 -37418.4229
    ##     60 17566453.3331             nan     0.1000 -34663.2277
    ##     80 17428621.5864             nan     0.1000 -22773.5569
    ##    100 17366600.9088             nan     0.1000 -2872.8895
    ##    120 17299496.1760             nan     0.1000 -9704.0928
    ##    140 17264442.9485             nan     0.1000 -23243.2092
    ##    150 17227015.0205             nan     0.1000 -10473.6699
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 18563805.3804             nan     0.1000 56787.5914
    ##      2 18500211.1070             nan     0.1000 48274.6791
    ##      3 18407180.9889             nan     0.1000 33170.8151
    ##      4 18349077.7675             nan     0.1000 1773.6013
    ##      5 18280962.9078             nan     0.1000 6810.4661
    ##      6 18219393.4729             nan     0.1000 16638.0516
    ##      7 18126428.8201             nan     0.1000 -5823.1496
    ##      8 18062929.9706             nan     0.1000 18927.1087
    ##      9 18021982.9241             nan     0.1000 -8245.8881
    ##     10 17963221.8920             nan     0.1000 -18704.3575
    ##     20 17608413.3617             nan     0.1000 -37619.2659
    ##     40 16954781.1792             nan     0.1000 -38741.9146
    ##     60 16557531.7652             nan     0.1000 -15989.9898
    ##     80 16293625.2141             nan     0.1000 -53517.0278
    ##    100 15955256.4447             nan     0.1000 -20281.3174
    ##    120 15719467.7527             nan     0.1000 -6356.4911
    ##    140 15581871.7291             nan     0.1000 -5054.5124
    ##    150 15538842.7533             nan     0.1000 -26048.0025
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 18539265.7602             nan     0.1000 33005.0264
    ##      2 18442778.2128             nan     0.1000 11791.9252
    ##      3 18370612.0765             nan     0.1000 71062.7365
    ##      4 18291087.4535             nan     0.1000 8164.3438
    ##      5 18183846.7871             nan     0.1000 -25154.3731
    ##      6 18106310.0913             nan     0.1000 24246.7441
    ##      7 18051356.3541             nan     0.1000 19908.8419
    ##      8 17994987.4377             nan     0.1000 -718.3208
    ##      9 17897776.1878             nan     0.1000  500.3048
    ##     10 17795812.3724             nan     0.1000 21908.9275
    ##     20 17175172.0192             nan     0.1000 3335.7634
    ##     40 16309403.9586             nan     0.1000 -50112.4066
    ##     60 15733006.1610             nan     0.1000 -35041.4851
    ##     80 15303191.6824             nan     0.1000 -8437.9333
    ##    100 15030695.5606             nan     0.1000 -15198.1167
    ##    120 14557742.7757             nan     0.1000 -19078.6780
    ##    140 14022086.5750             nan     0.1000 -16497.2237
    ##    150 13866008.4879             nan     0.1000 -30057.2540
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 125622569.5571             nan     0.1000 -68831.3978
    ##      2 125495249.6159             nan     0.1000 109225.2861
    ##      3 125405390.3423             nan     0.1000 80627.2996
    ##      4 123945812.7835             nan     0.1000 -508476.9571
    ##      5 123862906.1446             nan     0.1000 37757.7627
    ##      6 122963781.3745             nan     0.1000 -237458.3927
    ##      7 122879778.9365             nan     0.1000 -17347.7654
    ##      8 123185993.9161             nan     0.1000 -850497.5697
    ##      9 122293401.9844             nan     0.1000 -957445.8069
    ##     10 122589327.2463             nan     0.1000 -912157.2442
    ##     20 120661446.4701             nan     0.1000 -998381.3284
    ##     40 117306177.4104             nan     0.1000 349422.9795
    ##     60 115107120.2262             nan     0.1000 -1505995.9748
    ##     80 111810534.0028             nan     0.1000 -1778564.2727
    ##    100 110649299.9175             nan     0.1000 -664278.2179
    ##    120 108603155.5919             nan     0.1000 -1279528.9204
    ##    140 108248276.1610             nan     0.1000 -428633.9194
    ##    150 106824694.8099             nan     0.1000 -524819.0369
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 125459800.4160             nan     0.1000 -6926.8523
    ##      2 125243100.8084             nan     0.1000 166454.7944
    ##      3 125072964.5852             nan     0.1000 133503.1924
    ##      4 124996935.7770             nan     0.1000 6050.9489
    ##      5 123656069.9899             nan     0.1000 -151248.1477
    ##      6 122522400.3916             nan     0.1000 -705079.9695
    ##      7 122708829.8592             nan     0.1000 -810252.5842
    ##      8 121772244.1477             nan     0.1000 -659950.3690
    ##      9 121182128.5630             nan     0.1000 -1164621.7815
    ##     10 120681173.0330             nan     0.1000 300467.1437
    ##     20 114011017.0269             nan     0.1000 -1345873.1316
    ##     40 110161450.6885             nan     0.1000 -689207.0001
    ##     60 104835820.6625             nan     0.1000 553487.1268
    ##     80 101624853.4555             nan     0.1000 -941548.7575
    ##    100 100077460.7499             nan     0.1000 -1150225.4428
    ##    120 95967174.9292             nan     0.1000 -1056809.5630
    ##    140 89298207.1151             nan     0.1000 -1049995.0268
    ##    150 87459843.7012             nan     0.1000 -823594.5889
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 127419193.1739             nan     0.1000 117478.4754
    ##      2 127235835.7000             nan     0.1000 -532.8476
    ##      3 127054362.2362             nan     0.1000 85619.2923
    ##      4 124984288.4165             nan     0.1000 -70620.1823
    ##      5 123413419.4066             nan     0.1000 -652323.7554
    ##      6 122241440.4459             nan     0.1000 -524776.8494
    ##      7 122436714.7302             nan     0.1000 -698202.6960
    ##      8 122612224.5808             nan     0.1000 -749170.5578
    ##      9 121633985.6231             nan     0.1000 -503707.1601
    ##     10 120909959.8757             nan     0.1000 -788364.2649
    ##     20 117556570.1685             nan     0.1000 -981113.7788
    ##     40 114007874.2317             nan     0.1000 -1113895.5301
    ##     60 107872064.7071             nan     0.1000 -1131075.7494
    ##     80 103564350.5251             nan     0.1000 314236.5173
    ##    100 99566582.1750             nan     0.1000 -1107365.4735
    ##    120 96554770.2898             nan     0.1000 -2133906.4646
    ##    140 91638893.8901             nan     0.1000 -401209.7522
    ##    150 90469198.7266             nan     0.1000 -547737.7881
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 125996858.0829             nan     0.1000 -165883.0781
    ##      2 125897998.2854             nan     0.1000 119742.8166
    ##      3 125798240.7024             nan     0.1000 93460.3390
    ##      4 125691749.7631             nan     0.1000 -13955.5355
    ##      5 124426427.9154             nan     0.1000 -472050.3746
    ##      6 124302534.5303             nan     0.1000 98232.7183
    ##      7 123300947.7979             nan     0.1000 -287903.0509
    ##      8 123186375.0658             nan     0.1000 92599.0367
    ##      9 123126577.7781             nan     0.1000 20693.9611
    ##     10 123088454.8567             nan     0.1000 -70351.9094
    ##     20 118680277.3255             nan     0.1000 454148.5603
    ##     40 115152757.9831             nan     0.1000 -467315.4299
    ##     60 112087300.7540             nan     0.1000 -912857.2952
    ##     80 107993533.9563             nan     0.1000 331532.6082
    ##    100 104838711.6527             nan     0.1000 483063.3187
    ##    120 102755789.3431             nan     0.1000 -922144.5069
    ##    140 99855461.4806             nan     0.1000 -1705456.3767
    ##    150 98147809.8499             nan     0.1000 -855249.9656
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 127782637.6572             nan     0.1000 120566.5643
    ##      2 126167540.8986             nan     0.1000 -40601.3964
    ##      3 124849494.3422             nan     0.1000 -309512.8842
    ##      4 123322315.1304             nan     0.1000 -596865.6142
    ##      5 123137496.0308             nan     0.1000 159436.4247
    ##      6 122180084.9640             nan     0.1000 -519646.3702
    ##      7 121504512.1843             nan     0.1000 -760482.5456
    ##      8 121117526.7275             nan     0.1000 190196.5804
    ##      9 120635477.4505             nan     0.1000 -503239.6628
    ##     10 120254878.2263             nan     0.1000 -1188570.5446
    ##     20 116339661.2083             nan     0.1000 112532.2975
    ##     40 111725951.8584             nan     0.1000 98814.4532
    ##     60 100747994.0330             nan     0.1000 -240131.6461
    ##     80 99300081.8415             nan     0.1000 -843208.8376
    ##    100 94941194.8006             nan     0.1000 -466799.6914
    ##    120 90760269.2677             nan     0.1000 -828092.7348
    ##    140 84165976.6198             nan     0.1000 -664549.6947
    ##    150 83330858.2795             nan     0.1000 -1104247.7770
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 127821053.3742             nan     0.1000 50974.5295
    ##      2 125945753.4585             nan     0.1000 -40745.2303
    ##      3 125780530.9182             nan     0.1000 53758.6944
    ##      4 125512528.6242             nan     0.1000 237709.3105
    ##      5 124134589.6884             nan     0.1000 -371798.3980
    ##      6 123911254.1976             nan     0.1000 107547.3033
    ##      7 122849980.4455             nan     0.1000 -728152.6261
    ##      8 122555765.3741             nan     0.1000 148193.3473
    ##      9 122745765.5844             nan     0.1000 -724722.2469
    ##     10 122923516.7294             nan     0.1000 -578383.5321
    ##     20 119170595.4098             nan     0.1000 -682639.4786
    ##     40 114220470.9720             nan     0.1000 -855164.4610
    ##     60 111250775.7339             nan     0.1000 -540276.8335
    ##     80 106035728.7506             nan     0.1000 -106769.1310
    ##    100 98703892.4533             nan     0.1000 -453012.4139
    ##    120 89302572.4924             nan     0.1000 -190095.7882
    ##    140 81045721.2802             nan     0.1000 -788115.7233
    ##    150 80432832.7777             nan     0.1000 -797147.3049
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 125498925.4649             nan     0.1000 -102081.6694
    ##      2 124270020.5938             nan     0.1000 -316114.5040
    ##      3 124485644.7564             nan     0.1000 -530543.9183
    ##      4 123349388.0802             nan     0.1000 -830719.9211
    ##      5 122622638.0969             nan     0.1000 -578887.9307
    ##      6 122161308.4370             nan     0.1000 -1669487.7510
    ##      7 122347825.9459             nan     0.1000 -891568.4663
    ##      8 122588965.2849             nan     0.1000 -983624.9856
    ##      9 122822242.5788             nan     0.1000 -852728.6567
    ##     10 122746342.4529             nan     0.1000 -33586.4871
    ##     20 120754613.9079             nan     0.1000 -886173.4505
    ##     40 119417403.0968             nan     0.1000 428388.5344
    ##     60 116874392.7133             nan     0.1000 -1035449.0100
    ##     80 113395710.1850             nan     0.1000 -449239.7475
    ##    100 111633875.2742             nan     0.1000 -1174316.1129
    ##    120 108141627.6864             nan     0.1000 -844166.1805
    ##    140 106598365.2415             nan     0.1000 -1197468.8325
    ##    150 105194339.0148             nan     0.1000 -612992.5491
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 125219136.5194             nan     0.1000 -345971.0413
    ##      2 123757593.7430             nan     0.1000 -521685.2328
    ##      3 123894720.8531             nan     0.1000 -571535.0426
    ##      4 123996504.1070             nan     0.1000 -493285.0685
    ##      5 123124023.3114             nan     0.1000 -392349.1059
    ##      6 122359220.2533             nan     0.1000 -1409598.6762
    ##      7 122499137.9888             nan     0.1000 -711281.7154
    ##      8 122056462.7558             nan     0.1000 -1449523.0544
    ##      9 122131830.2237             nan     0.1000 -812084.5699
    ##     10 122245218.3880             nan     0.1000 -542506.5718
    ##     20 119812161.9060             nan     0.1000 -673811.5574
    ##     40 113382104.7227             nan     0.1000 -989191.2858
    ##     60 104468679.0765             nan     0.1000 -1097466.8814
    ##     80 98094444.6454             nan     0.1000 -699166.8731
    ##    100 93106689.4791             nan     0.1000 -1360663.1026
    ##    120 88265032.2327             nan     0.1000 -254669.6334
    ##    140 84568464.8966             nan     0.1000 128511.0828
    ##    150 82770988.9479             nan     0.1000 -830204.1797
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 126830824.4101             nan     0.1000 293447.8535
    ##      2 125204390.9891             nan     0.1000 71594.4616
    ##      3 125096299.7455             nan     0.1000 34956.4347
    ##      4 124355143.0944             nan     0.1000 1160269.5895
    ##      5 124143637.4875             nan     0.1000 64087.0186
    ##      6 122745848.5556             nan     0.1000 -393754.0226
    ##      7 121889485.0146             nan     0.1000 -319209.3058
    ##      8 121600657.1486             nan     0.1000 95811.9009
    ##      9 121773267.5753             nan     0.1000 -618110.0626
    ##     10 120816541.7146             nan     0.1000 -477830.8749
    ##     20 118062941.8603             nan     0.1000 -703149.6832
    ##     40 106528072.5416             nan     0.1000 211176.2320
    ##     60 103469715.5460             nan     0.1000 -557760.7789
    ##     80 97820840.9107             nan     0.1000 -544324.8519
    ##    100 95267236.7322             nan     0.1000 -682913.6730
    ##    120 90968859.2761             nan     0.1000 -28258.4456
    ##    140 85122350.6199             nan     0.1000 -775669.0277
    ##    150 82287265.2964             nan     0.1000 -517111.1044
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 104868992.7065             nan     0.1000 47053.9840
    ##      2 104798135.8497             nan     0.1000 21501.9161
    ##      3 104738471.0101             nan     0.1000 31637.3653
    ##      4 104676912.6216             nan     0.1000 75301.1685
    ##      5 104585047.3546             nan     0.1000 -12073.1926
    ##      6 103351998.6185             nan     0.1000 -64979.3894
    ##      7 103314760.9139             nan     0.1000 18842.1233
    ##      8 102146209.2275             nan     0.1000 -390344.6194
    ##      9 102066920.4936             nan     0.1000 79350.7122
    ##     10 101993699.0671             nan     0.1000 60283.1526
    ##     20 100642864.9552             nan     0.1000 123529.0390
    ##     25 99154341.8575             nan     0.1000 113974.5363

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
    ##    0.01810575    0.01940191    0.04242549    0.01630092

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ## Random Forest 
    ##    0.04242549

## Automation

We generated these reports automatically for each channel (“lifestyle”,
“entertainment”, “bus”, “socmed”, “tech”, and “world”) by creating a
function that uses the `rmarkdown` package to render a Github document,
and then using a for loop to execute that function for each channel in a
list. That’s how the page you’re reading was generated!

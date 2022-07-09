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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/entertainment_files/figure-gfm/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/entertainment_files/figure-gfm/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/entertainment_files/figure-gfm/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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
    ## plot: [1,4] [=============>----------------------------------------] 25% est: 1s
    ## plot: [2,1] [================>-------------------------------------] 31% est: 0s
    ## plot: [2,2] [===================>----------------------------------] 38% est: 0s
    ## plot: [2,3] [=======================>------------------------------] 44% est: 0s
    ## plot: [2,4] [==========================>---------------------------] 50% est: 0s
    ## plot: [3,1] [=============================>------------------------] 56% est: 0s
    ## plot: [3,2] [=================================>--------------------] 62% est: 0s
    ## plot: [3,3] [====================================>-----------------] 69% est: 0s
    ## plot: [3,4] [=======================================>--------------] 75% est: 0s
    ## plot: [4,1] [===========================================>----------] 81% est: 0s
    ## plot: [4,2] [==============================================>-------] 88% est: 0s
    ## plot: [4,3] [==================================================>---] 94% est: 0s
    ## plot: [4,4] [======================================================]100% est: 0s

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/entertainment_files/figure-gfm/exploratory%20graph-1.png)<!-- -->

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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 3953, 3954, 3953, 3952, 3952 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   7381.355  0.03899418  2861.193
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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 3953, 3954, 3952, 3953, 3952 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   7566.656  0.03895979  2861.161
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
    ## 4941 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (44), scaled (44), ignore (13), remove (1) 
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 3953, 3952, 3953, 3953, 3953 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     7576.514  0.02278116  2850.338
    ##   2     7536.044  0.02855535  2883.840
    ##   3     7554.395  0.02675890  2924.822
    ##   4     7572.287  0.02527999  2953.560
    ##   5     7582.129  0.02579383  2980.169
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was mtry = 2.

### Boosted Tree

``` r
# Load required packages
library(gbm)
library(plyr)

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
    ##      1 57228307.2088             nan     0.1000 -18168.4611
    ##      2 56584378.8938             nan     0.1000 111397.4140
    ##      3 56186687.3808             nan     0.1000 302759.6873
    ##      4 55786213.8906             nan     0.1000 -84053.0807
    ##      5 55530521.0359             nan     0.1000 42210.3926
    ##      6 55420603.2734             nan     0.1000 130845.0596
    ##      7 55276793.6077             nan     0.1000 -38853.4746
    ##      8 54940673.4262             nan     0.1000 -258951.3756
    ##      9 54765391.8613             nan     0.1000 -191326.8078
    ##     10 54635090.9279             nan     0.1000 -369825.5022
    ##     20 53947813.9161             nan     0.1000 -235268.9850
    ##     40 52869910.5295             nan     0.1000 -174100.1000
    ##     60 52188254.7012             nan     0.1000 -118769.7511
    ##     80 51506856.9209             nan     0.1000 -81245.1005
    ##    100 51025145.9436             nan     0.1000 -144811.4787
    ##    120 50457338.6951             nan     0.1000 -97259.6186
    ##    140 50064654.4995             nan     0.1000 -157167.5449
    ##    150 49755559.8616             nan     0.1000 -278875.2061
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 56613741.0667             nan     0.1000 142937.5077
    ##      2 56334147.1703             nan     0.1000 98131.5815
    ##      3 55588568.5550             nan     0.1000 -222803.5136
    ##      4 55327909.8914             nan     0.1000 53274.1594
    ##      5 54919622.6994             nan     0.1000 -96701.5374
    ##      6 54849000.1787             nan     0.1000 -44521.2326
    ##      7 54601018.6288             nan     0.1000 13191.6008
    ##      8 54315374.0320             nan     0.1000 -141023.1686
    ##      9 54235527.7778             nan     0.1000 -123982.4657
    ##     10 54085471.6698             nan     0.1000 -163613.4754
    ##     20 52205883.8902             nan     0.1000 18388.7000
    ##     40 49814593.8641             nan     0.1000 -88689.4021
    ##     60 48403251.0264             nan     0.1000 -115871.4694
    ##     80 47149701.7359             nan     0.1000 -26256.4525
    ##    100 45974736.8594             nan     0.1000 -101481.1308
    ##    120 45440871.9749             nan     0.1000 -145907.7846
    ##    140 44494657.1627             nan     0.1000 -149487.9524
    ##    150 43773888.5908             nan     0.1000 -87440.0054
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 57236773.8307             nan     0.1000 41053.2073
    ##      2 56256045.8314             nan     0.1000 -42483.8598
    ##      3 55866679.2371             nan     0.1000 190276.4608
    ##      4 55293873.2832             nan     0.1000 51129.1456
    ##      5 54578884.2558             nan     0.1000 61775.6794
    ##      6 54217380.1111             nan     0.1000 285031.9590
    ##      7 54081038.7446             nan     0.1000 -23999.1188
    ##      8 53834288.1187             nan     0.1000 -127930.8290
    ##      9 53580170.7614             nan     0.1000 -31756.7244
    ##     10 53137911.0164             nan     0.1000 -204044.5605
    ##     20 51336436.6356             nan     0.1000 -348996.5108
    ##     40 47600679.0413             nan     0.1000 -341819.1440
    ##     60 45455688.7884             nan     0.1000 -253194.7261
    ##     80 44173009.5199             nan     0.1000 23613.8501
    ##    100 42927881.4656             nan     0.1000 23351.3210
    ##    120 41172386.7272             nan     0.1000 -116909.7273
    ##    140 40153207.1407             nan     0.1000 -219541.3852
    ##    150 39680573.7166             nan     0.1000 -193014.1265
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 62829734.5080             nan     0.1000 54624.7368
    ##      2 62601456.3171             nan     0.1000 -54182.9447
    ##      3 62320414.3321             nan     0.1000 -39841.0005
    ##      4 62136164.1452             nan     0.1000 -38441.0396
    ##      5 61848958.7531             nan     0.1000  925.8145
    ##      6 61690754.6747             nan     0.1000 126573.6042
    ##      7 61582771.8082             nan     0.1000 -47585.0613
    ##      8 61379105.5749             nan     0.1000 -130640.7684
    ##      9 60953368.7225             nan     0.1000 -278444.1023
    ##     10 60811317.8625             nan     0.1000 94009.3028
    ##     20 59512359.4902             nan     0.1000 -29841.9347
    ##     40 58622039.0220             nan     0.1000 -133745.4986
    ##     60 57817449.8398             nan     0.1000 -16457.1973
    ##     80 57108223.1514             nan     0.1000 -144694.8663
    ##    100 56401234.7725             nan     0.1000 -127816.8569
    ##    120 55834692.0383             nan     0.1000 9130.7583
    ##    140 55104017.3186             nan     0.1000 -94581.5639
    ##    150 54770257.9426             nan     0.1000 -239113.0719
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 63074511.7568             nan     0.1000 216086.9959
    ##      2 62569851.5236             nan     0.1000 72304.2776
    ##      3 62086276.4022             nan     0.1000 -148880.3698
    ##      4 61760269.0904             nan     0.1000 68817.6138
    ##      5 61608224.1873             nan     0.1000 20290.3832
    ##      6 61428896.7665             nan     0.1000 57477.8470
    ##      7 60658507.1643             nan     0.1000 50111.6647
    ##      8 60500241.1517             nan     0.1000 -67822.1626
    ##      9 60277941.6117             nan     0.1000 103715.0582
    ##     10 59888922.0085             nan     0.1000 345917.3170
    ##     20 57767967.6388             nan     0.1000 -154468.3256
    ##     40 55035686.6843             nan     0.1000 -428014.4528
    ##     60 53630743.5742             nan     0.1000 -135553.3016
    ##     80 51403782.5461             nan     0.1000 35005.2862
    ##    100 49906444.5021             nan     0.1000 -4461.7348
    ##    120 48916246.6115             nan     0.1000 -149442.5362
    ##    140 47525113.4876             nan     0.1000 -71278.8437
    ##    150 46958504.9835             nan     0.1000 16132.8360
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 62279617.5830             nan     0.1000 150559.2994
    ##      2 61234337.8803             nan     0.1000 40141.8814
    ##      3 60784204.0087             nan     0.1000 114848.6976
    ##      4 60397688.2256             nan     0.1000 -55863.4954
    ##      5 59922915.0845             nan     0.1000 58283.7854
    ##      6 59619403.4955             nan     0.1000 -15185.5746
    ##      7 59254515.2530             nan     0.1000 -67761.6611
    ##      8 59041382.5177             nan     0.1000 -10367.0830
    ##      9 58750411.1505             nan     0.1000 -224584.0210
    ##     10 58534472.9776             nan     0.1000 190626.9206
    ##     20 56315834.5802             nan     0.1000 -297552.3150
    ##     40 53243608.1527             nan     0.1000 -218755.3735
    ##     60 51041946.6198             nan     0.1000 -194283.1051
    ##     80 49013530.4982             nan     0.1000 -187537.8041
    ##    100 46793522.7053             nan     0.1000 -57842.8532
    ##    120 44616913.1371             nan     0.1000 -204128.2088
    ##    140 43296516.3858             nan     0.1000 -201861.4531
    ##    150 42425629.0672             nan     0.1000 -260207.2493
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 67510393.1374             nan     0.1000 39770.2652
    ##      2 66987146.6502             nan     0.1000 -198859.3266
    ##      3 66835489.5073             nan     0.1000 150521.5347
    ##      4 66601292.9610             nan     0.1000 228485.4916
    ##      5 66342945.5927             nan     0.1000 141074.7138
    ##      6 66127593.6605             nan     0.1000 47769.3907
    ##      7 65825837.4800             nan     0.1000 -236301.2429
    ##      8 65406336.3699             nan     0.1000 -57902.2608
    ##      9 65106882.5114             nan     0.1000 145545.8628
    ##     10 64904315.3006             nan     0.1000 -134047.5403
    ##     20 63631964.1011             nan     0.1000 -170606.8539
    ##     40 62389033.7474             nan     0.1000 -105972.2048
    ##     60 61433433.4485             nan     0.1000 -243706.1004
    ##     80 60952939.3516             nan     0.1000 -37200.0921
    ##    100 60270104.9148             nan     0.1000 -203602.8667
    ##    120 59722206.8424             nan     0.1000 -151438.4548
    ##    140 59353463.1472             nan     0.1000 -190844.2268
    ##    150 59105068.9903             nan     0.1000 -101219.2365
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 67597523.3772             nan     0.1000 216107.9798
    ##      2 67113841.7051             nan     0.1000 225346.3207
    ##      3 66149959.2629             nan     0.1000 94261.1428
    ##      4 65505793.0073             nan     0.1000 3591.2759
    ##      5 65037124.6297             nan     0.1000 347129.3768
    ##      6 64416397.4444             nan     0.1000 -160617.1210
    ##      7 63919809.8995             nan     0.1000 -44774.5490
    ##      8 63713025.9308             nan     0.1000 -101705.0990
    ##      9 63257446.2496             nan     0.1000 61570.1814
    ##     10 62986322.6811             nan     0.1000 -131069.5798
    ##     20 60683501.4744             nan     0.1000 -144364.2207
    ##     40 57185858.7183             nan     0.1000 -227384.9996
    ##     60 55272240.5471             nan     0.1000 -93591.1450
    ##     80 53732860.0015             nan     0.1000 -52312.7468
    ##    100 52051933.0572             nan     0.1000 -146014.8971
    ##    120 50597813.8246             nan     0.1000 -238791.8032
    ##    140 49214075.5341             nan     0.1000 -94861.2372
    ##    150 48937894.9311             nan     0.1000 -141540.6871
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 67181261.0171             nan     0.1000 72456.6728
    ##      2 66572118.1636             nan     0.1000 81027.9616
    ##      3 66062067.5802             nan     0.1000 57584.4056
    ##      4 65346805.2677             nan     0.1000 -23547.5582
    ##      5 64271469.2478             nan     0.1000 156787.3892
    ##      6 63847301.9131             nan     0.1000 -10721.8563
    ##      7 63174093.8390             nan     0.1000 -128002.8525
    ##      8 62847397.9558             nan     0.1000 -107995.3072
    ##      9 62272455.3598             nan     0.1000 -211508.7589
    ##     10 61905380.7223             nan     0.1000 -279020.3081
    ##     20 59172475.9637             nan     0.1000 -66760.5109
    ##     40 55202915.7505             nan     0.1000 1143.5668
    ##     60 52620070.7229             nan     0.1000 -273819.3618
    ##     80 50849851.4339             nan     0.1000 -211372.5769
    ##    100 49318983.3147             nan     0.1000 -314835.9095
    ##    120 47856107.4568             nan     0.1000 -153986.8252
    ##    140 46417278.8928             nan     0.1000 -173722.2837
    ##    150 45415065.6618             nan     0.1000 -122874.6668
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 53233748.3020             nan     0.1000 -25580.9341
    ##      2 53032799.7349             nan     0.1000 -40392.6635
    ##      3 52876168.5635             nan     0.1000 138489.1942
    ##      4 52648679.1796             nan     0.1000 71310.4257
    ##      5 52540571.6983             nan     0.1000 116445.1175
    ##      6 52326088.6821             nan     0.1000 82233.9508
    ##      7 52264658.6933             nan     0.1000 16434.6122
    ##      8 52136233.2896             nan     0.1000 113949.0454
    ##      9 51996950.3203             nan     0.1000 94184.5909
    ##     10 51892092.0481             nan     0.1000 44374.4592
    ##     20 50770010.4996             nan     0.1000 -610.0798
    ##     40 49583229.4935             nan     0.1000 30717.0877
    ##     60 48996695.8060             nan     0.1000 -49166.9269
    ##     80 48563067.7245             nan     0.1000 -40773.4547
    ##    100 48280669.5104             nan     0.1000 -60657.6153
    ##    120 47785029.9099             nan     0.1000 -209515.2122
    ##    140 47562374.3985             nan     0.1000 -200105.8778
    ##    150 47330113.0218             nan     0.1000 -126093.4522
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 53242960.7304             nan     0.1000 -42993.7744
    ##      2 52759265.6471             nan     0.1000 435310.2480
    ##      3 52545153.8056             nan     0.1000 103312.4080
    ##      4 52261685.4720             nan     0.1000 98570.8953
    ##      5 52108171.2713             nan     0.1000 -70748.5480
    ##      6 51970519.5882             nan     0.1000 -4473.4584
    ##      7 51771835.2072             nan     0.1000 -25327.9920
    ##      8 51644155.1045             nan     0.1000 97528.3120
    ##      9 51200744.7336             nan     0.1000 -38662.1522
    ##     10 50897080.9324             nan     0.1000 -64699.4141
    ##     20 48846457.0312             nan     0.1000 -119240.9032
    ##     40 45844467.0980             nan     0.1000 -162083.6661
    ##     60 44397915.0192             nan     0.1000 -9553.1289
    ##     80 43173782.7839             nan     0.1000 -76657.6119
    ##    100 42413074.9065             nan     0.1000 -70476.7444
    ##    120 41270964.4885             nan     0.1000 -59710.7233
    ##    140 40460483.6645             nan     0.1000 -36495.6454
    ##    150 40098166.5569             nan     0.1000 -154066.7016
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 53136539.4488             nan     0.1000 67620.4872
    ##      2 52630632.4889             nan     0.1000 391711.3661
    ##      3 52110143.1295             nan     0.1000 370351.0925
    ##      4 51843083.3019             nan     0.1000 29962.2436
    ##      5 51299913.0673             nan     0.1000 -289164.8516
    ##      6 51123836.8180             nan     0.1000 -19883.2656
    ##      7 50908837.0086             nan     0.1000 41290.9565
    ##      8 50689048.7532             nan     0.1000 -148262.2554
    ##      9 50429988.3561             nan     0.1000 6688.8678
    ##     10 50191647.9202             nan     0.1000 97948.4693
    ##     20 47480883.3581             nan     0.1000 -160376.0761
    ##     40 44733999.4000             nan     0.1000 -93315.7154
    ##     60 42732618.7521             nan     0.1000 -166524.8268
    ##     80 41381366.8250             nan     0.1000 -242766.4418
    ##    100 39962291.9870             nan     0.1000 -92994.7784
    ##    120 38862162.9453             nan     0.1000 -188256.5523
    ##    140 37806570.4195             nan     0.1000 -103455.9560
    ##    150 37158086.6667             nan     0.1000 -210244.2253
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 52796632.0211             nan     0.1000 -12385.1520
    ##      2 52573837.2671             nan     0.1000 124380.9476
    ##      3 52327984.0456             nan     0.1000 218402.5616
    ##      4 52028478.7879             nan     0.1000 -63702.2975
    ##      5 51767987.8779             nan     0.1000 -39725.6100
    ##      6 51603281.6530             nan     0.1000 -55515.2493
    ##      7 51460709.7837             nan     0.1000 36631.4884
    ##      8 51287278.7704             nan     0.1000 -113230.6909
    ##      9 51198653.0919             nan     0.1000 5644.6114
    ##     10 51087324.1283             nan     0.1000 -138181.1385
    ##     20 50124375.9842             nan     0.1000 -24894.1522
    ##     40 49441397.6029             nan     0.1000 -124054.4028
    ##     60 48905701.8924             nan     0.1000 -4316.4735
    ##     80 48510543.7776             nan     0.1000 -67031.2012
    ##    100 48203735.5460             nan     0.1000 -101374.3497
    ##    120 47944126.6804             nan     0.1000 -105224.1617
    ##    140 47652732.6973             nan     0.1000 -32186.1834
    ##    150 47552720.2068             nan     0.1000 -136023.5753
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 52437582.0687             nan     0.1000 213861.6113
    ##      2 52117025.8880             nan     0.1000 -4347.0919
    ##      3 51033350.8399             nan     0.1000 64782.2903
    ##      4 50823227.5626             nan     0.1000 22942.5274
    ##      5 50530212.1091             nan     0.1000 85474.9088
    ##      6 50003568.5340             nan     0.1000 -106932.3545
    ##      7 49822770.4933             nan     0.1000 71735.4004
    ##      8 49524909.6011             nan     0.1000 -58075.5599
    ##      9 49307617.1692             nan     0.1000 -24069.8605
    ##     10 49137815.5177             nan     0.1000 -62383.4500
    ##     20 48017146.3189             nan     0.1000 82218.4837
    ##     40 46369165.4380             nan     0.1000 -54394.3425
    ##     60 45116818.3029             nan     0.1000 -102359.4856
    ##     80 43810818.1776             nan     0.1000 11287.8834
    ##    100 42497589.7976             nan     0.1000 -143334.1122
    ##    120 41541974.2299             nan     0.1000 -93565.5446
    ##    140 40645006.5698             nan     0.1000 -116651.6425
    ##    150 40222944.3170             nan     0.1000 -119989.4486
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 52413292.1052             nan     0.1000 406625.6348
    ##      2 51888869.5938             nan     0.1000 164311.3146
    ##      3 51636196.0882             nan     0.1000 37107.1110
    ##      4 51459257.9547             nan     0.1000 78108.0350
    ##      5 51036340.2151             nan     0.1000 123562.0867
    ##      6 50703548.1614             nan     0.1000 -74013.4392
    ##      7 50406159.9570             nan     0.1000 101461.8379
    ##      8 49955229.9442             nan     0.1000 23665.8766
    ##      9 49541995.8736             nan     0.1000 -50070.6188
    ##     10 49256384.5280             nan     0.1000 66620.3139
    ##     20 47132080.7337             nan     0.1000 -23220.0896
    ##     40 44523733.8781             nan     0.1000 -12434.1728
    ##     60 42471518.5955             nan     0.1000 -180211.6151
    ##     80 40945137.5379             nan     0.1000 -91999.1683
    ##    100 39399578.0039             nan     0.1000 -47148.6914
    ##    120 38299369.7357             nan     0.1000 -63969.9917
    ##    140 37429642.2521             nan     0.1000 -142434.1818
    ##    150 36790986.9605             nan     0.1000 -182848.5183
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 58536273.2790             nan     0.1000 137217.5401
    ##      2 58283395.8317             nan     0.1000 117550.3464
    ##      3 58097254.9904             nan     0.1000 111548.8750
    ##      4 57508358.6761             nan     0.1000 -34078.0658
    ##      5 57208782.0505             nan     0.1000 63943.0558
    ##      6 57039802.8635             nan     0.1000 78202.1153
    ##      7 56833603.3562             nan     0.1000 96390.6951
    ##      8 56620953.7950             nan     0.1000 145288.0523
    ##      9 56292895.9041             nan     0.1000 -277475.7718
    ##     10 56154688.7933             nan     0.1000 -106878.9699
    ##     20 53886332.6559             nan     0.1000 -107642.1640
    ##     25 53181380.8798             nan     0.1000 -84917.3161

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
    ##    0.03899418    0.01940191    0.02855535    0.02609620

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ##   Full Fit 
    ## 0.03899418

## Automation

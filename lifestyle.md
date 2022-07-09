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

    ## # A tibble: 2 × 4
    ##   is_weekend avgShares medianShares stdevShares
    ##        <dbl>     <dbl>        <dbl>       <dbl>
    ## 1          0     3464.         1500       8306.
    ## 2          1     4008.         2200       5136.

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/lifestyle_files/figure-gfm/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/lifestyle_files/figure-gfm/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/lifestyle_files/figure-gfm/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

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

![](/Users/claudialdonahue/Documents/00%20MOR/ST%20558%20Data%20Science%20for%20Statisticians/Project%202/st558-project2/lifestyle_files/figure-gfm/exploratory%20graph-1.png)<!-- -->

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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 1178, 1177, 1178, 1179, 1176 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   7234.314  0.01139563  3120.796
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
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 1178, 1177, 1177, 1178, 1178 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared  MAE     
    ##   7410.466  0.019461  3130.877
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
    ## 1472 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (45), scaled (45), ignore (13) 
    ## Resampling: Cross-Validated (5 fold) 
    ## Summary of sample sizes: 1178, 1177, 1179, 1177, 1177 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     7153.177  0.02607962  3111.086
    ##   2     7179.628  0.01879624  3173.928
    ##   3     7180.950  0.02383032  3195.830
    ##   4     7244.092  0.01949712  3229.954
    ##   5     7216.458  0.02199886  3227.240
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was mtry = 1.

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
    ##      1 70690912.3501             nan     0.1000 -236371.4840
    ##      2 70286672.3601             nan     0.1000 -28817.9283
    ##      3 69930237.6233             nan     0.1000 275521.4900
    ##      4 69897127.9972             nan     0.1000 -100389.0767
    ##      5 69565101.8891             nan     0.1000 -117158.3513
    ##      6 69393247.2204             nan     0.1000 31358.4934
    ##      7 69059593.2146             nan     0.1000 -226219.2728
    ##      8 68736203.6531             nan     0.1000 -28554.9926
    ##      9 68558589.8915             nan     0.1000 -270521.3138
    ##     10 68350485.4308             nan     0.1000 131935.8827
    ##     20 67227814.0656             nan     0.1000 -408397.4556
    ##     40 66315114.4345             nan     0.1000 -540520.7447
    ##     60 65455651.6626             nan     0.1000 -241985.6118
    ##     80 65105330.2907             nan     0.1000 -440145.8813
    ##    100 64612857.8018             nan     0.1000 -67006.7958
    ##    120 64222178.4182             nan     0.1000 -316247.6020
    ##    140 64056599.3510             nan     0.1000 -469323.3828
    ##    150 63930901.3796             nan     0.1000 -196015.4812
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 70308891.4038             nan     0.1000 340124.4782
    ##      2 70115701.9295             nan     0.1000 6158.1005
    ##      3 69494583.9238             nan     0.1000 -146968.3397
    ##      4 68048740.4899             nan     0.1000 -126606.6587
    ##      5 67450094.2818             nan     0.1000 26958.5613
    ##      6 67186844.2756             nan     0.1000 -62605.8371
    ##      7 66789893.2283             nan     0.1000 -104517.6612
    ##      8 66126799.9667             nan     0.1000 -397629.1220
    ##      9 65938204.4142             nan     0.1000 16347.2217
    ##     10 65530021.8025             nan     0.1000 9099.5679
    ##     20 64440750.4471             nan     0.1000 -420140.4073
    ##     40 60710903.5654             nan     0.1000 -640938.6336
    ##     60 58827458.2186             nan     0.1000 -387146.1157
    ##     80 56272461.5908             nan     0.1000 75080.5740
    ##    100 53764881.6325             nan     0.1000 -286861.9248
    ##    120 53069705.6192             nan     0.1000 -205871.8150
    ##    140 50961165.4421             nan     0.1000 -221361.4014
    ##    150 50046894.3689             nan     0.1000 -249947.6445
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 70602961.8807             nan     0.1000 209944.0349
    ##      2 70103894.1726             nan     0.1000 75250.0846
    ##      3 69176963.5791             nan     0.1000 -89853.2731
    ##      4 68884281.3046             nan     0.1000 -107972.2160
    ##      5 68132503.6339             nan     0.1000 212494.3983
    ##      6 67676509.3300             nan     0.1000 -488922.5608
    ##      7 67291337.1673             nan     0.1000 -107904.8245
    ##      8 66905486.3708             nan     0.1000 235664.5481
    ##      9 66563136.9484             nan     0.1000 -173255.2460
    ##     10 66208771.2360             nan     0.1000 -394361.8638
    ##     20 64435826.4558             nan     0.1000 -355766.2684
    ##     40 55259359.3009             nan     0.1000 -301540.3272
    ##     60 53210384.1273             nan     0.1000 -556169.0531
    ##     80 48619187.6560             nan     0.1000 -325125.3657
    ##    100 46583058.6864             nan     0.1000 -327642.1083
    ##    120 44318681.0986             nan     0.1000 -122444.2378
    ##    140 40892047.3463             nan     0.1000 -52952.5428
    ##    150 40472568.4719             nan     0.1000 -323580.2571
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 64903465.4558             nan     0.1000 16101.8367
    ##      2 64850327.3359             nan     0.1000 -84797.4625
    ##      3 64508647.5046             nan     0.1000 51096.7882
    ##      4 63988949.5148             nan     0.1000 -29193.3117
    ##      5 63569433.9523             nan     0.1000 -187813.9858
    ##      6 63271856.3290             nan     0.1000 -111413.9998
    ##      7 63029006.8331             nan     0.1000 -306765.2938
    ##      8 62914913.9529             nan     0.1000 -427628.0085
    ##      9 62644090.1309             nan     0.1000 51535.4511
    ##     10 62355887.2610             nan     0.1000 -76064.7305
    ##     20 61195463.9709             nan     0.1000 60482.2705
    ##     40 59898680.9441             nan     0.1000 -271759.5058
    ##     60 59749545.1694             nan     0.1000 -595834.0238
    ##     80 59003311.2771             nan     0.1000 -482788.5942
    ##    100 58703471.4043             nan     0.1000 -103676.7051
    ##    120 58520149.2593             nan     0.1000 -249913.7613
    ##    140 58284779.4902             nan     0.1000 -70659.3955
    ##    150 57913814.2380             nan     0.1000 -121359.9463
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 64845213.7177             nan     0.1000 217613.4410
    ##      2 64560122.4048             nan     0.1000 136483.3829
    ##      3 64431340.2210             nan     0.1000 -66473.5513
    ##      4 64030528.3000             nan     0.1000 -68333.0030
    ##      5 63771434.3770             nan     0.1000 137852.1415
    ##      6 62916015.0874             nan     0.1000 -195337.8663
    ##      7 62258669.8127             nan     0.1000 -320999.3833
    ##      8 62018680.6150             nan     0.1000 148677.8788
    ##      9 61736392.8349             nan     0.1000 -62300.2211
    ##     10 61456734.2592             nan     0.1000 -206990.2421
    ##     20 58901178.7055             nan     0.1000 -243535.4400
    ##     40 55622061.8024             nan     0.1000 -181907.8367
    ##     60 54803851.9036             nan     0.1000 -352761.2177
    ##     80 53814875.8869             nan     0.1000 -433738.1337
    ##    100 50848962.0863             nan     0.1000 -192336.8357
    ##    120 49396991.9845             nan     0.1000 -284559.0830
    ##    140 48744796.8065             nan     0.1000 -146146.4383
    ##    150 48113365.4914             nan     0.1000 -292729.1002
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 64576277.3982             nan     0.1000 156378.5487
    ##      2 64092152.9295             nan     0.1000 -20747.8740
    ##      3 63734126.6426             nan     0.1000 150715.9722
    ##      4 63411505.0182             nan     0.1000 157801.6958
    ##      5 63218569.8872             nan     0.1000 7796.0986
    ##      6 63121509.6874             nan     0.1000 -111801.2394
    ##      7 62873856.1600             nan     0.1000 46806.4465
    ##      8 62712136.9943             nan     0.1000 -3061.7007
    ##      9 62603079.4491             nan     0.1000 -35696.7930
    ##     10 62385277.1279             nan     0.1000 -140248.0134
    ##     20 59929209.8860             nan     0.1000 -585754.3548
    ##     40 55127320.4484             nan     0.1000 -671557.3890
    ##     60 49446052.0991             nan     0.1000 -227939.8833
    ##     80 48116824.4223             nan     0.1000 -528262.6713
    ##    100 44114861.8372             nan     0.1000 -419662.8348
    ##    120 42216108.4179             nan     0.1000 -275246.2915
    ##    140 40771587.1083             nan     0.1000 -293410.0652
    ##    150 39434835.0135             nan     0.1000 -178942.6890
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 68320818.2632             nan     0.1000 43657.1909
    ##      2 68042314.1421             nan     0.1000 163920.6771
    ##      3 67964680.4592             nan     0.1000 -59969.7289
    ##      4 67775737.5860             nan     0.1000 40545.9024
    ##      5 67457474.5540             nan     0.1000 -99722.2752
    ##      6 67311019.2812             nan     0.1000 -16867.9658
    ##      7 67111568.0135             nan     0.1000 155531.9523
    ##      8 66725860.3872             nan     0.1000 -530598.2547
    ##      9 66627266.6316             nan     0.1000 63415.2526
    ##     10 66507800.9025             nan     0.1000 -74759.1469
    ##     20 65413536.5135             nan     0.1000 -434478.4765
    ##     40 64155999.5546             nan     0.1000 -200701.8603
    ##     60 63484838.0862             nan     0.1000 -352004.1142
    ##     80 62878998.5455             nan     0.1000 -195263.5148
    ##    100 62598853.3369             nan     0.1000 -87525.9292
    ##    120 62399634.2607             nan     0.1000 -397834.1195
    ##    140 61773122.1909             nan     0.1000 -291153.8084
    ##    150 61660336.4872             nan     0.1000 -248927.9553
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 68727906.9914             nan     0.1000 -76250.8077
    ##      2 68477781.6195             nan     0.1000 151010.7230
    ##      3 68393383.0199             nan     0.1000 -115852.8909
    ##      4 68099067.6571             nan     0.1000 184183.7775
    ##      5 67819875.8473             nan     0.1000 12556.6396
    ##      6 67500701.5124             nan     0.1000 -86041.6260
    ##      7 67146305.4451             nan     0.1000 420533.9571
    ##      8 67013175.0824             nan     0.1000 133471.6375
    ##      9 66671092.3309             nan     0.1000 -33330.5282
    ##     10 66026104.6483             nan     0.1000 -113724.7126
    ##     20 63621519.5702             nan     0.1000 -86847.6551
    ##     40 60282255.6667             nan     0.1000 -231117.2438
    ##     60 57328066.0684             nan     0.1000 -548431.3881
    ##     80 56340100.3392             nan     0.1000 -156351.9319
    ##    100 54471822.2432             nan     0.1000 -501618.2462
    ##    120 53103259.8549             nan     0.1000 -235073.7005
    ##    140 51027050.3502             nan     0.1000 -159110.3630
    ##    150 50719792.2148             nan     0.1000 -158090.1057
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 68627033.3756             nan     0.1000 -222362.9625
    ##      2 67592217.2176             nan     0.1000 166844.1775
    ##      3 66570591.3997             nan     0.1000 -123505.6250
    ##      4 65809872.1479             nan     0.1000 -252808.7881
    ##      5 65587160.4772             nan     0.1000 112750.3387
    ##      6 65098614.9258             nan     0.1000 -323093.6562
    ##      7 64695613.9694             nan     0.1000 -148926.8136
    ##      8 64216709.7476             nan     0.1000 -353576.2190
    ##      9 64225571.2326             nan     0.1000 -448260.1362
    ##     10 63933371.0260             nan     0.1000 -244524.0716
    ##     20 61968813.2688             nan     0.1000 -383611.5308
    ##     40 57398967.4029             nan     0.1000 -116460.4118
    ##     60 55464057.3139             nan     0.1000 -229646.9037
    ##     80 52757745.1866             nan     0.1000 -369497.2019
    ##    100 50432645.9961             nan     0.1000 -228590.2616
    ##    120 48037233.1756             nan     0.1000 -220982.2854
    ##    140 44961375.3117             nan     0.1000 -277254.8811
    ##    150 43978596.5189             nan     0.1000 -431332.6508
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 27176340.6223             nan     0.1000 -35455.7546
    ##      2 27081075.0318             nan     0.1000 9176.0966
    ##      3 26999113.4141             nan     0.1000 15461.7103
    ##      4 26933082.8133             nan     0.1000 22973.1605
    ##      5 26884659.3649             nan     0.1000 12016.7903
    ##      6 26839008.3424             nan     0.1000 -37521.4975
    ##      7 26779928.4470             nan     0.1000 -50819.5282
    ##      8 26725018.3134             nan     0.1000 -16159.8534
    ##      9 26671941.9720             nan     0.1000 -20138.9687
    ##     10 26629366.9343             nan     0.1000 -18328.8194
    ##     20 26063011.0887             nan     0.1000 -41530.6462
    ##     40 25420795.8153             nan     0.1000 -9751.4932
    ##     60 24853170.9984             nan     0.1000  528.7569
    ##     80 24483297.5401             nan     0.1000 -28588.1633
    ##    100 24184759.5062             nan     0.1000 -85132.4574
    ##    120 23938840.5089             nan     0.1000 -119230.8226
    ##    140 23641003.7664             nan     0.1000 -58500.5663
    ##    150 23533804.5576             nan     0.1000 -40291.8675
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 27036560.0308             nan     0.1000 127754.7711
    ##      2 26815134.5295             nan     0.1000 84189.2085
    ##      3 26658776.6631             nan     0.1000 -1392.8646
    ##      4 26540713.4957             nan     0.1000 28936.5629
    ##      5 26417653.9276             nan     0.1000 -56114.4248
    ##      6 26357455.0158             nan     0.1000 -34671.6339
    ##      7 26276543.4298             nan     0.1000 -2919.6644
    ##      8 26184685.6900             nan     0.1000 45503.3038
    ##      9 25997166.5158             nan     0.1000 -35116.1380
    ##     10 25825823.3701             nan     0.1000 -64883.1472
    ##     20 24822984.5765             nan     0.1000 -84279.0116
    ##     40 22979763.0645             nan     0.1000 -84599.9171
    ##     60 21684778.7482             nan     0.1000 -72468.6847
    ##     80 20534641.5297             nan     0.1000 -35796.2874
    ##    100 19533051.1447             nan     0.1000 -32485.6604
    ##    120 18727930.8470             nan     0.1000 -34426.8798
    ##    140 17776272.3630             nan     0.1000 -41320.5385
    ##    150 17370513.1223             nan     0.1000 -95764.2158
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 26813937.8680             nan     0.1000 18162.6891
    ##      2 26563223.8623             nan     0.1000 -47510.7127
    ##      3 26215890.5305             nan     0.1000 -106976.8858
    ##      4 26016136.4634             nan     0.1000 48108.1149
    ##      5 25851191.2929             nan     0.1000 -23014.6081
    ##      6 25606346.3949             nan     0.1000 -70583.5737
    ##      7 25468995.1069             nan     0.1000 -28033.8213
    ##      8 25331611.0299             nan     0.1000 -13218.4724
    ##      9 25147173.1893             nan     0.1000 14257.8323
    ##     10 24977906.9562             nan     0.1000 -71557.7359
    ##     20 23444801.0279             nan     0.1000 -68566.8537
    ##     40 20871610.2118             nan     0.1000 -6575.1168
    ##     60 19166746.0814             nan     0.1000 -49863.2721
    ##     80 17618690.1764             nan     0.1000 -57483.8481
    ##    100 16365125.6590             nan     0.1000 -31560.6869
    ##    120 15247679.7249             nan     0.1000 -98104.5512
    ##    140 14226802.3699             nan     0.1000 -68020.8912
    ##    150 13766149.5739             nan     0.1000 -57126.6431
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 70073583.1274             nan     0.1000 204569.1022
    ##      2 69418934.5643             nan     0.1000 -151065.3629
    ##      3 68976588.9724             nan     0.1000 -83124.7309
    ##      4 68681792.4917             nan     0.1000 189655.6894
    ##      5 68304852.0782             nan     0.1000 -156422.1536
    ##      6 68259930.3991             nan     0.1000 -16376.3008
    ##      7 68176673.1809             nan     0.1000 -52288.0171
    ##      8 67981651.1955             nan     0.1000 54908.1802
    ##      9 67833206.1783             nan     0.1000 2434.3667
    ##     10 67669507.0954             nan     0.1000 28225.4720
    ##     20 65969802.9077             nan     0.1000 -128088.9961
    ##     40 64758075.6659             nan     0.1000 -231303.1178
    ##     60 63965559.6876             nan     0.1000 -1860.9160
    ##     80 63599663.5125             nan     0.1000 -470060.6384
    ##    100 63049483.6337             nan     0.1000 -464569.9960
    ##    120 62637616.0144             nan     0.1000 -383574.1530
    ##    140 62586647.1438             nan     0.1000 -594418.8174
    ##    150 62378016.2589             nan     0.1000 -286717.0648
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 69493797.4573             nan     0.1000 230552.4223
    ##      2 69078026.4557             nan     0.1000 -144225.6996
    ##      3 68858030.5069             nan     0.1000 113671.2378
    ##      4 68416536.1737             nan     0.1000 -23896.9854
    ##      5 67902455.6896             nan     0.1000 -139699.9334
    ##      6 67616841.3863             nan     0.1000 -22615.0821
    ##      7 66433326.1886             nan     0.1000 -189257.0067
    ##      8 66138188.7487             nan     0.1000 -128966.9903
    ##      9 65743501.4461             nan     0.1000 -39195.2653
    ##     10 65554848.6991             nan     0.1000 -62565.8259
    ##     20 63024468.5404             nan     0.1000 -482549.1086
    ##     40 60507607.0852             nan     0.1000 -90324.3598
    ##     60 57875010.8272             nan     0.1000 -293854.9486
    ##     80 55115126.2419             nan     0.1000 -342401.8702
    ##    100 54393221.5827             nan     0.1000 -565199.3668
    ##    120 52940749.7737             nan     0.1000 -422404.7575
    ##    140 51469634.5997             nan     0.1000 -412017.2081
    ##    150 50801829.0792             nan     0.1000 -464006.6018
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 69413822.4347             nan     0.1000 -94080.7525
    ##      2 69158133.4309             nan     0.1000 68498.6233
    ##      3 68486180.8026             nan     0.1000 -142308.0938
    ##      4 68223274.3366             nan     0.1000 58936.8594
    ##      5 67670062.2510             nan     0.1000 -39840.6622
    ##      6 67170793.3353             nan     0.1000 -102975.2769
    ##      7 66819406.0752             nan     0.1000 -186357.7344
    ##      8 66591022.6887             nan     0.1000 -222919.2507
    ##      9 66357014.2359             nan     0.1000 -223076.9102
    ##     10 65155776.3363             nan     0.1000 -252461.4070
    ##     20 60901541.7728             nan     0.1000 -239597.8878
    ##     40 55437765.9035             nan     0.1000 -90838.1876
    ##     60 52671947.2195             nan     0.1000 -289021.3517
    ##     80 49337260.3451             nan     0.1000 -207322.9901
    ##    100 46792091.0729             nan     0.1000 -274153.2123
    ##    120 45437880.7423             nan     0.1000 -330803.8244
    ##    140 43077087.6317             nan     0.1000 -298837.6271
    ##    150 42601493.3466             nan     0.1000 -138557.6453
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 60511276.5884             nan     0.1000 184541.3596
    ##      2 59963633.9491             nan     0.1000 19975.7540
    ##      3 59550798.2928             nan     0.1000 -159762.2949
    ##      4 59215941.4541             nan     0.1000 12550.8171
    ##      5 58912781.4935             nan     0.1000 -83452.3293
    ##      6 58669994.5319             nan     0.1000 -86861.2239
    ##      7 58491465.6817             nan     0.1000 -255587.5377
    ##      8 58282507.4896             nan     0.1000 -21601.4343
    ##      9 58099297.9788             nan     0.1000 84306.6133
    ##     10 57983167.6946             nan     0.1000 -955.5824
    ##     20 57005002.7375             nan     0.1000 -28692.8395
    ##     25 56974417.2778             nan     0.1000 -459176.8982

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
    ##    0.01139563    0.01940191    0.02607962    0.02281516

``` r
# The best model based on the highest R-squared value is:
results[which.max(results)]
```

    ## Random Forest 
    ##    0.02607962

## Automation

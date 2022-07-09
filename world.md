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
received. Here are our findings for studying how to predict the number
of shares in social networks (popularity).

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

# Add a day column for data exploration/plotting purposes
data$day <- case_when(
  data$weekday_is_monday == 1 ~ "Monday",
  data$weekday_is_tuesday == 1 ~ "Tuesday",
  data$weekday_is_wednesday == 1 ~ "Wednesday",
  data$weekday_is_thursday == 1 ~ "Thursday",
  data$weekday_is_friday == 1 ~ "Friday",
  data$weekday_is_saturday == 1 ~ "Saturday",
  data$weekday_is_sunday == 1 ~ "Sunday"
)
data$day <- as_factor(data$day)

#Converting categorical values from numeric to factor - Weekdays
data$weekday_is_monday <- factor(data$weekday_is_monday)
data$weekday_is_tuesday <- factor(data$weekday_is_tuesday)
data$weekday_is_wednesday <- factor(data$weekday_is_wednesday)
data$weekday_is_thursday <- factor(data$weekday_is_thursday)
data$weekday_is_friday <- factor(data$weekday_is_friday)
data$weekday_is_saturday <- factor(data$weekday_is_saturday)
data$weekday_is_sunday <- factor(data$weekday_is_sunday)

# Add a channel column 
data$chan <- case_when(
  data$data_channel_is_lifestyle == 1 ~ "Lifestyle",
  data$data_channel_is_entertainment == 1 ~ "Entertainment",
  data$data_channel_is_bus == 1 ~ "Business",
  data$data_channel_is_socmed == 1 ~ "Social Media",
  data$data_channel_is_tech == 1 ~ "Technology",
  data$data_channel_is_world == 1 ~ "World"
)
data$chan <- as_factor(data$chan)

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
read. But then we plotted the number of articles published each day, and
realized not much gets published on the weekend.

``` r
ggplot(data) + 
  geom_bar(aes(x = day, fill = chan)) +
  labs(title = "Number of Articles by Day of Week",
       x = "Day of the Week",
       y = "Number of Articles",
       fill = "Channel")
```

![](./world_images/bar%20by%20day%20of%20week-1.png)<!-- -->

So we did away with that theory, and we will instead look at just one
channel’s number of shares across days of the week.

``` r
ggplot(training, aes(x = day, y = shares)) +
  geom_boxplot() + 
  geom_jitter(aes(color = day)) + 
  ggtitle("Boxplot for Shares")
```

![](./world_images/boxplot%20of%20shares%20by%20day%20of%20week-1.png)<!-- -->

The boxplot shows the distribution of the number of shares by the day of
the week. It can be a good way to see if we have any outliers with
**way** more shares than a typical article.

Then we wanted to look at these outliers–the top articles by shares, so
we grabbed a list of those URLs, along with the number of shares.

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

![](./world_images/Scatter%20Plot%20title%20impact%20on%20shares-1.png)<!-- -->

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

![](./world_images/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->

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

![](./world_images/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->

Before the modeling step, we took one final look at some of the other
variables we thought might be important in predicting number of shares,
based on the summaries above and our own experiences.

``` r
library(GGally)
training %>% 
  select(self_reference_avg_sharess, LDA_00, rate_negative_words, shares) %>%
  GGally::ggpairs()
```

![](./world_images/exploratory%20graph-1.png)<!-- -->

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
              trControl = trainControl(method = "cv", number = 2)
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
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 2949, 2951 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   6461.254  0.01767855  2011.121
    ## 
    ## Tuning parameter 'intercept' was held constant at a value of TRUE

The next multiple regresson model is a little more simplified and
includes a smaller subset of variables that we think would be important.

``` r
smallFit <- train(shares ~ n_tokens_content + num_hrefs + num_self_hrefs +
                     average_token_length + num_keywords + 
                     kw_min_max + kw_max_max + kw_avg_max + kw_max_avg +
                     kw_avg_avg + self_reference_min_shares +
                     global_subjectivity + title_sentiment_polarity,
              data = training, 
              method = "lm", 
              preProcess = c("center", "scale", "nzv"),
              trControl = trainControl(method = "cv", number = 2)
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
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 2949, 2951 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared   MAE     
    ##   6342.722  0.0200121  2016.383
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
tunegrid <- expand.grid(.mtry=c(1:3)) # This is key for amount of time running

#train model
rfFit <- train(x = select(training, -url, -shares, -day, -chan), 
                y = training$shares,
                method = "rf",
                tuneGrid = tunegrid,
                preProcess = c("center", "scale", "nzv"),
                trControl = trainControl(method = "cv", 
                                         number = 2)
                )
rfFit
```

    ## Random Forest 
    ## 
    ## 5900 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (44), scaled (44), ignore (13), remove (1) 
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 2950, 2950 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     6397.362  0.02062581  1992.233
    ##   2     6383.789  0.02372651  2019.751
    ##   3     6394.256  0.02472315  2048.513
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was mtry = 2.

### Boosted Tree

``` r
# Load required packages
library(gbm)

# set up the parameters
gbmGrid <-  expand.grid(interaction.depth = c(1, 2, 3), 
                        n.trees = c(25, 50), 
                        shrinkage = 0.1,
                        n.minobsinnode = 10)

#train model
btFit <- train(x = select(training, -url, -shares, -day, -chan), 
                y = training$shares,
                method = "gbm",
                tuneGrid = gbmGrid,
                preProcess = c("center", "scale", "nzv"),
                trControl = trainControl(method = "cv", 
                                         number = 2)
                )
```

    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 33684179.6549             nan     0.1000 93413.0857
    ##      2 33595328.1850             nan     0.1000 -34180.7841
    ##      3 33489139.5788             nan     0.1000  654.6332
    ##      4 33353279.9643             nan     0.1000 58446.4441
    ##      5 33278309.1760             nan     0.1000 -46503.0111
    ##      6 33172641.0286             nan     0.1000 92187.2003
    ##      7 33059659.9736             nan     0.1000 34446.8480
    ##      8 32928501.0215             nan     0.1000 -6084.3702
    ##      9 32882470.9201             nan     0.1000 -6970.5198
    ##     10 32772948.8818             nan     0.1000 61216.7275
    ##     20 32015056.2922             nan     0.1000 7892.3014
    ##     40 31218404.6087             nan     0.1000 4652.1445
    ##     50 30992599.4903             nan     0.1000 -49039.4000
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 33326737.1036             nan     0.1000 271695.4505
    ##      2 32899636.5422             nan     0.1000 168608.6200
    ##      3 32661145.2401             nan     0.1000 -9246.5927
    ##      4 32163446.5839             nan     0.1000 93968.7183
    ##      5 31845860.1873             nan     0.1000 -21355.7605
    ##      6 31609265.8134             nan     0.1000 -21683.6403
    ##      7 31344924.1216             nan     0.1000 42283.2602
    ##      8 31160926.7638             nan     0.1000 44284.8598
    ##      9 30799101.0795             nan     0.1000 -13895.8354
    ##     10 30699757.7568             nan     0.1000 -40209.5429
    ##     20 29431391.3655             nan     0.1000 -53934.8557
    ##     40 27591056.7565             nan     0.1000 -82089.5661
    ##     50 26824805.2707             nan     0.1000 -142050.5034
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 33148745.6838             nan     0.1000 170420.0980
    ##      2 32628973.5703             nan     0.1000 43404.5534
    ##      3 32297126.4675             nan     0.1000 107889.3918
    ##      4 32101673.3453             nan     0.1000 19259.8224
    ##      5 31821706.5920             nan     0.1000 78024.0984
    ##      6 30993140.8061             nan     0.1000 -40056.4190
    ##      7 30822301.5976             nan     0.1000 43595.8251
    ##      8 30524835.1671             nan     0.1000 10277.8679
    ##      9 30264189.5424             nan     0.1000 -14992.7649
    ##     10 29959564.9509             nan     0.1000 -46407.8043
    ##     20 28159058.4516             nan     0.1000 -41681.4801
    ##     40 25774602.3929             nan     0.1000 -4766.3586
    ##     50 24732315.4746             nan     0.1000 -61052.0034
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 51161033.2435             nan     0.1000 33514.2288
    ##      2 51098548.2252             nan     0.1000 20349.1402
    ##      3 50986949.0196             nan     0.1000 111359.1173
    ##      4 50655134.7553             nan     0.1000 -54850.7349
    ##      5 50271639.9489             nan     0.1000 3304.5625
    ##      6 49966708.7176             nan     0.1000 -174401.6389
    ##      7 49894792.5339             nan     0.1000 18921.9808
    ##      8 49799070.9432             nan     0.1000 12647.2060
    ##      9 49709280.0691             nan     0.1000 73592.7041
    ##     10 49629483.4094             nan     0.1000 88332.5283
    ##     20 48616492.3947             nan     0.1000 40474.3394
    ##     40 47272136.6117             nan     0.1000 -318022.5550
    ##     50 46666637.9922             nan     0.1000 -31491.6824
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 51291928.7630             nan     0.1000 2649.9131
    ##      2 51087927.7262             nan     0.1000 26963.0022
    ##      3 50373159.4141             nan     0.1000 8607.4370
    ##      4 49813027.9254             nan     0.1000 -70061.9660
    ##      5 49722679.1082             nan     0.1000 -7152.2700
    ##      6 49325307.6743             nan     0.1000 -57858.1860
    ##      7 49054636.7040             nan     0.1000 -53495.8654
    ##      8 48907284.2664             nan     0.1000 -43170.5556
    ##      9 48772450.5260             nan     0.1000 26208.0581
    ##     10 48420852.8804             nan     0.1000 93412.5040
    ##     20 46302624.7588             nan     0.1000 54622.0254
    ##     40 41032372.3395             nan     0.1000 -55735.2328
    ##     50 39874166.9330             nan     0.1000 86694.5983
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 50869286.0607             nan     0.1000 264821.7993
    ##      2 50466194.2527             nan     0.1000 342060.3480
    ##      3 50000843.7206             nan     0.1000 67051.8005
    ##      4 49591629.7480             nan     0.1000 -59450.2034
    ##      5 49420064.9918             nan     0.1000 11140.6142
    ##      6 49181207.7576             nan     0.1000 6379.2072
    ##      7 49026621.6782             nan     0.1000 32846.6345
    ##      8 48694700.0007             nan     0.1000 -101315.6519
    ##      9 48367830.0213             nan     0.1000 -453734.5490
    ##     10 48266456.8895             nan     0.1000 -168216.0290
    ##     20 45934889.6143             nan     0.1000 -59667.7393
    ##     40 42984365.2590             nan     0.1000 -230935.1557
    ##     50 41429388.8745             nan     0.1000 52174.2655
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 42138366.1373             nan     0.1000 93475.2793
    ##      2 41701460.8897             nan     0.1000 -25406.7121
    ##      3 41216128.6616             nan     0.1000 71374.7082
    ##      4 41048911.4567             nan     0.1000 63864.9527
    ##      5 40874453.7558             nan     0.1000 55180.1580
    ##      6 40652590.5306             nan     0.1000 73943.6033
    ##      7 40335148.6217             nan     0.1000 -166745.0187
    ##      8 39927614.6005             nan     0.1000 -76929.3510
    ##      9 39620014.8161             nan     0.1000 -126775.0053
    ##     10 39524371.1487             nan     0.1000 -11358.6767
    ##     20 37068481.9379             nan     0.1000 -62683.2691
    ##     25 36268506.7841             nan     0.1000 -20206.0428

## Comparison

We compared all four of these models using the test dataset.

``` r
# full fit multiple regression model
fullPred <- predict(fullFit, newdata = testing)
# selected variable multiple regression model
smallPred <- predict(smallFit, newdata = testing)
# random forest
rfPred <- predict(rfFit, newdata = testing)
# boosted tree
btPred <- predict(btFit, newdata = testing)
```

Now we will compare the four candidate models and choose one “winner”:

``` r
# Create a named with results (Rsquared values) for each model
results <- c("Full Fit" = max(fullFit$results$Rsquared), 
           "Small Fit" = max(smallFit$results$Rsquared),
           "Random Forest" = max(rfFit$results$Rsquared),
           "Boosted Tree" = max(btFit$results$Rsquared))

# RSquared Values are: 
results
```

    ##      Full Fit     Small Fit Random Forest  Boosted Tree 
    ##    0.01767855    0.02001210    0.02472315    0.02243335

``` r
# The best model based on the highest R-squared value is:
winner <- results[which.max(results)]
```

We have a winning model based on the highest R-Squared value, and it’s
0.0247232! Our models are not doing that great, and only explain a small
percentage of the variation in number of shares, but let’s not let that
dampen our enthusiasm!

If we wanted to improve upon these models, we could increase the tuning
value of `mtry` in the Random Forest model. The cost would be the model
would take a lot longer to train. We also considered trying to predict
the
![log(\`shares\`)](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;log%28%60shares%60%29 "log(`shares`)")
instead of `shares` itself, but decided that was outside the scope of
the assignment.

## Automation

We generated these reports automatically for each channel (“lifestyle”,
“entertainment”, “bus”, “socmed”, “tech”, and “world”) by creating a
function that uses the `rmarkdown` package to render a Github document
with a `params` option, and then using a for loop to execute that
function for each channel in a list. That’s how the page you’re reading
was generated!

The code we used to automate the rendering is visible at the main page
for this project [here](https://cdonahu.github.io/st558-project2/).

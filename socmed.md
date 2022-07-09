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

![](./socmed_images/bar%20by%20day%20of%20week-1.png)<!-- -->

So we did away with that theory, and we will instead look at just one
channel’s number of shares across days of the week.

``` r
ggplot(training, aes(x = day, y = shares)) +
  geom_boxplot() + 
  geom_jitter(aes(color = day)) + 
  ggtitle("Boxplot for Shares")
```

![](./socmed_images/boxplot%20of%20shares%20by%20day%20of%20week-1.png)<!-- -->

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
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 814, 814 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE    
    ##   5869.703  0.01545385  2676.44
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
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 814, 814 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   5858.447  0.01798806  2628.791
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
    ## 1628 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (45), scaled (45), ignore (13) 
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 815, 813 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     5707.941  0.05046077  2648.902
    ##   2     5679.066  0.04652017  2647.039
    ##   3     5700.280  0.04076133  2678.269
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
    ##      1 20875413.6832             nan     0.1000 210175.4026
    ##      2 20787430.9198             nan     0.1000 -125075.1832
    ##      3 20659216.8789             nan     0.1000 56959.4949
    ##      4 20599239.9859             nan     0.1000 16131.5394
    ##      5 20497279.4567             nan     0.1000 -22973.6905
    ##      6 20399154.5193             nan     0.1000 19275.3687
    ##      7 20315421.8413             nan     0.1000 23777.1589
    ##      8 20232878.1958             nan     0.1000 -23519.3387
    ##      9 20144943.0466             nan     0.1000 3647.4331
    ##     10 20084033.9527             nan     0.1000 17849.4294
    ##     20 19648462.4203             nan     0.1000 -8748.0148
    ##     40 18860174.9732             nan     0.1000 -8233.6329
    ##     50 18591004.0197             nan     0.1000 -225149.4527
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 20624388.1003             nan     0.1000 -69359.7331
    ##      2 20421086.9965             nan     0.1000 -15510.4102
    ##      3 20349009.4385             nan     0.1000 -77871.3280
    ##      4 20183614.5516             nan     0.1000 -40146.9913
    ##      5 20115767.4656             nan     0.1000 -66403.2460
    ##      6 20008119.1449             nan     0.1000 -54122.1864
    ##      7 19749295.0044             nan     0.1000 -68200.9458
    ##      8 19475961.2884             nan     0.1000 10208.3590
    ##      9 19206752.7685             nan     0.1000 -35425.1891
    ##     10 19094294.4194             nan     0.1000 44590.1143
    ##     20 18070296.5009             nan     0.1000 -224768.9485
    ##     40 16153770.9243             nan     0.1000 -148811.3803
    ##     50 15464656.9560             nan     0.1000 -39348.7272
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 20598078.4144             nan     0.1000 -32349.2748
    ##      2 20296289.6997             nan     0.1000 -110855.1294
    ##      3 20050706.5908             nan     0.1000 -10876.3410
    ##      4 19861111.3515             nan     0.1000 -55049.6434
    ##      5 19746735.6277             nan     0.1000 -69206.0867
    ##      6 19606548.7339             nan     0.1000 6354.0051
    ##      7 19439308.9771             nan     0.1000 -51923.1876
    ##      8 19022005.0706             nan     0.1000 -62076.3900
    ##      9 18956871.4502             nan     0.1000 -101545.3000
    ##     10 18579075.3102             nan     0.1000 -130009.3255
    ##     20 16798177.5066             nan     0.1000 6814.2463
    ##     40 14870482.7902             nan     0.1000 -48766.9848
    ##     50 14244170.0304             nan     0.1000 -110.3951
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 47854513.6516             nan     0.1000 -42150.0311
    ##      2 47641765.8059             nan     0.1000 -134558.9703
    ##      3 47450341.7981             nan     0.1000 -145709.3207
    ##      4 47165253.8748             nan     0.1000 141690.4957
    ##      5 46982301.7055             nan     0.1000 -22687.4741
    ##      6 46793075.9208             nan     0.1000 -81908.5279
    ##      7 46510150.5238             nan     0.1000 174912.1977
    ##      8 46229907.8342             nan     0.1000 270364.9317
    ##      9 46161269.6538             nan     0.1000 -119568.4764
    ##     10 46044347.1174             nan     0.1000 -151208.4884
    ##     20 44503297.4883             nan     0.1000 -168332.4257
    ##     40 42520547.1869             nan     0.1000 -191199.9672
    ##     50 41942520.2277             nan     0.1000 -46539.8771
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 47601194.1970             nan     0.1000 -71342.1061
    ##      2 47085576.3897             nan     0.1000 94088.8374
    ##      3 46594536.1527             nan     0.1000 123805.6156
    ##      4 46138307.9297             nan     0.1000 -115322.9120
    ##      5 45749179.4354             nan     0.1000 98412.5851
    ##      6 45504208.3862             nan     0.1000 41760.4092
    ##      7 45208078.5706             nan     0.1000 -312939.8767
    ##      8 44947317.4119             nan     0.1000 85108.1785
    ##      9 44569117.4805             nan     0.1000 -51491.9102
    ##     10 44306283.2802             nan     0.1000 -181859.5029
    ##     20 40792394.4327             nan     0.1000 -61599.7638
    ##     40 37482713.6965             nan     0.1000 -172120.2407
    ##     50 36478403.6094             nan     0.1000 -375280.3130
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 47378587.1947             nan     0.1000 194503.4641
    ##      2 46710494.4498             nan     0.1000 213789.0423
    ##      3 46426374.0556             nan     0.1000 65454.9991
    ##      4 45627148.6780             nan     0.1000 -153541.7432
    ##      5 45268359.2958             nan     0.1000 -223937.2890
    ##      6 44852207.2743             nan     0.1000 1091.2199
    ##      7 44523007.5182             nan     0.1000 -210943.4493
    ##      8 44019280.9894             nan     0.1000 -45085.6997
    ##      9 43638297.1440             nan     0.1000 -313365.6004
    ##     10 42634443.9898             nan     0.1000 -107542.2002
    ##     20 39931475.2184             nan     0.1000 -500282.5730
    ##     40 36553794.6815             nan     0.1000 -313452.5130
    ##     50 35322442.7056             nan     0.1000 -265029.0073
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 34484350.9190             nan     0.1000 169200.9747
    ##      2 34329062.7547             nan     0.1000 -15047.1368
    ##      3 34251924.5637             nan     0.1000 53071.8882
    ##      4 34089035.6988             nan     0.1000 75920.6878
    ##      5 33989981.4163             nan     0.1000 -23847.5529
    ##      6 33918252.6919             nan     0.1000 -40577.2539
    ##      7 33782723.8071             nan     0.1000 35514.4123
    ##      8 33642247.6864             nan     0.1000 -7089.2023
    ##      9 33591273.1877             nan     0.1000 -43061.8277
    ##     10 33543321.1898             nan     0.1000 -81379.4742
    ##     20 32768211.0021             nan     0.1000 18756.6893
    ##     40 31912979.9447             nan     0.1000 -125402.9398
    ##     50 31618518.8300             nan     0.1000 -120706.4655

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
    ##    0.01545385    0.01798806    0.05046077    0.02789868

``` r
# The best model based on the highest R-squared value is:
winner <- results[which.max(results)]
```

We have a winning model based on the highest R-Squared value, and it’s
0.0504608! Our models are not doing that great, and only explain a small
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

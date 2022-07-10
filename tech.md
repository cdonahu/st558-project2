Predicting Popularity of Articles in the tech Channel
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
an article’s number of shares to social networks (its popularity). We
wanted to look at the patterns in the articles that were shared. For
example, is the timing of the article, the headline, and the article’s
content all relevant in determining the number of times the article gets
shared? What about whether an article had a polarizing title versus a
generic non-polarizing title. Then, we wanted to find out whether the
number of keywords associated with an article impacted the number of
shares it received. Here are our findings for studying how to predict
the number of shares in social networks (popularity).

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

Next we will begin our look at one specific channel (tech) by subsetting
the data.

``` r
channel <- channel # set = to channel when ready to automate

channelNow <- paste("data_channel_is_", channel, sep = "")

cData <- data[data[channelNow] == 1, ] # Extract rows of interest
```

We then split the tech channel’s data into training and testing sets
(70% and 30%, respectively). We will only explore the training set, and
will keep the testing set in reserve to determine the quality of our
predictions. We will use the function `createDataPartition()` from the
`caret` package to split the data.

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
realized not much gets published on the weekend, compared to weekdays.
To visualize this pattern, we created the chart below:

``` r
ggplot(data) + 
  geom_bar(aes(x = day, fill = chan)) +
  labs(title = "Number of Articles by Day of Week",
       x = "Day of the Week",
       y = "Number of Articles",
       fill = "Channel")
```

![](./tech_images/bar%20by%20day%20of%20week-1.png)<!-- --> A table of
the above chart:

``` r
data %>% group_by(day,chan) %>%
  summarise(n=n(),
            Avg=mean(shares),
            Sd=sd(shares),
            Median=median(shares),
            Min=min(shares),
            Max=max(shares))
```

    ## `summarise()` has grouped output by 'day'. You can override using the
    ## `.groups` argument.

    ## # A tibble: 49 × 8
    ## # Groups:   day [7]
    ##    day     chan              n   Avg     Sd Median   Min    Max
    ##    <fct>   <fct>         <int> <dbl>  <dbl>  <dbl> <dbl>  <dbl>
    ##  1 Monday  Entertainment  1358 2931.  7176.   1100    59 112600
    ##  2 Monday  Business       1153 3887. 28313.   1400     1 690400
    ##  3 Monday  Technology     1235 2821.  3915.   1600   192  51000
    ##  4 Monday  Lifestyle       322 4346. 14073.   1600   109 196700
    ##  5 Monday  World          1356 2456.  6865.   1100    43 141400
    ##  6 Monday  Social Media    337 4010.  6046.   2300    53  57600
    ##  7 Monday  <NA>            900 6961. 17388.   1900     4 200100
    ##  8 Tuesday Entertainment  1285 2708.  6453.   1100    47  98000
    ##  9 Tuesday Business       1182 2932. 10827.   1300    44 310800
    ## 10 Tuesday Technology     1474 2883.  4722.   1600   104  88500
    ## # … with 39 more rows

So we did away with that theory, and we will instead look at just the
tech channel’s number of shares across days of the week.

``` r
ggplot(training, aes(x = day, y = shares)) +
  geom_boxplot() + 
  geom_jitter(aes(color = day)) + 
  ggtitle("Boxplot for Shares")
```

![](./tech_images/boxplot%20of%20shares%20by%20day%20of%20week-1.png)<!-- -->
A table of the above chart:

``` r
training %>% group_by(day,chan) %>%
  summarise(n=n(),
            Avg=mean(shares),
            Sd=sd(shares),
            Median=median(shares),
            Min=min(shares),
            Max=max(shares))
```

    ## `summarise()` has grouped output by 'day'. You can override using the
    ## `.groups` argument.

    ## # A tibble: 7 × 8
    ## # Groups:   day [7]
    ##   day       chan           n   Avg     Sd Median   Min    Max
    ##   <fct>     <fct>      <int> <dbl>  <dbl>  <dbl> <dbl>  <dbl>
    ## 1 Monday    Technology   850 2813.  3832.   1600   192  51000
    ## 2 Tuesday   Technology  1048 2902.  4826.   1600   162  88500
    ## 3 Wednesday Technology   975 3580. 21611.   1600    36 663600
    ## 4 Thursday  Technology   917 2772.  4398.   1600    86  55200
    ## 5 Friday    Technology   706 2999.  4269.   1800   140  40200
    ## 6 Saturday  Technology   363 3468.  5785.   2200   119  96100
    ## 7 Sunday    Technology   286 3746.  4109.   2300   206  27700

The boxplot shows the distribution of the number of shares by the day of
the week. It can be a good way to see if we have any outliers with
**way** more shares than a typical article in this channel.

We wanted to look at these outliers–the tech channel’s top articles by
shares, so we grabbed a list of those URLs, along with the number of
shares.

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

You can check out the article’s date and title within the URL and see
what some of the most-shared articles were in the tech channel during
the time period studied.

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
A table of the above chart:

``` r
training %>% group_by(title_sentiment_polarity) %>%
  summarise(n=n(),
            Avg=mean(shares),
            Sd=sd(shares),
            Median=median(shares),
            Min=min(shares),
            Max=max(shares))
```

    ## # A tibble: 250 × 7
    ##    title_sentiment_polarity     n   Avg    Sd Median   Min   Max
    ##                       <dbl> <int> <dbl> <dbl>  <dbl> <dbl> <dbl>
    ##  1                   -1         8 2528. 1097.   2850   726  4000
    ##  2                   -0.815     1 4800    NA    4800  4800  4800
    ##  3                   -0.8       6 2800  3286.   1550  1200  9500
    ##  4                   -0.714     3 2767. 2454.   1400  1300  5600
    ##  5                   -0.7       8 5000  4970.   3300  1400 16700
    ##  6                   -0.65      1 3000    NA    3000  3000  3000
    ##  7                   -0.6      14 3317. 3272.   2050   936 12800
    ##  8                   -0.55      1 1100    NA    1100  1100  1100
    ##  9                   -0.508     1 3700    NA    3700  3700  3700
    ## 10                   -0.5      47 2510. 2253.   1600   675 11200
    ## # … with 240 more rows

In this plot of the impact of the title’s sentiment polarity on shares,
an upward trend in the plotted points would indicate that articles with
higher values of title sentiment polarity tend to be shared more often.
Note that polarity values can be positive or negative.

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
A table of the above chart:

``` r
training %>% group_by(n_tokens_content) %>%
  summarise(n=n(),
            Avg=mean(shares),
            Sd=sd(shares),
            Median=median(shares),
            Min=min(shares),
            Max=max(shares))
```

    ## # A tibble: 1,433 × 7
    ##    n_tokens_content     n   Avg    Sd Median   Min   Max
    ##               <dbl> <int> <dbl> <dbl>  <dbl> <dbl> <dbl>
    ##  1                0    14 3978. 3335.   3000   887 13200
    ##  2               35     1 2000    NA    2000  2000  2000
    ##  3               41     1 2000    NA    2000  2000  2000
    ##  4               46     1 1100    NA    1100  1100  1100
    ##  5               54     1 1900    NA    1900  1900  1900
    ##  6               65     1 3000    NA    3000  3000  3000
    ##  7               67     1 3000    NA    3000  3000  3000
    ##  8               71     1 3600    NA    3600  3600  3600
    ##  9               75     1 2800    NA    2800  2800  2800
    ## 10               77     2 1813  1537.   1813   726  2900
    ## # … with 1,423 more rows

In this plot, a downward trend in plotted points would indicate that
shorter articles generally get more shares, while an upward trend would
indicate that longer articles achieve more shares.

Next we looked at an article’s keyword characteristics. Within its
metadata, a website can be assigned a number of keywords, which used to
give search engines more information about the content. We wondered how
the number of keywords related to the number of shares, given that this
data is several years old, and that used to be considered a part of
search engine optimization.

``` r
ggplot(training, aes(x = num_keywords,
                     y = shares)) +
  geom_count() +
  labs(title = "Number of Keywords vs. Shares",
       x = "Number of Keywords",
       y = "Number of Shares")
```

![](./tech_images/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->
A table of the above chart:

``` r
training %>% group_by(num_keywords) %>%
  summarise(n=n(),
            Avg=mean(shares),
            Sd=sd(shares),
            Median=median(shares),
            Min=min(shares),
            Max=max(shares))
```

    ## # A tibble: 9 × 7
    ##   num_keywords     n   Avg     Sd Median   Min    Max
    ##          <dbl> <int> <dbl>  <dbl>  <dbl> <dbl>  <dbl>
    ## 1            2     2 2550   1202.   2550  1700   3400
    ## 2            3    23 1785.  1119.   1600   119   4200
    ## 3            4   101 3651.  5640.   1800   775  47300
    ## 4            5   398 2890.  4400.   1700   548  52600
    ## 5            6   701 2904.  3851.   1700    64  48000
    ## 6            7  1047 2839.  3760.   1700   140  40100
    ## 7            8   933 2837.  4883.   1600    36  96100
    ## 8            9   799 3026.  5084.   1600   192  70200
    ## 9           10  1141 3746. 20092.   1900    86 663600

The plot depicts circles sized by the number of articles falling into
that category of number of keywords and number of shares. So you can how
many keywords are typically used, and also whether any specific number
of keywords tends to achieve more shares.

Before the modeling step, we took one final look at a few more of the
other variables we thought might be important in predicting number of
shares, based on the summaries above and our own experiences.

``` r
library(GGally)
training %>% 
  select(self_reference_avg_sharess, LDA_00, rate_negative_words, shares) %>%
  GGally::ggpairs()
```

![](./tech_images/exploratory%20graph-1.png)<!-- -->

Looking across the bottom row of graphs, we can see whether any
relationships between `shares` and another variable are evident.

## Modeling

Now we were ready to create some predictive models using the training
data.

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
    ##               (Intercept)           n_tokens_content  
    ##                   3092.60                     593.06  
    ##                 num_hrefs             num_self_hrefs  
    ##                    878.68                    -709.48  
    ##      average_token_length               num_keywords  
    ##                   -118.12                      59.29  
    ##                kw_max_max                 kw_avg_max  
    ##                    -24.19                    -232.10  
    ##                kw_max_avg                 kw_avg_avg  
    ##                   -442.73                     800.89  
    ## self_reference_min_shares         weekday_is_monday1  
    ##                     94.50                    -108.71  
    ##       weekday_is_tuesday1      weekday_is_wednesday1  
    ##                   -133.47                     158.77  
    ##      weekday_is_thursday1         weekday_is_friday1  
    ##                   -167.03                    -103.83  
    ##       global_subjectivity   title_sentiment_polarity  
    ##                   -102.64                     131.73

``` r
fullFit
```

    ## Linear Regression 
    ## 
    ## 5145 samples
    ##   18 predictor
    ## 
    ## Pre-processing: centered (17), scaled (17), remove (1) 
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 2572, 2573 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   9390.032  0.01027755  2475.099
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
    ##               (Intercept)           n_tokens_content  
    ##                   3092.60                     605.41  
    ##                 num_hrefs             num_self_hrefs  
    ##                    873.06                    -713.66  
    ##      average_token_length               num_keywords  
    ##                   -109.46                      61.01  
    ##                kw_max_max                 kw_avg_max  
    ##                    -30.90                    -230.21  
    ##                kw_max_avg                 kw_avg_avg  
    ##                   -441.22                     797.78  
    ## self_reference_min_shares        global_subjectivity  
    ##                     91.66                     -96.59  
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
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 2573, 2572 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   9099.087  0.01663601  2389.436
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
    ## 5145 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (44), scaled (44), ignore (13), remove (1) 
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 2573, 2572 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     8937.529  0.01383934  2349.939
    ##   2     8954.891  0.01548638  2375.853
    ##   3     8987.531  0.01533669  2410.382
    ## 
    ## RMSE was used to select the optimal model using the smallest value.
    ## The final value used for the model was mtry = 1.

### Boosted Tree

Boosted tree models is another tree-based method of prediction.
Although, unlike random forest models, boosted tree models grow
sequentially with each subsequent grown on a modified version of the
original data and the predictions updated as trees grow.

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
    ##      1 187411336.4289             nan     0.1000 -417036.6811
    ##      2 187315041.1750             nan     0.1000 -11989.7305
    ##      3 187219557.7922             nan     0.1000 -67475.8987
    ##      4 184575699.7356             nan     0.1000 -831074.7824
    ##      5 184853478.8149             nan     0.1000 -711046.0559
    ##      6 182655916.9405             nan     0.1000 -519267.9292
    ##      7 181124273.7981             nan     0.1000 -1213845.9987
    ##      8 181523499.9678             nan     0.1000 -1181914.9749
    ##      9 182000064.0750             nan     0.1000 -1498289.3653
    ##     10 180419285.0125             nan     0.1000 -1274277.1448
    ##     20 180897695.2189             nan     0.1000 -1040917.1238
    ##     40 173203397.0507             nan     0.1000 -1216717.7567
    ##     50 173166907.8161             nan     0.1000 -2251722.2083
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 187493025.3950             nan     0.1000 -879392.6589
    ##      2 187675667.6736             nan     0.1000 -673770.9103
    ##      3 184701981.6654             nan     0.1000 -338977.0446
    ##      4 182329889.0610             nan     0.1000 -304463.0095
    ##      5 180614445.7788             nan     0.1000 -1054695.9039
    ##      6 179569746.4614             nan     0.1000 -2675415.1326
    ##      7 179877369.2654             nan     0.1000 -1401151.0727
    ##      8 178105111.1356             nan     0.1000 -404944.9405
    ##      9 178348433.5643             nan     0.1000 -1050241.9081
    ##     10 178511972.7793             nan     0.1000 -816986.7548
    ##     20 170686447.3367             nan     0.1000 -1094660.3379
    ##     40 163718675.1623             nan     0.1000 -989856.3463
    ##     50 158001500.4582             nan     0.1000 -2361265.3716
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 190198768.4180             nan     0.1000 35792.5251
    ##      2 187114587.9506             nan     0.1000 -193345.6358
    ##      3 186974441.5255             nan     0.1000 -56526.5162
    ##      4 187197771.0288             nan     0.1000 -685145.5263
    ##      5 187088143.3443             nan     0.1000 25432.1914
    ##      6 184598243.9796             nan     0.1000 -617750.0507
    ##      7 184752113.6736             nan     0.1000 -587095.5879
    ##      8 185056615.9797             nan     0.1000 -871320.6202
    ##      9 183131010.0853             nan     0.1000 -1458678.5807
    ##     10 183483163.1438             nan     0.1000 -1263490.3052
    ##     20 171964559.3054             nan     0.1000 -1709516.2843
    ##     40 165281754.4977             nan     0.1000 -1041316.6495
    ##     50 162037723.5847             nan     0.1000 -1039269.1456
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 19321807.8640             nan     0.1000 30156.8619
    ##      2 19247458.8896             nan     0.1000 67434.1216
    ##      3 19182636.7307             nan     0.1000 -6902.3050
    ##      4 19103764.7590             nan     0.1000 46660.8677
    ##      5 19055790.6937             nan     0.1000 50652.1716
    ##      6 19009525.5686             nan     0.1000 42650.5108
    ##      7 18971641.2684             nan     0.1000  763.9546
    ##      8 18923601.0222             nan     0.1000 29358.7267
    ##      9 18893014.9236             nan     0.1000 10114.0185
    ##     10 18827947.1926             nan     0.1000 -26904.3883
    ##     20 18546357.4287             nan     0.1000 -6603.1313
    ##     40 18151639.9486             nan     0.1000 -7497.0984
    ##     50 18031356.8247             nan     0.1000 -8498.5778
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 19229996.5595             nan     0.1000 49397.1970
    ##      2 19080377.1241             nan     0.1000 87386.2731
    ##      3 18950998.7040             nan     0.1000 62214.9643
    ##      4 18828436.3338             nan     0.1000 -12837.2679
    ##      5 18728394.4506             nan     0.1000 30326.4250
    ##      6 18666034.1894             nan     0.1000 29476.9227
    ##      7 18587961.5422             nan     0.1000 -1625.7476
    ##      8 18521617.5522             nan     0.1000 68918.6571
    ##      9 18452011.7136             nan     0.1000 -39607.2300
    ##     10 18393644.5288             nan     0.1000 -15226.3526
    ##     20 17555542.9603             nan     0.1000 42481.0992
    ##     40 16354546.3815             nan     0.1000 -24058.5138
    ##     50 16067952.5133             nan     0.1000 -16368.2475
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 19250068.4252             nan     0.1000 134945.7245
    ##      2 19043058.5182             nan     0.1000 137112.5084
    ##      3 18844150.2123             nan     0.1000 65619.5964
    ##      4 18697639.4587             nan     0.1000 96514.2952
    ##      5 18549492.8541             nan     0.1000 40112.4571
    ##      6 18456967.4558             nan     0.1000 -23778.5859
    ##      7 18365791.1321             nan     0.1000 -10733.9253
    ##      8 18269699.6381             nan     0.1000  115.0864
    ##      9 18205749.5867             nan     0.1000 -12943.3655
    ##     10 18137639.0373             nan     0.1000 24139.0874
    ##     20 17153195.7090             nan     0.1000 23545.2499
    ##     40 15687999.7203             nan     0.1000 -16584.5415
    ##     50 15149686.7931             nan     0.1000 -60840.0776
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 104783348.7888             nan     0.1000 52464.4497
    ##      2 104611045.9187             nan     0.1000 130204.5066
    ##      3 102911709.9231             nan     0.1000 -73977.5590
    ##      4 101812712.2860             nan     0.1000 -318471.0412
    ##      5 101641375.1843             nan     0.1000 164120.1966
    ##      6 101456302.3006             nan     0.1000 153387.0481
    ##      7 101353538.2437             nan     0.1000 52009.3526
    ##      8 100517755.4348             nan     0.1000 -314467.0136
    ##      9 99813060.6864             nan     0.1000 -929962.2988
    ##     10 99941591.6014             nan     0.1000 -628839.3853
    ##     20 97022742.9991             nan     0.1000 -429280.7764
    ##     40 92092588.5944             nan     0.1000 91375.2024
    ##     50 89958604.9529             nan     0.1000 -677745.5398

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
    ##    0.01027755    0.01663601    0.01548638    0.01387625

``` r
# The best model based on the highest R-squared value is:
winner <- results[which.max(results)]
winner
```

    ##  Small Fit 
    ## 0.01663601

Above is our winning model for the tech channel based on it having the
highest R-Squared value of 0.016636! Our models are not doing that
great, and only explain a small percentage of the variation in number of
shares, but let’s not let that dampen our enthusiasm!

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
function for each channel in a list. That’s how the tech channel page
you’re reading was generated!

The code we used to automate the rendering is visible at the main page
for this project [here](https://cdonahu.github.io/st558-project2/).

Predicting Popularity of Articles in the lifestyle Channel
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

Next we will begin our look at one specific channel (lifestyle) by
subsetting the data.

``` r
channel <- channel # set = to channel when ready to automate

channelNow <- paste("data_channel_is_", channel, sep = "")

cData <- data[data[channelNow] == 1, ] # Extract rows of interest
```

We then split the lifestyle channel’s data into training and testing
sets (70% and 30%, respectively). We will only explore the training set,
and will keep the testing set in reserve to determine the quality of our
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

![](./lifestyle_images/bar%20by%20day%20of%20week-1.png)<!-- --> A table
of the above chart:

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
lifestyle channel’s number of shares across days of the week.

``` r
ggplot(training, aes(x = day, y = shares)) +
  geom_boxplot() + 
  geom_jitter(aes(color = day)) + 
  ggtitle("Boxplot for Shares")
```

![](./lifestyle_images/boxplot%20of%20shares%20by%20day%20of%20week-1.png)<!-- -->
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
    ##   day       chan          n   Avg     Sd Median   Min    Max
    ##   <fct>     <fct>     <int> <dbl>  <dbl>  <dbl> <dbl>  <dbl>
    ## 1 Monday    Lifestyle   226 4029. 13728.   1600   109 196700
    ## 2 Tuesday   Lifestyle   237 3659.  8313.   1500    93  81200
    ## 3 Wednesday Lifestyle   278 3217.  5793.   1600   128  73100
    ## 4 Thursday  Lifestyle   257 3600.  6351.   1600    28  56000
    ## 5 Friday    Lifestyle   189 2723.  4184.   1400   127  40400
    ## 6 Saturday  Lifestyle   135 4474.  5909.   2400   446  43000
    ## 7 Sunday    Lifestyle   150 3589.  4301.   2000   613  33100

The boxplot shows the distribution of the number of shares by the day of
the week. It can be a good way to see if we have any outliers with
**way** more shares than a typical article in this channel.

We wanted to look at these outliers–the lifestyle channel’s top articles
by shares, so we grabbed a list of those URLs, along with the number of
shares.

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

You can check out the article’s date and title within the URL and see
what some of the most-shared articles were in the lifestyle channel
during the time period studied.

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

    ## # A tibble: 149 × 7
    ##    title_sentiment_polarity     n    Avg    Sd Median   Min   Max
    ##                       <dbl> <int>  <dbl> <dbl>  <dbl> <dbl> <dbl>
    ##  1                   -1         6  8100  8093.   6000  1400 22300
    ##  2                   -0.8       2  1200     0    1200  1200  1200
    ##  3                   -0.738     1  1100    NA    1100  1100  1100
    ##  4                   -0.714     2  3095  3684.   3095   490  5700
    ##  5                   -0.707     1  1300    NA    1300  1300  1300
    ##  6                   -0.7       7  4800. 4754.   3300   401 13000
    ##  7                   -0.667     1  7200    NA    7200  7200  7200
    ##  8                   -0.625     1  3100    NA    3100  3100  3100
    ##  9                   -0.6       6  2714. 2297.   1750   882  7000
    ## 10                   -0.583     1 12300    NA   12300 12300 12300
    ## # … with 139 more rows

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

![](./lifestyle_images/Scatter%20plot%20of%20Article%20content%20length%20and%20images-1.png)<!-- -->
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

    ## # A tibble: 831 × 7
    ##    n_tokens_content     n   Avg    Sd Median   Min   Max
    ##               <dbl> <int> <dbl> <dbl>  <dbl> <dbl> <dbl>
    ##  1                0    14 6693. 6160.   4050  1100 23100
    ##  2               77     1  782    NA     782   782   782
    ##  3               81     1  490    NA     490   490   490
    ##  4               85     1 1300    NA    1300  1300  1300
    ##  5               91     2 2100   141.   2100  2000  2200
    ##  6               96     1 4400    NA    4400  4400  4400
    ##  7               97     1 1200    NA    1200  1200  1200
    ##  8               99     2 1600   141.   1600  1500  1700
    ##  9              101     1 2700    NA    2700  2700  2700
    ## 10              102     1  527    NA     527   527   527
    ## # … with 821 more rows

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

![](./lifestyle_images/Histogram%20of%20Keywords%20vs%20shares-1.png)<!-- -->
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

    ## # A tibble: 8 × 7
    ##   num_keywords     n   Avg     Sd Median   Min    Max
    ##          <dbl> <int> <dbl>  <dbl>  <dbl> <dbl>  <dbl>
    ## 1            3     5 5720   8727.   2100  1200  21300
    ## 2            4    31 2441.  3237.   1400   564  16300
    ## 3            5    65 2889.  3657.   1400    28  22300
    ## 4            6   160 3060.  5007.   1400   383  40400
    ## 5            7   230 3748.  6968.   1700   128  54200
    ## 6            8   262 4600. 14635.   1700    93 196700
    ## 7            9   253 3419.  4613.   1700   127  39900
    ## 8           10   466 3306.  4882.   1800   180  54900

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

![](./lifestyle_images/exploratory%20graph-1.png)<!-- -->

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
    ##                  3569.505                    783.124  
    ##                 num_hrefs             num_self_hrefs  
    ##                   287.173                   -299.390  
    ##      average_token_length               num_keywords  
    ##                  -405.737                   -144.394  
    ##                kw_min_max                 kw_max_max  
    ##                    -9.546                     23.413  
    ##                kw_avg_max                 kw_max_avg  
    ##                  -439.902                   -468.484  
    ##                kw_avg_avg  self_reference_min_shares  
    ##                   618.156                    685.362  
    ##        weekday_is_monday1        weekday_is_tuesday1  
    ##                    76.685                    -24.456  
    ##     weekday_is_wednesday1       weekday_is_thursday1  
    ##                  -274.617                    -55.793  
    ##        weekday_is_friday1        global_subjectivity  
    ##                  -340.010                    150.017  
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
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 736, 736 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared    MAE     
    ##   7688.056  0.00606908  3174.468
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
    ##                   3569.51                     764.41  
    ##                 num_hrefs             num_self_hrefs  
    ##                    283.22                    -289.89  
    ##      average_token_length               num_keywords  
    ##                   -430.97                    -151.74  
    ##                kw_min_max                 kw_max_max  
    ##                    -28.29                      38.35  
    ##                kw_avg_max                 kw_max_avg  
    ##                   -428.57                    -508.90  
    ##                kw_avg_avg  self_reference_min_shares  
    ##                    676.82                     686.85  
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
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 736, 736 
    ## Resampling results:
    ## 
    ##   RMSE      Rsquared     MAE     
    ##   7729.234  0.007054583  3252.575
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
    ## 1472 samples
    ##   58 predictor
    ## 
    ## Pre-processing: centered (45), scaled (45), ignore (13) 
    ## Resampling: Cross-Validated (2 fold) 
    ## Summary of sample sizes: 737, 735 
    ## Resampling results across tuning parameters:
    ## 
    ##   mtry  RMSE      Rsquared    MAE     
    ##   1     7469.894  0.01717033  3142.417
    ##   2     7488.209  0.01458830  3195.320
    ##   3     7524.816  0.01138422  3228.134
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
    ##      1 46312022.0303             nan     0.1000 -76419.4581
    ##      2 45556838.3716             nan     0.1000 -60638.7029
    ##      3 45059720.0685             nan     0.1000 -202032.3161
    ##      4 44451391.1701             nan     0.1000 53784.8778
    ##      5 44019563.2348             nan     0.1000 21817.1487
    ##      6 43759751.9264             nan     0.1000 -25898.5232
    ##      7 43614898.1257             nan     0.1000 -125166.0686
    ##      8 43241399.0979             nan     0.1000 -91947.6579
    ##      9 42990937.7674             nan     0.1000 -477901.5048
    ##     10 42735604.9633             nan     0.1000 -90664.7902
    ##     20 41776891.9298             nan     0.1000 -101017.6415
    ##     40 40285195.8969             nan     0.1000 -78686.1980
    ##     50 39801831.2620             nan     0.1000 -277426.5700
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 45698449.5844             nan     0.1000 -144490.1994
    ##      2 45201301.6513             nan     0.1000 343441.8134
    ##      3 44713248.2994             nan     0.1000 -44142.7450
    ##      4 44341692.5164             nan     0.1000 -59016.4568
    ##      5 44060419.8471             nan     0.1000 -46974.9552
    ##      6 43900576.2820             nan     0.1000 -127620.1001
    ##      7 43430832.7625             nan     0.1000 295124.3278
    ##      8 42874030.7110             nan     0.1000 -21451.4705
    ##      9 42564868.9489             nan     0.1000 149676.2950
    ##     10 42274910.0287             nan     0.1000 95271.7073
    ##     20 39525073.3284             nan     0.1000 -130214.4941
    ##     40 36159068.2658             nan     0.1000 -131099.7271
    ##     50 35081671.9692             nan     0.1000 -74513.3629
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 45594479.2298             nan     0.1000 62389.0601
    ##      2 45045904.9069             nan     0.1000 386300.4952
    ##      3 44523628.6579             nan     0.1000 -105778.6085
    ##      4 43609702.1120             nan     0.1000 -132274.2634
    ##      5 43391306.2018             nan     0.1000 -192302.2677
    ##      6 43127202.2929             nan     0.1000 115363.1311
    ##      7 42897513.9791             nan     0.1000 -123525.3922
    ##      8 42444212.6524             nan     0.1000 -146395.5209
    ##      9 41638698.0866             nan     0.1000 -40266.9420
    ##     10 41561822.3893             nan     0.1000 -181071.7720
    ##     20 37465744.9128             nan     0.1000 -170263.1272
    ##     40 32997499.7748             nan     0.1000 -252483.8556
    ##     50 31003650.4782             nan     0.1000 -75443.9784
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 74168119.9698             nan     0.1000 136144.1735
    ##      2 74062430.6102             nan     0.1000 29162.0946
    ##      3 73572776.3936             nan     0.1000 -27769.5267
    ##      4 73504088.8270             nan     0.1000 -31098.2030
    ##      5 73059801.1453             nan     0.1000 -314086.5297
    ##      6 72923683.6011             nan     0.1000 -34903.3910
    ##      7 71914692.5219             nan     0.1000 -319095.7523
    ##      8 71847654.4201             nan     0.1000 -71270.7893
    ##      9 71676765.6977             nan     0.1000 -520172.3530
    ##     10 71348707.1345             nan     0.1000 89844.4548
    ##     20 69628283.8459             nan     0.1000 -477448.6006
    ##     40 68046990.4196             nan     0.1000 -469202.2372
    ##     50 67051835.6637             nan     0.1000 -160423.2378
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 73850962.6063             nan     0.1000 135703.5123
    ##      2 73715898.8006             nan     0.1000 -149317.4379
    ##      3 73538934.7684             nan     0.1000 -81864.7561
    ##      4 73434718.4475             nan     0.1000 -65661.3583
    ##      5 73262977.9338             nan     0.1000 -184761.7170
    ##      6 73194633.7584             nan     0.1000 -125359.9145
    ##      7 72971868.9982             nan     0.1000 194636.4342
    ##      8 72926144.5098             nan     0.1000 -92754.7367
    ##      9 70875598.2585             nan     0.1000 -55045.0389
    ##     10 69582053.7148             nan     0.1000 -342901.8502
    ##     20 65604180.5923             nan     0.1000 -255989.9577
    ##     40 59816560.7603             nan     0.1000 -344843.0845
    ##     50 58206860.4741             nan     0.1000 -210797.2173
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 74301483.4859             nan     0.1000 571184.6413
    ##      2 73505101.6584             nan     0.1000 -82461.3755
    ##      3 72324839.0727             nan     0.1000 48202.0801
    ##      4 72182818.0738             nan     0.1000 -4778.1475
    ##      5 70879168.3155             nan     0.1000 -27595.6513
    ##      6 69576518.7877             nan     0.1000 -363211.3111
    ##      7 68811859.2832             nan     0.1000 -33687.1753
    ##      8 66989998.0408             nan     0.1000 -213881.7162
    ##      9 66699030.6847             nan     0.1000 -154885.7298
    ##     10 65936586.0723             nan     0.1000 -322866.3646
    ##     20 62105170.7965             nan     0.1000 -97895.3702
    ##     40 53661760.4174             nan     0.1000 -302437.4569
    ##     50 50297694.3169             nan     0.1000 -250703.8791
    ## 
    ## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
    ##      1 60301586.2462             nan     0.1000 69409.0175
    ##      2 59971811.5861             nan     0.1000 -35524.3475
    ##      3 59884455.8785             nan     0.1000 88844.6198
    ##      4 59467014.8341             nan     0.1000 -161825.7757
    ##      5 59275036.7684             nan     0.1000 104417.4994
    ##      6 59086337.2804             nan     0.1000 -87129.4504
    ##      7 58815497.3442             nan     0.1000 -23675.4791
    ##      8 58582811.4502             nan     0.1000 -220222.1273
    ##      9 58424299.5861             nan     0.1000 -47994.3657
    ##     10 58347212.9732             nan     0.1000 -61567.6569
    ##     20 57413468.8843             nan     0.1000 -134887.9683
    ##     25 57188650.6071             nan     0.1000 -159791.1251

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
    ##   0.006069080   0.007054583   0.017170334   0.005179363

``` r
# The best model based on the highest R-squared value is:
winner <- results[which.max(results)]
winner
```

    ## Random Forest 
    ##    0.01717033

Above is our winning model for the lifestyle channel based on it having
the highest R-Squared value of 0.0171703! Our models are not doing that
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
function for each channel in a list. That’s how the lifestyle channel
page you’re reading was generated!

The code we used to automate the rendering is visible at the main page
for this project [here](https://cdonahu.github.io/st558-project2/).

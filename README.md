
<!-- README.md is generated from README.Rmd. Please edit that file -->

# assignmentB2LucaStoeckl

This package has one function, `count_all_missing_by_group()`. You give
it a data frame and a grouping column, and it tells you how many NAs
every column has in each group. I wrote this kind of `group_by()` +
`summarize(across(...))` code again and again when looking at new data,
so now it is one call.

## Installation

Install version 0.1.0 from GitHub:

``` r
# install.packages("devtools")
devtools::install_github("UBC-STAT545-F2026/assignment-B2-Luca-Stoeckl", ref = "0.1.0")
```

## Usage

NAs per month in the `airquality` data:

``` r
library(assignmentB2LucaStoeckl)

count_all_missing_by_group(airquality, Month)
#> # A tibble: 5 × 6
#>   Month Ozone Solar.R  Wind  Temp   Day
#>   <int> <int>   <int> <int> <int> <int>
#> 1     5     5       4     0     0     0
#> 2     6    21       0     0     0     0
#> 3     7     5       0     0     0     0
#> 4     8     5       3     0     0     0
#> 5     9     1       0     0     0     0
```

Almost all NAs are in `Ozone`. June alone has 21 of them, so for Ozone
in June I would be careful.

Piping works too:

``` r
airquality |> count_all_missing_by_group(Month)
#> # A tibble: 5 × 6
#>   Month Ozone Solar.R  Wind  Temp   Day
#>   <int> <int>   <int> <int> <int> <int>
#> 1     5     5       4     0     0     0
#> 2     6    21       0     0     0     0
#> 3     7     5       0     0     0     0
#> 4     8     5       3     0     0     0
#> 5     9     1       0     0     0     0
```

The output is ungrouped by default. With `.groups = "keep"` it stays
grouped by `Month`:

``` r
count_all_missing_by_group(airquality, Month, .groups = "keep")
#> # A tibble: 5 × 6
#> # Groups:   Month [5]
#>   Month Ozone Solar.R  Wind  Temp   Day
#>   <int> <int>   <int> <int> <int> <int>
#> 1     5     5       4     0     0     0
#> 2     6    21       0     0     0     0
#> 3     7     5       0     0     0     0
#> 4     8     5       3     0     0     0
#> 5     9     1       0     0     0     0
```

Full documentation: `?count_all_missing_by_group`.

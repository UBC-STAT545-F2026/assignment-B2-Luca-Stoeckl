# Toy data, small enough to count the NAs by hand:
# group A has 2 rows, B and C one each. var1 has one NA (in B),
# var2 has one NA (in A).
small_tbl <- tibble::tribble(
  ~group, ~var1, ~var2,
  "A",    1,     NA,
  "A",    2,     "x",
  "B",    NA,    "y",
  "C",    3,     "z"
)

test_that("Output matches direct call to dplyr", {
  expect_equal(
    small_tbl |>
      dplyr::group_by(group) |>
      dplyr::summarize(dplyr::across(dplyr::everything(), ~ sum(is.na(.x))),
                       .groups = "drop"),
    count_all_missing_by_group(small_tbl, group)
  )

  expect_equal(
    small_tbl |>
      dplyr::group_by(group) |>
      dplyr::summarize(dplyr::across(dplyr::everything(), ~ sum(is.na(.x))),
                       .groups = NULL),
    count_all_missing_by_group(small_tbl, group, NULL)
  )
})

test_that("NA counts are right for every group", {
  res <- count_all_missing_by_group(small_tbl, group)
  expect_named(res, c("group", "var1", "var2"))
  expect_equal(nrow(res), 3)
  expect_equal(res$var1, c(0, 1, 0))
  expect_equal(res$var2, c(1, 0, 0))
})

test_that(".groups decides if the output stays grouped", {
  expect_false(dplyr::is_grouped_df(count_all_missing_by_group(small_tbl, group)))
  expect_true(dplyr::is_grouped_df(
    count_all_missing_by_group(small_tbl, group, .groups = "keep")
  ))
})

test_that("Checking error handling for .groups input", {
  # typo in .groups should fail, NULL should not
  expect_error(
    count_all_missing_by_group(datasets::airquality, Month, "kep"),
    "needs to be one of"
  )
  expect_no_error(
    count_all_missing_by_group(datasets::airquality, Month, NULL)
  )
})

test_that("A list instead of a data frame gives an error", {
  expect_error(
    count_all_missing_by_group(as.list(small_tbl), group),
    "must be a data frame"
  )
})

rm("small_tbl")

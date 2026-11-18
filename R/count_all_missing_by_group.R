#' @title Count missing values for all columns by group
#'
#' @description Counts the NAs in every column of `data`, separately for
#' each level of `group_col`. You get back one row per group: first the
#' group, then one column per variable with the number of NAs in it.
#'
#' @details Under the hood this is just [dplyr::group_by()] followed by
#' [dplyr::summarize()] with `across()`. I mostly use it as a first look at
#' a new data set, to see in which groups the data are missing before I
#' start the real analysis.
#'
#' @param data Data frame or tibble.
#' @param group_col Column to group by, written without quotes (for example
#'   `Month`).
#' @param .groups Should the output stay grouped? Goes straight to
#'   [dplyr::summarize()]. Default `"drop"` gives an ungrouped tibble,
#'   `"keep"` keeps it grouped by `group_col`. Allowed: `NULL`,
#'   `"drop_last"`, `"drop"`, `"keep"` and `"rowwise"`.
#'
#' @return Tibble with one row per level of `group_col`. First column are
#'   the groups, all other columns are the number of NAs for that column in
#'   this group.
#'
#' @examples
#' # NAs per month in airquality
#' count_all_missing_by_group(datasets::airquality, Month)
#'
#' # same thing with the pipe
#' datasets::airquality |> count_all_missing_by_group(Month)
#'
#' # output stays grouped by Month
#' count_all_missing_by_group(datasets::airquality, Month, .groups = "keep")
#'
#' @export
count_all_missing_by_group <- function(data, group_col, .groups = "drop") {
  # check the inputs first
  if (!is.data.frame(data)) {
    stop("`data` must be a data frame or tibble, not an object of class '",
         class(data)[1], "'.", call. = FALSE)
  }

  # NULL is allowed, otherwise only the options summarize() knows
  if (!is.null(.groups)) {
    allowed <- c("drop_last", "drop", "keep", "rowwise")
    if (!is.character(.groups) || length(.groups) != 1 ||
        !(.groups %in% allowed)) {
      stop("`.groups` needs to be one of NULL, \"drop_last\", \"drop\", ",
           "\"keep\" or \"rowwise\".", call. = FALSE)
    }
  }

  # count the NAs of every column inside each group
  data |>
    dplyr::group_by({{ group_col }}) |>
    dplyr::summarize(
      dplyr::across(dplyr::everything(), ~ sum(is.na(.x))),
      .groups = .groups
    )
}

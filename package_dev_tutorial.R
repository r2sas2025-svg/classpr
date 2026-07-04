

## ----compare-setup---------------------------------------------------------------------------------------------------------
# "development" version
adsl_dev <- data.frame(
  USUBJID = c("01", "02", "03", "04"),
  AGE     = c(34, 45, 29, 50)
)

# "QC" version — note subject 04 has AGE 51 instead of 50
adsl_qc <- data.frame(
  USUBJID = c("01", "02", "03", "04"),
  AGE     = c(34, 45, 29, 51)
)

adsl_dev
adsl_qc


## ----compare-identical-----------------------------------------------------------------------------------------------------
identical(adsl_dev, adsl_qc)   # FALSE, because AGE differs for subject 04


## ----compare-diffdf, eval=FALSE--------------------------------------------------------------------------------------------
install.packages("diffdf")   # one-time install
library(diffdf)

diffdf(adsl_dev, adsl_qc)


## ----compare-diffdf-save, eval=FALSE---------------------------------------------------------------------------------------
diff_output <- diffdf(adsl_dev, adsl_qc)
diff_output   # re-print the stored comparison anytime


## ----compare-arsenal, eval=FALSE-------------------------------------------------------------------------------------------
install.packages("arsenal")   # one-time install
library(arsenal)

summary(comparedf(adsl_dev, adsl_qc, by = "USUBJID"))


## ----messaging, error=TRUE-------------------------------------------------------------------------------------------------

message("Comparison of adsl_dev and adsl_qc completed. Differences identified.")
print("Please review the output for details on the discrepancies.")
warning("Ensure the data frames are correctly aligned and differences are expected.")
stop("Please investigate the discrepancies before proceeding.")


# simple function with message use case

## ----functions-syntax------------------------------------------------------------------------------------------------------
# name <- function(arguments) { body }
test <- function(x) {
  y <- x + 1
  print(y)
}

test(2)   # call the function with the argument 2

test_fun <- function(x) {
  if (x < 0) {
    warning("Input is negative. Proceeding with absolute value.")
    x <- abs(x)
  }
  message("Processing input: ", x)
  return(sqrt(x))
}

test_fun(-4)   # triggers a warning and a message
test_fun(9)    # just a message

read_sas <- function(file_path) {
  if (!file.exists(file_path)) {
    stop("File does not exist: ", file_path)
  }
  message("Reading SAS file: ", file_path)
  data <- haven::read_sas(file_path)
  message("Successfully read ", nrow(data), " rows from the SAS file.")
  return(data)
}

test <- read_sas("test/adsl.sas7bdat")   # triggers an error")
adsl <- read_sas("D:/R2SAS/r4sas/data/adam/adsl.sas7bdat")



## ----messaging-warnings, eval=FALSE----------------------------------------------------------------------------------------
warnings()   # show all recent warnings generated in this session


## ----files-list, eval=FALSE------------------------------------------------------------------------------------------------
dir()                                            # everything in the working directory
dir(path = ".", pattern = "\\.R$", full.names = FALSE)  # only .R files, names only
list.files()                                     # identical to dir()


## ----files-dirs, eval=FALSE------------------------------------------------------------------------------------------------
dir.create("comparison_results")        # make a new folder
dir.exists("comparison_results")        # TRUE if it now exists
unlink("comparison_results", recursive = TRUE)  # delete folder AND its contents


## ----files-sasfiles, eval=FALSE--------------------------------------------------------------------------------------------
sas_paths <- list.files(
  path      = "~/R_info/sas2R_s/data/sdtm",
  pattern   = "\\.sas7bdat$",   # only SAS transport files
  full.names = TRUE             # full paths, so read_sas can find them
)
sas_paths


## ----files-lapply, eval=FALSE----------------------------------------------------------------------------------------------
library(haven)

# Modern pipe style (|>): take the paths, then read each one
sdtm_lst <- list.files("~/R_info/sas2R_s/data/sdtm",
                       pattern = "\\.sas7bdat$", full.names = TRUE) |>
  lapply(haven::read_sas)

# Exactly equivalent, written without the pipe:
sdtm_lst <- lapply(
  list.files("~/R_info/sas2R_s/data/sdtm",
             pattern = "\\.sas7bdat$", full.names = TRUE),
  haven::read_sas
)


## ----files-names, eval=FALSE-----------------------------------------------------------------------------------------------
names(sdtm_lst) <- gsub(
  "\\.sas7bdat$", "",                       # remove the extension
  basename(list.files("~/R_info/sas2R_s/data/sdtm",
                      pattern = "\\.sas7bdat$", full.names = FALSE))
)


## ----files-access, eval=FALSE----------------------------------------------------------------------------------------------
sdtm_lst[[1]]              # first data set (by position)
sdtm_lst$ae                # the "ae" data set (by name)
sdtm_lst$ae[1, 1]          # row 1, column 1 of ae
sdtm_lst$ae[, "USUBJID"]   # the whole USUBJID column of ae


## ----files-info, eval=FALSE------------------------------------------------------------------------------------------------
# # Details (size, modified time, permissions) for every SAS file
file.info(list.files("~/R_info/sas2R_s/data/sdtm",
                     pattern = "\\.sas7bdat$", full.names = TRUE))

# Back up all SAS files to another folder
file.copy(
  from = list.files("~/R_info/sas2R_s/data/sdtm",
                    pattern = "\\.sas7bdat$", full.names = TRUE),
  to   = "~/R_info/sas2R_s/data/sdtm_backup"
)

file.exists("~/R_info/sas2R_s/data/sdtm_backup")   # confirm the backup exists


## ----functions-doc, eval=FALSE---------------------------------------------------------------------------------------------
# #' Test Function
# #'
# #' This function takes a numeric input and adds 1 to it.
# #'
# #' @param x A numeric value.
# #' @return The input value incremented by 1.
# #' @examples
# #' test(2)  # returns 3
# #' test(5)  # returns 6
# #' @export
# test <- function(x) {
#   y <- x + 1
#   print(y)
# }


## ----explore, eval=FALSE---------------------------------------------------------------------------------------------------
library(help = "dplyr")     # opens a list of dplyr's functions and data sets
ls()                        # list objects in YOUR current environment
library(dplyr)              # load the package so its functions are available
ls("package:dplyr")         # list every function dplyr exposes
objects("package:dplyr")    # same as ls() — list the package's objects


## ----explore-func, eval=FALSE----------------------------------------------------------------------------------------------
args(dplyr::filter)   # what arguments does filter()
formals(dplyr::filter) # show the formal arguments of filter()
body(dplyr::filter)   # show the actual source code of filter()


## ----git-config, eval=FALSE------------------------------------------------------------------------------------------------
library(usethis)
use_git_config(user.name = "My Username", user.email = "my_email@address.com")


## ----git-auth, eval=FALSE--------------------------------------------------------------------------------------------------
# usethis::edit_git_config()        # open the git config file to inspect/edit
# usethis::create_github_token()    # opens GitHub to mint a PAT
# library(gitcreds)
# gitcreds::gitcreds_set()          # paste the PAT to store it securely
#
# # lower-level alternative to set config directly:
# gert::git_config_set("user.email", "my_email@address.com")


## ----git-usethis, eval=FALSE-----------------------------------------------------------------------------------------------
# usethis::use_git()      # initialise the repo + make the first commit
# usethis::use_r("my_new_script")  # create R/my_new_script.R in a package
# usethis::use_github()   # create the GitHub repo and connect it to your project


## ----pkg-install, eval=FALSE-----------------------------------------------------------------------------------------------
# install.packages(c("devtools", "roxygen2", "usethis", "testthat"))


## ----pkg-doc, eval=FALSE---------------------------------------------------------------------------------------------------
# #' My First R Package
# #'
# #' This package contains functions for basic arithmetic operations.
# #'
# #' @docType package
# #' @name mypackage
# #' @keywords package
# #' @examples
# #' test(2)
# #' test(5)
# "_PACKAGE"


## ----pkg-loop, eval=FALSE--------------------------------------------------------------------------------------------------
# usethis::create_package("~/projects/mypackage")  # scaffold the package
# usethis::use_r("test")        # create R/test.R and paste your function there
# usethis::use_testthat()       # set up the tests/ folder
# usethis::use_test("test")     # create a matching test file
#
# devtools::document()   # build help pages + NAMESPACE from roxygen comments
# devtools::load_all()   # load the package for interactive testing
# devtools::test()       # run all tests
# devtools::check()      # full R CMD check — the quality gate
# devtools::install()    # install it into your R library


## ----rlang-load------------------------------------------------------------------------------------------------------------
library(rlang)
library(dplyr)


## ----rlang-core------------------------------------------------------------------------------------------------------------
# expr(): capture an expression WITHOUT running it
e <- expr(AGE + 1)
e
class(e)          # a "call" — a stored piece of code

# sym(): turn a string into a symbol (a bare name)
s <- sym("AGE")
s

# eval_tidy(): evaluate captured code inside a data context
eval_tidy(expr(AGE * 2), data = adsl_dev)

# as_label(): turn an expression/quosure back into a readable string
as_label(e)


## ----rlang-broken, error=TRUE----------------------------------------------------------------------------------------------
try({
avg_broken <- function(data, col) {
  summarise(data, avg = mean(col))   # looks for a column literally named "col"
}
avg_broken(adsl_dev, AGE)
})


## ----rlang-curly-----------------------------------------------------------------------------------------------------------
avg <- function(data, col) {
  summarise(data, avg = mean({{ col }}))
}
avg(adsl_dev, AGE)   # works: AGE flows through correctly


## ----rlang-enquo-----------------------------------------------------------------------------------------------------------
avg_classic <- function(data, col) {
  col <- enquo(col)                    # capture what the user typed
  summarise(data, avg = mean(!!col))   # inject it back into the dplyr call
}
avg_classic(adsl_dev, AGE)


## ----rlang-string----------------------------------------------------------------------------------------------------------
avg_str <- function(data, col) {
  summarise(data, avg = mean(.data[[col]]))
}
avg_str(adsl_dev, "AGE")   # note the quotes


## ----rlang-predicates------------------------------------------------------------------------------------------------------
is_symbol(sym("AGE"))          # TRUE — it's a symbol
is_call(expr(mean(AGE)))       # TRUE — it's a function call
is_quosure(quo(AGE))           # TRUE — quo() makes a quosure
is_atomic(1:5)                 # TRUE — a plain atomic vector
is_list(list(1, 2))            # TRUE
is_function(mean)              # TRUE
is_null(NULL)                  # TRUE
is_empty(list())               # TRUE — length zero
is_named(c(a = 1, b = 2))      # TRUE — the vector has names


## ----together, eval=FALSE--------------------------------------------------------------------------------------------------
# library(diffdf)
#
# compare_and_log <- function(dev, qc, out_dir = "comparison_results") {
#   # 1. make an output folder if needed
#   if (!dir.exists(out_dir)) dir.create(out_dir)
#
#   # 2. quick gate
#   if (identical(dev, qc)) {
#     message("Data sets are identical — nothing to report.")
#     return(invisible(NULL))
#   }
#
#   # 3. detailed comparison
#   result <- diffdf(dev, qc)
#
#   # 4. communicate + save
#   warning("Differences found — review before proceeding.")
#   saveRDS(result, file.path(out_dir, "diff_result.rds"))
#   message("Comparison complete. Report saved to ", out_dir)
#
#   invisible(result)
# }
#
# compare_and_log(adsl_dev, adsl_qc)


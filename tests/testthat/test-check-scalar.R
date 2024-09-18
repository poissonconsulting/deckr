test_that("check_scalar length 1 if value undefined", {
  x <- 2
  expect_identical(check_scalar(x), 2)
})

test_that("check_scalar tests vector", {
  x <- 2
  expect_error(check_scalar(x, NULL), "value must be a vector")
  expect_error(check_scalar(list(x), 1), "list[(]x[)] must be a scalar")
  expect_error(check_scalar(1, list(x)), "value must be a vector")
})

test_that("check_scalar tests rows", {
  x <- 2
  expect_identical(check_scalar(x, 1), x)
  expect_error(check_scalar(c(1,1), 1), "c[(]1[,] 1[)] must be a scalar")
  expect_error(check_scalar(character(0), 1), "character[(]0[)] must be a scalar")
})

test_that("check_scalar tests for classes", {
  x <- 1L
  expect_error(check_scalar(x, 1),
               "x must be of class 'numeric'")
  expect_error(check_scalar(x, TRUE),
               "x must be of class 'logical'")
  expect_identical(check_scalar(x, integer()), x)
})

test_that("check_scalar tests for missing values", {
  y <- 1
  expect_identical(check_scalar(y, 1), y)
  expect_identical(check_scalar(y, numeric()), y)
  expect_identical(check_scalar(y,c(3,NA)), y)
  expect_error(check_scalar(y, as.numeric(NA)),
               "y can only include missing values")

  z <- as.numeric(NA)
  expect_error(check_scalar(z, 1), "z cannot include missing values")
  expect_identical(check_scalar(z, numeric()), z)
  expect_identical(check_scalar(z, c(3,NA)), z)
  expect_identical(check_scalar(z, as.numeric(NA)), z)
})

test_that("check_scalar tests for range", {
  x <- 1
  expect_error(check_scalar(x, c(4, 1.01)), "x must lie between 1.01 and 4")

  y <-2
  expect_identical(check_scalar(y, c(4, 1.01)), y)
})

test_that("check_scalar tests for specific values", {
  x <- 1
  expect_error(check_scalar(x, c(0, 4, 5)), "x must only include the permitted values 0, 4 and 5")
  expect_error(check_scalar(x, c(5, 5, 5)), "x must only include the permitted value 5")
  expect_error(check_scalar(x, c(0, 2, 3, 4, 5, 6)), "x includes non-permitted values")
  expect_identical(check_scalar(x, c(1, 4, 5)), x)
})

test_that("check_scalar works with logical vectors", {
  data <- TRUE
  expect_identical(check_scalar(data, c(TRUE, TRUE)), data)
  expect_error(check_scalar(data, c(FALSE, FALSE)), "data can only include FALSE values")
})

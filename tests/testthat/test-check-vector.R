test_that("check_vector errors if value undefined", {
  x <- 2
  expect_error(check_vector(x), "argument \"value\" is missing, with no default")
})

test_that("check_vector tests vector", {
  x <- 2
  expect_error(check_vector(x, NULL), "value must be a vector")
  expect_error(check_vector(NULL, NULL, min_length = 0), "NULL must be a vector")
  expect_error(check_vector(list(x), 1), "list[(]x[)] must be a vector")
  expect_error(check_vector(1, list(x)), "value must be a vector")
})

test_that("check_vector works no rows", {
  x <- numeric()
  expect_identical(x, check_vector(x, 1, min_length = 0))
  expect_identical(x, check_vector(x, as.numeric(NA), min_length = 0))
  expect_identical(x, check_vector(x, c(1,NA), min_length = 0))
  expect_identical(x, check_vector(x, c(4,3), min_length = 0))
  expect_identical(x, check_vector(x, c(4,3,5), min_length = 0))
  expect_identical(x, check_vector(x, c(4,3,5, NA), min_length = 0))

  expect_error(check_vector(x, 1L, min_length = 0),
               "x must be of class 'integer'")
  expect_error(check_vector(x, c(1L,2L), min_length = 0),
               "x must be of class 'integer'")
})

test_that("check_vector tests rows", {
  x <- 2
  expect_identical(check_vector(x, 1), x)
  expect_error(check_vector(x, 1, min_length = 3), "x must be at least of length 3")
  expect_error(check_vector(x, 1, min_length = 0, max_length = 0), "x must not be longer than 0")
})

test_that("check_vector tests for classes", {
  x <- 1L

  expect_error(check_vector(x, 1),
               "x must be of class 'numeric'")
  expect_error(check_vector(x, TRUE),
               "x must be of class 'logical'")
  expect_identical(check_vector(x, integer()), x)
})

test_that("check_vector tests for missing values", {
  x <- c(1,2, NA)
  expect_error(check_vector(x, 1),
               "x cannot include missing values")
  expect_identical(check_vector(x, numeric()), x)
  expect_identical(check_vector(x, c(3,NA)), x)
  expect_error(check_vector(x, as.numeric(NA)),
               "x can only include missing values")

  y <- c(1,2)
  expect_identical(check_vector(y, 1), y)
  expect_identical(check_vector(y, numeric()), y)
  expect_identical(check_vector(y,c(3,NA)), y)
  expect_error(check_vector(y, as.numeric(NA)),
               "y can only include missing values")

  z <- as.numeric(NA)
  expect_error(check_vector(z, 1), "z cannot include missing values")
  expect_identical(check_vector(z, numeric()), z)
  expect_identical(check_vector(z, c(3,NA)), z)
  expect_identical(check_vector(z, as.numeric(NA)), z)
})

test_that("check_vector tests for range", {
  x <- 1
  expect_error(check_vector(x, c(4, 1.01)), "x must lie between 1.01 and 4")

  y <-2
  expect_identical(check_vector(y, c(4, 1.01)), y)
})

test_that("check_vector tests for specific values", {
  x <- 1
  expect_error(check_vector(x, c(0, 4, 5)), "x must only include the permitted values 0, 4 and 5")
  expect_error(check_vector(x, c(5, 5, 5)), "x must only include the permitted value 5")
  expect_error(check_vector(x, c(0, 2, 3, 4, 5, 6)), "x includes non-permitted values")
  expect_identical(check_vector(x, c(1, 4, 5)), x)
})

test_that("check_vector works with logical vectors", {
  data <- TRUE
  expect_identical(check_vector(data, c(TRUE, TRUE)), data)
  expect_error(check_vector(data, c(FALSE, FALSE)), "data can only include FALSE values")
})

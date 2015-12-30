<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Travis-CI Build Status](https://travis-ci.org/poissonconsulting/deckr.svg?branch=master)](https://travis-ci.org/poissonconsulting/deckr)

deckr
=====

This README is the outline for a possible R package to check the names, classes and values of columns in objects inheriting from class `data.frame`.

The Problem
-----------

Most of the packages I write need to check that one or more user supplied data frames have the correct type of data in them before proceeding to analysis or plotting. If they don't then I need to provide a helpful error message so the user is able to correct the input data.

In short, I need a function that is able to input a data frame and test whether or not it includes certain named columns of particular classes that may or may not contain particular values including missing values. If not it should return an informative error message. Otherwise it should return the original data frame so the function can be used in piping sequences.

To the best of my knowledge an elegant solution to this problem does not currently exist. **If you think it does please let me know right away by filing an [issue](https://github.com/poissonconsulting/deckr/issues)**.

An Elegant Solution?
--------------------

It seems to me that a function that takes as its two arguments the input data frame and a named list of vectors specifying the possible values would fit the bill. Let us call the function `deck` (short for `data_checker`). The names of the list elements would specify those columns that need to appear in the data.frame while the classes of the vectors would specify the classes of the columns.

### Checking Columns and Classes

Thus, to specify that x should contain a column called `col1` of class integer the call would be one of the following because with a single value only its class matters.

    deck(x, list("col1" = 1L))
    deck(x, list("col1" = 2L))

To specify that x should not contain a column called `col1` the call is just

    deck(x, list("col1" = NULL))

and to specify that it can contain a column `col1` that can be integer or numeric values the call would be

    deck(x, list("col1" = 3L, "col1" = NULL, "col1" = 9))

### Checking Missing Values

To specify that a column can include missing values just add an `NA` to the vector.

    deck(x, list("col1" = c(1L, NA)))

### Checking Ranges

And to indicate that it must fall within a range use two non-missing values (the following code tests for counts).

    deck(x, list("col1" = c(0L, .Machine$integer.max)))

### Checking Specific Values

If particular values are required then specify them as vector of three or more missing values

    deck(x, list("col1" = c(0L, 1L, 4L)))

The above code test that `col1` contains just the counts 0, 1 and 4.

### Numeric, Date and Logical Classes

Missing values, ranges and specific values would work the same for integer, numeric, and Date vectors. With logical values two and three or more non-missing values would behave identically, i.e., use `deck(x, list("col1" = c(TRUE, TRUE)))` to indicate only `TRUE` values.

### Character Class

To specify that `col1` must be a character vector use

    deck(x, list("col1" = "b"))

while the following requires that the values match both character elements which are treated as regular expressions

    deck(x, list("col1" = c("^//d", ".*")))

with three or more non-missing character elements each value in `col1` must match at least one of the elements which are treated as regular expressions.

### Factor Class

To indicate that `col1` should be a factor use

    deck(x, list("col1" = factor("c")))

while the following specifies that `col1` should be a factor that includes the factor levels `b` and `c` (in any order)

    deck(x, list("col1" = factor("c", "b")))

The following specifies that `col1` must be a factor with levels `c("b", "c", "f")`

    deck(x, list("col1" = factor("c", "b", "f")))

Feedback
--------

I currently think the above outlines a very intuitive solution for checking basic properties of data frames. Consider the following example

    deck(df, list("Count" = c(0L, .Machine$integer.max), 
                 "Comments" = NULL, 
                 "LocationX" = c(NA, 2345, 1012),
                 "LocationX" = NULL))

it states that `df` should have column `Count` of non-missing counts, should not have a column `Comments` and can include a column `LocationX` with missing values between 1012 and 2345.

This would make an excellent three month project for a talented student.

I would really appreciate your feedback in the form of an [issue](https://github.com/poissonconsulting/deckr/issues).

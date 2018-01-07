context("configure-file")

test_that("configure_file expands variables in files", {

    source <- "resources/example.txt.in"
    target <- "resources/example.txt"

    configure_define(VARIABLE = "VALUE")
    configure_file(source)

    expect_true(file.exists(target))
    contents <- readLines(target)
    expect_equal(contents, "VALUE")
})

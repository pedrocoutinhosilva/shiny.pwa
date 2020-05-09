context("Templates")

test_that("Apply Template", {
  expect_equal(
    applyTemplate("this is a <<field>>.", list(field = "test")),
    "this is a test."
  )
})

test_that("Get Template Path", {
  expect_true(endsWith(getTemplate("test"), "test"))
})

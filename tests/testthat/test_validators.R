context("Validators")

invisible(capture.output(
  test_that("validate Domain", {
    # HTTP is not a valid protocol
    expect_error(validateDomain("http://mydomain.com"))

    # Output always contains https protocol and no forward slash sufix
    expect_equal(validateDomain("mydomain.com"), "https://mydomain.com")
    expect_equal(validateDomain("https://mydomain.com"), "https://mydomain.com")
    expect_equal(validateDomain("https://mydomain.com/"), "https://mydomain.com")
  })
))

invisible(capture.output(
  test_that("validate Location", {
    expect_equal(validateLocation(""), "/")
    expect_equal(validateLocation("location"), "/location/")
    expect_equal(validateLocation("/location"), "/location/")
    expect_equal(validateLocation("location/"), "/location/")
    expect_equal(validateLocation("/location/"), "/location/")
  })
))

invisible(capture.output(
  test_that("validate Icon", {
    expect_true(endsWith(validateIcon(NULL), "/pwa/icon.png"))
    expect_true(endsWith(validateIcon(""), "/pwa/icon.png"))

    expect_error(validateIcon("icon"))
    expect_error(validateIcon("icon.svg"))
    expect_error(validateIcon("icon.sample"))

    expect_true(endsWith(validateIcon("icon.png"), "/icon.png"))
  })
))

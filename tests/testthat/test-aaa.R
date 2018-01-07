context("setup")

files <- list.files("resources", full.names = TRUE)
targets <- grep("[.]in$", files, value = TRUE, invert = TRUE)
unlink(targets)

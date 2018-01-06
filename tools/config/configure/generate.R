source("R/utils.R")

# write shared components
shared <- list.files("R", full.names = TRUE)
concatenate_files(shared, "tools/config/shared.R")

# copy the generated tools to inst
for (file in c("configure.R", "cleanup.R", "shared.R")) {
    configure_file(
        file.path("tools/config", file),
        file.path("inst/resources/tools/config", file))
}

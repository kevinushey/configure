source("R/utils.R")

# write shared components
shared <- c("R/utils.R", "tools/config/resources/run.R")
concatenate_files(shared, "tools/config/shared.R")

# copy to inst
paths <- c(
	"tools/config/shared.R",
	"configure",
	"configure.win",
	"cleanup",
	"cleanup.win"
)

lapply(paths, function(path) {
	configure_file(path, file.path("inst/resources", path))
})

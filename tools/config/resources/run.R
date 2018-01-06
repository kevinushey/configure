# extract path to install script
args <- commandArgs(TRUE)
target <- args[[1]]
path <- sprintf("tools/config/%s.R", target)
if (!file.exists(path))
    stop("no file available at path '", path, "'")

# report start of execution
package <- Sys.getenv("R_PACKAGE_NAME", unset = "<unknown>")
fmt <- "* preparing to %s '%s' ..."
message(sprintf(fmt, target, package))

# execute the requested script
source_file(path)

# report end of execution
fmt <- "* finished %s for '%s'"
message(sprintf(fmt, target, package))

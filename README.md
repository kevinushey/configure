# configure

Configure R packages for installation with R.

## Motivation

Writing portable package `configure` scripts is painful. It's even more painful
because you often need to do it twice: once for Unix, and once for Windows (with
`configure.win`). And the same tools you might use to generate a `configure`
script (say, [autoconf](https://www.gnu.org/software/autoconf/autoconf.html))
might not be available when you want to write `configure.win`. This package
seeks to solve that problem by:

- Allowing you to configure your R package directly with R; and
- Providing a set of functions for accomplishing common configuration tasks.

## Usage

First, prepare your package by invoking:

```r
configure::use_configure()
```

This will write out a few files to your package's directory.

- configure
- configure.win
- cleanup
- cleanup.win
- tools/config/shared.R

The `configure{.win}` and `cleanup{.win}` scripts invoke the `shared.R` script,
using command line arguments to route to either a user-defined configure script
at `tools/config/configure.R`, or a cleanup script at `tools/config/cleanup.R`.

## Understanding configure and cleanup

Here's a rough timeline of what happens when R attempts to install your package
from a source tarball. When `R CMD INSTALL` is invoked (either directly by the
user, or perhaps from a helper function like `install.packages()` or one of
the `devtools::install_*()` functions), the following occurs:

- If the `--preclean` option was supplied, the `cleanup{.win}` script will
  be run. This is off by default.

- Next, unless `--no-configure` was passed, the `configure{.win}` script is run,
  to prepare the package for installation.

- Finally, if installation was invoked with `--clean`, the `cleanup{.win}`
  script will be run.
  
Note that the default behavior is _not_ to run `cleanup{.win}` during install
(one must explicitly request it from R); however, CRAN compliance checks will
still ensure that you do clean up artefacts generated by `configure{.win}`. In
other words, if you write a `configure{.win}` script, you almost certainly need
a `cleanup{.win}` script as well -- hence why this package generates both.
 
### Configure

The main goal during the configure stage is to generate, or modify, files
for compilation or installation on the current platform. The primary mechanism
through which this is accomplished is through translating `.in` files, with
the `configure_file()` helper function.

```r
configure_file("src/Makevars.in", "src/Makevars")
```

This will substitute variables of the form `@VAR@` with the associated
definition discovered in the configuration database. By default, the
configuration database is empty, but you can populate it using the
`configure_define()` function. For example, you might use the following
to define the value for a variable called `STDVER`:

```r
define(STDVER = "c++11")
```

If you want to read R's configuration -- for example, to discover what C
compiler should be used for compilation, you can use the `read_r_config()`
function:

```r
read_r_config("CC", "CXX")
```

## Cleanup

The cleanup stage's primary purpose is to remove files created during the
configure stage. For example, we might want to remove the generated
Makevars files generated earlier:

```r
unlink("src/Makevars")
```

## Automatic Configuration

The `configure` package tries to perform some of the most common configuration
and cleanup steps automatically, to avoid overburdening the user when possible.
In particular, all `.in` files discovered within the root, `R/`, and `src/`
folders are automatically configured and cleaned up as required. This implies
that, in many cases, it should be sufficient for a user to write a `configure.R`
script whose only purpose is to define configuration variables.

As an example, the `configure` package uses itself to manage configuration.
The file
[R/zzz.R.in](https://github.com/kevinushey/configure/blob/master/R/zzz.R.in)
contains the single line:

```r
.PACKAGE <- "@PACKAGE_NAME@"
```

And the file at
[tools/config/configure.R](https://github.com/kevinushey/configure/blob/master/tools/config/configure.R)
contains only:

```r
define(PACKAGE_NAME = "configure")
```

and the existing machinery automatically generates and cleans up `zzz.R`
as appropriate.

This automatic configuration can be disabled by setting the R option
`configure.common` to `FALSE`.

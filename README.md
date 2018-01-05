# configure

Configure R packages for installation with R.

## Motivation

Writing portable package `configure` scripts is painful. It's even more painful because
you need to do it twice: once for Unix, and once for Windows (with `configure.win`). And
the same tools you might use to write `configure` might not be available when you want to
write `configure.win`. This package seeks to solve that problem by allowing you to
configure your R package with R code.

## Usage

First, prepare your package by invoking:

```r
configure::use_configure()
```

This will write out a few files:

- configure
- configure.win
- R/config/configure.R

The `configure` and `configure.win` scripts ask R to source the `R/config/configure.R`
file. This script configures your package with these steps:

- R scripts within the `R/config/scripts` are sourced,
- If a function called `configure()` is defined by one of those scripts, it is
  then invoked. This function should return a 'config database', as a list of
  named values, mapping variables to their replacements.
- All `.in` files are then 'configured' -- any instances of `@VAR@` in those files are
  then replaced with the value of `VAR` in the aforementioned `config` database.

The user-defined `configure()` script should primarily be used to:

- Read R configuration through the `read_config()` function,
- Modify environment variables to be used during configuration,
- Generate files as required for installation on the current platform.

The `config` object returned by `configure()` can be used to modify how `.in`
files are configured. This is primarily useful for R packages containing e.g.
a `Makevars.in`, where compilation options might differ from platform to platform.

Note that these files are standalone -- the `configure` package need not be present when
your package is configured; the `configure.R` script contains all of the functions
necessary to run.


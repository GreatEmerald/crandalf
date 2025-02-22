# markdown is for xfun::rev_check() to generate the check summary in HTML;
# rmarkdown is installed just in case the package has R Markdown vignettes
pkgs = c('markdown', 'rmarkdown', 'strucchangeRcpp', 'zoo', 'forecast', 'Rcpp', 'Rdpack')
for (i in pkgs) {
  if (!requireNamespace(i, quietly = TRUE)) install.packages(i)
}

pkgs = readLines('latex-packages.txt')
xfun::rev_check('PKG_NAME', src = 'package')
pkgs = setdiff(tinytex::tl_pkgs(), pkgs)
if (length(pkgs)) message(
  'These new packages were installed in TinyTeX during the checks: ',
  paste(pkgs, collapse = ' ')
)

if (file.exists('00check_diffs.html')) {
  system('curl -F "file=@00check_diffs.html" https://file.io')
  r = '[.]Rcheck2$'
  pkgs = gsub(r, '', list.files('.', r))
  stop(
    'Some reverse dependencies may be broken by the dev version of PKG_NAME: ',
    paste(pkgs, collapse = ' ')
  )
}

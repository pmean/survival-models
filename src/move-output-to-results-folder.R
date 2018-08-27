project_name <- "survival-models"
src <- paste("~", project_name, "src", sep="/")
results <- paste("~", project_name, "results", sep="/")
html_list <- list.files(src, pattern="*html")
for (i in html_list) {
  file.copy(paste(src, i, sep="/"), results, overwrite=TRUE)
  file.remove(paste(src, i, sep="/"))
}
cat("\n\n", length(html_list), " file(s) moved: ", paste(html_list, collapse=", "), sep="")

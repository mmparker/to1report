



# Strings ain't factors
options(stringsAsFactors = FALSE)


# Load knitr and markdown to generate the reports
library(knitr)
library(markdown)

# Knit 
knit("qa_report.rmd")

markdownToHTML(file = "qa_report.md",
               output = "qa_report.html",
               stylesheet = file.path("..", "css", "tbesc_report.css"))



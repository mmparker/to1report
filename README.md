
### TO 1 Site Report

This report covers enrollment progress, participant demographics, 
testing results, and a variety of data quality checks.


Here's the overview of how to make the report work:
 - Download the files in this repository
 - Install R and the required packages
 - Use the package `to1check` to generate cleaned data
 - Write a `local_facts.csv` file.
 - Run `knit.r` to generate the report.
 - View the qa_report.html file.


### Download Files

You'll need three files to make this report work:
 - qa_report.rmd: an R-Markdown file that contains the report template.
 - knit.r: a simple R script that converts the .rmd file to HTML
 - local_facts.csv: a .csv file containing key information about your site

The first two are included in this repository; you'll need to make the
third yourself. See local_facts.csv below.



    
### Install R and Packages

You'll also need to install R (http://cran.r-project.org/) and a few of its
packages. After you've installed R, open it and type this into the console:
```
install.packages(c("knitr", "to1check", "plyr", "xtable", "lubridate"))
```


### Use the package `to1check` to generate cleaned data

In DMS, download all of the Data Extract tables into a single folder.
There's a function called `clean_to1` in the `to1check` package that will
convert all of these .csv files into a nice, clean R list. Run that function
(and remember where the output goes!)


### Create a local_facts.csv

local_facts.csv is just a .csv file that looks like this:

```
site,enroll_target,period_start,period_end,datapath
Denver,500,2012-11-01,2013-08-30,"G:\StrategicArea\TB_Program\Research\TBESC 2\Data\cleaned\to1clean.rdata"
```

That is: columns named `site`, `enroll_target`, `period_start`, `period_end`, 
and `datapath`.
 - `site`: the name of your site, e.g., "Denver", "Maricopa County", and so on.
 - `enroll_target`: an integer indicating how many participants you aim to
    enroll during the period in question
 - `period_start`: the start date of the period in question, in "YYYY-MM-DD" 
    format
 - `period_end`: the end date of the period in question, in "YYYY-MM-DD" format
 - `datapath`: the path to your cleaned data - see the `to1check` package for R    (https://github.com/mmparker/to1check)

Save this into the same directory as `qa_report.rmd` and `knit.r`.




### Run `knit.r` to generate the report.

The simplest thing to do is just open R, then open knit.r and paste its
commands into the R console.



### View the qa_report.html file.

knit.r converts qa_report.rmd into qa_report.html, which you should be able
to view in any browser, send in emails, etc.

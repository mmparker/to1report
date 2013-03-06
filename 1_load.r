# This script coordinates the execution of all of the other data QA functions.



# Strings ain't factors
options(stringsAsFactors = FALSE)



# Load the most recent TO 1 data into a list
extracts <- list.files("G:\\StrategicArea\\TB_Program\\Research\\TBESC 2\\Data",
                       pattern = "*.csv",
                       full.names = TRUE)

originals <- lapply(extracts, read.csv)


# Rename them
names(originals) <- tolower(gsub(x = basename(extracts),
                                 pattern = "^Denver_V(\\w*).*\\.csv",
                                 replace = "\\1")
)


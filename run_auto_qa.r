# This script coordinates the execution of all of the other data QA functions.



# Strings ain't factors
options(stringsAsFactors = FALSE)



# Load the most recent TO 1 data into a list
load("G:\\StrategicArea\\TB_Program\\Research\\TBESC 2\\Data\\cleaned\\to1_cleaned.rdata")


# Set a directory for the output
outdir <- "G:\\StrategicArea\\TB_Program\\Research\\TBESC 2\\QA\\auto_qa\\problems"


# Temporary name for the cleaned data - match arg names before functions
# become real functions
cleanlist <- cleaned

# Test-related checks
tst_check(cleanlist = cleaned, outdir = outdir)


# Patient status checks
closed_check(cleanlist = cleaned, outdir = outdir)

# This script coordinates the execution of all of the other data QA functions.


# Strings ain't factors
options(stringsAsFactors = FALSE)

library(to1check)


# Load the most recent TO 1 data into a list
load("G:\\StrategicArea\\TB_Program\\Research\\TBESC 2\\Data\\cleaned\\to1clean.rdata")


# Set a directory for the output
outdir <- "G:\\StrategicArea\\TB_Program\\Research\\TBESC 2\\QA\\auto_qa\\problems"



# Test-related checks
tst_check(cleanlist = to1clean, outdir = outdir)
test_check(cleanlist = to1clean, outdir = outdir)


# Patient status checks
closed_check(cleanlist = to1clean, outdir = outdir)

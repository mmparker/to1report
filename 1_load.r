# This script coordinates the execution of all of the other data QA functions.



# Strings ain't factors
options(stringsAsFactors = FALSE)



# Load the most recent TO 1 data into a list
extracts <- list.files("G:\\StrategicArea\\TB_Program\\Research\\TBESC 2\\Data",
                       pattern = "*.csv",
                       full.names = TRUE)

originals <- lapply(extracts, read.csv)


# Rename the entries in originals for ease of reference
names(originals) <- tolower(gsub(x = basename(extracts),
                                 pattern = "^Denver_V(\\w*).*\\.csv",
                                 replace = "\\1")
)


# Set up a "cleaned" list to preserve originals for comparisons
cleaned <- originals



################################################################################
# Rename variables to something actually useful
################################################################################


# Rename MASTER (ie questionnaire) variables
# PC_1 indicates a patient's enrollment status
names(originals$master)[names(originals$master) %in% "PC_1"] <- "status"

# ... whereas Status indicates *that form's* status (draft, submitted, etc)
# To me, much more intuitive for PC_1 to be "status" and Status to be
# "form_status"
names(originals$master)[names(originals$master) %in% "Status"] <- "form_status"




# Rename TST variables
names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_1_AND_2"] <- "dt_placed"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_2_Reason"] <- "reason_2"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_3"] <- "placed_by"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_3_Reason"] <- "reason_3"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_4"] <- "ppd_mfg"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_5"] <- "ppd_lot"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_6"] <- "date_read"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_7"] <- "time_read"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_6_AND_7"] <- "dt_read"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_6_Reason"] <- "reason_6"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_7_Reason"] <- "reason_7"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_8"] <- "tst_mm"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_9"] <- "tst_interp"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_10"] <- "blistering"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_11"] <- "read_by"

names(originals$skintest)[names(originals$skintest) 
                          %in% "TST_11_Reason"] <- "reason_11"


# Rename QFT variables



# Rename TSPOT variables







# Convert datetimes to POSIXct
originals$skintest$dt_placed <- as.POSIXct(originals$skintest$dt_placed,
                                           format = "%d%B%Y:%H:%M:%S.000")

originals$skintest$dt_read <- as.POSIXct(originals$skintest$dt_read, 
                                         format = "%d%B%Y:%H:%M:%S.000")




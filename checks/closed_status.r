
# This function that individuals who had a negative TST, QFT, and TSPOT
# were closed, and that closed individuals have sufficient documentation of
# why they're closed (which I think is just trip-neg and completion of two
# of FU


closed_check <- function(cleanlist, outdir) {

    # Get study IDs and status
    parts <- subset(cleanlist$master, select = c("StudyId", "status"))


    ########################################################################### 
    # Identify the triple-negatives
    ########################################################################### 

    # Participants can have multiple tests, so I'll need to expand this
    # to accommodate that...
    parts$tst_neg <- parts$StudyId %in% 
        cleanlist$skintest$StudyId[cleanlist$skintest$result %in% "Negative"]

    parts$qft_neg <- parts$StudyId %in% 
        cleanlist$qft$StudyId[cleanlist$qft$result %in% 
                              c("Negative", "Indeterminate")]

    parts$tspot_neg <- parts$StudyId %in% 
        cleanlist$tspot$StudyId[cleanlist$tspot$result %in% 
                                c("Negative", "Borderline", "Invalid")]

    parts$trip_neg <- with(parts, tst_neg & qft_neg & tspot_neg)



    ########################################################################### 
    # Identify any triple-negative participants who aren't closed
    ########################################################################### 

    to.close <- subset(parts, 
                       trip_neg %in% TRUE & status %in% "Open")


    ########################################################################### 
    # Identify any participants closed as triple-negatives who weren't
    ########################################################################### 

    not.tripneg <- subset(parts, 
                          trip_neg %in% FALSE & status %in% "Triple Negative")





    ########################################################################### 
    # Write out the problems
    ########################################################################### 

    write.csv(to.close, 
              file = file.path(outdir, "Triple-negative participants not yet closed.csv"),
              row.names = FALSE
    )


    # Need to remove duplicates
    write.csv(not.tripneg,
              file = file.path(outdir, "Patients wrongly closed as triple-negative.csv"),
              row.names = FALSE
    )


}

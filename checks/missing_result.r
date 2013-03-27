
# This function checks that all patients have
#  - a TST result
#  - a QFT result
#  - a TSPOT result




test_check <- function(cleanlist, outdir) {

    # Get study IDs and status
    parts <- subset(cleanlist$master, select = c("StudyId", "status"))

    ########################################################################### 
    # Merge test results onto participant status
    ########################################################################### 


    # Participants can have multiple tests, so I'll need to expand this
    # to accommodate that...
    parts$tst_res <- parts$StudyId %in% 
        subset(cleanlist$skintest, result %in% 
               c("Negative", "Positive"))$StudyId

    parts$qft_res <- parts$StudyId %in% 
        subset(cleanlist$qft, result %in% 
               c("Negative", "Positive"))$StudyId


    parts$tspot_res <- parts$StudyId %in% 
        subset(cleanlist$tspot, result %in% 
               c("Negative", "Positive", "Borderline"))$StudyId

    parts$trip_res <- with(parts, tst_res & qft_res & tspot_res)



    ########################################################################### 
    # Identify any participants with a missing result
    ########################################################################### 

    # Ignore the missing result if they didn't complete enrollment, withdrew,
    # or were ineligible.
    missing.res <- subset(parts, 
                          trip_res %in% FALSE & 
                          !status %in% c("Didn't complete enrollment",
                                         "Withdrew", "Not eligible")
    )




    ########################################################################### 
    # Write out the problems
    ########################################################################### 

    write.csv(subset(missing.res, tst_res %in% FALSE), 
              file = file.path(outdir, "Participants missing TST result.csv"),
              row.names = FALSE
    )


    write.csv(subset(missing.res, qft_res %in% FALSE), 
              file = file.path(outdir, "Participants missing QFT result.csv"),
              row.names = FALSE
    )


    write.csv(subset(missing.res, tspot_res %in% FALSE), 
              file = file.path(outdir, "Participants missing TSPOT result.csv"),
              row.names = FALSE
    )









}

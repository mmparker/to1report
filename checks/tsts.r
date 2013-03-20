# This function checks that the TSTs were:
#  - placed after the phlebotomy
#  - read within 48-72 hours of placement



tst_check <- function(cleanlist, outdir) {

    tsts <- cleanlist$skintest

    # Check that the TST, QFT, and TSPOT entries are complete
    # Check that 

    ########################################################################### 
    # Were TSTs read within 48-72 hours?
    ########################################################################### 

    tsts$hrs_to_read <- as.numeric(
        with(tsts, difftime(dt_read, dt_placed, units = "hours"))
    )

    # Report any outside of the 48-72 hour bounds (which are actually 44-76)
    tsts.oob <- subset(tsts,
                       subset = hrs_to_read > 76 |
                                hrs_to_read < 44,
                       select = c("StudyId", 
                                  "dt_placed", "placed_by",
                                  "dt_read", "read_by",
                                  "hrs_to_read"))



    ########################################################################### 
    # Were TSTs placed after the QFT and TSPOT?
    ########################################################################### 

    # Merge the IGRAs for ease of use
    igras <- subset(merge(x = cleanlist$qft,
                          y = cleanlist$tspot,
                          by = "PatientID",
                          all = TRUE,
                          suffixes = c("_qft", "_tspot")),
                    select = c("PatientID", "dt_placed_qft", "dt_placed_tspot")
    )


    # Add them to the TSTs
    tstigra <- subset(merge(x = tsts,
                            y = igras,
                            all.x = TRUE),
                      select = c("StudyId", "dt_placed", 
                                 "dt_placed_qft", "dt_placed_tspot")
    )

    # Calc hours between QFT draw and TST placement - should be negative
    tstigra$qft_hrs_between <- with(tstigra,
        as.numeric(difftime(dt_placed_qft, dt_placed, units = "hours"))
    )

    # Calc hours between TSPOT draw and TST placement - should be negative
    tstigra$tspot_hrs_between <- with(tstigra,
        as.numeric(difftime(dt_placed_tspot, dt_placed, units = "hours"))
    )


    # Filter to tests with any positive time between IGRA and TST placement
    tsts.postigra <- subset(tstigra, 
                            qft_hrs_between > 0 | tspot_hrs_between > 0)

    # Slightly improved report names
    names(tsts.postigra) <- c("studyid", "tst_placed", 
                              "qft_placed", "tspot_placed", 
                              "hours_before_qft", "hours_before_tspot")




    ########################################################################### 
    # Were TSTs placed on or after the consent date?
    ########################################################################### 

    # Using enrollment date as a proxy
    tsts.enroll <- merge(x = tsts,
                         y = subset(cleanlist$preenrollment,
                                    select = c("PatientID", "enroll_date")),
                         by = "PatientID",
                         all.x = TRUE)

    # Were any placed before the enrollment date?
    tsts.beforeenroll <- subset(tsts.enroll, 
                                subset = as.Date(dt_placed) < enroll_date,
                                select = c("StudyId", 
                                           "enroll_date", "dt_placed")
    )




    ########################################################################### 
    # Write out the problems
    ########################################################################### 

    write.csv(tsts.oob, 
              file = file.path(outdir, "TSTs read too early or too late.csv"),
              row.names = FALSE
    )


    # Need to remove duplicates
    write.csv(tsts.postigra, 
              file = file.path(outdir, "TSTs placed before IGRAs.csv"),
              row.names = FALSE
    )


    write.csv(tsts.beforeenroll, 
              file = file.path(outdir, "TSTs placed before enrollment.csv"),
              row.names = FALSE
    )









}

# This function checks that the TSTs were:
#  - placed after the phlebotomy
#  - read within 48-72 hours of placement



# tst_check <- function(cleanlist, outdir) {
cleanlist <- cleaned

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

    tstqft <- merge(x = tsts,
                    y = subset(cleanlist$qft,
                               select = c("PatientID", "dt_placed")),
                    by = "PatientID",
                    suffixes = c(".tst", ".igra"),
                    all.x = TRUE)

    tstqft$hrs_between <- as.numeric(
        with(tstqft, difftime(dt_placed.tst, dt_placed.igra, units = "hours"))
    )

    tsts.postqft <- subset(tstqft,
                           subset = hrs_between < 0,
                           select = c("StudyId", 
                                      "dt_placed.tst", "dt_placed.igra",
                                      "placed_by", "hrs_between"))

    tsttspot <- merge(x = tsts,
                      y = subset(cleanlist$tspot,
                                 select = c("PatientID", "dt_placed")),
                      by = "PatientID",
                      suffixes = c(".tst", ".igra"),
                      all.x = TRUE)

    tsttspot$hrs_between <- as.numeric(with(tsttspot, 
        difftime(dt_placed.tst, dt_placed.igra, units = "hours"))
    )

    tsts.posttspot <- subset(tsttspot,
                           subset = hrs_between < 0,
                           select = c("StudyId", 
                                      "dt_placed.tst", "dt_placed.igra",
                                      "placed_by", "hrs_between"))

    # Stack 'em
    tsts.postigra <- rbind(tsts.postqft, tsts.posttspot)



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
    tsts.beforeenroll <- subset(tsts_enroll, 
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









#}

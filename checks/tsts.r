# This function checks that the TSTs were:
#  - placed after the phlebotomy
#  - read within 48-72 hours of placement



#tst_check <- function(cleaned, outdir) {

    tsts <- cleaned$skintest

    # Check that the TST, QFT, and TSPOT entries are complete
    # Check that 


    # Were TSTs read within 48-72 hours?
    tsts$hrs_to_read <- with(tsts, 
                             difftime(dt_read, dt_placed, units = "hours")
    )

    # Report any outside of the 48-72 hour bounds (which are actually 44-76)
    tsts.oob <- subset(tsts,
                       subset = as.numeric(hrs_to_read) > 76 |
                                as.numeric(hrs_to_read) < 44,
                       select = c("PatientID", 
                                  "dt_placed", "placed_by",
                                  "dt_read", "read_by",
                                  "hrs_to_read"))



    # Were TSTs placed after the QFT and TSPOT?
    tstqft <- merge(x = tsts,
                    y = cleaned$qft,
                    by = "PatientID",
                    all.x = TRUE)


    # Were TSTs placed on or after the consent date?
    # Using enrollment date as a proxy


    # Attach study IDs to those
    id.oob <- merge(x = tsts.oob,
                    y = subset(cleaned$master, 
                               select = c("PatientID", "StudyId")),
                    by = "PatientID",
                    all.x = TRUE)


    # Write out the problems
    write.csv(subset(id.oob, select = c("StudyId", 
                                        "dt_placed", "placed_by",
                                        "dt_read", "read_by",
                                        "hrs_to_read")),
              file = file.path(outdir, "TSTs read too early or too late.csv"),
              row.names = FALSE
    )



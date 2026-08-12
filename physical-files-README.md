# Physical Files (PF)

The case study identifies the following Physical Files used by the Domestic Flight Booking System.

| Physical File | Purpose |
|---|---|
| `BOOKINGPF` | Stores flight booking information. |
| `COMPLIANT` | Stores complaint information against a flight booking. |
| `CONTROLTBL` | Stores key information maintained by the admin for use by airline and user workflows. |
| `FLIGHTPF` | Stores flight information. |
| `USERMASTER` | Stores user data. |
| `AIRMASTER` | Stores airline details. |
| `RATINGPF` | Stores flight rating information. |
| `TICKETPF` | Stores ticket details. |
| `PSNGRPF` | Stores passenger details. |
| `LOGINPF` | Stores user/login details. |

## Source note

This inventory is based directly on the PF/LF section of the internship case study. The case-study document describes the files and their purposes, but the retrieved text does not provide the complete DDS field-by-field PF source definitions. Therefore, no field names, lengths, data types, or keys are invented here.

The RPGLE source in `src/domestic_flight_booking.rpgle` references these database files through RPG file declarations and keyed operations such as `CHAIN`, `READ`, `SETLL`, `WRITE`, and `UPDATE`.

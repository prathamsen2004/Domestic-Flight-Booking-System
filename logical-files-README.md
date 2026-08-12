# Logical Files (LF)

The case study identifies three Logical Files used by the Domestic Flight Booking System:

| Logical File | Based on / Purpose |
|---|---|
| Flight LF | Logical file for `FLIGHTPF`. |
| Complaint LF | Logical file for `COMPLIANT`. |
| Booking LF | Logical file for `BOOKINGPF`. |

## RPGLE references

The RPGLE source declares and uses logical-file access, including:

- `fltlf` for flight-related keyed input
- `grievlf` for complaint-related keyed input
- `bookinglf` for booking-related keyed input

The case study also shows renamed record formats for these logical-file declarations.

## Source note

The case-study text identifies these LF files but does not provide complete field-by-field DDS definitions in the retrieved source. This file therefore documents only what the case study explicitly supports rather than inventing DDS details.

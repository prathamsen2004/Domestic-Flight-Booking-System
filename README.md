# Domestic Flight Booking System

A Domestic Flight Booking System developed as part of an internship case study using **RPGLE on IBM i (AS400), DB2, Physical Files (PF), Logical Files (LF), and Workstation Files**.

The system provides separate workflows for three primary roles:

- Admin
- Airline
- User

It covers authentication, registration, flight management, booking management, passenger and ticket handling, complaint management, configuration, and password management.

---

## Project Overview

The application manages domestic flight booking operations through role-based workflows.

RPGLE is used for application logic, database operations, validations, and workstation interaction, while DB2 Physical Files and Logical Files are used for data storage and keyed access.

The repository contains the RPGLE source, database documentation, workstation-file documentation, and application screenshots from the case study.

---

## User Roles

### Admin

The Admin module provides operations including:

- Manage Airlines
- Manage Users
- View Bookings
- View Flights
- Manage Complaints
- Configuration / Control Table
- Password Management

### Airline

The Airline module provides:

- Airline Dashboard
- Schedule Flights
- View / Manage Flights
- Flight Management
- Password Management

### User

The User module provides:

- User Dashboard
- View / Update Profile
- Flight-related operations
- Booking Management
- Passenger and Ticket handling
- Booking Cancellation
- Password Management

---

## Authentication

The system provides authentication for all users.

The login workflow:

1. Accepts user credentials.
2. Searches the login data.
3. Validates the username.
4. Validates the password.
5. Determines the user's role.
6. Routes the user to the corresponding module.

The application handles invalid username and invalid password cases.

Additional authentication features include:

- User Registration
- Forgot Password
- Change Password
- Password Confirmation
- Password Validation

The password validation logic includes checks for minimum length, uppercase characters, lowercase characters, digits, and special characters.

---

## Major Features

### Flight Management

- Flight Scheduling
- View Flights
- Manage Flight Information
- Update Flight Information
- Display Flight Details

Flight information is maintained in `FLIGHTPF`.

### Booking Management

Booking information is maintained in `BOOKINGPF`.

The application uses booking information while managing bookings and retrieving related flight, passenger, and ticket information.

### Passenger Management

Passenger information is maintained in `PSNGRPF`.

Passenger records are used during booking-related operations.

### Ticket Management

Ticket information is maintained in `TICKETPF`.

Ticket data is used together with booking, flight, and passenger information.

### Complaint Management

The system provides complaint management functionality.

Complaint information is maintained in `COMPLIANT` and accessed through its corresponding logical file.

### Configuration

`CONTROLTBL` is used by the Admin to maintain key information used by Airline and User workflows.

---

## Database

The application uses **DB2 on IBM i** with Physical Files (PF) and Logical Files (LF).

### Physical Files

| File | Purpose |
|---|---|
| `BOOKINGPF` | Stores flight booking information |
| `COMPLIANT` | Stores complaint information |
| `CONTROLTBL` | Stores configuration information |
| `FLIGHTPF` | Stores flight information |
| `USERMASTER` | Stores user information |
| `AIRMASTER` | Stores airline information |
| `RATINGPF` | Stores flight rating information |
| `TICKETPF` | Stores ticket information |
| `PSNGRPF` | Stores passenger information |
| `LOGINPF` | Stores login information |

### Logical Files

The RPGLE source uses logical files for keyed access to flight, complaint, and booking data.

Logical-file references in the RPGLE source include:

- `fltlf`
- `grievlf`
- `bookinglf`

---

## RPGLE Implementation

The RPGLE source demonstrates:

- File declarations
- Keyed database access
- Workstation file handling
- Subfile processing
- Record retrieval
- Record updates
- Input validation
- Role-based navigation
- Password management
- Booking operations
- Flight operations

Database operations used in the source include:

```text
CHAIN
READ
SETLL
READC
WRITE
UPDATE

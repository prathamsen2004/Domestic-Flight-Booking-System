# Domestic Flight Booking System

A domestic flight booking system developed as part of an internship case study using RPGLE on IBM i (AS400), DB2, PF/LF, and workstation files.

The system is organized around three primary user roles:

- Admin
- Airline
- User

It covers authentication, registration, flight management, booking management, passenger and ticket handling, complaints, configuration, and role-specific operations.

---

## Project Overview

The Domestic Flight Booking System manages domestic flight booking operations through separate workflows for Admin, Airline, and User.

The application uses RPGLE for business logic and workstation interaction, while DB2 physical and logical files are used for persistent data access.

The case study includes both the application source code and the corresponding output screens for the different workflows.

---

## User Roles

### Admin

The Admin module provides administrative operations such as:

- Manage Airlines
- Manage Users
- View Bookings
- View Flights
- Manage Complaints
- Configuration / Control Table operations
- Booking-related operations
- Password management

The RPGLE implementation uses separate subroutines and workstation subfiles for several Admin operations. 

### Airline

The Airline module provides airline-specific operations including:

- Airline Dashboard
- Schedule Flights
- View / Manage Flights
- Airline profile-related operations
- Flight management
- Password management

The case study contains dedicated screens and RPGLE logic for scheduling and managing flights. 

### User

The User module provides user-facing operations including:

- User Dashboard
- View / Update Profile
- Flight-related operations
- Booking management
- Passenger and ticket handling
- Booking cancellation
- Password management

The RPGLE implementation reads booking, flight, passenger, and ticket information to support these workflows. :contentReference[oaicite:3]{index=3}

---

## Authentication

The system provides authentication for all users.

The login flow:

1. Accepts the user's credentials.
2. Searches the login data.
3. Validates the username.
4. Validates the password.
5. Determines the user's role.
6. Routes the user to the corresponding module.

The RPGLE logic routes authenticated users to:

- Airline module
- Admin dashboard
- User dashboard

Invalid username and invalid password cases are also handled. :contentReference[oaicite:4]{index=4}

### Additional Authentication Features

The case study also includes:

- User registration
- Forgot password
- Password validation
- Change password
- Password confirmation

Password validation includes minimum length and checks for uppercase characters, lowercase characters, digits, and special characters. 

---

## Major Features

### Flight Management

The system supports flight-related operations including:

- Flight scheduling
- Viewing flights
- Managing flight information
- Updating flight information
- Displaying flight details

Flight information is stored in `FLIGHTPF`. :contentReference[oaicite:6]{index=6}

### Booking Management

Booking information is stored in `BOOKINGPF`.

The system uses booking information while displaying and managing bookings and while retrieving related flight, passenger, and ticket information. 

### Passenger Management

Passenger information is maintained in `PSNGRPF`.

Passenger records are used while processing and displaying booking-related information. 

### Ticket Management

Ticket information is maintained in `TICKETPF`.

Ticket data is used along with booking, flight, and passenger information during booking-related operations. 

### Complaint Management

The system includes complaint management functionality.

Complaint information is stored in the complaint PF and is accessed through the corresponding logical file during complaint-related operations. 

### Configuration

`CONTROLTBL` is used by the Admin to maintain key information that can be used by Airline and User workflows. :contentReference[oaicite:11]{index=11}

---

## Database Files

The case study uses DB2 Physical Files (PF) and Logical Files (LF).

### Physical Files

| File | Purpose |
|------|---------|
| `BOOKINGPF` | Stores flight booking information |
| `COMPLIANT` | Stores complaint information against bookings |
| `CONTROLTBL` | Stores key configuration information maintained by Admin |
| `FLIGHTPF` | Stores flight information |
| `USERMASTER` | Stores user information |
| `AIRMASTER` | Stores airline information |
| `RATINGPF` | Stores flight rating information |
| `TICKETPF` | Stores ticket information |
| `PSNGRPF` | Stores passenger information |
| `LOGINPF` | Stores user login details |

These file responsibilities are documented in the original case study. 

### Logical Files

Logical files are used for keyed access and for retrieving related records from the physical files.

The RPGLE source declares logical files for flight, complaint, and booking data, including:

- `fltlf`
- `grievlf`
- `bookinglf`

The source also uses renamed record formats where required. :contentReference[oaicite:13]{index=13}

---

## RPGLE Implementation

The main RPGLE source demonstrates:

- File declarations
- Keyed database access
- Workstation file handling
- Subfile processing
- Record retrieval
- Record updates
- Validation
- Role-based navigation
- Password management
- Booking operations
- Flight operations

Examples of database operations used in the source include:

- `CHAIN`
- `READ`
- `SETLL`
- `READC`
- `WRITE`
- `UPDATE`

The source also uses RPGLE subroutines (`BEGSR` / `ENDSR`) to organize different application workflows.

---

## Workstation Files & Subfiles

The application uses workstation files for interactive screens.

The RPGLE source declares workstation files for:

- Login
- Airline module
- Admin module
- User module

The Admin workstation file contains multiple subfiles for operations such as airline management, user management, bookings, flights, complaints, configuration, and other displays.

The User workstation file similarly contains subfiles for user-facing operations. :contentReference[oaicite:14]{index=14}

---

## Validation & Error Handling

The application contains validation logic for several input areas.

Examples include:

- Invalid username
- Invalid password
- Password length
- Password complexity
- Password mismatch
- Invalid mobile number
- Invalid email
- Invalid city
- Invalid state
- Invalid address
- Invalid Aadhar
- Invalid pincode
- Invalid security question / answer
- Invalid date of birth

The registration logic performs multiple validations before writing user information to the relevant files. :contentReference[oaicite:15]{index=15}

---

## Application Workflow

```text
                    +------------------+
                    |      Login       |
                    +--------+---------+
                             |
                 +-----------+-----------+
                 |           |           |
              Admin       Airline      User
                 |           |           |
        +--------+---+    +--+------+   +----------------+
        |            |    |         |   |                |
     Airlines     Users  Schedule  Manage Flights    Bookings
     Bookings     Flights Flights Flights            Passengers
     Complaints   Config                           Tickets

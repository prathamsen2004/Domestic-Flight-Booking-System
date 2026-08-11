# Domestic Flight Booking System

A domestic flight booking system developed as part of an internship case study using **RPGLE, IBM i (AS400), DB2, PF/LF, and workstation files**.

## 📌 Project Overview

The system is designed to manage domestic flight booking operations through separate workflows for **Admin, Airline, and Users**.

It includes user authentication, flight management, booking management, passenger and ticket handling, complaint management, and administrative operations.

## 🛠️ Technologies Used

- RPGLE
- IBM i / AS400
- DB2
- Physical Files (PF)
- Logical Files (LF)
- Workstation / Display Files
- Subfiles
- CL / IBM i environment

## ✨ Key Features

### User Module
- User registration
- Login authentication
- Password management
- Flight search
- Flight booking
- Passenger management
- Ticket management
- Complaint submission

### Airline Module
- Airline login
- Flight management
- Booking management
- Passenger information
- Ticket-related operations

### Admin Module
- User management
- Airline management
- Flight management
- Booking management
- Complaint management
- System configuration

## 🗄️ Database

The application uses **DB2 on IBM i** with Physical Files and Logical Files.

Major entities include:

- Users
- Airlines
- Flights
- Bookings
- Passengers
- Tickets
- Complaints
- Configuration

## 💻 RPGLE Implementation

The application uses RPGLE for business logic and database operations, including:

- `CHAIN`
- `SETLL`
- `READ`
- `READE`
- `UPDATE`
- `WRITE`
- Subroutines
- Indicators
- Data structures
- Subfiles
- Keyed database access

## 📂 Repository Structure

```text
src/             → RPGLE source programs
database/        → PF/LF definitions
display-files/   → Workstation/display files
screenshots/     → Application screenshots
docs/            → Project documentation

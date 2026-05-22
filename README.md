# 🎬 Movie Ticket Booking — Database Project

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL-orange)
![Tables](https://img.shields.io/badge/Tables-12-green)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A fully normalized relational database design for an online **Movie Ticket Booking System**, built with MySQL. This project covers the complete booking lifecycle — from browsing movies and selecting seats to payment processing, discount coupons, and customer reviews.

---

## 📌 Project Description

This project is a **MySQL database schema** for a movie ticket booking platform similar to BookMyShow or Ticketmaster. It models real-world entities such as cinemas, screens, seats, shows, bookings, and payments using proper relational design principles.

Designed as a portfolio/academic project to demonstrate:
- Database design and normalization (up to 3NF)
- Entity-Relationship modeling
- Foreign key constraints and referential integrity
- Complex SQL queries (JOINs, GROUP BY, subqueries, aggregations)
- Realistic sample data generation

---

## 🗂️ Repository Structure

```
movie-ticket-booking-db/
│
├── schema/
│   └── movie_ticket_booking_full.sql     # CREATE TABLE statements (all 12 tables)
│
├── data/
│   └── movie_data.sql                # 500 rows of realistic sample data
│
├── model/
│   └── movie_ticket_booking.mwb          # MySQL Workbench EER Diagram
│
├── queries/
│   └── sample_queries.sql                # 10 useful SELECT queries
│
└── README.md
```

---

## 🧱 Database Schema — 12 Tables

| # | Table | Description |
|---|-------|-------------|
| 1 | `customer` | Registered users with contact details |
| 2 | `movie` | Movie catalogue with genre, language, and rating |
| 3 | `cinema` | Theatre/multiplex locations |
| 4 | `screen` | Individual screens inside a cinema |
| 5 | `seat` | Seats per screen with type (regular / premium / recliner) |
| 6 | `show_schedule` | A movie scheduled at a specific screen and time |
| 7 | `booking` | A customer's ticket booking for a show |
| 8 | `booking_seat` | Bridge table — seats reserved per booking |
| 9 | `payment` | Payment transaction linked to a booking |
| 10 | `offer` | Discount coupon codes |
| 11 | `booking_offer` | Bridge table — offers applied to bookings |
| 12 | `review` | Customer ratings and reviews per movie |

---

## 🔗 Entity Relationship Overview

```
cinema ──< screen ──< seat
                  └──< show_schedule >── movie
                            └──< booking >── customer
                                    ├──< booking_seat >── seat
                                    ├──── payment
                                    └──< booking_offer >── offer

customer ──< review >── movie
```

**13 Foreign Key Relationships | All with ON DELETE CASCADE**

---

## 📊 Sample Data Stats

| Table | Rows |
|-------|------|
| customer | 500 |
| movie | 10 |
| cinema | 5 |
| screen | 15 |
| seat | 1,200 |
| show_schedule | 150 |
| booking | 500 |
| booking_seat | ~1,236 |
| payment | 500 |
| booking_offer | ~155 |
| review | ~172 |

---

## ⚙️ Setup Instructions

### Prerequisites
- MySQL 8.0+ or MariaDB 10.5+
- MySQL Workbench (optional, for the `.mwb` model)

### Step 1 — Clone the repository
```bash
git clone https://github.com/your-username/movie-ticket-booking-db.git
cd movie-ticket-booking-db
```

### Step 2 — Create the schema
```bash
mysql -u root -p < schema/movie_ticket_booking_full.sql
```

### Step 3 — Load sample data
```bash
mysql -u root -p < data/movie_500_data.sql
```

### Step 4 — Run sample queries (optional)
```bash
mysql -u root -p movie_ticket_booking < queries/sample_queries.sql
```

### Step 5 — Open the EER Diagram (optional)
1. Open **MySQL Workbench**
2. Go to `File → Open Model`
3. Select `model/movie_ticket_booking.mwb`

---

## 🔍 Sample Queries

### Find all upcoming shows for a movie
```sql
SELECT ss.show_id, m.title, c.name AS cinema,
       s.screen_name, ss.show_time, ss.price
FROM show_schedule ss
JOIN movie m  ON ss.movie_id  = m.movie_id
JOIN screen s ON ss.screen_id = s.screen_id
JOIN cinema c ON s.cinema_id  = c.cinema_id
WHERE ss.status = 'upcoming'
ORDER BY ss.show_time;
```

### Total revenue per movie
```sql
SELECT m.title,
       COUNT(DISTINCT b.booking_id) AS total_bookings,
       SUM(b.total_amount)          AS gross_revenue
FROM booking b
JOIN show_schedule ss ON b.show_id   = ss.show_id
JOIN movie m          ON ss.movie_id = m.movie_id
WHERE b.status = 'confirmed'
GROUP BY m.movie_id, m.title
ORDER BY gross_revenue DESC;
```

### Available seats for a specific show
```sql
SELECT seat_id, row_label, seat_number, seat_type
FROM seat
WHERE screen_id = (SELECT screen_id FROM show_schedule WHERE show_id = 1)
  AND seat_id NOT IN (
      SELECT bs.seat_id
      FROM booking_seat bs
      JOIN booking b ON bs.booking_id = b.booking_id
      WHERE b.show_id = 1 AND b.status = 'confirmed'
  );
```

### Average rating per movie
```sql
SELECT m.title,
       ROUND(AVG(r.rating), 1) AS avg_rating,
       COUNT(r.review_id)      AS total_reviews
FROM movie m
LEFT JOIN review r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY avg_rating DESC;
```

---

## 🧩 Key Design Decisions

- **Normalization** — Schema follows 3NF; no redundant data across tables.
- **Bridge tables** — `booking_seat` and `booking_offer` handle M:N relationships cleanly.
- **ENUM types** — Used for constrained fields like `seat_type`, `status`, and `payment method` to enforce valid values at the DB level.
- **ON DELETE CASCADE** — All FKs cascade deletes to maintain referential integrity automatically.
- **Unique constraints** — Applied on `email`, offer `code`, and `(customer_id, movie_id)` in reviews to prevent duplicate entries.
- **1:1 Payment** — Each booking has exactly one payment record enforced via a unique FK.

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| MySQL 8.0 | Database engine |
| MySQL Workbench | EER diagram and schema design |
| Python 3 | Sample data generation script |
| SQL | Schema, DML, and queries |

---

## 🙋 Author

**Your Name**
- GitHub: [@jayaramg-0](https://github.com/jayaramg-0)
- LinkedIn: [linkedin.com/in/jayaramg456](https://www.linkedin.com/in/jayaramg456/)

---

> ⭐ If you found this project helpful, give it a star on GitHub!

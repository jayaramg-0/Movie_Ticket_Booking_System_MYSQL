-- ============================================================
--  MOVIE TICKET BOOKING DATABASE
--  MySQL Script
--  Tables: 12
-- ============================================================

DROP DATABASE IF EXISTS movie_ticket_booking;
CREATE DATABASE movie_ticket_booking;
USE movie_ticket_booking;

-- ============================================================
--                  CREATE TABLES
-- ============================================================

-- 1. CUSTOMER
CREATE TABLE customer (
    customer_id   INT            AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100)   NOT NULL,
    email         VARCHAR(150)   NOT NULL UNIQUE,
    phone         VARCHAR(15)    NOT NULL,
    dob           DATE,
    created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP
);

-- 2. MOVIE
CREATE TABLE movie (
    movie_id      INT            AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(200)   NOT NULL,
    genre         VARCHAR(50)    NOT NULL,
    language      VARCHAR(50)    NOT NULL,
    duration_min  INT            NOT NULL,
    rating        VARCHAR(10),
    release_date  DATE           NOT NULL
);

-- 3. CINEMA
CREATE TABLE cinema (
    cinema_id     INT            AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(150)   NOT NULL,
    city          VARCHAR(100)   NOT NULL,
    address       VARCHAR(255)   NOT NULL,
    phone         VARCHAR(15)
);

-- 4. SCREEN
CREATE TABLE screen (
    screen_id     INT            AUTO_INCREMENT PRIMARY KEY,
    cinema_id     INT            NOT NULL,
    screen_name   VARCHAR(50)    NOT NULL,
    total_seats   INT            NOT NULL,
    CONSTRAINT fk_screen_cinema FOREIGN KEY (cinema_id)
        REFERENCES cinema(cinema_id) ON DELETE CASCADE
);

-- 5. SEAT
CREATE TABLE seat (
    seat_id       INT            AUTO_INCREMENT PRIMARY KEY,
    screen_id     INT            NOT NULL,
    row_label     VARCHAR(5)     NOT NULL,
    seat_number   INT            NOT NULL,
    seat_type     ENUM('regular','premium','recliner') DEFAULT 'regular',
    CONSTRAINT fk_seat_screen FOREIGN KEY (screen_id)
        REFERENCES screen(screen_id) ON DELETE CASCADE,
    UNIQUE KEY uq_seat (screen_id, row_label, seat_number)
);

-- 6. SHOW SCHEDULE
CREATE TABLE show_schedule (
    show_id       INT            AUTO_INCREMENT PRIMARY KEY,
    movie_id      INT            NOT NULL,
    screen_id     INT            NOT NULL,
    show_time     DATETIME       NOT NULL,
    price         DECIMAL(8,2)   NOT NULL,
    status        ENUM('upcoming','ongoing','completed','cancelled') DEFAULT 'upcoming',
    CONSTRAINT fk_show_movie  FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id) ON DELETE CASCADE,
    CONSTRAINT fk_show_screen FOREIGN KEY (screen_id)
        REFERENCES screen(screen_id) ON DELETE CASCADE
);

-- 7. BOOKING
CREATE TABLE booking (
    booking_id    INT            AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT            NOT NULL,
    show_id       INT            NOT NULL,
    booked_at     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    total_amount  DECIMAL(10,2)  NOT NULL,
    status        ENUM('pending','confirmed','cancelled') DEFAULT 'pending',
    CONSTRAINT fk_booking_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_show     FOREIGN KEY (show_id)
        REFERENCES show_schedule(show_id) ON DELETE CASCADE
);

-- 8. BOOKING_SEAT
CREATE TABLE booking_seat (
    booking_seat_id INT          AUTO_INCREMENT PRIMARY KEY,
    booking_id      INT          NOT NULL,
    seat_id         INT          NOT NULL,
    status          ENUM('booked','cancelled') DEFAULT 'booked',
    CONSTRAINT fk_bs_booking FOREIGN KEY (booking_id)
        REFERENCES booking(booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_bs_seat    FOREIGN KEY (seat_id)
        REFERENCES seat(seat_id) ON DELETE CASCADE,
    UNIQUE KEY uq_booking_seat (booking_id, seat_id)
);

-- 9. PAYMENT
CREATE TABLE payment (
    payment_id    INT            AUTO_INCREMENT PRIMARY KEY,
    booking_id    INT            NOT NULL UNIQUE,
    amount        DECIMAL(10,2)  NOT NULL,
    method        ENUM('card','upi','netbanking','wallet','cash') NOT NULL,
    status        ENUM('pending','success','failed','refunded') DEFAULT 'pending',
    paid_at       TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id)
        REFERENCES booking(booking_id) ON DELETE CASCADE
);

-- 10. OFFER
CREATE TABLE offer (
    offer_id      INT            AUTO_INCREMENT PRIMARY KEY,
    code          VARCHAR(20)    NOT NULL UNIQUE,
    discount_pct  DECIMAL(5,2)   NOT NULL,
    valid_from    DATE           NOT NULL,
    valid_to      DATE           NOT NULL,
    max_uses      INT            DEFAULT 100
);

-- 11. BOOKING_OFFER
CREATE TABLE booking_offer (
    id               INT         AUTO_INCREMENT PRIMARY KEY,
    booking_id       INT         NOT NULL,
    offer_id         INT         NOT NULL,
    discount_applied DECIMAL(8,2) NOT NULL,
    CONSTRAINT fk_bo_booking FOREIGN KEY (booking_id)
        REFERENCES booking(booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_bo_offer   FOREIGN KEY (offer_id)
        REFERENCES offer(offer_id) ON DELETE CASCADE
);

-- 12. REVIEW
CREATE TABLE review (
    review_id     INT            AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT            NOT NULL,
    movie_id      INT            NOT NULL,
    rating        TINYINT        NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment       TEXT,
    created_at    TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_review_customer FOREIGN KEY (customer_id)
        REFERENCES customer(customer_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_movie    FOREIGN KEY (movie_id)
        REFERENCES movie(movie_id) ON DELETE CASCADE,
    UNIQUE KEY uq_review (customer_id, movie_id)
);



-- ============================================================
--  SECTION 2: INSERT SAMPLE DATA
-- ============================================================

-- Customers
INSERT INTO customer (name, email, phone, dob) VALUES
('Arjun Kumar',    'arjun@gmail.com',   '9876543210', '1995-04-12'),
('Priya Sharma',   'priya@gmail.com',   '9845612345', '1998-07-23'),
('Rahul Verma',    'rahul@gmail.com',   '9123456789', '1993-11-05'),
('Sneha Nair',     'sneha@gmail.com',   '9012345678', '2000-01-30'),
('Vikram Singh',   'vikram@gmail.com',  '9765432100', '1990-08-15');

-- Movies
INSERT INTO movie (title, genre, language, duration_min, rating, release_date) VALUES
('KGF Chapter 3',     'Action',    'Kannada', 170, 'UA', '2025-01-10'),
('Leo',               'Thriller',  'Tamil',   164, 'UA', '2024-10-19'),
('Jawan',             'Action',    'Hindi',   169, 'UA', '2024-09-07'),
('Animal',            'Drama',     'Hindi',   201, 'A',  '2024-12-01'),
('RRR Returns',       'Adventure', 'Telugu',  185, 'UA', '2025-03-22');

-- Cinemas
INSERT INTO cinema (name, city, address, phone) VALUES
('PVR Cinemas Phoenix',    'Chennai',   '142 Anna Salai, Mount Road',    '04422345678'),
('INOX Nexus Mall',        'Chennai',   '88 Old Mahabalipuram Road',     '04433456789'),
('Rohini Silver Screens',  'Chennai',   '32 Koyambedu Link Road',        '04411223344');

-- Screens
INSERT INTO screen (cinema_id, screen_name, total_seats) VALUES
(1, 'Screen 1 - IMAX',    200),
(1, 'Screen 2',           150),
(2, 'Screen 1',           180),
(2, 'Screen 2 - 4DX',    120),
(3, 'Screen 1',           160),
(3, 'Screen 2',           140);

-- Seats for Screen 1 (rows A-D, 10 seats each = 40 seats shown as sample)
INSERT INTO seat (screen_id, row_label, seat_number, seat_type) VALUES
(1,'A',1,'regular'),(1,'A',2,'regular'),(1,'A',3,'regular'),(1,'A',4,'regular'),(1,'A',5,'regular'),
(1,'B',1,'premium'),(1,'B',2,'premium'),(1,'B',3,'premium'),(1,'B',4,'premium'),(1,'B',5,'premium'),
(1,'C',1,'recliner'),(1,'C',2,'recliner'),(1,'C',3,'recliner'),(1,'C',4,'recliner'),(1,'C',5,'recliner'),
(2,'A',1,'regular'),(2,'A',2,'regular'),(2,'A',3,'regular'),(2,'B',1,'premium'),(2,'B',2,'premium'),
(3,'A',1,'regular'),(3,'A',2,'regular'),(3,'A',3,'regular'),(3,'B',1,'premium'),(3,'B',2,'premium');

-- Show Schedules
INSERT INTO show_schedule (movie_id, screen_id, show_time, price, status) VALUES
(1, 1, '2025-06-01 10:00:00', 350.00, 'upcoming'),
(1, 1, '2025-06-01 14:00:00', 350.00, 'upcoming'),
(2, 2, '2025-06-01 11:00:00', 280.00, 'upcoming'),
(3, 3, '2025-06-02 18:30:00', 300.00, 'upcoming'),
(4, 4, '2025-06-02 21:00:00', 400.00, 'upcoming'),
(5, 5, '2025-06-03 09:30:00', 320.00, 'upcoming');

-- Offers
--- - INSERT INTO offer (code, discount_pct, valid_from, valid_to, max_uses) VALUES
-- -- ('MOVIE10',  10.00, '2025-01-01', '2025-12-31', 500),
-- -- ('PAYDAY20', 20.00, '2025-05-31', '2025-06-01', 100),
-- -- ('FIRSTBOOK',15.00, '2025-01-01', '2025-12-31', 200);

-- Bookings
INSERT INTO booking (customer_id, show_id, total_amount, status) VALUES
(1, 1, 700.00,  'confirmed'),
(2, 1, 350.00,  'confirmed'),
(3, 3, 280.00,  'confirmed'),
(4, 4, 600.00,  'confirmed'),
(5, 5, 400.00,  'confirmed');

-- Booking Seats
INSERT INTO booking_seat (booking_id, seat_id, status) VALUES
(1, 1, 'booked'),
(1, 2, 'booked'),
(2, 3, 'booked'),
(3, 16,'booked'),
(4, 21,'booked'),
(4, 22,'booked'),
(5, 11,'booked');

-- Payments
INSERT INTO payment (booking_id, amount, method, status) VALUES
(1, 700.00, 'upi',        'success'),
(2, 350.00, 'card',       'success'),
(3, 280.00, 'netbanking', 'success'),
(4, 600.00, 'wallet',     'success'),
(5, 400.00, 'upi',        'success');

-- Booking Offers
INSERT INTO booking_offer (booking_id, offer_id, discount_applied) VALUES
(1, 1, 70.00),
(4, 2, 120.00);

-- Reviews
INSERT INTO review (customer_id, movie_id, rating, comment) VALUES
(1, 1, 5, 'Absolutely fantastic! Exceeded all expectations.'),
(2, 1, 4, 'Great action sequences. A bit long though.'),
(3, 2, 5, 'Vijay was brilliant. Best thriller of the year.'),
(4, 3, 4, 'Shah Rukh Khan delivered a power-packed performance.'),
(5, 4, 3, 'Intense but too violent for my taste.');

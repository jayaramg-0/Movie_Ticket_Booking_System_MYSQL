
-- ----------------------------
-- | SOME IMPORTANT QUERIES | 
-- ----------------------------

-- Q1: All upcoming shows with cinema and screen details
SELECT
    ss.show_id,
    m.title          AS movie,
    c.name           AS cinema,
    c.city,
    s.screen_name,
    ss.show_time,
    ss.price,
    ss.status
FROM show_schedule ss
JOIN movie  m ON ss.movie_id  = m.movie_id
JOIN screen s ON ss.screen_id = s.screen_id
JOIN cinema c ON s.cinema_id  = c.cinema_id
WHERE ss.status = 'upcoming'
ORDER BY ss.show_time;

-- -- Q2: Count available seats for show_id = 1
-- SELECT
--     s.seat_id,
--     s.row_label,
--     s.seat_number,
--     s.seat_type
-- FROM seat s
-- WHERE s.screen_id = (
--         SELECT screen_id FROM show_schedule WHERE show_id = 1
--     )
--   AND s.seat_id NOT IN (
--         SELECT bs.seat_id
--         FROM booking_seat bs
--         JOIN booking b ON bs.booking_id = b.booking_id
--         WHERE b.show_id = 1 AND b.status = 'confirmed' AND bs.status = 'booked'
--     );

-- Q3: Full booking details for a customer
SELECT
    b.booking_id,
    m.title          AS movie,
    c.name           AS cinema,
    ss.show_time,
    GROUP_CONCAT(CONCAT(se.row_label, se.seat_number) ORDER BY se.row_label SEPARATOR ', ') AS seats,
    b.total_amount,
    b.status         AS booking_status,
    p.method         AS payment_method,
    p.status         AS payment_status
FROM booking b
JOIN show_schedule ss  ON b.show_id      = ss.show_id
JOIN movie m           ON ss.movie_id    = m.movie_id
JOIN screen scr        ON ss.screen_id   = scr.screen_id
JOIN cinema c          ON scr.cinema_id  = c.cinema_id
JOIN booking_seat bs   ON b.booking_id   = bs.booking_id
JOIN seat se           ON bs.seat_id     = se.seat_id
LEFT JOIN payment p    ON b.booking_id   = p.booking_id
WHERE b.customer_id = 1
GROUP BY b.booking_id, m.title, c.name, ss.show_time, b.total_amount, b.status, p.method, p.status;

-- Q4: Total revenue per movie
SELECT
    m.title,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    SUM(b.total_amount)          AS gross_revenue
FROM booking b
JOIN show_schedule ss ON b.show_id  = ss.show_id
JOIN movie m          ON ss.movie_id = m.movie_id
WHERE b.status = 'confirmed'
GROUP BY m.movie_id, m.title
ORDER BY gross_revenue DESC;

Q5: Top 5 customers by number of bookings
SELECT
    c.customer_id,
    c.name,
    c.email,
    COUNT(b.booking_id)  AS total_bookings,
    SUM(b.total_amount)  AS total_spent
FROM customer c
JOIN booking b ON c.customer_id = b.customer_id
WHERE b.status = 'confirmed'
GROUP BY c.customer_id, c.name, c.email
ORDER BY total_bookings DESC
LIMIT 5;

-- Q6: Average rating and review count per movie
SELECT
    m.title,
    ROUND(AVG(r.rating), 1) AS avg_rating,
    COUNT(r.review_id)      AS total_reviews
FROM movie m
LEFT JOIN review r ON m.movie_id = r.movie_id
GROUP BY m.movie_id, m.title
ORDER BY avg_rating DESC;

Q7: Seats booked vs available for each show
SELECT
    ss.show_id,
    m.title,
    ss.show_time,
    s.total_seats,
    COUNT(bs.booking_seat_id)              AS booked_seats,
    s.total_seats - COUNT(bs.booking_seat_id) AS available_seats
FROM show_schedule ss
JOIN movie m  ON ss.movie_id  = m.movie_id
JOIN screen s ON ss.screen_id = s.screen_id
LEFT JOIN booking b  ON ss.show_id    = b.show_id  AND b.status = 'confirmed'
LEFT JOIN booking_seat bs ON b.booking_id = bs.booking_id AND bs.status = 'booked'
GROUP BY ss.show_id, m.title, ss.show_time, s.total_seats;

-- Q8: Revenue by payment method
SELECT
    p.method,
    COUNT(p.payment_id)  AS transactions,
    SUM(p.amount)        AS total_revenue
FROM payment p
WHERE p.status = 'success'
GROUP BY p.method
ORDER BY total_revenue DESC;

Q9: Most booked movies this month
SELECT
    m.title,
    COUNT(b.booking_id) AS bookings_this_month
FROM booking b
JOIN show_schedule ss ON b.show_id   = ss.show_id
JOIN movie m          ON ss.movie_id = m.movie_id
WHERE b.status = 'confirmed'
  AND MONTH(b.booked_at) = MONTH(CURDATE())
  AND YEAR(b.booked_at)  = YEAR(CURDATE())
GROUP BY m.movie_id, m.title
ORDER BY bookings_this_month DESC;

-- Q10: All cancelled bookings with customer and show info
SELECT
    b.booking_id,
    cu.name         AS customer_name,
    cu.email,
    m.title         AS movie,
    ss.show_time,
    b.total_amount,
    b.booked_at
FROM booking b
JOIN customer cu       ON b.customer_id  = cu.customer_id
JOIN show_schedule ss  ON b.show_id      = ss.show_id
JOIN movie m           ON ss.movie_id    = m.movie_id
WHERE b.status = 'cancelled'
ORDER BY b.booked_at DESC;

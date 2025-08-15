-- C P R G 2 5 0    P R O J E C T   2
-- PHASE THREE: SQL QUERIES AND REPORTING
-- Report 2: Recent rentals with customer + movie
-- Author: Abimbola Pitan
-- Desc: Rentals from the last 7 days joined to customers and movies
-- Concepts: INNER JOINs (joins), TO_CHAR (single-row), WHERE + ORDER BY (restrict/sort)

SELECT
  r.rentalid,
  TO_CHAR(r.rentaldate, 'YYYY-MM-DD HH24:MI') AS rented_at,
  CONCAT(c.firstname, ' ', c.lastname)        AS customer_name,
  m.title
FROM rental r
JOIN customer c ON c.customerid = r.customerid
JOIN movie    m ON m.movieid    = r.movieid
WHERE r.rentaldate >= NOW() - INTERVAL '7 days'
ORDER BY r.rentaldate DESC, m.title;

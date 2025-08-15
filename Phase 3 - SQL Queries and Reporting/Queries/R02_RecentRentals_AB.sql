-- C P R G 2 5 0    P R O J E C T  2  –  P H A S E  3
-- Report R02: Recent rentals with customer and movie
-- Author: Abimbola (AB)
-- Script: R02_RecentRentals_AB.sql
-- Purpose: Show rentals from the last 7 days joined to customers and movies
-- Concepts: INNER JOIN (joins), TO_CHAR (single-row), WHERE + ORDER BY
-- Screenshot: R02_RecentRentals_AB.png

SET search_path = vod;

SELECT
  r.rentalid,
  TO_CHAR(r.rentaldate, 'YYYY-MM-DD HH24:MI') AS rented_at,  -- single-row
  CONCAT(c.firstname, ' ', c.lastname)        AS customer_name,
  m.title
FROM rental r
JOIN customer c ON c.customerid = r.customerid      -- join 1
JOIN movie    m ON m.movieid    = r.movieid         -- join 2
WHERE r.rentaldate >= NOW() - INTERVAL '7 days'     -- restrict
ORDER BY r.rentaldate DESC, m.title;                -- sort

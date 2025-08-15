SET search_path = vod;

SELECT
  c.email,
  m.title,
  to_char(r.rentaldate, 'YYYY-MM-DD HH24:MI')     AS rented_at,
  to_char(r.viewstartat, 'YYYY-MM-DD HH24:MI')    AS started_at,
  to_char(r.expiresat, 'YYYY-MM-DD HH24:MI')      AS expires_at,
  COALESCE(r.customerrating, 0)                   AS rating,
  COALESCE(r.pricepaid, 0)::numeric(7,2)          AS price_paid
FROM rental r
JOIN customer c ON c.customerid = r.customerid
JOIN movie    m ON m.movieid    = r.movieid
WHERE c.email = 'alex.ng@example.com'
ORDER BY r.rentaldate DESC;

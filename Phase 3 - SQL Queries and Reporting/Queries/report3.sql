-- C P R G 2 5 0    P R O J E C T   2
-- PHASE THREE: SQL QUERIES AND REPORTING
-- Report 3: Top 10 movies by rentals in last 90 days
-- Author: Abimbola Pitan
-- Desc: Counts rentals per movie over the last 90 days
-- Concepts: LEFT JOIN (joins), COUNT (group func), GROUP BY/HAVING, ORDER BY + LIMIT (restrict/sort)

SELECT
  m.title,
  COUNT(r.rentalid) AS rentals_90d
FROM movie m
LEFT JOIN rental r
  ON r.movieid = m.movieid
 AND r.rentaldate >= NOW() - INTERVAL '90 days'
GROUP BY m.title
HAVING COUNT(r.rentalid) > 0
ORDER BY rentals_90d DESC, m.title
LIMIT 10;

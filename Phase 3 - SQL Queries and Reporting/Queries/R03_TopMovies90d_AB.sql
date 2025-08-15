-- C P R G 2 5 0    P R O J E C T  2  –  P H A S E  3
-- Report R03: Top 10 movies by rentals in the last 90 days
-- Author: Abimbola (AB)
-- Script: R03_TopMovies90d_AB.sql
-- Purpose: Count rentals per movie over the last 90 days
-- Concepts: LEFT JOIN (joins), COUNT (group), GROUP BY/HAVING, ORDER BY + LIMIT
-- Screenshot: R03_TopMovies90d_AB.png

SET search_path = vod;

SELECT
  m.title,
  COUNT(r.rentalid) AS rentals_90d            -- group function
FROM movie m
LEFT JOIN rental r
  ON r.movieid = m.movieid
 AND r.rentaldate >= NOW() - INTERVAL '90 days'  -- time window
GROUP BY m.title
HAVING COUNT(r.rentalid) > 0                     -- post-group filter
ORDER BY rentals_90d DESC, m.title               -- sort
LIMIT 10;                                        -- top N

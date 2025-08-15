-- C P R G 2 5 0    P R O J E C T   2
-- PHASE THREE: SQL QUERIES AND REPORTING
-- Report 5: Rank movies within each category by 90-day rentals
-- Author: Abimbola Pitan
-- Desc: Computes a per-category rank for movie popularity
-- Concepts: JOINs, COUNT (group func), RANK() OVER (OLAP), ORDER BY (restrict/sort)

WITH counts AS (
  SELECT
    mc.categoryid,
    m.movieid,
    m.title,
    COUNT(r.rentalid) AS rentals_90d
  FROM movie m
  JOIN moviecategory mc ON mc.movieid = m.movieid
  LEFT JOIN rental r
    ON r.movieid = m.movieid
   AND r.rentaldate >= NOW() - INTERVAL '90 days'
  GROUP BY mc.categoryid, m.movieid, m.title
)
SELECT
  c.categoryname,
  title,
  rentals_90d,
  RANK() OVER (PARTITION BY categoryid ORDER BY rentals_90d DESC, title) AS rank_in_category
FROM counts
JOIN category c ON c.categoryid = counts.categoryid
ORDER BY c.categoryname, rank_in_category, title;

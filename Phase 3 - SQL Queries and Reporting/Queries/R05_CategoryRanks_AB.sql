-- C P R G 2 5 0    P R O J E C T  2  –  P H A S E  3
-- Report R05: Rank movies within each category by 90-day rentals
-- Author: Abimbola (AB)
-- Script: R05_CategoryRanks_AB.sql
-- Purpose: Compute a per-category popularity rank
-- Concepts: JOINs, COUNT (group), RANK() OVER (OLAP), ORDER BY
-- Screenshot: R05_CategoryRanks_AB.png

SET search_path = vod;

WITH counts AS (
  SELECT
    mc.categoryid,
    m.movieid,
    m.title,
    COUNT(r.rentalid) AS rentals_90d             -- group
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
  RANK() OVER (PARTITION BY categoryid ORDER BY rentals_90d DESC, title) AS rank_in_category  -- OLAP
FROM counts
JOIN category c ON c.categoryid = counts.categoryid
ORDER BY c.categoryname, rank_in_category, title;

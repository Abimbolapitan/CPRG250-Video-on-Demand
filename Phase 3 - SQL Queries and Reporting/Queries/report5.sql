-- C P R G 2 5 0    P R O J E C T   2
-- PHASE THREE: SQL QUERIES AND REPORTING
-- Report 5: Rank movies within each category by 90-day rentals
-- Author: Abimbola Pitan
-- Desc: Computes a per-category rank for movie popularity
-- Concepts: JOINs, COUNT (group func), RANK() OVER (OLAP), ORDER BY (restrict/sort)

SET search_path = vod;

WITH counts AS (
  SELECT
    mc.categoryid,
    m.movieid,
    m.title,
    COUNT(r.rentalid) AS rentals_90d
  FROM vod.movie m
  JOIN vod.moviecategory mc ON mc.movieid = m.movieid
  LEFT JOIN vod.rental r
    ON r.movieid = m.movieid
   AND r.rentaldate >= NOW() - INTERVAL '90 days'
  GROUP BY mc.categoryid, m.movieid, m.title
)
SELECT
  c.categoryname,
  cnt.title,
  cnt.rentals_90d,
  RANK() OVER (
    PARTITION BY cnt.categoryid
    ORDER BY cnt.rentals_90d DESC, cnt.title
  ) AS rank_in_category
FROM counts AS cnt
JOIN vod.category c ON c.categoryid = cnt.categoryid
ORDER BY c.categoryname, rank_in_category, cnt.title;

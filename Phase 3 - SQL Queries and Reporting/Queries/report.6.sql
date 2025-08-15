-- C P R G 2 5 0    P R O J E C T   2
-- PHASE THREE: SQL QUERIES AND REPORTING
-- Report 6: Customers who rented before, but not in last 7 days
-- Author: Abimbola Pitan
-- Desc: Uses EXISTS/NOT EXISTS to find lapsed customers
-- Concepts: EXISTS / NOT EXISTS (subqueries), ORDER BY (restrict/sort)

SET search_path = vod;

SELECT c.customerid, c.email
FROM vod.customer c
WHERE EXISTS (         -- has at least one rental, ever
  SELECT 1 FROM vod.rental r
  WHERE r.customerid = c.customerid
)
AND NOT EXISTS (       -- but none in the last 7 days
  SELECT 1 FROM vod.rental r
  WHERE r.customerid = c.customerid
    AND r.rentaldate >= NOW() - INTERVAL '7 days'
)
ORDER BY c.customerid;

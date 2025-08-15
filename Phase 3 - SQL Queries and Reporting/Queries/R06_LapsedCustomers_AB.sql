-- C P R G 2 5 0    P R O J E C T  2  –  P H A S E  3
-- Report R06: Customers who rented before but not in last 7 days
-- Author: Abimbola (AB)
-- Script: R06_LapsedCustomers_AB.sql
-- Purpose: Identify lapsed customers using EXISTS/NOT EXISTS
-- Concepts: EXISTS / NOT EXISTS (subqueries), ORDER BY
-- Screenshot: R06_LapsedCustomers_AB.png

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


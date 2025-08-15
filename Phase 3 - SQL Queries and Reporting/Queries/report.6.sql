-- C P R G 2 5 0    P R O J E C T   2
-- PHASE THREE: SQL QUERIES AND REPORTING
-- Report 6: Customers who rented before, but not in last 180 days
-- Author: Abimbola Pitan
-- Desc: Uses EXISTS/NOT EXISTS to find lapsed customers
-- Concepts: EXISTS / NOT EXISTS (subqueries), ORDER BY (restrict/sort)

SELECT c.customerid, c.email
FROM customer c
WHERE EXISTS (
  SELECT 1 FROM rental r
  WHERE r.customerid = c.customerid
)
AND NOT EXISTS (
  SELECT 1 FROM rental r
  WHERE r.customerid = c.customerid
    AND r.rentaldate >= NOW() - INTERVAL '180 days'
)
ORDER BY c.customerid;

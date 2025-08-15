-- C P R G 2 5 0    P R O J E C T   2
-- PHASE THREE: SQL QUERIES AND REPORTING
-- Report 4: Monthly revenue with running total
-- Author: Abimbola Pitan
-- Desc: Sums pricepaid per month and shows a cumulative total
-- Concepts: SUM (group func), DATE_TRUNC, window SUM() OVER (OLAP), ORDER BY (restrict/sort)

SELECT
  DATE_TRUNC('month', r.rentaldate)::date AS month,
  SUM(r.pricepaid)                        AS revenue,
  SUM(SUM(r.pricepaid)) OVER (ORDER BY DATE_TRUNC('month', r.rentaldate)) AS running_revenue
FROM rental r
GROUP BY DATE_TRUNC('month', r.rentaldate)
ORDER BY month;

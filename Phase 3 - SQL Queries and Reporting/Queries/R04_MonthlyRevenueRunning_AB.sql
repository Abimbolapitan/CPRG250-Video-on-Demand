-- C P R G 2 5 0    P R O J E C T  2  –  P H A S E  3
-- Report R04: Monthly revenue and cumulative total
-- Author: Abimbola (AB)
-- Script: R04_MonthlyRevenueRunning_AB.sql
-- Purpose: Sum pricepaid per month and show a running total
-- Concepts: SUM (group), DATE_TRUNC, window SUM() OVER (OLAP), ORDER BY
-- Screenshot: R04_MonthlyRevenueRunning_AB.png

SET search_path = vod;

SELECT
  DATE_TRUNC('month', r.rentaldate)::date AS month,
  SUM(r.pricepaid)                        AS revenue,          -- group
  SUM(SUM(r.pricepaid)) OVER (ORDER BY DATE_TRUNC('month', r.rentaldate)) AS running_revenue  -- OLAP
FROM rental r
GROUP BY DATE_TRUNC('month', r.rentaldate)
ORDER BY month;

-- C P R G 2 5 0    P R O J E C T  2  –  P H A S E  3
-- Report R01: Customers currently in Alberta with contact info
-- Author: Abimbola (AB)
-- Script: R01_CustomersInAB_AB.sql
-- Purpose: List customer names and emails where province = 'AB'
-- Concepts: CONCAT (single-row), WHERE + ORDER BY (restrict/sort)
-- Screenshot: R01_CustomersInAB_AB.png

SET search_path = vod;

SELECT
  customerid,
  CONCAT(firstname, ' ', lastname) AS name,   -- single-row function
  email,
  provincestate AS prov
FROM customer
WHERE provincestate = 'AB'                    -- restrict
ORDER BY lastname, firstname;                 -- sort

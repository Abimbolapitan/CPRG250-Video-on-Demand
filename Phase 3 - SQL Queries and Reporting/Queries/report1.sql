-- C P R G 2 5 0    P R O J E C T   2
-- PHASE THREE: SQL QUERIES AND REPORTING
-- Report 1: Customers currently in Alberta with contact info
-- Author: Abimbola Pitan
-- Desc: Lists customer names and email where province code is 'AB'
-- Concepts: CONCAT (single-row), WHERE + ORDER BY (restrict/sort)

SELECT
  customerid,
  CONCAT(firstname, ' ', lastname) AS name,
  email,
  provincestate AS prov
FROM customer
WHERE provincestate = 'AB'
ORDER BY lastname, firstname;


-- Explore members table
SELECT *
FROM members;

-- Total number of members
SELECT COUNT(*) AS total_members
FROM members;

-- Count active members
SELECT COUNT(*) AS active_members
FROM members
WHERE enrollment_date <= CURRENT_DATE
  AND (termination_date IS NULL OR termination_date > CURRENT_DATE);

-- Monthly new enrollments
SELECT
  DATE_TRUNC('month', enrollment_date) AS enrollment_month,
  COUNT(*) AS new_members
FROM members
GROUP BY enrollment_month
ORDER BY enrollment_month;

-- Total claims cost
SELECT
  SUM(claim_amount) AS total_claim_cost
FROM claims;

-- Monthly claims cost trend
SELECT
  DATE_TRUNC('month', service_date) AS service_month,
  SUM(claim_amount) AS total_claim_cost
FROM claims
GROUP BY service_month
ORDER BY service_month;

-- Claims cost by plan type
SELECT
  m.plan_type,
  SUM(c.claim_amount) AS total_claim_cost
FROM claims c
JOIN members m
  ON c.member_id = m.member_id
GROUP BY m.plan_type
ORDER BY total_claim_cost DESC;


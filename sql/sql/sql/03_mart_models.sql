-- Member monthly metrics mart
-- Used for enrollment trend analysis
WITH member_months AS (
  SELECT
    DATE_TRUNC('month', enrollment_date) AS month,
    COUNT(*) AS new_members
  FROM stg_members
  GROUP BY 1
),

terminations AS (
  SELECT
    DATE_TRUNC('month', termination_date) AS month,
    COUNT(*) AS terminated_members
  FROM stg_members
  WHERE termination_date IS NOT NULL
  GROUP BY 1
)

SELECT
  m.month,
  COALESCE(m.new_members, 0) AS new_members,
  COALESCE(t.terminated_members, 0) AS terminated_members
FROM member_months m
LEFT JOIN terminations t
  ON m.month = t.month
ORDER BY m.month;

-- Monthly claims cost mart
SELECT
  DATE_TRUNC('month', service_date) AS month,
  SUM(claim_amount) AS total_claim_cost
FROM stg_claims
GROUP BY 1
ORDER BY 1;

-- PMPM calculation

WITH monthly_claims AS (
  SELECT
    DATE_TRUNC('month', service_date) AS month,
    SUM(claim_amount) AS total_claim_cost
  FROM stg_claims
  GROUP BY 1
),

monthly_members AS (
  SELECT
    DATE_TRUNC('month', enrollment_date) AS month,
    COUNT(*) AS active_members
  FROM stg_members
  WHERE termination_date IS NULL
     OR termination_date > enrollment_date
  GROUP BY 1
)

SELECT
  c.month,
  c.total_claim_cost,
  m.active_members,
  ROUND(c.total_claim_cost / NULLIF(m.active_members, 0), 2) AS pmpm
FROM monthly_claims c
JOIN monthly_members m
  ON c.month = m.month
ORDER BY c.month;


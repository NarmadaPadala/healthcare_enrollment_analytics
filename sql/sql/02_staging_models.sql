-- Staging members table
-- Cleaned and standardized enrollment data
SELECT
  member_id,
  plan_type,
  enrollment_date,
  termination_date,
  age,
  gender
FROM members;


-- Staging claims table
-- Cleaned claims cost data
SELECT
  claim_id,
  member_id,
  service_date,
  claim_amount,
  claim_type
FROM claims;

-- Staging plans reference table
SELECT
  plan_type,
  plan_name,
  metal_level
FROM plans;


CREATE OR REPLACE TABLE hackathon.bl_customers AS

-- Some loyalty_card_creation_date are null. If it's null, we use the last_purchase_date instead
-- There are some duplications in loyalty_card_num. Use "Qualify" to keep only one.
WITH single_loyalty AS (
  SELECT
    * EXCEPT(loyalty_card_creation_date),
    IF
      (loyalty_card_creation_date IS NULL, CAST(last_purchase_date AS TIMESTAMP), loyalty_card_creation_date) AS loyalty_card_creation_date
  FROM
        hackathon.d_customers
  QUALIFY ROW_NUMBER() OVER(PARTITION BY loyalty_card_num ORDER BY loyalty_card_creation_date DESC,last_purchase_date DESC) = 1
)

-- Put Generation_Z classification on customers according to their year_birthdate and counting
SELECT
  *,
  CASE
    WHEN year_birthdate < 1997 THEN "older_gen_z"
    WHEN year_birthdate BETWEEN 1997 AND 2010 THEN "gen_z"
    WHEN year_birthdate > 2010 THEN "younger_gen_z"
    ELSE "unknown"
  END AS class_gen_z,
  CASE
    WHEN year_birthdate < 1997 THEN 1
    WHEN year_birthdate BETWEEN 1997 AND 2010 THEN 1
    WHEN year_birthdate > 2010 THEN 1
    ELSE 1
  END AS count_gen_z,
  COUNT(loyalty_card_num) OVER () AS total_clients
FROM
  single_loyalty;



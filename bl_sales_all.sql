
-- Create or replace a table "bl_sales_all"
-- and add a column "product_scope" based on the condition if the modeles belong to the four limited series
CREATE OR REPLACE TABLE hackathon.bl_sales_all PARTITION BY the_date_transaction AS
WITH nom_sales AS (
  SELECT *,
    CASE
      WHEN mdl_num_model_r3 IN (7635140, 5015822, 2486222, 7166996) THEN 1
      ELSE 0
    END AS product_scope
  FROM  hackathon.f_transaction_detail
  LEFT JOIN (SELECT distinct sku_idr_sku,mdl_num_model_r3,product_nature_label FROM hackathon.d_sku) s
  USING(sku_idr_sku)
)
-- Add a column "panier_scope" based on the sum of "product_scope" over the partition of "the_transaction_id". The basket contains at least one module from the scope
SELECT *,
  CASE
    WHEN SUM(product_scope) OVER (PARTITION BY the_transaction_id ORDER BY the_date_transaction) >= 1 THEN 1
    ELSE 0
  END AS panier_scope
FROM nom_sales;

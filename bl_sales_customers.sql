-- Create or replace the table hackathon.bl_sales_customers partitioned by the_date_transaction
CREATE OR REPLACE TABLE hackathon.bl_sales_customers PARTITION BY the_date_transaction AS

-- Selecting necessary columns and aggregating sales data
SELECT
  the_transaction_id,
  the_date_transaction,
  ctm_customer_id,
  loyalty_card_creation_date,
  last_purchase_date,
  -- mdl_num_model_r3,
  SUM(f_to_tax_in) AS f_to_tax_in,
  SUM(f_qty_item) AS f_qty_item,
  product_scope,
  panier_scope,
  class_gen_z,
  count_gen_z
FROM
  hackathon.bl_sales_all
INNER JOIN
  hackathon.bl_customers
ON
  ctm_customer_id = loyalty_card_num
-- WHERE
--   panier_scope = 1
GROUP BY
  the_transaction_id,
  the_date_transaction,
  ctm_customer_id,
  loyalty_card_creation_date,
  last_purchase_date,
  -- mdl_num_model_r3,
  product_scope,
  panier_scope,
  class_gen_z,
  count_gen_z

-- Select only the rows with the latest purchase date for each customer
QUALIFY ROW_NUMBER() OVER (PARTITION BY ctm_customer_id ORDER BY last_purchase_date DESC) = 1;

LOAD DATA
INFILE 'fullstg_fact_vp_order_product.csv'
BADFILE 'fullstg_fact_vp_order_product.bad'
DISCARDFILE 'fullstg_fact_vp_order_product.dsc'
INTO TABLE STG_FACT_VP_ORDER_PRODUCT
TRUNCATE
FIELDS TERMINATED BY ',' optionally enclosed by '"'
NULLIF = "NULL"
DATE FORMAT "yyyy-mm-dd HH24:MI"
   ( row_id,
    quantity,
    discount,
    shipping_cost,
    order_id,
    product_id,
    ship_mode,
    ship_date,
    cust_id,
    location_id,
    state_id,
    country_id,
    market_id,
    region_id,
    category_id,
    sub_cat_id,
    TBL_LAST_DT  
 )
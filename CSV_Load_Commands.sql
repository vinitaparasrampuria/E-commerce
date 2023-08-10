LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Customer.csv' 
INTO TABLE superstore.mm_customer 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (id, customer_id, first_name, last_name, segment)
SET created_at = NOW(),
	updated_at = NOW();

LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Order.csv' 
INTO TABLE superstore.mm_order
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (order_id, customer_id, @order_date, return_status)
SET order_date = STR_TO_DATE(@order_date,'%m/%d/%y'),
	created_at = NOW(),
	updated_at = NOW();

SET GLOBAL local_infile=1;

LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Address.csv' 
INTO TABLE superstore.mm_address 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (address_id,city, add_state, country, region, market)
SET created_at = NOW(),
	updated_at = NOW();

LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Customer_address.csv' 
INTO TABLE superstore.mm_customer_address
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (address_id, customer_id, postal_code)
SET created_at = NOW(),
	updated_at = NOW();

LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Product_category.csv' 
INTO TABLE superstore.mm_product_category 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (category_id,category, sub_category)
SET created_at = NOW(),
	updated_at = NOW();
    
LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Category.csv' 
INTO TABLE superstore.mm_category 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (category_id,category)
SET created_at = NOW(),
	updated_at = NOW();
    
LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Sub_Category.csv' 
INTO TABLE superstore.mm_sub_category 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (sub_category_id,category_id, sub_category)
SET created_at = NOW(),
	updated_at = NOW();

LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Product.csv' 
INTO TABLE superstore.mm_product
FIELDS TERMINATED BY ','  
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (id,product_id,product_name,mrp, manu_cost, category_id,sub_category_id )
SET created_at = NOW(),
	updated_at = NOW();

LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Order_product.csv' 
INTO TABLE superstore.mm_order_product
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (order_id,product_id,quantity,discount,shipping_cost)
SET created_at = NOW(),
	updated_at = NOW();

LOAD DATA LOCAL INFILE '/Users/jinishamehta/Documents/NYU/DBMS/Advance_Project/Data Loading/Shipping_details.csv' 
INTO TABLE superstore.mm_shipping_details
FIELDS TERMINATED BY ','  
LINES TERMINATED BY '\n' 
IGNORE 1 
ROWS (ship_id,order_id,@ship_date,ship_mode,priority)
SET ship_date = STR_TO_DATE(@ship_date,'%m/%d/%y'), 
    created_at = NOW(),
	updated_at = NOW();
    
-- mysql --local-infile=1 -u root -p;
show global variables like 'local_infile';
show global variables like 'secure_file_priv';
set global local_infile=True;
--  show global variables like 'local_infile';
--   quit;

select * from
mm_order o
inner join 
mm_order_product op
on o.order_id = op.order_id
inner join
mm_product p 
on p.product_id = op.product_id
inner join
mm_product_category pc
on pc.category_id = p.category_id
where 
o.order_id = "CA-2012-AB10015140-40974";  

use superstore;
select p.product_id, p.product_name, p.mrp, p.manu_cost,
	s.sub_category_id, s.sub_category, 
    c.category_id, c.category, current_date() as tbl_last_date
into outfile '/usr/local/mysql/data/dim_mm_product.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM mm_product p
join mm_sub_category s
on p.sub_category_id = s.sub_category_id
join mm_category c
on p.category_id = c.category_id;

select c.customer_id, c.first_name, c.last_name, c.segment,
	i.address_id, i.postal_code,
    a.city, a.add_state, a.country, a.region, a.market
into outfile '/usr/local/mysql/data/dim_mm_customer.csv'
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM mm_customer c
right join mm_customer_address i
on c.id= i.customer_id
left join mm_address a
on a.address_id = i.address_id;







use ppt_project;
-- ******** --
-- EXPLORE ALL THE TABLES IN THE SCHEMA --
-- ********* --

-- ***************** --
-- SLIDE 2 --
-- ***************** --
-- 3 YEARS OF DATA FROM JULY 2012 to OCTOBER 2014 
SELECT * FROM orders;
SELECT year(ordersdate) as years,week(ordersdate),monthname(ordersdate),count(date((ordersdate))) as days
 FROM orders group by 1,2,3 ;

-- 91 CUSTOMERS --
SELECT * FROM customer;
SELECT COUNT(id) AS total_customer FROM customer;

--  830 ORDERS --
SELECT * FROM orders;
SELECT COUNT(id) AS orders_placed FROM orders;

-- 2155 ORDER QUATITY --
SELECT * FROM ordersitem;
SELECT count(id) AS order_quantity FROM ordersitem;

-- 78 PRODUCT CATEGORIES--
SELECT * FROM product;
SELECT COUNT(id) AS product_categories FROM product;

-- 29 SUPPLIER COMPANIES --
SELECT * FROM supplier;
SELECT COUNT(id) AS supplier_company FROM supplier;


-- ***************** --
-- SLIDE 3 --
-- ***************** --
-- sales performance in countries --
select c.country, count(o.id) as orders_placed from customer as c INNER JOIN orders as o on 
c.id=o.CustomerId group by 1 order by 2 desc ;  

-- ***************** --
-- SLIDE 4 --
-- ***************** --
-- sales performance in cities --
select c.city, count(o.id) as orders_placed from customer as c INNER JOIN orders as o on 
c.id=o.CustomerId group by 1 order by 2 desc ; 


-- ***************** --
-- SLIDE 5 --
-- ***************** --
--  total Revenue --
select sum(totalamount) as total_revenue from orders;

-- sales revenue on monthly basis over years --
select months,max(weeks) as weeks,max(year2012) as year2012,max(year2013) as year2013,max(year2014) as year2014 from (select months,weeks, case 
when years=2012  then rev
else 0 
end as year2012,
case 
when years=2013 then rev
else 0 
end as year2013,
case
when years=2014 then rev
else 0 
end as year2014 from (select year(ordersdate) as years ,monthname(OrdersDate) as months,weekofyear(OrdersDate) as weeks,sum(totalamount) as 
rev from  orders group by 1,2,3) as y) as m group by 1 order by 2  ;
  
 
-- ***************** --
-- SLIDE 6 
-- ***************** --
 --  product_supplier and thier companies from different country
select  n as country,max(uk_products) as uk, max(france_products) as france,max(canada_products) as canada ,
 max(brazil_products) as brazil ,max(germany_products) as germany , max(spain_products) as spain , max(sweden_products) as sweden,
 max(usa_products) as usa,max(denmark_products) as denmark,max(australia_products) as australia , max(finland_products) as finland, 
 max(singapore_products) as singapore, max(italy_products) as italy,max(japan_products) as japan, max(netherland_products) as
 netherland, max(norway_products)  as norway from  (
 select c,n, 
case  when c="uk" then cnt else 0 end as uk_products,
case when c="france"then cnt else 0 end as france_products,
case when c="canada"then cnt else 0 end as canada_products,
case when c="brazil"then cnt else 0 end as brazil_products,
case when c="germany"then cnt else 0 end as germany_products,
case when c="spain"then cnt else 0 end as spain_products,
case when c="sweden"then cnt else 0 end as sweden_products,
case when c="usa"then cnt else 0 end as usa_products,
case when c="denmark"then cnt else 0 end as denmark_products,
case when c="australia"then cnt else 0 end as australia_products,
case when c="finland"then cnt else 0 end as finland_products,
case when c="netherlands"then cnt else 0 end as netherland_products,
case when c="norway"then cnt else 0 end as norway_products,
case when c="singapore"then cnt else 0 end as singapore_products,
case when c="japan"then cnt else 0 end as japan_products,
case when c="italy"then cnt else 0 end as italy_products 
 from (
 select s.country as c ,s.companyname as n ,count(p.id) as cnt from supplier as s  inner join product  as p on 
 s.id = p.supplierid group by 1,2 ) as m) as y group by 1 ; 
 
 
-- ***************** --
-- SLIDE 7
-- ***************** --
 --    number of orders and the revenue of the product --
 select  p.ProductName,count(i.id) as product_quantity,sum((i.unitprice*i.quantity)) as sales_amount
from ordersitem  as i inner join product as p on i.productid= p.id group by 1  ; 
 
 
 
-- ***************** --
-- SLIDE 8
-- ***************** -- 
-- average revenue per user --
select  (revenue/customers) as avg_revenue_per_user  from 
( select  sum(totalamount) as revenue, count(distinct(customerid)) as customers from orders ) as m ;

-- average revenue per customer in monthly basis --
select   monthly_basis,max((revenue/customers)) as avg_revenue_per_user,max(weeks) as weeks  from 
( select  week(ordersdate) as weeks, monthname(ordersdate) as monthly_basis, sum(totalamount) as revenue, 
count(distinct(customerid)) as customers
 from orders where year(ordersdate)="2013" group by 1,2) as m  group by  1;


-- ***************** --
-- END -- 
-- ***************** --  
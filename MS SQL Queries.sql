--- Find the hierarchy of employees under a given manager "Asha". --- 
drop TABLE emp_details;
CREATE TABLE emp_details
    (
        id           int PRIMARY KEY,
        name         varchar(100),
        manager_id   int,
        salary       int,
        designation  varchar(100)
    );
INSERT INTO emp_details VALUES (1,  'Rudy', NULL, 10000, 'CEO');
INSERT INTO emp_details VALUES (2,  'Satya', 5, 1400, 'Software Engineer');
INSERT INTO emp_details VALUES (3,  'Jia', 5, 500, 'Data Analyst');
INSERT INTO emp_details VALUES (4,  'David', 5, 1800, 'Data Scientist');
INSERT INTO emp_details VALUES (5,  'Michael', 7, 3000, 'Manager');
INSERT INTO emp_details VALUES (6,  'Arvind', 7, 2400, 'Architect');
INSERT INTO emp_details VALUES (7,  'Asha', 1, 4200, 'CTO');
INSERT INTO emp_details VALUES (8,  'Maryam', 1, 3500, 'Manager');
INSERT INTO emp_details VALUES (9,  'Simon', 8, 2000, 'Business Analyst');
INSERT INTO emp_details VALUES (10, 'Akshay', 8, 2500, 'Java Developer');
commit;
--- Solution using recursive cte:
  with cte as
  (select *
  from emp_details 
  where name = 'Asha'
  union all 
  select e.*
  from cte 
  join emp_details e on e.manager_id = cte.id)
  select * from cte;


/***Pizza Delivery Status
An order's Final_ Status is calculated based on status as follows:
1. When all orders for a customer have a status of DELIVERED, that customer's order has a Final_Status of COMPLETED.
2. If a customer has some orders that are not DELIVERED and some orders that are DELIVERED, the Final_ Status is IN PROGRESS.
3. If all of a customer's orders are SUBMITTED, the Final_Status is AWAITING PROGRESS.
4. Otherwise, the Final Status is AWAITING SUBMISSION.
Write a query to report the customer_name and Final_Status of each customer's arder. Order the results by customer name. ***/
drop table cust_orders;
create table cust_orders
(
cust_name   varchar(50),
order_id    varchar(10),
status      varchar(50)
);

insert into cust_orders values ('John', 'J1', 'DELIVERED');
insert into cust_orders values ('John', 'J2', 'DELIVERED');
insert into cust_orders values ('David', 'D1', 'SUBMITTED');
insert into cust_orders values ('David', 'D2', 'DELIVERED'); 
insert into cust_orders values ('David', 'D3', 'CREATED');
insert into cust_orders values ('Smith', 'S1', 'SUBMITTED');
insert into cust_orders values ('Krish', 'K1', 'CREATED');
commit;
---Solution using CASE WHEN:
select cust_name, 
case 
when count(*) = count(case when status = 'DELIVERED' then 1 end) then 'COMPLETED'
when count(case when status <> 'DELIVERED' then 1 end) > 1 then 'IN PROGRESS'
when count(*) = count(case when status = 'SUBMITTED' then 1 end) then 'AWAITING PROGRESS'
else 'AWAITING SUBMISSION' end as status
from cust_orders
group by cust_name


--- Find difference in average sales. Write a query to find the difference in average sales for each month of 2003 and 2004
create table Sales_order
(
    order_number        bigserial primary key,
    quantity_ordered    int check (quantity_ordered > 0),
    price_each          float,
    sales               float,
    order_date          date,
    status              varchar(15),
    qtr_id              int check (qtr_id between 1 and 4),
    month_id            int check (month_id between 1 and 12),
    year_id             int,
    Product             varchar(20) ,
    customer            varchar(20) ,
    deal_size           varchar(10) check (deal_size in ('Small', 'Medium', 'Large'))
);
alter table Sales_order add constraint chk_ord_sts
check (status in ('Cancelled', 'Disputed', 'In Process', 'On Hold', 'Resolved', 'Shipped'));

insert into sales_order values (DEFAULT,'30','95.7','2871',to_date('2/24/2003','mm/dd/yyyy'),'Shipped','1','2','2003','S10_1678','C1','Small');
insert into sales_order values (DEFAULT,'34','81.35','2765.9',to_date('05/07/2003','mm/dd/yyyy'),'Shipped','2','5','2003','S10_1678','C2','Small');
insert into sales_order values (DEFAULT,'41','94.74','3884.34',to_date('07/01/2003','mm/dd/yyyy'),'Shipped','3','7','2003','S10_1678','C3','Medium');
insert into sales_order values (DEFAULT,'45','83.26','3746.7',to_date('8/25/2003','mm/dd/yyyy'),'Shipped','3','8','2003','S10_1678','C4','Medium');
insert into sales_order values (DEFAULT,'49','100','5205.27',to_date('10/10/2003','mm/dd/yyyy'),'Shipped','4','10','2003','S10_1678','C5','Medium');
insert into sales_order values (DEFAULT,'36','96.66','3479.76',to_date('10/28/2003','mm/dd/yyyy'),'Shipped','4','10','2003','S10_1678','C6','Medium');
insert into sales_order values (DEFAULT,'29','86.13','2497.77',to_date('11/11/2003','mm/dd/yyyy'),'Shipped','4','11','2003','S10_1678','C7','Small');
insert into sales_order values (DEFAULT,'48','100','5512.32',to_date('11/18/2003','mm/dd/yyyy'),'Shipped','4','11','2003','S10_1678','C8','Medium');
insert into sales_order values (DEFAULT,'22','98.57','2168.54',to_date('12/01/2003','mm/dd/yyyy'),'Shipped','4','12','2003','S10_1678','C9','Small');
insert into sales_order values (DEFAULT,'41','100','4708.44',to_date('1/15/2004','mm/dd/yyyy'),'Shipped','1','1','2004','S10_1678','C10','Medium');
insert into sales_order values (DEFAULT,'37','100','3965.66',to_date('2/20/2004','mm/dd/yyyy'),'Shipped','1','2','2004','S10_1678','C11','Medium');
insert into sales_order values (DEFAULT,'23','100','2333.12',to_date('04/05/2004','mm/dd/yyyy'),'Shipped','2','4','2004','S10_1678','C12','Small');
insert into sales_order values (DEFAULT,'28','100','3188.64',to_date('5/18/2004','mm/dd/yyyy'),'Shipped','2','5','2004','S10_1678','C13','Medium');

--- Solutions:    
with cte as (
select avg(sales) avg_sales, month_id, year_id, format(order_date, 'MMM') mon
from Sales_order
where year_id in (2003,2004)
group by month_id, year_id, format(order_date, 'MMM'))

select y3.mon, round(abs(y3.avg_sales - y4.avg_sales),2) diff
from cte y3
join cte y4 on y3.month_id = y4.month_id
where y3.year_id = 2003 and y4.year_id = 2004
order by y3.month_id

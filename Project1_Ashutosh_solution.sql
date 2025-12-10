
--1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 

with cte as (select city,sum(amount) as total_spend 
from credit_card_transcations
group by city)
,cte2 as (select sum(cast(amount as bigint)) as total_amount from credit_card_transcations)

select top 5 cte.* ,round(total_spend*1.0/total_amount *100,2) as percentage_contribution from cte
join cte2 on 1=1
order by total_spend  desc

select * from credit_card_transcations
--2- write a query to print highest spend month and amount spent in that month for each card type

with cte as (select card_type, datepart(year,transaction_date) as yt,datepart(month,transaction_date) as mt,sum(amount) as total_spend
from credit_card_transcations
group by card_type, datepart(year,transaction_date) ,datepart(month,transaction_date))

select * from(select *,rank() over (partition by card_type order by total_spend desc) as rn from cte)A
where rn =1



--3- write a query to print the transaction details(all columns from the table) for each card type when
--it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)

with cte as (select *,sum(amount) over(partition by card_type order by transaction_date,transaction_id) as total_spend 
from credit_card_transcations)

select * from(select * ,rank() over(partition by card_type order by  total_spend) as rn from cte
where total_spend>=1000000)A
where rn=1

--4- write a query to find city which had lowest percentage spend for gold card type


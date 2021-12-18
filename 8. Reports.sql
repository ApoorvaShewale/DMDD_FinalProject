--------------View rating of all properties----------------
select (p.p_id) as Apartment_no, p_type Property_type, p_city City, 
p_street Street, p_state State, p_zipcode Zipcode,
round((f.f_rating_maintainance + f.f_rating_cleanliness + 
f.f_rating_amenities+f_rating_utilities+f_rating_location
+f_rating_rent+f_rating_aptcondition+f_rating_recommendation)/8) Rating_for_property,f.f_date Feedback_date 
from Property p join feedback f on p.p_id = f.fk_p_id order by p.p_id,f.f_date;


--------Customer leasing property multiple times are premium customers-------
SELECT c.c_id premium_customer_id,
c.c_fname || ' '|| c.c_lname Customer_name,
c.c_phone Phone_no,c.c_email Email_id, c.c_city city,c.c_state State,
c.c_zipcode Zipcode
FROM LEASE L JOIN CUSTOMER C
ON L.FK_LEASE_C_ID = c.c_id
GROUP BY c.c_id,c.c_fname,c.c_lname,
c.c_phone, c.c_email,c.c_city,c.c_state,
c.c_zipcode HAVING COUNT(*) > 1;



-----------View rating for available properties-----------
select p.p_id Apartment_no, p_type Property_type, p_city City, 
p_street Street, p_state State, p_zipcode Zipcode,
round((f_rating_maintainance + f_rating_cleanliness + 
f_rating_amenities+f_rating_utilities+f_rating_location
+f_rating_rent+f_rating_aptcondition+f_rating_recommendation)/8) Rating_for_property
from Property p join feedback f on p.p_id = f.fk_p_id where p.P_ID in (Select p_id from Property 
where P_ID Not IN (Select FK_Lease_P_ID from Lease) Or P_ID IN (Select FK_Lease_P_ID from Lease where L_Status='Broken' or L_Status='Completed'
and (FK_Lease_P_ID Not IN (select FK_Lease_P_ID from Lease where L_Status='Active'))));



----------------Customers with pending amount------------
--Fetched the customers with amount yet to be paid after the Due date
--Also calculated the remaining amount under amount_to_be_paid 
select l.fk_lease_p_id Apartment_no, c_id, c_fname ||' '|| c_lname Customer_name, c_street Street, c_zipcode Zipcode,
l.l_id Lease_Id, l.l_strtdate Lease_Start_date, l.l_enddate Lease_end_date, l.l_pay_duedate Due_Date,
l.mon_rent Monthly_Rent, cp.amount_paid Amount_Paid,
(l.mon_rent - cp.amount_paid) Amount_to_be_paid
from customer_payment cp join customer c on c.c_id = cp.fk_customer_payment_c_id 
join lease l on cp.fk_customer_payment_c_id = l.fk_lease_c_id 
where fk_customer_payment_c_id in 
(select distinct fk_customer_payment_c_id from customer_payment where payment_status = 'Pending'
minus
(select distinct  fk_customer_payment_c_id from customer_payment where fk_customer_payment_c_id in (
select distinct fk_customer_payment_c_id from customer_payment where payment_status = 'Pending') 
and payment_status = 'Complete'));


---------Calculated Amount to be paid after applying discount-------------------
select  distinct p.p_id Apartment_no, l.deposit, l.keyfee, l.Application_fee, l.MISC, p.p_discount Discount,
(l.deposit+l.keyfee+l.Application_fee+l.MISC) - (p.P_discount/100*(l.deposit+l.keyfee+l.Application_fee+l.MISC)) as total_fee_after_discount, 
l.mon_rent Monthly_rent from Lease l join property p on p.p_id = l.fk_lease_p_id 
join customer_payment cp on cp.fk_customer_payment_c_id = l.fk_lease_c_id order by 1 asc;



------------------------Sales Report by Region and Year---------------------------
select distinct to_char(l.l_enddate,'YYYY') as Sales_Year,p.p_state as Region,
sum(cp.amount_paid) OVER (PARTITION BY to_char(l.l_enddate,'YYYY')) AS Sales_by_region
from customer_payment cp join lease l on  cp.fk_customer_payment_c_id = l.fk_lease_c_id
join property p on l.fk_lease_p_id = p.p_id  order by 1;



-----------Properties with most to least complaints----------------
select distinct p.p_id Apartment_no,o.o_fname || ' '||o.o_lname as Owner_name, 
o.o_contact Contact_number, o.o_email as email_id,p.p_type Property_type, p.p_city City, 
p.p_street Street, p.p_state State, p.p_zipcode Zipcode,
count(*) over (partition by fk_complaint_p_id order by p.p_id )as No_of_complaints 
from complaint c
join property p on c.fk_complaint_p_id = p.p_id
join owner o on p.fk_o_id = o.o_id order by 10 desc;


----------------------Calculates discount, amount to be paid by customer after discount, credit/debit amount of the customer---------------------
select  distinct cp.fk_customer_payment_c_id as customer_id,to_char(l.l_enddate,'YYYY') as Rented_in_year, 
l.deposit, l.keyfee, l.Application_fee, l.MISC, 
p.p_discount Discount,  l.mon_rent Monthly_rent,
sum(cp.amount_paid) OVER (PARTITION BY fk_customer_payment_c_id,to_char(l.l_enddate,'YYYY')) as amt_paid_by_customer,

-------The below case statement gives the total amount to be paid after calculating discount-----------
case  
WHEN  l.fk_lease_c_id in (Select fk_customer_payment_c_id from customer_payment where payment_status = 'Complete' group by fk_customer_payment_c_id having count(*)>1)
THEN 2*((l.deposit+l.keyfee+l.Application_fee+l.MISC) - (p.P_discount/100*(l.deposit+l.keyfee+l.Application_fee+l.MISC)))
else (l.deposit+l.keyfee+l.Application_fee+l.MISC) - (p.P_discount/100*(l.deposit+l.keyfee+l.Application_fee+l.MISC)) 
end as total_amt_after_discount,

--------The below part of query gives the customer's credit/debit amount---------
case 
when l.fk_lease_c_id in (Select fk_customer_payment_c_id from customer_payment where payment_status = 'Complete' group by fk_customer_payment_c_id having count(*)>1)
Then (sum(cp.amount_paid) OVER (PARTITION BY l.fk_lease_c_id,to_char(l.l_enddate,'YYYY')) -
2*((l.deposit+l.keyfee+l.Application_fee+l.MISC) - (p.P_discount/100*(l.deposit+l.keyfee+l.Application_fee+l.MISC))))
else 
(sum(cp.amount_paid) OVER (PARTITION BY l.fk_lease_c_id,to_char(l.l_enddate,'YYYY')) -
((l.deposit+l.keyfee+l.Application_fee+l.MISC) - (p.P_discount/100*(l.deposit+l.keyfee+l.Application_fee+l.MISC))))
end as credit_debit

from Lease l join property p on p.p_id = l.fk_lease_p_id 
join customer_payment cp on cp.fk_customer_payment_c_id = l.fk_lease_c_id
where l_strtdate >('01-Jan-2021') AND l_strtdate <('31-Dec-2021')
and l.l_status = 'Active' or l.l_status = 'Pending'
order by 1 asc;
--------Customer leasing property multiple times are premium customers-------
SELECT C.C_ID PREMIUM_CUSTOMER_ID,
C.C_FNAME FIRST_NAME ,C.C_LNAME LAST_NAME,
C.C_PHONE PHONE_NO, C.C_CITY CITY,C.C_STATE STATE,
C.C_ZIPCODE ZIPCODE
FROM LEASE L JOIN CUSTOMER C
ON L.FK_LEASE_C_ID = C.C_ID
GROUP BY C.C_ID,C.C_FNAME, C.C_LNAME,C.C_PHONE, C.C_CITY,C.C_STATE,
C.C_ZIPCODE HAVING COUNT(*) > 1;





-----------View rating for available properties-----------
select p.p_id, p_type Property_type, p_city City,
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
select t_id Transaction_ID, c_id, c_fname ||' '|| c_lname Customer_name, c_street Street, c_zipcode Zipcode,
l.l_id Lease_Id, l.l_strtdate Lease_Start_date, l.l_enddate Lease_end_date, l.l_pay_duedate Due_Date,
l.mon_rent Monthly_Rent, cp.amount_paid Amount_Paid,
(l.mon_rent - cp.amount_paid) Amount_to_be_paid
from customer_payment cp join customer c on c.c_id = cp.fk_customer_payment_c_id
join lease l on cp.fk_customer_payment_c_id = l.fk_lease_c_id
where fk_customer_payment_c_id in
(select distinct fk_customer_payment_c_id from customer_payment where payment_status = 'Pending'
minus
(select distinct fk_customer_payment_c_id from customer_payment where fk_customer_payment_c_id in (
select distinct fk_customer_payment_c_id from customer_payment where payment_status = 'Pending')
and payment_status = 'Complete'));


---------Calculated Amount to be paid after applying discount-------------------
select distinct p.p_id Property_Id, l.deposit, l.keyfee, l.Application_fee, l.MISC, p.p_discount Discount, (l.deposit+l.keyfee+l.Application_fee+l.MISC) - (p.P_discount/100*(l.deposit+l.keyfee+l.Application_fee+l.MISC)) as total_fee_after_discount,
l.mon_rent Monthly_rent from Lease l join property p on p.p_id = l.fk_lease_p_id join customer_payment cp on cp.fk_customer_payment_c_id = l.fk_lease_c_id order by 1 asc;






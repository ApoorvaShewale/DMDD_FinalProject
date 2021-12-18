--CUSTOMER

call DROP_ENTITY('customer','PROFILE');
call DROP_ENTITY('Bernard','USER');

----CREATE CUSTOMER PROFILE---------------------------------------------
Create profile customer limit 
SESSIONS_PER_USER UNLIMITED
CPU_PER_SESSION UNLIMITED 
CONNECT_TIME 15
FAILED_LOGIN_ATTEMPTS 5
    PASSWORD_LIFE_TIME 90;


----CREATE CUSTOMER ROLE --------------------------------------------------------
create role customer_role;    

----CREATE USER --------------------------------------------------------    
    CREATE USER Bernard
    IDENTIFIED BY Northeastern2021
    PROFILE customer
    ACCOUNT UNLOCK;

---------------GRANT SESSION AND ROLE TO USER------------------------------   
grant create session to Bernard;
grant customer_role to Bernard;

---------------------GRANT ACCESS--------------------------------------------
grant select,update on customer_view to customer_role;
grant select on VALL_AVAILABLE_PROPERTIES to customer_role;
grant select on VALL_customer_lease to customer_role;
grant select,update,insert on customer_card_detail_V to customer_role;
grant select,update,insert on CUSTOMER_BANK_DETAILS_V to customer_role;
grant select on CUSTOMER_PAYMENT_V to customer_role;
grant select,insert on CUSTOMER_FEEDBACK_V to customer_role;
grant select,insert on customer_complaint_view to customer_role;

--GRANT EXECUTE ON add_feedback to Bernard;


CREATE OR REPLACE VIEW customer_view AS
select C_ID,C_FNAME,C_LNAME,C_PHONE,C_EMAIL,C_DOB,C_CITY,C_STREET,C_STATE,C_ZIPCODE,C_RFNAME,C_RLNAME,C_REFRELATION,C_REFPHONE,C_REFADDRESS,C_DATE_ADDED,regexp_replace (C_SSN, '([[:digit:]]{7})', '******\3') C_SSN,C_OCCUPATION,C_GENDER
from customer where lower(C_Fname)=(select lower(user) from dual);

CREATE OR REPLACE VIEW VALL_AVAILABLE_PROPERTIES AS
Select P_ID "PROPERTY ID",FK_MID "MANAGEMENT ID", FK_O_ID "OWNER ID",
P_TYPE "PROPERTY TYPE", P_CITY "PROPERTY CITY", P_ZIPCODE "ZIPCODE",
P_CONFIGURATION "CONFIGURATION",P_FLOOR "FLOOR",P_CARPETAREA "CARPETAREA"
from Property where P_ID Not IN (Select FK_Lease_P_ID from Lease) Or
P_ID IN (Select FK_Lease_P_ID from Lease where L_Status='Broken' or L_Status='Completed'
and (FK_Lease_P_ID Not IN (select FK_Lease_P_ID from Lease where L_Status='Active')));



CREATE OR REPLACE VIEW VALL_customer_lease AS
select l_id,fk_lease_p_id,fk_lease_c_id,l_strtdate,l_enddate,l_status,mon_rent,l_pay_duedate,deposit,keyfee,application_fee,latefee,misc,subleasing_allowed
from lease where fk_lease_c_id = (Select c_id from customer where lower(C_Fname)=(select lower(user) from dual));

CREATE OR REPLACE VIEW customer_view AS
Select * from customer where lower(C_Fname)=(select lower(user) from dual);


create or replace view customer_card_detail_V
as select regexp_replace (card_number, '([[:digit:]]{12})', '************\4') card_number,
fk_c_id, expiry_date,card_type,name_on_card,regexp_replace (CVV, '([[:digit:]])', '**') CVV
from Customer_card_detail where fk_c_id = (Select c_id from customer where lower(C_Fname)=(select lower(user) from dual));


Create or replace view CUSTOMER_BANK_DETAILS_V as
select detail_ID,fk_cbd_c_id,bankname, regexp_replace (account_number, '([[:digit:]]{6})', '******\4') account_number,bank_routingnumber,last_updated 
from Customer_bank_detail where fk_cbd_c_id = (Select c_id from customer where lower(C_Fname)=(select lower(user) from dual));

Create or replace view CUSTOMER_PAYMENT_V as
select T_ID,fk_customer_payment_c_id,amount_paid,payment_date,payment_status,autopayenable from customer_payment 
where fk_customer_payment_c_id = (Select c_id from customer where lower(C_Fname)=(select lower(user) from dual));

Create or replace view CUSTOMER_FEEDBACK_V as
select * from feedback 
where fk_p_id = (select fk_lease_p_id from lease where fk_lease_c_id = (Select c_id from customer where lower(C_Fname)=(select lower(user) from dual)));

Create or replace view customer_complaint_view as
select * from complaint 
where fk_complaint_p_id = (select p_id from property where p_id = (Select fk_lease_p_id from lease where fk_lease_c_id = (Select c_id from customer where lower(C_Fname)=(select lower(user) from dual))));


--select * from ADMIN.customer_view;



--select * from admin.VALL_AVAILABLE_PROPERTIES;



--select * from admin.VALL_customer_lease;



--select * from admin.customer_view;



--select * from admin.customer_card_detail_V;



--select * from admin.CUSTOMER_BANK_DETAILS_V;



--select * from admin.CUSTOMER_PAYMENT_V;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--OWNER

----CREATE OWNER PROFILE---------------------------------------------
Create profile owner limit 
SESSIONS_PER_USER UNLIMITED
CPU_PER_SESSION UNLIMITED 
CONNECT_TIME 15
FAILED_LOGIN_ATTEMPTS 5
    PASSWORD_LIFE_TIME 90;

---------------CREATE OWNER ROLE-------------------------------------
create role owner_role;    

-------------------------------CREATE USER----------------------------    
    CREATE USER Marshall
    IDENTIFIED BY Northeastern2021
    PROFILE owner
    ACCOUNT UNLOCK;
    

grant create session to Marshall;
grant owner_role to Marshall;
   

grant select,insert,update on owner_view to owner_role;
grant select on owner_property_view to owner_role;
grant select on owner_lease_view to owner_role;
grant select on owner_feedback_view to owner_role;
grant select on owner_complaint_view to owner_role;
grant select on owner_mgmt_view to owner_role;

 


CREATE OR REPLACE VIEW owner_view AS
select O_ID,O_FNAME,O_LNAME,O_DOB,O_CITY,O_STREET,O_STATE,O_ZIPCODE,O_CONTACT,O_DATE_ADDED,regexp_replace (O_SSN, '([[:digit:]]{7})', '******\3') O_SSN,O_EMAIL,O_OCCUPATION,O_GENDER
from owner where lower(o_Fname)=(select lower(user) from dual);

CREATE OR REPLACE VIEW owner_property_view AS
select * from property where fk_o_id = (Select o_id from owner where lower(o_Fname)=(select lower(user) from dual));


CREATE OR REPLACE VIEW owner_lease_view AS
select * from lease where fk_lease_p_id = (select p_id from property where fk_o_id = (Select o_id from owner where lower(o_Fname)=(select lower(user) from dual)));

CREATE OR REPLACE VIEW owner_feedback_view AS
select * from feedback 
where fk_p_id = (select p_id from property where fk_o_id = (Select o_id from owner where lower(o_Fname)=(select lower(user) from dual)));


CREATE OR REPLACE VIEW owner_complaint_view AS
select * from complaint 
where fk_complaint_p_id = (select p_id from property where fk_o_id = (Select o_id from owner where lower(o_Fname)=(select lower(user) from dual)));



CREATE OR REPLACE VIEW owner_mgmt_view AS
select m_name,m_contact,m_websiteurl from management_company where m_id = (select fk_mid from property where fk_o_id = (Select o_id from owner where lower(o_Fname)=(select lower(user) from dual)));



--select * from admin.owner_property_view;
--select * from admin.owner_lease_view;
--select * from admin.owner_feedback_view;
--select * from admin.owner_complaint_view;
--select * from admin.owner_mgmt_view;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--EMPLOYEE AGENT

---------------------------------------CREATE EMPLOYEE AGENT PROFILE----------------------
Create profile emp_agent limit 
SESSIONS_PER_USER UNLIMITED
CPU_PER_SESSION UNLIMITED 
CONNECT_TIME 15
FAILED_LOGIN_ATTEMPTS 5
    PASSWORD_LIFE_TIME 90;


---------------------------------------------CREATE EMPLOYEE AGENT ROLE--------------------------
create role emp_agent_role;    

--------------------------------------CREATE USER------------------------------------------------    
    CREATE USER Hal
    IDENTIFIED BY Northeastern2021
    PROFILE emp_agent
    ACCOUNT UNLOCK;
    
grant create session to Hal;
grant emp_agent_role to Hal;
   


grant select on emp_agent_mgmt_view to emp_agent_role;
grant select on emp_agent_feedback_view to emp_agent_role;
grant select,update on emp_agent_complaint_view to emp_agent_role;
grant select on emp_agent_customer_payment_view to emp_agent_role;
grant select,insert,update on emp_agent_property_view to emp_agent_role;

--grant execute on emp_agent_property_view to emp_agent_role;
--revoke select on emp_agent_property_view from emp_agent_role;

grant select,update,insert on emp_agent_lease_view to emp_agent_role;
grant select,update on emp_view to emp_agent_role;
grant select on emp_agent_customer_view to emp_agent_role;
grant select,insert on emp_agent_owner_view to emp_agent_role;
grant select,insert,update on emp_agent_ComplaintType_view to emp_agent_role;


CREATE OR REPLACE VIEW emp_agent_mgmt_view AS
select * from management_company where m_id = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual));


CREATE OR REPLACE VIEW emp_agent_feedback_view AS
select * from feedback where fk_p_id IN (select p_id from property where fk_mid = (Select fk_m_id from Employee where lower(e_first_name)=(select lower(user) from dual)));

CREATE OR REPLACE VIEW emp_agent_complaint_view AS
select * from complaint where fk_complaint_p_id IN (select p_id from property where fk_mid = (Select fk_m_id from Employee where lower(e_first_name)=(select lower(user) from dual)));

CREATE OR REPLACE VIEW emp_agent_customer_payment_view AS
select * from customer_payment;


CREATE OR REPLACE VIEW emp_agent_property_view AS
select * from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual));

CREATE OR REPLACE VIEW emp_agent_lease_view AS
select * from lease where fk_lease_p_id IN (Select p_id from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual)));

CREATE OR REPLACE VIEW emp_view AS
select e_id,fk_m_id,e_first_name,e_last_name,e_contact,e_city,e_street,e_state,e_zipcode,e_salary,e_designation,e_hire_date,e_dob,e_email,regexp_replace (E_SSN, '([[:digit:]]{6})', '******\3') E_SSN,e_gender 
from employee where lower(e_first_name)=(select lower(user) from dual);

CREATE OR REPLACE VIEW emp_agent_customer_view AS
select C_ID,C_FNAME,C_LNAME,C_PHONE,C_EMAIL,C_DOB,C_CITY,C_STREET,C_STATE,C_ZIPCODE,C_RFNAME,C_RLNAME,C_REFRELATION,C_REFPHONE,C_REFADDRESS,C_DATE_ADDED,regexp_replace (C_SSN, '([[:digit:]]{7})', '******\3') C_SSN,C_OCCUPATION,C_GENDER from customer where c_id IN (Select fk_lease_c_id from lease 
where fk_lease_p_id IN (Select p_id from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual))));


CREATE OR REPLACE VIEW emp_agent_owner_view AS
select O_ID,O_FNAME,O_LNAME,O_DOB,O_CITY,O_STREET,O_STATE,O_ZIPCODE,O_CONTACT,O_DATE_ADDED,regexp_replace (O_SSN, '([[:digit:]]{7})', '******\3') O_SSN,O_EMAIL,O_OCCUPATION,O_GENDER
from owner where o_id IN (Select fk_o_id from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual)));


CREATE OR REPLACE VIEW emp_agent_ComplaintType_view AS
select * from complaint_type where comp_type_id IN 
(Select fk_comp_type_id from complaint where fk_complaint_p_id IN 
(Select p_id from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual))));






--select * from admin.emp_agent_mgmt_view;

--select * from admin.emp_agent_feedback_view;

--select * from admin.emp_agent_complaint_view;

--select * from admin.emp_agent_customer_payment_view;

--select * from admin.emp_agent_property_view;

--select * from admin.emp_agent_lease_view;

--select * from admin.emp_view;

--select * from admin.emp_agent_customer_view;

--select * from admin.emp_agent_owner_view;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--EMPLOYEE MANAGER

---------------------CREATE EMPLOYEE MANAGER PROFILE------------------------------------------
Create profile EMP_MANAGER limit 
SESSIONS_PER_USER UNLIMITED
CPU_PER_SESSION UNLIMITED 
CONNECT_TIME 15
FAILED_LOGIN_ATTEMPTS 5
    PASSWORD_LIFE_TIME 90;


---------------------CREATE EMPLOYEE USER------------------------------------------    
    CREATE USER Milan
    IDENTIFIED BY Northeastern2021
    PROFILE EMP_MANAGER
    ACCOUNT UNLOCK;

-------------------------CREATE ROLE--------------------------------------------------
create role emp_manager_role;    
    
    
    
grant create session to Milan;
grant emp_manager_role to Milan;
   


grant select on emp_agent_mgmt_view to emp_manager_role;
grant select on emp_agent_feedback_view to emp_manager_role;
grant select,update,insert on emp_agent_complaint_view to emp_manager_role;
grant select on emp_agent_customer_payment_view to emp_manager_role;
grant select,insert,update on emp_agent_property_view to emp_manager_role;
grant select,insert,update on emp_agent_lease_view to emp_manager_role;
grant select,insert,update on emp_view to emp_manager_role;
grant select on emp_agent_customer_view to emp_manager_role;
grant select,insert,update on emp_agent_owner_view to emp_manager_role;
grant select,insert,update on emp_agent_ComplaintType_view to emp_manager_role;


CREATE OR REPLACE VIEW emp_agent_mgmt_view AS
select * from management_company where m_id = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual));


CREATE OR REPLACE VIEW emp_agent_feedback_view AS
select * from feedback where fk_p_id IN (select p_id from property where fk_mid = (Select fk_m_id from Employee where lower(e_first_name)=(select lower(user) from dual)));

CREATE OR REPLACE VIEW emp_agent_complaint_view AS
select * from complaint where fk_complaint_p_id IN (select p_id from property where fk_mid = (Select fk_m_id from Employee where lower(e_first_name)=(select lower(user) from dual)));

CREATE OR REPLACE VIEW emp_agent_customer_payment_view AS
select * from customer_payment;


CREATE OR REPLACE VIEW emp_agent_property_view AS
select * from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual));

CREATE OR REPLACE VIEW emp_agent_lease_view AS
select * from lease where fk_lease_p_id IN (Select p_id from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual)));

CREATE OR REPLACE VIEW emp_view AS
select * from employee;

CREATE OR REPLACE VIEW emp_agent_customer_view AS
select C_ID,C_FNAME,C_LNAME,C_PHONE,C_EMAIL,C_DOB,C_CITY,C_STREET,C_STATE,C_ZIPCODE,C_RFNAME,C_RLNAME,C_REFRELATION,C_REFPHONE,C_REFADDRESS,C_DATE_ADDED,regexp_replace (C_SSN, '([[:digit:]]{7})', '******\3') C_SSN,C_OCCUPATION,C_GENDER from customer where c_id IN (Select fk_lease_c_id from lease 
where fk_lease_p_id IN (Select p_id from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual))));


CREATE OR REPLACE VIEW emp_agent_owner_view AS
select O_ID,O_FNAME,O_LNAME,O_DOB,O_CITY,O_STREET,O_STATE,O_ZIPCODE,O_CONTACT,O_DATE_ADDED,regexp_replace (O_SSN, '([[:digit:]]{7})', '******\3') O_SSN,O_EMAIL,O_OCCUPATION,O_GENDER
from owner where o_id IN (Select fk_o_id from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual)));


CREATE OR REPLACE VIEW emp_agent_ComplaintType_view AS
select * from complaint_type where comp_type_id IN 
(Select fk_comp_type_id from complaint where fk_complaint_p_id IN 
(Select p_id from property where fk_mid = (Select fk_m_id from employee where lower(e_first_name)=(select lower(user) from dual))));






--select * from admin.emp_agent_mgmt_view;

--select * from admin.emp_agent_feedback_view;

--select * from admin.emp_agent_complaint_view;

--select * from admin.emp_agent_customer_payment_view;

--select * from admin.emp_agent_property_view;

--select * from admin.emp_agent_lease_view;

--select * from admin.emp_view;

--select * from admin.emp_agent_customer_view;

--select * from admin.emp_agent_owner_view;


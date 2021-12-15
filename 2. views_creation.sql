-- VIEWS
 
-----MASK CARD NUMBER AND CVV VIEW----------
create or replace view customer_card_detail_V
as select regexp_replace (card_number, '([[:digit:]]{12})', '************\4') card_number,
fk_c_id, expiry_date,card_type,name_on_card,regexp_replace (CVV, '([[:digit:]])', '**') CVV
from Customer_card_detail;
 
 
-----MASK ACCOUNT NUMBER VIEW----------
Create or replace view CUSTOMER_BANK_DETAILS_V as
select detail_ID,fk_cbd_c_id,bankname, regexp_replace (account_number, '([[:digit:]]{6})', '******\4') account_number,bank_routingnumber,last_updated from Customer_bank_detail;
 
 

------VIEW ALL ACTIVE LEASES------
CREATE OR REPLACE VIEW VALL_ACTIVE_LEASES AS
SELECT P.P_ID "PROPERTY ID",
L.L_ID "LEASE ID", L.L_STRTDATE "LEASE START DATE",
L.L_ENDDATE "LEASE END DATE",P.P_CITY "PROPERTY CITY", P.P_CONFIGURATION "CONFIGURATION",
C.C_FNAME|| ' ' ||C.C_LNAME "CUSTOMER NAME",C.C_PHONE "PHONE NO",
C.C_EMAIL "EMAIL ID",C.C_CITY "CUSTOMER CITY"
FROM PROPERTY P JOIN LEASE L
ON P.P_ID = L.FK_LEASE_P_ID
JOIN CUSTOMER C
ON C.C_ID=L.FK_LEASE_C_ID
WHERE L.L_STATUS = 'Active';
 
 
------VIEW AVAILABLE PROPERTIES------
CREATE OR REPLACE VIEW VALL_AVAILABLE_PROPERTIES AS
Select P_ID "PROPERTY ID",FK_MID "MANAGEMENT ID", FK_O_ID "OWNER ID",
P_TYPE "PROPERTY TYPE", P_CITY "PROPERTY CITY", P_ZIPCODE "ZIPCODE",
P_CONFIGURATION "CONFIGURATION",P_FLOOR "FLOOR",P_CARPETAREA "CARPETAREA"
from Property where P_ID Not IN (Select FK_Lease_P_ID from Lease) Or
P_ID IN (Select FK_Lease_P_ID from Lease where L_Status='Broken' or L_Status='Completed'
and (FK_Lease_P_ID Not IN (select FK_Lease_P_ID from Lease where L_Status='Active')));
 
 
 

SELECT * from customer_card_detail_V;
SELECT * from CUSTOMER_BANK_DETAILS_V;
select * from VALL_ACTIVE_LEASES ;
SELECT * FROM VALL_AVAILABLE_PROPERTIES;
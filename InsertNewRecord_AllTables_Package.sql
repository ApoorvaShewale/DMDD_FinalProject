CREATE OR REPLACE PACKAGE INSERT1
AS
procedure insert_new_customer ( FNAME IN VARCHAR,LNAME IN VARCHAR,PHONE IN NUMBER,EMAIL IN VARCHAR,DOB IN DATE,CITY IN VARCHAR,STREET IN VARCHAR,STATES IN VARCHAR,ZIPCODE IN Number,RFNAME IN VARCHAR,RLNAME IN VARCHAR,REFRELATION IN VARCHAR,REFPHONE IN NUMBER,REFADDRESS IN VARCHAR,DATE_ADDED IN DATE,SSN IN NUMBER,OCCUPATION IN VARCHAR,GENDER IN VARCHAR);
procedure INSERT_COMPLAINT_TYPE (COMP_TYPE1 IN VARCHAR);
procedure INSERT_LEASE (fk_LEASE_P_ID1 IN number, fk_LEASE_C_ID1 IN number,L_STRTDATE1 IN DATE,L_ENDDATE1 IN Number,L_STATUS1 IN VARCHAR,MON_RENT1 IN NUMBER, LEASE_BREAK_DATE1 IN DATE,  DEPOSIT1 IN NUMBER,KEYFEE1 IN NUMBER,APPLICATION_FEE1 IN NUMBER,LATEFEE1 IN NUMBER,MISC1 IN NUMBER,SUBLEASING_ALLOWED1 IN VARCHAR);
PROCEDURE INSERT_PROP(fk_PROPERTY_M_ID1 IN number, fk_PROPERTY_O_ID1 IN number, P_TYPE1 IN VARCHAR, P_City1 IN VARCHAR,P_Street1 IN VARCHAR,P_State1 IN VARCHAR, P_Zip1 IN VARCHAR, P_Description1 IN VARCHAR, P_Configuration1 IN VARCHAR,P_Discount1 IN NUMBER,P_Date_Listed1 IN DATE,P_Floor1 IN NUMBER,P_Carpet_Area1 IN NUMBER);
procedure INSERT_UTILITY (fk_UTILITY_P_ID1 IN number, Utility_TYPE1 IN VARCHAR, Availibility1 IN VARCHAR);
procedure insert_new_employee (M_ID IN NUMBER,FIRST_NAME IN VARCHAR,LAST_NAME IN VARCHAR,CONTACT IN NUMBER,CITY IN VARCHAR,STREET IN VARCHAR,STATES IN VARCHAR,ZIPCODE IN VARCHAR,SALARY IN NUMBER,DESIGNATION IN VARCHAR,HIRE_DATE IN DATE,DOB IN DATE,EMAIL IN VARCHAR,SSN IN NUMBER,GENDER IN VARCHAR);
procedure insert_new_management (MANAME IN VARCHAR,CITY IN VARCHAR,STREET IN VARCHAR,STATES IN VARCHAR,ZIPCODE IN VARCHAR,CONTACT IN NUMBER,WEBSITEURL IN VARCHAR,STARTDATE IN DATE ,ENDDATE IN DATE);
PROCEDURE ADD_FEEDBACK(PROP_ID IN NUMBER,DESCRP VARCHAR,RAT_MAINT IN NUMBER,RAT_CLEAN IN NUMBER,RAT_AMEN IN NUMBER,RAT_UTI IN NUMBER,RAT_LOC IN NUMBER,RAT_RENT IN NUMBER,RAT_APTCOND IN NUMBER,RAT_RECOMM IN NUMBER,FEED_DATE DATE); 
procedure insert_new_Owner( FNAME IN VARCHAR, LNAME IN VARCHAR, DOB IN DATE, STREET IN VARCHAR, CITY IN VARCHAR,STATE IN VARCHAR,ZIPCODE IN NUMBER,CONTACT IN NUMBER,SSN IN NUMBER,DATE_ADDED IN DATE ,EMAIL IN VARCHAR,GENDER IN VARCHAR,OCCUPATION IN VARCHAR);
PROCEDURE ADD_CUSTBANKDETAILS(CUST_ID IN NUMBER,BNAME VARCHAR,ACCNBR NUMBER,BRNUM NUMBER,LUPDATED DATE);
PROCEDURE ADD_CUSTCARDDETAILS(C_NUM IN NUMBER,CUST_ID IN NUMBER,EXP_DT DATE,C_TYPE VARCHAR,CUST_NAME VARCHAR,CVV_NUM IN NUMBER);
PROCEDURE ADD_COMPLAINT(PROP_ID IN NUMBER,COMPL_TYPE_ID IN NUMBER,COMP_DATE DATE,COMP_STATUS VARCHAR,C_DESC VARCHAR,C_SEVERITY VARCHAR,C_PRIORITY IN NUMBER);
PROCEDURE ADD_CUSTOMERPAYMENT(CP_CUST_ID IN NUMBER,AMT_PAID IN NUMBER,PAY_DATE DATE,PAY_STATUS VARCHAR,AUTOPAY VARCHAR);
END INSERT1;
/




set define off;
create or replace package body INSERT1
AS
procedure insert_new_customer (FNAME IN VARCHAR,LNAME IN VARCHAR,PHONE IN NUMBER,EMAIL IN VARCHAR,DOB IN DATE,CITY IN VARCHAR,STREET IN VARCHAR,STATES IN VARCHAR,ZIPCODE IN Number,RFNAME IN VARCHAR,RLNAME IN VARCHAR,REFRELATION IN VARCHAR,REFPHONE IN NUMBER,REFADDRESS IN VARCHAR,DATE_ADDED IN DATE,SSN IN NUMBER,OCCUPATION IN VARCHAR,GENDER IN VARCHAR)

is

MAX_CID number;
MAXCUST_ID number;
Contact_Len_error Exception;
Date_error exception;
Email_unique exception;
CountUnique number;
Gender_notin exception;
countSSN number;
SSN_unique exception;
ZIPCODE_NOTNUMBER exception;

begin
select count(*) into countUnique from CUSTOMER where C_EMAIL = EMAIL;
select count(*) into countSSN from CUSTOMER where C_SSN = SSN;
Select MAX(C_ID) into MAXCUST_ID from customer;
MAX_CID := MAXCUST_ID + 1;

IF(countSSN>0)
then raise SSN_unique;

ELSIF
is_number(ZIPCODE)=0
THEN RAISE ZIPCODE_NOTNUMBER;

ELSIF (CountUnique> 0 )
Then
Raise Email_unique;

ELSIF

length(PHONE)<>10 OR length(SSN)<>9 OR length(REFPHONE)<>10 THEN
Raise Contact_Len_error;

ELSIF
Gender NOT IN('M','F')
Then raise Gender_notin;

Else

insert into Customer(C_ID,
C_FNAME,
C_LNAME,
C_PHONE,
C_EMAIL,
C_DOB,
C_CITY ,
C_STREET,
C_STATE,
C_ZIPCODE,
C_RFNAME,
C_RLNAME,
C_REFRELATION,
C_REFPHONE,
C_REFADDRESS,
C_DATE_ADDED,
C_SSN,
C_OCCUPATION,
C_GENDER)
values
(MaX_CID,
FNAME,
LNAME,
PHONE,
EMAIL,
DOB,
CITY,
STREET,
STATES,
ZIPCODE,
RFNAME,
RLNAME,
REFRELATION,
REFPHONE,
REFADDRESS,
DATE_ADDED,
SSN,
OCCUPATION,
GENDER);

END IF;
EXCEPTION
When Contact_Len_error Then
raise_application_error (-20001,'Contact number should be 10 digits and SSN should be 9 digits ');
When Email_unique Then
raise_application_error (-20003,'Email should be unique');
When Gender_notin Then
raise_application_error (-20004,'Gender values should be m or f');
When SSN_unique Then
raise_application_error (-20005,'SSN should be unique');
When ZIPCODE_NOTNUMBER Then
raise_application_error (-20006,'ZIPCODE SHOULD CONTAIN ONLY NUMBERS');

end insert_new_customer;


--------------------------------------------
PROCEDURE INSERT_COMPLAINT_TYPE (COMP_TYPE1 IN VARCHAR) 
IS   
    MaX_Comp_ID number;

BEGIN

Select nvl(MAX(COMP_TYPE_ID),0) into  MaX_Comp_ID from COMPLAINT_TYPE;
MaX_Comp_ID := MaX_Comp_ID + 1;

    INSERT INTO COMPLAINT_TYPE(COMP_TYPE_ID, COMP_TYPE)
    values (MaX_Comp_ID, COMP_TYPE1);
    COMMIT;


END INSERT_COMPLAINT_TYPE;
---------------------------------------------------------------------

PROCEDURE INSERT_LEASE (
fk_LEASE_P_ID1 IN number, 
fk_LEASE_C_ID1 IN number,
L_STRTDATE1 IN DATE,
L_ENDDATE1 IN Number,
L_STATUS1 IN VARCHAR,
MON_RENT1 IN NUMBER, 
LEASE_BREAK_DATE1 IN DATE,  
DEPOSIT1 IN NUMBER,
KEYFEE1 IN NUMBER,
APPLICATION_FEE1 IN NUMBER,
LATEFEE1 IN NUMBER,
MISC1 IN NUMBER,
SUBLEASING_ALLOWED1 IN VARCHAR) 

IS
    L_STATUS_INCORRECT EXCEPTION;
    SUBLEASING_ALLOWED_INCOREECT EXCEPTION;
    MaX_LID number;
    P_ID_count number;
    P_ID_EXCEPTION EXCEPTION;
    C_ID_count number;
    C_ID_EXCEPTION EXCEPTION;
    ALREADY_ACTIVE_CUSTOMER EXCEPTION;
    current_status VARCHAR(30);
    Curr_status Varchar(30);
    L_ENDDATE DATE;
    L_PAY_DUEDATE1 DATE;
    

BEGIN

L_ENDDATE:=ADD_MONTHS(L_STRTDATE1,L_ENDDATE1);
L_PAY_DUEDATE1:=ADD_MONTHS(L_STRTDATE1,-1);
Select count(*) into P_ID_count from Property where fk_LEASE_P_ID1=Property.P_ID;
Select count(*) into C_ID_count from Customer where fk_LEASE_C_ID1=Customer.C_ID;
Select L_status into current_status from Lease where fk_LEASE_C_ID1=Lease.FK_LEASE_C_ID;
Select nvl(MAX(L_ID),0) into   MaX_LID from LEASE;
MaX_LID := MaX_LID + 1;
Curr_status:=current_status;

IF L_STATUS1 NOT IN ('Active','Completed','Broken') THEN 
    RAISE L_STATUS_INCORRECT;

ELSIF Curr_status ='Active' THEN
 RAISE ALREADY_ACTIVE_CUSTOMER;

ELSIF (P_ID_count=0)
Then raise P_ID_EXCEPTION;

ELSIF (C_ID_count=0)
Then raise C_ID_EXCEPTION;

ELSIF SUBLEASING_ALLOWED1 NOT IN ('Yes','No') THEN
    RAISE SUBLEASING_ALLOWED_INCOREECT;

ELSE   
    INSERT INTO LEASE(L_ID, fk_LEASE_P_ID,fk_LEASE_C_ID,L_STRTDATE,L_ENDDATE,L_STATUS,MON_RENT,LEASE_BREAK_DATE,L_PAY_DUEDATE,DEPOSIT,KEYFEE,APPLICATION_FEE,LATEFEE,MISC,SUBLEASING_ALLOWED) 
    values (MaX_LID, fk_LEASE_P_ID1 ,fk_LEASE_C_ID1 ,L_STRTDATE1 ,L_ENDDATE,L_STATUS1,MON_RENT1 ,LEASE_BREAK_DATE1 ,L_PAY_DUEDATE1 ,DEPOSIT1,KEYFEE1,APPLICATION_FEE1 ,LATEFEE1,MISC1 ,SUBLEASING_ALLOWED1);
    COMMIT;

END IF;

EXCEPTION 
    WHEN L_STATUS_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('Lease Status can only be Active/completed/Broken');
    WHEN P_ID_EXCEPTION THEN
                DBMS_OUTPUT.PUT_LINE('Property ID not found in Parent table');
    WHEN SUBLEASING_ALLOWED_INCOREECT THEN
                DBMS_OUTPUT.PUT_LINE('Subleasing aloowed filed can only be Yes/No');
    WHEN ALREADY_ACTIVE_CUSTOMER THEN
                DBMS_OUTPUT.PUT_LINE('This customer already has an active Leases');
     WHEN C_ID_EXCEPTION THEN
                DBMS_OUTPUT.PUT_LINE('Customer ID not found in Parent table');
  
                


END INSERT_LEASE;
---------------------------------------------------------------------------------------------

PROCEDURE INSERT_PROP(fk_PROPERTY_M_ID1 IN number, fk_PROPERTY_O_ID1 IN number, P_TYPE1 IN VARCHAR, P_City1 IN VARCHAR,P_Street1 IN VARCHAR,P_State1 IN VARCHAR, P_Zip1 IN VARCHAR, P_Description1 IN VARCHAR, P_Configuration1 IN VARCHAR,P_Discount1 IN NUMBER,P_Date_Listed1 IN DATE,P_Floor1 IN NUMBER,P_Carpet_Area1 IN NUMBER) 
IS
    P_TYPE_INCORRECT EXCEPTION;
    P_Zip1_INCORRECT EXCEPTION;
    MaX_PID number;
    M_ID_count number;
    M_ID_EXCEPTION EXCEPTION;
    O_ID_count number;
    O_ID_EXCEPTION EXCEPTION;
    P_Date_Listed_INCORRECT EXCEPTION;
    mgmt_start_date DATE;

BEGIN

Select count(*) into M_ID_count from MANAGEMENT_COMPANY where fk_PROPERTY_M_ID1=MANAGEMENT_COMPANY.M_ID;
Select count(*) into O_ID_count from OWNER where fk_PROPERTY_O_ID1=OWNER.O_ID;
Select nvl(MAX(P_ID),0) into   MaX_PID from PROPERTY;
MaX_PID := MaX_PID + 1;
Select M_STARTDATE into mgmt_start_date from MANAGEMENT_COMPANY where MANAGEMENT_COMPANY.M_ID=fk_PROPERTY_M_ID1;

IF P_TYPE1 NOT IN ('Apartment','Condo','Duplex') THEN 
    RAISE P_TYPE_INCORRECT;

ELSIF LENGTH(P_Zip1)!=5 THEN 
    RAISE P_Zip1_INCORRECT;
    
ELSIF (M_ID_count>0)
Then raise M_ID_EXCEPTION;

ELSIF (O_ID_count>0)
Then raise O_ID_EXCEPTION; 

ELSIF mgmt_start_date > P_Date_Listed1 THEN
    RAISE P_Date_Listed_INCORRECT;

ELSE   
    INSERT INTO PROPERTY(P_ID,FK_MID,fk_O_ID ,P_TYPE ,P_City,P_Street ,P_State ,P_Zipcode ,P_Description,P_Configuration,P_Discount ,P_Date_Listed,P_Floor ,P_CarpetArea) 
    values (MaX_PID, fk_PROPERTY_M_ID1 ,fk_PROPERTY_O_ID1 ,P_TYPE1 ,P_City1,P_Street1 ,P_State1 ,P_Zip1 ,P_Description1,P_Configuration1,P_Discount1 ,P_Date_Listed1,P_Floor1 ,P_Carpet_Area1);
    COMMIT;
    
END IF;

EXCEPTION 
    WHEN P_TYPE_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('P_TYPE can only be Apartment/Condo/Duplex');
    WHEN P_Zip1_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('Zip code has to be 5 digits');
    WHEN M_ID_EXCEPTION THEN
                DBMS_OUTPUT.PUT_LINE('Management ID not found in Parent table');
    WHEN O_ID_EXCEPTION THEN
                DBMS_OUTPUT.PUT_LINE('Owner ID not found in Parent table');
    WHEN P_Date_Listed_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('Property listed date cannot be before Managemnt listed date');

END INSERT_PROP;

----------------------------------------------------------------------------------------------------------

PROCEDURE INSERT_UTILITY (fk_UTILITY_P_ID1 IN number, Utility_TYPE1 IN VARCHAR, Availibility1 IN VARCHAR) 
IS
    U_TYPE_INCORRECT EXCEPTION;
    AVAILABILITY_INCORRECT EXCEPTION;
    MaX_UID number;
    P_ID2_count number;
    P_ID2_EXCEPTION EXCEPTION;

BEGIN

Select count(*) into P_ID2_count from Property where fk_UTILITY_P_ID1=Property.P_ID;
Select nvl(MAX(U_ID),0) into  MaX_UID from UTILITY;
MaX_UID := MaX_UID + 1;


IF (P_ID2_count=0)
Then raise P_ID2_EXCEPTION;

ELSIF Utility_TYPE1 NOT IN ('ELEC','HEAT','WATER','GAS') THEN 
    RAISE U_TYPE_INCORRECT;
    
ELSIF Availibility1 NOT IN ('Y','N') THEN 
    RAISE AVAILABILITY_INCORRECT;

ELSE   
    INSERT INTO UTILITY(U_ID, fk_UTILITY_P_ID, UTILITY_TYPE ,AVAILABILITY)
    values (MaX_UID, fk_UTILITY_P_ID1, UTILITY_TYPE1, Availibility1);
    COMMIT;
    
END IF;

EXCEPTION 
    WHEN P_ID2_EXCEPTION THEN
                DBMS_OUTPUT.PUT_LINE('Property ID not found in Parent table');
    WHEN AVAILABILITY_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('Availability can only be Y/N');
    WHEN U_TYPE_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('U_TYPE can only be ELEC/HEAT/WATER/GAS');

END INSERT_UTILITY;

-------------------------------------------------------------------------------------------
procedure insert_new_employee (M_ID IN NUMBER,FIRST_NAME IN VARCHAR,LAST_NAME IN VARCHAR,CONTACT IN NUMBER,CITY IN VARCHAR,STREET IN VARCHAR,STATES IN VARCHAR,ZIPCODE IN VARCHAR,SALARY IN NUMBER,DESIGNATION IN VARCHAR,HIRE_DATE IN DATE,DOB IN DATE,EMAIL IN VARCHAR,SSN IN NUMBER,GENDER IN VARCHAR)

IS

MaX_EID number;
MAXEMP_ID number;
Contact_Len_error Exception;
Date_error exception;
Email_unique exception;
CountUnique number;
Gender_notin exception;
countSSN number;
SSN_unique exception;
MANAGEMENT_ID number;
unique_management exception;

begin


Select count(*) into MANAGEMENT_ID from management_company where M_ID=management_company.m_id;
select count(*) into countUnique from employee where E_EMAIL = EMAIL;
select count(*) into countSSN from employee where E_SSN = SSN;
Select MAX(E_ID) into   MAXEMP_ID from employee;
MaX_EID := MAXEMP_ID + 1;

IF (MANAGEMENT_ID=0)
Then raise unique_management;
ELSIF(countSSN>0)
then raise SSN_unique;

ELSIF (CountUnique> 0 )
Then
Raise Email_unique;

ELSIF 

length(CONTACT)<>10 OR length(SSN)<>9 THEN
Raise Contact_Len_error;

ELSIF hire_date<DOB 
then raise Date_error;

ELSIF
Gender NOT IN('M','F')
Then raise Gender_notin;




Else

  insert into employee 
  (E_ID,fk_M_ID,E_FIRST_NAME,E_LAST_NAME,E_CONTACT,E_CITY,E_STREET,E_STATE,E_ZIPCODE,E_SALARY,E_DESIGNATION,E_HIRE_DATE,E_DOB,E_EMAIL,E_SSN,E_GENDER) 
  values
  (MaX_EID,M_ID,FIRST_NAME,LAST_NAME,CONTACT,CITY,STREET,STATES,ZIPCODE,SALARY,DESIGNATION,HIRE_DATE,DOB,EMAIL,SSN,GENDER); 
  DBMS_Output.Put_Line('Location Updated');

  END IF;
EXCEPTION
When Contact_Len_error Then
raise_application_error (-20001,'Contact number should be 10 digits and SSN should be 9 digits ');
When Date_error Then
raise_application_error (-20002,'Hiredate cannot be less than DOB');
When Email_unique Then
raise_application_error (-20003,'Email should be unique');
When Gender_notin Then
raise_application_error (-20004,'Gender values should be m or f');
When SSN_unique Then
raise_application_error (-20005,'SSN should be unique');
When others then
raise_application_error (-20006,'Management_id not present in parent table');
end insert_new_employee;


------------------------------------------------------------------------------------------------
procedure insert_new_management (MANAME IN VARCHAR,CITY IN VARCHAR,STREET IN VARCHAR,STATES IN VARCHAR,ZIPCODE IN VARCHAR,CONTACT IN NUMBER,WEBSITEURL IN VARCHAR,STARTDATE IN DATE ,ENDDATE IN DATE) 
IS

MAX_MID number;
MAXManag_ID number;
Contact_Len_error Exception;


ZIPCODE_NOTNUMBER exception;
DATE_ERROR Exception;

begin




Select MAX(M_ID) into   MAX_MID from management_company;
MAXManag_ID := MAX_MID + 1;


IF 
is_number(ZIPCODE)=0 OR LENGTH(ZIPCODE)<>5 
THEN RAISE ZIPCODE_NOTNUMBER;


ELSIF 

length(CONTACT)<>10  THEN
Raise Contact_Len_error;

ELSIF
STARTDATE > ENDDATE
Then raise DATE_ERROR;



Else

insert into management_company(M_ID,M_NAME,M_CITY,M_STREET,M_STATE,M_ZIPCODE,M_CONTACT,M_WEBSITEURL,M_STARTDATE,M_ENDDATE) 
  values
  (MAXManag_ID,MANAME,CITY,STREET,STATES,ZIPCODE,CONTACT,WEBSITEURL,STARTDATE,ENDDATE); 


  END IF;
EXCEPTION
When Contact_Len_error Then
raise_application_error (-20001,'Contact number should be 10 digits');

When ZIPCODE_NOTNUMBER Then
raise_application_error (-20006,'ZIPCODE SHOULD CONTAIN ONLY NUMBERS and contains 5 digit');
When DATE_ERROR Then
raise_application_error (-20007,'Startdate cannot be greater than End date');
end insert_new_management;
-----------------------------------------------------------------------------------------------------
PROCEDURE ADD_FEEDBACK(PROP_ID IN NUMBER,DESCRP VARCHAR,RAT_MAINT IN NUMBER,RAT_CLEAN IN NUMBER,RAT_AMEN IN NUMBER,RAT_UTI IN NUMBER,RAT_LOC IN NUMBER,RAT_RENT IN NUMBER,RAT_APTCOND IN NUMBER,RAT_RECOMM IN NUMBER,FEED_DATE DATE) 

IS 

MAX_F_ID NUMBER;
NEW_F_ID NUMBER;
PROPERTY_ID NUMBER;
PROPERTY_ID_EXCEPTION EXCEPTION;
RAT_EXCEPTION EXCEPTION;

BEGIN
Select count(*) into PROPERTY_ID from PROPERTY where PROP_ID=PROPERTY.P_ID;

SELECT NVL(MAX(F_ID),0) INTO MAX_F_ID FROM FEEDBACK; 
NEW_F_ID := MAX_F_ID +1; 

IF (PROPERTY_ID=0) THEN
    RAISE PROPERTY_ID_EXCEPTION;
ELSIF is_number(RAT_MAINT)=0 OR is_number(RAT_CLEAN)=0 OR is_number(RAT_AMEN)=0 OR is_number(RAT_UTI)=0 OR is_number(RAT_LOC)=0 OR is_number(RAT_RENT)=0 OR is_number(RAT_APTCOND)=0 OR is_number(RAT_RECOMM)=0 THEN
    RAISE RAT_EXCEPTION;
ELSE
INSERT INTO FEEDBACK(F_ID,FK_P_ID,F_DESCRIPTION,F_RATING_MAINTAINANCE,F_RATING_CLEANLINESS,F_RATING_AMENITIES,F_RATING_UTILITIES,F_RATING_LOCATION,F_RATING_RENT,F_RATING_APTCONDITION,F_RATING_RECOMMENDATION,F_DATE)
VALUES (NEW_F_ID,PROP_ID,DESCRP,RAT_MAINT,RAT_CLEAN,RAT_AMEN,RAT_UTI,RAT_LOC,RAT_RENT,RAT_APTCOND,RAT_RECOMM,FEED_DATE);
COMMIT;
END IF;

EXCEPTION
    WHEN PROPERTY_ID_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('PROPERTY ID NOT PRESENT IN PROPERTY TABLE');
    WHEN RAT_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('ENTER A NUMBER BETWEEN 1 TO 5');
        
END ADD_FEEDBACK;
-----------------------------------------------------------------------------------------------------------------
procedure insert_new_Owner( 
FNAME IN VARCHAR, 
LNAME IN VARCHAR, 
DOB IN DATE, 
STREET IN VARCHAR, 
CITY IN VARCHAR,
STATE IN VARCHAR,
ZIPCODE IN NUMBER,
CONTACT IN NUMBER,
SSN IN NUMBER,
DATE_ADDED IN DATE ,
EMAIL IN VARCHAR,
GENDER IN VARCHAR,
OCCUPATION IN VARCHAR) 


    is

MAX_OID number;
MAXOwner_ID number;
Contact_Len_error Exception;
Date_error exception;
Email_unique exception;
CountUnique number;
Gender_notin exception;
countSSN number;
SSN_unique exception;
ZIPCODE_NOTNUMBER exception;

begin



select count(*) into countUnique from Owner where O_EMAIL = EMAIL;
select count(*) into countSSN from Owner where O_SSN = SSN;
Select nvl(MAX(O_ID),0) into   MAX_OID from Owner;
MAXOwner_ID := MAX_OID + 1;

IF(countSSN>0)
then raise SSN_unique;

ELSIF 
is_number(ZIPCODE)=0 OR Length(ZIPCODE)<>5
THEN RAISE ZIPCODE_NOTNUMBER;

ELSIF (CountUnique> 0)
Then
Raise Email_unique;

ELSIF 

length(CONTACT)<>10 OR length(SSN)<>9  THEN
Raise Contact_Len_error;



ELSIF
Gender NOT IN('M','F')
Then raise Gender_notin;

Else

insert into OWNER(O_ID,O_FNAME,O_LNAME,O_DOB,O_STREET,O_CITY,O_STATE,O_ZIPCODE,O_CONTACT,O_SSN,O_DATE_ADDED,O_EMAIL,O_GENDER,O_OCCUPATION)   values (MAXOwner_ID,FNAME,LNAME,DOB,STREET,CITY,STATE,ZIPCODE,CONTACT,SSN,DATE_ADDED,EMAIL,GENDER,OCCUPATION); 


  END IF;
EXCEPTION
When Contact_Len_error Then
raise_application_error (-20001,'Contact number should be 10 digits and SSN should be 9 digits ');
When Email_unique Then
raise_application_error (-20003,'Email should be unique');
When Gender_notin Then
raise_application_error (-20004,'Gender values should be m or f');
When SSN_unique Then
raise_application_error (-20005,'SSN should be unique');
When ZIPCODE_NOTNUMBER Then
raise_application_error (-20006,'ZIPCODE SHOULD CONTAIN ONLY NUMBERS and should be of 5 digits');

end insert_new_Owner;

---------------------------------------------------------------------------------------------------------
PROCEDURE ADD_CUSTBANKDETAILS(CUST_ID IN NUMBER,BNAME VARCHAR,ACCNBR NUMBER,BRNUM NUMBER,LUPDATED DATE) IS 

CUST_ID_EXCEPTION EXCEPTION;
ACCNBR_EXCEPTION EXCEPTION;
BRNUM_EXCEPTION EXCEPTION;
MAX_DETAIL_ID NUMBER;
NEW_DETAIL_ID NUMBER;
CUSTOMER_ID NUMBER;

BEGIN
Select count(*) into CUSTOMER_ID from CUSTOMER where CUST_ID=CUSTOMER.C_ID;

SELECT NVL(MAX(DETAIL_ID),0) INTO MAX_DETAIL_ID FROM CUSTOMER_BANK_DETAIL; 
NEW_DETAIL_ID := MAX_DETAIL_ID +1;

IF is_number(ACCNBR)=0 THEN
    RAISE ACCNBR_EXCEPTION;
ELSIF is_number(BRNUM)=0 THEN
    RAISE BRNUM_EXCEPTION;
ELSIF (CUSTOMER_ID=0) THEN
    RAISE CUST_ID_EXCEPTION;
ELSE
INSERT INTO customer_bank_detail(DETAIL_ID,FK_CBD_C_ID,BANKNAME,ACCOUNT_NUMBER,BANK_ROUTINGNUMBER,LAST_UPDATED) VALUES (NEW_DETAIL_ID,CUST_ID,BNAME,ACCNBR,BRNUM,LUPDATED);
COMMIT;
END IF;

EXCEPTION
    WHEN ACCNBR_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('ACCOUNT NUMBER SHOULD BE A NUMBER');
    WHEN CUST_ID_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('CUSTOMER ID NOT PRESENT IN CUSTOMER TABLE');
    WHEN BRNUM_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('BANK ROUTING NUMBER SHOULD BE A NUMBER');
END ADD_CUSTBANKDETAILS;

----------------------------------------------------------------------------------------------------
PROCEDURE ADD_CUSTCARDDETAILS(C_NUM IN NUMBER,CUST_ID IN NUMBER,EXP_DT DATE,C_TYPE VARCHAR,CUST_NAME VARCHAR,CVV_NUM IN NUMBER) IS 

CUST_ID_EXCEPTION EXCEPTION;
C_NUM_EXCEPTION EXCEPTION;
EXP_DT_EXCEPTION EXCEPTION;
CVV_NUM_EXCEPTION EXCEPTION;
MAX_CUST_CARD_ID NUMBER;
NEW_CUST_CARD_ID NUMBER;
CUSTOMER_ID NUMBER;

BEGIN
Select count(*) into CUSTOMER_ID from CUSTOMER where CUST_ID=CUSTOMER.C_ID;

SELECT NVL(MAX(CUSTOMER_CARD_ID),0) INTO MAX_CUST_CARD_ID FROM CUSTOMER_CARD_DETAIL; 
NEW_CUST_CARD_ID := MAX_CUST_CARD_ID +1;

IF (CUSTOMER_ID=0) THEN
    RAISE CUST_ID_EXCEPTION;
ELSIF LENGTH(C_NUM)<>16 THEN
    RAISE C_NUM_EXCEPTION;
ELSIF EXP_DT < DATE '2021-12-07' THEN
    RAISE EXP_DT_EXCEPTION;
ELSIF LENGTH(CVV_NUM) <> 3 THEN
    RAISE CVV_NUM_EXCEPTION;
ELSE
INSERT INTO customer_card_detail(CUSTOMER_CARD_ID,CARD_NUMBER,FK_C_ID,EXPIRY_DATE,CARD_TYPE,NAME_ON_CARD,CVV) VALUES (NEW_CUST_CARD_ID,C_NUM,CUST_ID,EXP_DT,C_TYPE,CUST_NAME,CVV_NUM);
COMMIT;
END IF;

EXCEPTION
    WHEN C_NUM_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('CARD NUMBER SHOULD BE OF 16 DIGITS');
    WHEN EXP_DT_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('EXPIRY DATE IS INCORRECT');
    WHEN CVV_NUM_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('CVV SHOULD BE OF 3 TO 4 DIGITS');
    WHEN CUST_ID_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('CUSTOMER ID NOT PRESENT IN CUSTOMER TABLE');
END ADD_CUSTCARDDETAILS;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
PROCEDURE ADD_COMPLAINT(PROP_ID IN NUMBER,COMPL_TYPE_ID IN NUMBER,COMP_DATE DATE,COMP_STATUS VARCHAR,C_DESC VARCHAR,C_SEVERITY VARCHAR,C_PRIORITY IN NUMBER)

IS 

MAX_COMP_ID NUMBER;
NEW_COMP_ID NUMBER;
PROPERTY_ID NUMBER;
COMPLAINT_TYPE_ID NUMBER;

PROPERTY_ID_EXCEPTION EXCEPTION;
COMPLAINT_TYPE_ID_EXCEPTION EXCEPTION;
--COMP_DATE_EXCEPTION EXCEPTION;
COMP_STATUS_EXCEPTION EXCEPTION;
COMP_SEVERITY_EXCEPTION EXCEPTION;
COMP_PRIORITY_EXCEPTION EXCEPTION;
COMP_PRIORITY_NUM_EXCEPTION EXCEPTION;

BEGIN
Select count(*) INTO PROPERTY_ID from PROPERTY where PROP_ID=PROPERTY.P_ID;
Select count(*) into COMPLAINT_TYPE_ID from COMPLAINT_TYPE where COMPL_TYPE_ID=COMPLAINT_TYPE.COMP_TYPE_ID;

SELECT NVL(MAX(COMP_ID),0) INTO MAX_COMP_ID FROM COMPLAINT; 
NEW_COMP_ID := MAX_COMP_ID +1; 

IF (PROPERTY_ID=0) THEN
    RAISE PROPERTY_ID_EXCEPTION;
ELSIF (COMPLAINT_TYPE_ID=0) THEN
    RAISE COMPLAINT_TYPE_ID_EXCEPTION;
--ELSIF COMP_DATE BETWEEN LEASE.L_STRTDATE AND LEASE.L_ENDDATE THEN
 --   RAISE COMP_DATE_EXCEPTION;
ELSIF COMP_STATUS NOT IN ('OPEN') THEN
    RAISE COMP_STATUS_EXCEPTION;  
ELSIF C_SEVERITY NOT IN ('LOW','MEDIUM','HIGH') THEN
    RAISE COMP_SEVERITY_EXCEPTION;
ELSIF C_PRIORITY<1 OR C_PRIORITY>11 THEN
    RAISE COMP_PRIORITY_EXCEPTION;
ELSIF is_number(C_PRIORITY)=0  THEN
    RAISE COMP_PRIORITY_NUM_EXCEPTION;
ELSE
INSERT INTO COMPLAINT(COMP_ID,FK_COMPLAINT_P_ID,FK_COMP_TYPE_ID,C_DATE,C_STATUS,COMP_DESC,COMP_SEVERITY,COMP_PRIORITY)
VALUES(NEW_COMP_ID,PROP_ID,COMPL_TYPE_ID,COMP_DATE,COMP_STATUS,C_DESC,C_SEVERITY,C_PRIORITY);
COMMIT;
END IF;

EXCEPTION
    WHEN PROPERTY_ID_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('PROPERTY ID NOT PRESENT IN PROPERTY TABLE');
    WHEN COMPLAINT_TYPE_ID_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('COMPLAINT TYPE ID NOT PRESENT IN COMPLAINT TYPE TABLE');
 --   WHEN COMP_DATE_EXCEPTION THEN
  --      DBMS_OUTPUT.PUT_LINE('COMPLAINT DATE SHOULD BE BETWEEN LEASE START DATE AND LEASE END DATE');
    WHEN COMP_STATUS_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('COMPLAINT STATUS SHOULD BE OPEN');
    WHEN COMP_SEVERITY_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('COMPLAINT SEVERITY SHOULD BE LOW,MEDIUM OR HIGH');
    WHEN COMP_PRIORITY_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('COMPLAINT PRIORITY SHOULD BE BETWEEN 1 TO 10'); 
    WHEN COMP_PRIORITY_NUM_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('COMPLAINT PRIORITY SHOULD BE NUMBER');
END ADD_COMPLAINT;


-----------------------------------------------------------------------------------------------------------
PROCEDURE ADD_CUSTOMERPAYMENT(CP_CUST_ID IN NUMBER,
AMT_PAID IN NUMBER,
PAY_DATE DATE,
PAY_STATUS VARCHAR,
AUTOPAY VARCHAR) 

IS 

MAX_T_ID NUMBER;
NEW_T_ID NUMBER;
CUSTOMER_ID NUMBER;
CUSTOMER_ID_EXCEPTION EXCEPTION;
PAY_STATUS_EXCEPTION EXCEPTION;
AUTOPAY_EXCEPTION EXCEPTION;
AMTPAID_EXCEPTION EXCEPTION;

BEGIN
Select count(*) into CUSTOMER_ID from LEASE where CP_CUST_ID=LEASE.FK_LEASE_C_ID;

SELECT NVL(MAX(T_ID),0) INTO MAX_T_ID FROM CUSTOMER_PAYMENT; 
NEW_T_ID := MAX_T_ID +1; 

IF (CUSTOMER_ID=0) THEN
    RAISE CUSTOMER_ID_EXCEPTION;
ELSIF PAY_STATUS NOT IN ('COMPLETE','PENDING') THEN
    RAISE PAY_STATUS_EXCEPTION;
ELSIF AUTOPAY NOT IN ('Y','N') THEN
    RAISE AUTOPAY_EXCEPTION;
ELSIF is_number(AMT_PAID)=0 THEN
    RAISE AMTPAID_EXCEPTION;
ELSE
INSERT INTO CUSTOMER_PAYMENT(T_ID,FK_CUSTOMER_PAYMENT_C_ID,AMOUNT_PAID,PAYMENT_DATE,PAYMENT_STATUS,AUTOPAYENABLE)
VALUES (NEW_T_ID,CP_CUST_ID,AMT_PAID,PAY_DATE,PAY_STATUS,AUTOPAY);
COMMIT;
END IF;

EXCEPTION
    WHEN CUSTOMER_ID_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('CUSTOMER ID NOT PRESENT IN CUSTOMER TABLE');
    WHEN PAY_STATUS_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('PAYMENT STATUS SHOULD BE COMPLETE OR PENDING');
    WHEN AUTOPAY_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('AUTOPAY SHOULD BE Y OR N');
    WHEN AMTPAID_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('AMOUNT PAID SHOULD BE A NUMBER');
END ADD_CUSTOMERPAYMENT;

end;
-----FOR CUSTOMER


--positive test case
CALL INSERT_UPDATE_PACKAGE.insert_new_customer(FNAME=>'John',LNAME=>'Baker',PHONE=>1234123412,EMAIL=>'johnbaker19@gmail.com',DOB=>'17-Aug-95',CITY=>'Pune',STREET=>'Baker str',STATES=>'MA',ZIPCODE=>'67854',RFNAME=>'Alexa'
,RLNAME=>'Jaya',REFRELATION=>'Friend',REFPHONE=>7654876534,REFADDRESS=>'Hemenway',DATE_ADDED=>'15-dec-15',SSN=>876437657,OCCUPATION=>'engineer',GENDER=>'M');

Select * from Customer where C_EMAIL='johnbaker19@gmail.com';
--negative test
--Check unique SSN Validation
CALL INSERT_UPDATE_PACKAGE.insert_new_customer(FNAME=>'John',LNAME=>'tim',PHONE=>1200123412,EMAIL=>'johntim19@gmail.com',DOB=>'17-Aug-95',CITY=>'Pune',STREET=>'Baker str',STATES=>'MA',ZIPCODE=>'67854',RFNAME=>'Alexa'
,RLNAME=>'Jaya',REFRELATION=>'Friend',REFPHONE=>7650076034,REFADDRESS=>'Hemenway',DATE_ADDED=>'15-dec-15',SSN=>8764376578,OCCUPATION=>'engineer',GENDER=>'M');

--Check unique Email Validation
CALL INSERT_UPDATE_PACKAGE.insert_new_customer(FNAME=>'John',LNAME=>'snow',PHONE=>1034123412,EMAIL=>'johnbaker19@gmail.com',DOB=>'17-Aug-95',CITY=>'Pune',STREET=>'Baker str',STATES=>'MA',ZIPCODE=>'67854',RFNAME=>'Alexa'
,RLNAME=>'Jaya',REFRELATION=>'Friend',REFPHONE=>7654876534,REFADDRESS=>'Hemenway',DATE_ADDED=>'15-dec-2015',SSN=>876430057,OCCUPATION=>'engineer',GENDER=>'M');

--check phone length validation
CALL INSERT_UPDATE_PACKAGE.insert_new_customer(FNAME=>'John',LNAME=>'Hopper',PHONE=>123412,EMAIL=>'john1hoper19@gmail.com',DOB=>'17-Aug-95',CITY=>'Pune',STREET=>'Baker str',STATES=>'MA',ZIPCODE=>'67854',RFNAME=>'Alexa'
,RLNAME=>'Jaya',REFRELATION=>'Friend',REFPHONE=>7654876534,REFADDRESS=>'Hemenway',DATE_ADDED=>'15-dec-2015',SSN=>870437578,OCCUPATION=>'engineer',GENDER=>'M');

--Check Email pattern----------
CALL INSERT_UPDATE_PACKAGE.insert_new_customer(FNAME=>'John',LNAME=>'Hopper',PHONE=>1234122443,EMAIL=>'john1hoper1@9@gmail.com',DOB=>'17-Aug-95',CITY=>'Pune',STREET=>'Baker str',STATES=>'MA',ZIPCODE=>'67854',RFNAME=>'Alexa'
,RLNAME=>'Jaya',REFRELATION=>'Friend',REFPHONE=>7654876534,REFADDRESS=>'Hemenway',DATE_ADDED=>'15-dec-2015',SSN=>870437578,OCCUPATION=>'engineer',GENDER=>'M');




----complaint type--------------------

--Positive test case

CALL INSERT_UPDATE_PACKAGE.INSERT_COMPLAINT_TYPE (COMP_TYPE1=>'Foul Smell');

Select * from COMPLAINT_TYPE;

--Negative Test case
--Raise a complaint_type that already exists
CALL INSERT_UPDATE_PACKAGE.INSERT_COMPLAINT_TYPE (COMP_TYPE1=>'Rat issue');


------Property--------------------

--Property Table Test cases
--Positive Test cases:
CALL INSERT_UPDATE_PACKAGE.INSERT_PROP(fk_PROPERTY_M_ID1=>1, fk_PROPERTY_O_ID1=>9, P_TYPE1=>'Flat', P_City1=>'Boston',P_Street1=>'Huntington',P_State1=>'Masss', P_Zip1=>'02120',
P_Description1=>'Balcony with great view',P_Configuration1=>'2B2BHK',P_Discount1=>5,P_Date_Listed1=>'2-feb-78',P_Floor1=>2,P_Carpet_Area1=>850);

Select * from property where P_ID=21;

--Negative test cases
--check if the length of zip is 5 digits
CALL INSERT_UPDATE_PACKAGE.INSERT_PROP(fk_PROPERTY_M_ID1=>1, fk_PROPERTY_O_ID1=>9, P_TYPE1=>'Flat', P_City1=>'Boston',P_Street1=>'Huntington',P_State1=>'Masss', P_Zip1=>'020',
P_Description1=>'Balcony with great view',P_Configuration1=>'2B2BHK',P_Discount1=>5,P_Date_Listed1=>'2-feb-78',P_Floor1=>2,P_Carpet_Area1=>850);

--Property date listed cannot be before the management start date
CALL INSERT_UPDATE_PACKAGE.INSERT_PROP(fk_PROPERTY_M_ID1=>1, fk_PROPERTY_O_ID1=>9, P_TYPE1=>'Flat', P_City1=>'Boston',P_Street1=>'Huntington',P_State1=>'Masss', P_Zip1=>'02120',
P_Description1=>'Balcony with great view',P_Configuration1=>'2B2BHK',P_Discount1=>5,P_Date_Listed1=>'02-feb-1888',P_Floor1=>2,P_Carpet_Area1=>850);


--Property should belong to owners that exist in owner table
CALL INSERT_UPDATE_PACKAGE.INSERT_PROP(fk_PROPERTY_M_ID1=>1, fk_PROPERTY_O_ID1=>9000, P_TYPE1=>'Flat', P_City1=>'Boston',P_Street1=>'Huntington',P_State1=>'Masss', P_Zip1=>'02120',
P_Description1=>'Balcony with great view',P_Configuration1=>'2B2BHK',P_Discount1=>5,P_Date_Listed1=>'2-feb-78',P_Floor1=>2,P_Carpet_Area1=>850);




---Employee Table test cases:
--positive test case

CALL INSERT_UPDATE_PACKAGE.insert_new_employee (M_ID=>1,FIRST_NAME=>'Zen',LAST_NAME=>'Ker',CONTACT=>3762538768,CITY=>'nyc',STREET=>'Quees str',STATES=>'new york',
ZIPCODE=>'94748',SALARY=>34733,DESIGNATION=>'Employee',HIRE_DATE=>'01-Jun-21',DOB=> '01-Jun-1989',EMAIL=>'zenker@gmail.com',SSN=>4738303888,GENDER=>'M');

Select * from employee where E_SSN=4738303888;
--negative test case
--Employee should belong to management ID that exists
CALL INSERT_UPDATE_PACKAGE.insert_new_employee (M_ID=>10001,FIRST_NAME=>'Zen',LAST_NAME=>'Ker',CONTACT=>3762538761,CITY=>'nyc',STREET=>'Quees str',STATES=>'new york',
ZIPCODE=>'94748',SALARY=>'34733',DESIGNATION=>'Employee',HIRE_DATE=>'01-Jun-1995',DOB=> '01-Jun-1989',EMAIL=>'zenke@gmail.com',SSN=>947383038,GENDER=>'M');
-- Employee email should be unique
CALL INSERT_UPDATE_PACKAGE.insert_new_employee (M_ID=>1,FIRST_NAME=>'Zeen',LAST_NAME=>'Kerr',CONTACT=>3762038768,CITY=>'nyc',STREET=>'Quees str',STATES=>'new york',
ZIPCODE=>'94748',SALARY=>'34733',DESIGNATION=>'Employee',HIRE_DATE=>'01-Jun-1995',DOB=> '01-Jun-1989',EMAIL=>'zenker@gmail.com',SSN=>9473030388,GENDER=>'M');

---------------------------------------------------------------------------------------------------------
--Management Test cases :
--positive test case
CALL INSERT_UPDATE_PACKAGE.insert_new_management(MANAME=>'Jvue',CITY=>'Boston',STREET=>'roxbury str',STATES=>'MA',ZIPCODE=>'02120',
CONTACT=>'8563839473',WEBSITEURL=>'www.jvue.com',STARTDATE=>'27-Nov-72',ENDDATE=>'27-Nov-2050');

Select * from management_company where M_NAME='Jvue';

--negative test cases
--zip code should be a number
CALL INSERT_UPDATE_PACKAGE.insert_new_management(MANAME=>'Jvue',CITY=>'Boston',STREET=>'roxbury str',STATES=>'MA',ZIPCODE=>'abcd',
CONTACT=>'8563839473',WEBSITEURL=>'www.jvue.com',STARTDATE=>'27-Nov-1972',ENDDATE=>'27-Nov-2050');

-- Management Startdate cannot be greater than End date
CALL INSERT_UPDATE_PACKAGE.insert_new_management(MANAME=>'Jvue',CITY=>'Boston',STREET=>'roxbury str',STATES=>'MA',ZIPCODE=>'12345',
CONTACT=>8563839473,WEBSITEURL=>'www.jvue.com',STARTDATE=>'27-Nov-72',ENDDATE=>'27-Nov-70');
------------------------------------------------------------------------------------------------------------


--Feedback Table Test cases :
--positive test case
CALL INSERT_UPDATE_PACKAGE.ADD_FEEDBACK(PROP_ID=>3,DESCRP=>'good',RAT_MAINT=>3,RAT_CLEAN=>3,RAT_AMEN=>3,RAT_UTI=>3,
RAT_LOC=>3,RAT_RENT=>3,RAT_APTCOND=>3,RAT_RECOMM=>3,FEED_DATE=>'1-Sep-2021');
Select * from feedback where f_ID=21;
--Negative Test case
--Feedback can only be given to properties that exist
CALL INSERT_UPDATE_PACKAGE.ADD_FEEDBACK(PROP_ID=>30000,DESCRP=>'good',RAT_MAINT=>3,RAT_CLEAN=>3,RAT_AMEN=>3,RAT_UTI=>3,
RAT_LOC=>3,RAT_RENT=>3,RAT_APTCOND=>3,RAT_RECOMM=>3,FEED_DATE=>'1-Sep-2021');
--Feedback rating should be between 1-5
CALL INSERT_UPDATE_PACKAGE.ADD_FEEDBACK(PROP_ID=>3,DESCRP=>'good',RAT_MAINT=>9,RAT_CLEAN=>3,RAT_AMEN=>3,RAT_UTI=>3,
RAT_LOC=>3,RAT_RENT=>8,RAT_APTCOND=>7,RAT_RECOMM=>3,FEED_DATE=>'1-Sep-2021');
--Rating should be a number
CALL INSERT_UPDATE_PACKAGE.ADD_FEEDBACK(PROP_ID=>3,DESCRP=>'good',RAT_MAINT=>6,RAT_CLEAN=>3,RAT_AMEN=>6,RAT_UTI=>3,
RAT_LOC=>3,RAT_RENT=>9,RAT_APTCOND=>7,RAT_RECOMM=>3,FEED_DATE=>'1-Sep-2021');
--------------------------------------------------------------------------------------------------------
---Lease Table Test cases:
--positive test case (Add new record in Lease table)

CALL INSERT_UPDATE_PACKAGE.INSERT_LEASE(fk_LEASE_P_ID1=>6, fk_LEASE_C_ID1=>6,L_STRTDATE1=>'12-dec-21',L_ENDDATE1=>12,L_STATUS1=>'Active',MON_RENT1=>1400, LEASE_BREAK_DATE1=>'',DEPOSIT1=>3000,KEYFEE1=>20,APPLICATION_FEE1=>20,LATEFEE1=>30,
MISC1=>10,SUBLEASING_ALLOWED1=>'No');

Select * from Lease where L_ID=22;


--negative test case (Try to add a Lease for Property which already has an active lease)

CALL INSERT_UPDATE_PACKAGE.INSERT_LEASE(fk_LEASE_P_ID1=>7, fk_LEASE_C_ID1=>2,L_STRTDATE1=>'12-dec-21',L_ENDDATE1=>6,L_STATUS1=>'Active',MON_RENT1=>1400, LEASE_BREAK_DATE1=>'',DEPOSIT1=>3000,KEYFEE1=>20,APPLICATION_FEE1=>20,LATEFEE1=>30,
MISC1=>10,SUBLEASING_ALLOWED1=>'No');


--Owner Test cases :
--Positive test case

CALL INSERT_UPDATE_PACKAGE.insert_new_Owner( FNAME=>'Steve', LNAME=>'Jab', DOB=>'17-Aug-93', STREET=>'rose str', CITY=>'Miami',STATE=>'Florida',ZIPCODE=>'87578',CONTACT=>9876789543,
SSN=>999988887,DATE_ADDED=>'17-dec-21',EMAIL=>'stevejob@gmail.com',GENDER=>'M',OCCUPATION=>'Actor');

Select * from owner where O_ID=21;

--Negative test case
--Email should be unique
CALL INSERT_UPDATE_PACKAGE.insert_new_Owner( FNAME=>'Steveeee', LNAME=>'Job', DOB=>'17-Aug-93', STREET=>'rose str', CITY=>'Miami',STATE=>'Florida',ZIPCODE=>87578,CONTACT=>9876089543,
SSN=>999088887,DATE_ADDED=>'17-dec-2021',EMAIL=>'stevejob@gmail.com',GENDER=>'M',OCCUPATION=>'Actor');
--Zipcode should be a number and should be of 5 digits
CALL INSERT_UPDATE_PACKAGE.insert_new_Owner( FNAME=>'Steave', LNAME=>'Job', DOB=>'17-Aug-93', STREET=>'rose str', CITY=>'Miami',STATE=>'Florida',ZIPCODE=>'835',CONTACT=>9800789543,
SSN=>999988087,DATE_ADDED=>'17-dec-2021',EMAIL=>'stevejoab@gmail.com',GENDER=>'M',OCCUPATION=>'Actor');
--contact number should be 10 digits and ssn should be 9 digits
CALL INSERT_UPDATE_PACKAGE.insert_new_Owner( FNAME=>'Steve', LNAME=>'Jab', DOB=>'17-Aug-93', STREET=>'rose str', CITY=>'Miami',STATE=>'Florida',ZIPCODE=>'87578',CONTACT=>9879543,
SSN=>988887,DATE_ADDED=>'17-dec-2021',EMAIL=>'steveb@gmail.com',GENDER=>'M',OCCUPATION=>'Actor');

-----------------------------------------------------------------------------------------------------------


-- CUSTBANKDETAILS table
--positive test case
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTBANKDETAILS(CUST_ID=>2,BNAME=>'BoFA',ACCNBR=>9876567898,BRNUM=>87678967,LUPDATED=>'12-dec-21');

Select * from CUSTOMER_BANK_DETAIL where fk_cbd_c_id=2;
--negative test case
--Customer should be present in customer table to insert the record
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTBANKDETAILS(CUST_ID=>209887,BNAME=>'BoFA',ACCNBR=>9876567898,BRNUM=>7,LUPDATED=>'12-dec-2021');
--negative test case 

--Account number should be 10 digits
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTBANKDETAILS(CUST_ID=>2,BNAME=>'BoFA',ACCNBR=>9898,BRNUM=>7,LUPDATED=>'12-dec-2021');
--------------------------------------------------------------------------------------------------------------

--Rating :
--Positive test case

CALL INSERT_UPDATE_PACKAGE.Rating(property_ID=>1);
--Negative Test case
CALL INSERT_UPDATE_PACKAGE.Rating(property_ID=>10000);

----------------------------------------------------------------------------------------------------------------

CALL INSERT_UPDATE_PACKAGE.UPDATE_LEASE_STATUS();


----------------------------------------------------------------------------------------------------------------
--CustCardDetails Table test cases

--positive test case

CALL INSERT_UPDATE_PACKAGE.ADD_CUSTCARDDETAILS(C_NUM=>1672654786543786,CUST_ID=>1,EXP_DT=>'09-DEC-24',C_TYPE=>'Credit',CUST_NAME=>'Blake',CVV_NUM=>445);
--negative test case
--Account number should be 16 digits
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTCARDDETAILS(C_NUM=>1672656543786,CUST_ID=>1,EXP_DT=>'09-DEC-24',C_TYPE=>'Credit',CUST_NAME=>'Blake',CVV_NUM=>445);
--negative test case
-- cvv should be 3 digits
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTCARDDETAILS(C_NUM=>1672654786543786,CUST_ID=>1,EXP_DT=>'09-DEC-24',C_TYPE=>'Credit',CUST_NAME=>'Blake',CVV_NUM=>44975);


---------------ADD_CUSTOMERPAYMENT

--Positive test case
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTOMERPAYMENT(CP_CUST_ID=>1,AMT_PAID=>3800,PAY_DATE=>'12-dec-21',PAY_STATUS=>'COMPLETE',AUTOPAY=>'Y');
Select * from CUSTOMER_PAYMENT where T_ID=26;
--customerID which does not exist--------------
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTOMERPAYMENT(CP_CUST_ID=>1000,AMT_PAID=>3800,PAY_DATE=>'12-dec-21',PAY_STATUS=>'COMPLETE',AUTOPAY=>'Y');


-----Autopay in value should be Y or N
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTOMERPAYMENT(CP_CUST_ID=>1,AMT_PAID=>3800,PAY_DATE=>'12-dec-21',PAY_STATUS=>'COMPLETE',AUTOPAY=>'NA');

-------PAyment status should be PENDING or COMPLETE
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTOMERPAYMENT(CP_CUST_ID=>1,AMT_PAID=>3800,PAY_DATE=>'12-dec-21',PAY_STATUS=>'COMPL',AUTOPAY=>'N');

-----------------------------------------------------------------------------------------------------------------------------------------------------

---update Customer bank details
---positive test case 

CALL INSERT_UPDATE_PACKAGE.UPDATE_CUSTOMER_BANK_DETAIL(DET_ID=>1,BNAME=>'Santander',ACC_NBR=>5848483844,BNK_RNUM=>44535354);
Select * from CUSTOMER_BANK_DETAIL where DETAIL_ID=21;
---detail id not in parent-----
CALL INSERT_UPDATE_PACKAGE.UPDATE_CUSTOMER_BANK_DETAIL(DET_ID=>1111,BNAME=>'Santander',ACC_NBR=>58484838,BNK_RNUM=>44535354);

---Account number length should be 10-----
CALL INSERT_UPDATE_PACKAGE.UPDATE_CUSTOMER_BANK_DETAIL(DET_ID=>1,BNAME=>'Santander',ACC_NBR=>584848844,BNK_RNUM=>44535354);

---Routing number length should be 8-----
CALL INSERT_UPDATE_PACKAGE.UPDATE_CUSTOMER_BANK_DETAIL(DET_ID=>1,BNAME=>'Santander',ACC_NBR=>5848488844,BNK_RNUM=>4453535);



--positive test case
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTCARDDETAILS(C_NUM=>1672654786543786,CUST_ID=>1,EXP_DT=>'09-DEC-24',C_TYPE=>'Credit',CUST_NAME=>'Blake',CVV_NUM=>445);
Select * from CUSTOMER_CARD_DETAIL where CUSTOMER_CARD_ID=21;
--negative test case
--Account number should be 16 digits
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTCARDDETAILS(C_NUM=>1672656543786,CUST_ID=>1,EXP_DT=>'09-DEC-24',C_TYPE=>'Credit',CUST_NAME=>'Blake',CVV_NUM=>445);
--negative test case
-- cvv should be 3 digits
CALL INSERT_UPDATE_PACKAGE.ADD_CUSTCARDDETAILS(C_NUM=>1672654786543786,CUST_ID=>1,EXP_DT=>'09-DEC-24',C_TYPE=>'Credit',CUST_NAME=>'Blake',CVV_NUM=>44975);


-- COMPLAINT
--Positive test case
CALL INSERT_UPDATE_PACKAGE.ADD_COMPLAINT(PROP_ID=>17,COMPL_TYPE_ID=>4,COMP_DATE=>'18-Nov-2021',COMP_STATUS=>'OPEN',C_DESC=>'Foul Smell in lobby',C_SEVERITY=>'MEDIUM',C_PRIORITY=>1);

Select * from COMPLAINT where COMP_ID=21;
--Negative
--Complaint date should be between Lease start date and Lease end date
CALL INSERT_UPDATE_PACKAGE.ADD_COMPLAINT(PROP_ID=>17,COMPL_TYPE_ID=>4,COMP_DATE=>'18-Nov-1998',COMP_STATUS=>'OPEN',C_DESC=>'Foul Smell in lobby',C_SEVERITY=>'Medium',C_PRIORITY=>1);
-- Complaint Severity should be High, Medium, Low
CALL INSERT_UPDATE_PACKAGE.ADD_COMPLAINT(PROP_ID=>17,COMPL_TYPE_ID=>4,COMP_DATE=>'18-Nov-2021',COMP_STATUS=>'OPEN',C_DESC=>'Foul Smell in lobby',C_SEVERITY=>'Medi',C_PRIORITY=>1);



--positive test case

CALL INSERT_UPDATE_PACKAGE.UPDATE_CUSTOMER_DETAILS(CUST_ID=>1,CUST_PHONE=>8567894531,CUST_EMAIL=>'sam@neu.edu',CUS_STREET=>'75 St',CUS_CITY=>'Boston',CUS_STATE=>'MA',CUS_ZIP=>'02120');

Select * from customer where C_ID=1;
--Negative Test case

--Invalid email

CALL INSERT_UPDATE_PACKAGE.UPDATE_CUSTOMER_DETAILS(CUST_ID=>1,CUST_PHONE=>8567894531,CUST_EMAIL=>'sam',CUS_STREET=>'75 St',CUS_CITY=>'Boston',CUS_STATE=>'MA',CUS_ZIP=>'2120');

--Invalid phone no.

CALL INSERT_UPDATE_PACKAGE.UPDATE_CUSTOMER_DETAILS(CUST_ID=>3,CUST_PHONE=>85678,CUST_EMAIL=>'sam@neu.edu',CUS_STREET=>'75 St',CUS_CITY=>'Boston',CUS_STATE=>'MA',CUS_ZIP=>'02120');

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--positive test case

CALL INSERT_UPDATE_PACKAGE.UPDATE_OWNER_DETAILS(OWN_ID=>1,OWN_PHONE=>8567894531,OWN_EMAIL=>'sam@neu.edu',OWN_STREET=>'75 St',OWN_CITY=>'Boston',OWN_STATE=>'MA',OWN_ZIP=>'02120');
Select * from owner where O_ID=1;
--Negative Test case

--Invalid email

CALL INSERT_UPDATE_PACKAGE.UPDATE_OWNER_DETAILS(OWN_ID=>1,OWN_PHONE=>8567894531,OWN_EMAIL=>'sam',OWN_STREET=>'75 St',OWN_CITY=>'Boston',OWN_STATE=>'MA',OWN_ZIP=>'02120');

--Invalid phone no.

CALL INSERT_UPDATE_PACKAGE.UPDATE_OWNER_DETAILS(OWN_ID=>3,OWN_PHONE=>85678,OWN_EMAIL=>'sam@neu.edu',OWN_STREET=>'75 St',OWN_CITY=>'Boston',OWN_STATE=>'MA',OWN_ZIP=>'02120');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--positive test case

CALL INSERT_UPDATE_PACKAGE.UPDATE_EMPLOYEE_DETAILS(EMP_ID=>1,EMP_PHONE=>8567894531,EMP_EMAIL=>'sam@neu.edu',EMP_STREET=>'75 St',EMP_CITY=>'Boston',EMP_STATE=>'MA',EMP_ZIP=>'02120');
Select * from employee where E_ID=1;

--Negative Test case

--Invalid email


CALL INSERT_UPDATE_PACKAGE.UPDATE_EMPLOYEE_DETAILS(EMP_ID=>1,EMP_PHONE=>8567894531,EMP_EMAIL=>'sam',EMP_STREET=>'75 St',EMP_CITY=>'Boston',EMP_STATE=>'MA',EMP_ZIP=>'02120');

--Invalid phone no.

CALL INSERT_UPDATE_PACKAGE.UPDATE_EMPLOYEE_DETAILS(EMP_ID=>3,EMP_PHONE=>85678,EMP_EMAIL=>'sam@neu.edu',EMP_STREET=>'75 St',EMP_CITY=>'Boston',EMP_STATE=>'MA',EMP_ZIP=>'02120');











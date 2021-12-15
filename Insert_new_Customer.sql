

create or replace procedure insert_new_customer ( 
FNAME IN VARCHAR,
LNAME IN VARCHAR,
PHONE IN NUMBER,
EMAIL IN VARCHAR,
DOB IN DATE,
CITY IN VARCHAR,
STREET IN VARCHAR,
STATES IN VARCHAR,
ZIPCODE IN Number,
RFNAME IN VARCHAR,
RLNAME IN VARCHAR,
REFRELATION IN VARCHAR,
REFPHONE IN NUMBER,
REFADDRESS IN VARCHAR,
DATE_ADDED IN DATE,
SSN IN NUMBER,
OCCUPATION IN VARCHAR,
GENDER IN VARCHAR) 


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
Select MAX(C_ID) into   MAXCUST_ID from customer;
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

end;


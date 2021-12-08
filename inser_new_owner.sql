




create or replace procedure insert_new_Owner( 
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

insert into OWNER(
O_ID,
O_FNAME,
O_LNAME,
O_DOB,
O_STREET,
O_CITY,
O_STATE,
O_ZIPCODE,
O_CONTACT,
O_SSN,
O_DATE_ADDED,
O_EMAIL,
O_GENDER,
O_OCCUPATION) 
  values
(MAXOwner_ID,
FNAME,
LNAME,
DOB,
STREET,
CITY,
STATE,
ZIPCODE,
CONTACT,
SSN,
DATE_ADDED,
EMAIL,
GENDER,
OCCUPATION); 


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

end;


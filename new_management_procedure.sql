
create or replace procedure insert_new_management (
MANAME IN VARCHAR,
CITY IN VARCHAR,
STREET IN VARCHAR,
STATES IN VARCHAR,
ZIPCODE IN VARCHAR,
CONTACT IN NUMBER,
WEBSITEURL IN VARCHAR,
STARTDATE IN DATE ,
ENDDATE IN DATE) 


    is

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
end;


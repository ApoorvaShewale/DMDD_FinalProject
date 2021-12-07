create or replace procedure insert_new_employee (M_ID IN employee.fk_M_ID%TYPE,
FIRST_NAME IN VARCHAR,
LAST_NAME IN VARCHAR,
CONTACT IN NUMBER,
CITY IN VARCHAR,
STREET IN VARCHAR,
STATES IN VARCHAR,
ZIPCODE IN VARCHAR,
SALARY IN NUMBER,
DESIGNATION IN VARCHAR,
HIRE_DATE IN DATE,
DOB IN DATE,
EMAIL IN VARCHAR,
SSN IN NUMBER,
GENDER IN VARCHAR) 


    is

MaX_EID number;
MAXEMP_ID number;
Contact_Len_error Exception;
Date_error exception;
Email_unique exception;
CountUnique number;
Gender_notin exception;

begin


 
select count(*) into countUnique from employee where E_EMAIL = EMAIL;
Select MAX(E_ID) into   MAXEMP_ID from employee;
MaX_EID := MAXEMP_ID + 1;


IF (CountUnique> 0 )
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
raise_application_error (-20001,'Contact number should be 10 digits');
When Date_error Then
raise_application_error (-20002,'Hiredate cannot be less than DOB');
When Email_unique Then
raise_application_error (-20003,'Email should be unique');
When Gender_notin Then
raise_application_error (-20004,'Gender values shouold be m or f');
end;

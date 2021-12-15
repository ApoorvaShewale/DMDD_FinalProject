create or replace PROCEDURE INSERT_PROP (fk_PROPERTY_M_ID1 IN number, fk_PROPERTY_O_ID1 IN number, P_TYPE1 IN VARCHAR, P_City1 IN VARCHAR,P_Street1 IN VARCHAR,P_State1 IN VARCHAR, P_Zip1 IN VARCHAR, P_Description1 IN VARCHAR, P_Configuration1 IN VARCHAR,P_Discount1 IN NUMBER,P_Date_Listed1 IN DATE,P_Floor1 IN NUMBER,P_Carpet_Area1 IN NUMBER) 
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
    
ELSIF (M_ID_count=0)
Then raise M_ID_EXCEPTION;

ELSIF (O_ID_count=0)
Then raise O_ID_EXCEPTION; 

ELSIF mgmt_start_date > P_Date_Listed1 THEN
    RAISE P_Date_Listed_INCORRECT;

ELSE   
    INSERT INTO PROPERTY(P_ID, fk_PROPERTY_M_ID ,fk_O_ID ,P_TYPE ,P_City,P_Street ,P_State ,P_Zipcode ,P_Description,P_Configuration,P_Discount ,P_Date_Listed,P_Floor ,P_CarpetArea) 
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

END;
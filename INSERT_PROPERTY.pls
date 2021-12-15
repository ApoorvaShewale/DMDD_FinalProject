create or replace PROCEDURE INSERT_PROPERTY (P_ID1 IN number, fk_PROPERTY_M_ID1 IN number, fk_PROPERTY_O_ID1 IN number, P_TYPE1 IN VARCHAR, P_City1 IN VARCHAR,P_Street1 IN VARCHAR,P_State1 IN VARCHAR, P_Zip1 IN VARCHAR, P_Description1 IN VARCHAR, P_Configuration1 IN VARCHAR,P_Discount1 IN NUMBER,P_Date_Listed1 IN DATE,P_Floor1 IN NUMBER,P_Carpet_Area1 IN NUMBER) 
IS
    P_ZIP_INCORRECT EXCEPTION;
    fk_PROPERTY_M_ID_INCORRECT EXCEPTION;
    fk_PROPERTY_O_ID_INCORRECT EXCEPTION;
    P_TYPE_INCORRECT EXCEPTION;
    P_Date_Listed_INCORRECT EXCEPTION;
    


BEGIN

--Select M_STARTDATE into mgmt_start_date from MANAGEMENT_COMPANY where fk_PROPERTY_M_ID1=fk_PROPERTY_M_ID; 

IF LENGTH(P_Zip1)>5  THEN 
    RAISE P_ZIP_INCORRECT;

ELSIF fk_PROPERTY_M_ID1 THEN 
    RAISE fk_PROPERTY_M_ID_INCORRECT;
    
ELSIF fk_PROPERTY_O_ID1 THEN 
    RAISE fk_PROPERTY_O_ID_INCORRECT;
    
ELSIF P_TYPE1 NOT IN ('Apartment','Duplex','Condo') THEN  
    RAISE P_TYPE_INCORRECT;
    
    ELSIF mgmt_start_date < P_Date_Listed1 THEN
    RAISE P_Date_Listed_INCORRECT;

ELSE   
    INSERT INTO LEASE(P_ID, fk_PROPERTY_M_ID ,fk_PROPERTY_O_ID ,P_TYPE ,P_City,P_Street ,P_State ,P_Zip ,P_Description,P_Configuration,P_Discount ,P_Date_Listed,P_Floor ,P_Carpet_Area) 
    values (P_ID1, fk_PROPERTY_M_ID1 ,fk_PROPERTY_O_ID1 ,P_TYPE1 ,P_City1,P_Street1 ,P_State1 ,P_Zip1 ,P_Description1,P_Configuration1,P_Discount1 ,P_Date_Listed1,P_Floor1 ,P_Carpet_Area1);
    COMMIT;
    
END IF;

EXCEPTION 
    WHEN P_ZIP_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('Zip code has to be 5 digits');
   WHEN fk_PROPERTY_M_ID_INCORRECT THEN
               DBMS_OUTPUT.PUT_LINE('Please enter the coreect M_ID');
    WHEN fk_PROPERTY_O_ID_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('Please enter the correct O_ID');         
   WHEN P_TYPE_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('Please enter correct P_Type');
   WHEN P_Date_Listed_INCORRECT THEN
                DBMS_OUTPUT.PUT_LINE('P_Date_Listed canot be before the management start date');

END;
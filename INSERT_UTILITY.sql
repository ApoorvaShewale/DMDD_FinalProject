create or replace PROCEDURE INSERT_UTILITY (fk_UTILITY_P_ID1 IN number, Utility_TYPE1 IN VARCHAR, Availibility1 IN VARCHAR) 
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

END;
create or replace PROCEDURE ADD_CUSTBANKDETAILS(CUST_ID IN NUMBER,BNAME VARCHAR,ACCNBR NUMBER,BRNUM NUMBER,LUPDATED DATE) IS 

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
END;

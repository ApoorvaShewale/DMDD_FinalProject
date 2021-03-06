CREATE OR REPLACE PROCEDURE UPDATE_LEASE_STATUS
IS
    CURR_DATE DATE;
BEGIN
    --SELECT in_patient_id into temp_pat_id FROM LEASE WHERE L_ENDDATE<CURR_DATE;
    SELECT SYSDATE INTO CURR_DATE FROM DUAL;
    UPDATE LEASE SET L_STATUS = 'Completed' WHERE L_ENDDATE<CURR_DATE AND L_STATUS = 'Active';
    DBMS_OUTPUT.PUT_LINE('Lease status - updated successfully');
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Lease status - record not found ');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

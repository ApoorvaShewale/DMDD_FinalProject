create or replace PROCEDURE INSERT_COMPLAINT_TYPE (COMP_TYPE1 IN VARCHAR) 
IS
    
    MaX_Comp_ID number;

BEGIN

Select nvl(MAX(COMP_TYPE_ID),0) into  MaX_Comp_ID from COMPLAINT_TYPE;
MaX_Comp_ID := MaX_Comp_ID + 1;



    INSERT INTO COMPLAINT_TYPE(COMP_TYPE_ID, COMP_TYPE)
    values (MaX_Comp_ID, COMP_TYPE1);
    COMMIT;


END;
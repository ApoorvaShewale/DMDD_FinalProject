create or replace PROCEDURE ADD_FEEDBACK(PROP_ID IN NUMBER,
DESCRP VARCHAR,
RAT_MAINT IN NUMBER,
RAT_CLEAN IN NUMBER,
RAT_AMEN IN NUMBER,
RAT_UTI IN NUMBER,
RAT_LOC IN NUMBER,
RAT_RENT IN NUMBER,
RAT_APTCOND IN NUMBER,
RAT_RECOMM IN NUMBER,
FEED_DATE DATE) 

IS 

MAX_F_ID NUMBER;
NEW_F_ID NUMBER;
PROPERTY_ID NUMBER;
PROPERTY_ID_EXCEPTION EXCEPTION;
RAT_EXCEPTION EXCEPTION;
RATNUM_EXCEPTION EXCEPTION;

BEGIN
Select count(*) into PROPERTY_ID from PROPERTY where PROP_ID=PROPERTY.P_ID;

SELECT NVL(MAX(F_ID),0) INTO MAX_F_ID FROM FEEDBACK; 
NEW_F_ID := MAX_F_ID +1; 

IF (PROPERTY_ID=0) THEN
    RAISE PROPERTY_ID_EXCEPTION;
ELSIF RAT_MAINT>5 OR RAT_CLEAN>5 OR RAT_AMEN>5 OR RAT_UTI>5 OR RAT_LOC>5 OR RAT_RENT>5 OR RAT_APTCOND>5 OR RAT_RECOMM>5 THEN
    RAISE RAT_EXCEPTION;
ELSIF RAT_MAINT<0 OR RAT_CLEAN<0 OR RAT_AMEN<0 OR RAT_UTI<0 OR RAT_LOC<0 OR RAT_RENT<0 OR RAT_APTCOND<0 OR RAT_RECOMM<0 THEN
    RAISE RAT_EXCEPTION;
ELSIF is_number(RAT_MAINT)=0 OR is_number(RAT_CLEAN)=0 OR is_number(RAT_AMEN)=0 OR is_number(RAT_UTI)=0 OR is_number(RAT_LOC)=0 OR is_number(RAT_RENT)=0 OR is_number(RAT_APTCOND)=0 OR is_number(RAT_RECOMM)=0 THEN
    RAISE RATNUM_EXCEPTION;
ELSE
INSERT INTO FEEDBACK(F_ID,FK_P_ID,F_DESCRIPTION,F_RATING_MAINTAINANCE,F_RATING_CLEANLINESS,F_RATING_AMENITIES,F_RATING_UTILITIES,F_RATING_LOCATION,F_RATING_RENT,F_RATING_APTCONDITION,F_RATING_RECOMMENDATION,F_DATE)
VALUES (NEW_F_ID,PROP_ID,DESCRP,RAT_MAINT,RAT_CLEAN,RAT_AMEN,RAT_UTI,RAT_LOC,RAT_RENT,RAT_APTCOND,RAT_RECOMM,FEED_DATE);
COMMIT;
END IF;

EXCEPTION
    WHEN PROPERTY_ID_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('PROPERTY ID NOT PRESENT IN PROPERTY TABLE');
    WHEN RAT_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('RATINGS SHOULD BE BETWEEN BETWEEN 1 TO 5');
    WHEN RATNUM_EXCEPTION THEN
        DBMS_OUTPUT.PUT_LINE('PLEASE ENTER A NUMBER');
END;
create or replace PROCEDURE DROP_ENTITY(ENTNAME varchar2,ENTTYPE varchar2) IS 
nCount NUMBER;
BEGIN
if ENTTYPE = 'TABLE' THEN
SELECT count(*) into nCount FROM user_tables where table_name = upper(ENTNAME);
IF (nCount > 0) THEN 
    EXECUTE IMMEDIATE 'drop table ' || ENTNAME || ' cascade constraints';
END IF;
END IF;
END DROP_ENTITY;
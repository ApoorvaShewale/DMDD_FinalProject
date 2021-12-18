
---------------------------Index for searching customers by city--------------------
declare 
index_exists NUMBER(1) :=0;
Begin 
SELECT CASE WHEN EXISTS(SELECT * FROM USER_INDEXES WHERE INDEX_NAME = 'CUST_CITY')
THEN 1
ELSE 0
END CASE INTO index_exists
FROM DUAL;
IF index_exists = 1
THEN
DBMS_OUTPUT.PUT_LINE('INDEX EXIST');
Execute Immediate 'Drop index cust_city';
END IF;

DBMS_OUTPUT.PUT_LINE('NO INDEX EXIST');
Execute Immediate 'CREATE INDEX cust_city 
ON customer(c_city)';
END;
/

select * from customer where c_city like 'M%';



--------------------Index for searching managements that are closed-----------------------

declare 
index_status NUMBER(1) :=0;
Begin 
SELECT CASE WHEN EXISTS(SELECT * FROM USER_INDEXES WHERE INDEX_NAME = 'MANAGEMENT_STATUS')
THEN 1
ELSE 0
END CASE INTO index_status
FROM DUAL;
IF index_status = 1
THEN
DBMS_OUTPUT.PUT_LINE('INDEX EXIST');
Execute Immediate 'Drop index management_status';
END IF;

DBMS_OUTPUT.PUT_LINE('NO INDEX EXIST');
Execute Immediate 'CREATE INDEX management_status 
ON management_company(m_enddate)';
END;
/

select m_id Management_no,m_name Management_name,m_city City,m_street Street,
m_state State,m_zipcode Zipcode,m_contact Phone_no, m_websiteurl Website, m_startdate Management_startdate, 
m_enddate Management_enddate,
'Closed' as Management_status
from management_company where m_enddate < sysdate;
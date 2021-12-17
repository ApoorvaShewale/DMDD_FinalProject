-------CASCADE UPDATE WHEN MANAGEMENT ID IS UPDATE IN PARENT TABLE ----------------------------------------------

Create or replace trigger On_M_ID_Update
AFTER update OF M_ID on MANAGEMENT_COMPANY
for each row
begin



update employee
set FK_M_ID=:new.M_ID where employee.FK_M_ID=:old.M_ID;



update property
set fk_MID= :new.M_ID where property.FK_MID=:old.M_ID;



END;

/


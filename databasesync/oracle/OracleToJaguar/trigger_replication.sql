
Suppose your Oracle table to be replicated is table123.
You can create a table123_trigger_table to capture the changes in table123.

create table table123
(
	nid int primary key, 
	addr varchar(64 ),
	phone varchar(16)
);

drop table table123_trigger_table;
create table table123_trigger_table (
    ts timestamp,
    nid int,
    addr varchar(64),
	phone varchar(16),
    action char(1)
);


Then you can create three triggers to record the changes of table123 into table123_trigger_table:


CREATE OR REPLACE TRIGGER after_table123_insert AFTER INSERT ON table123 
 FOR EACH ROW
 BEGIN
    INSERT INTO table123_trigger_table values ( 
				sysdate, 
				:new.nid, 
				:new.addr, 
				:new.phone, 
				'I' );
 END;
 /


CREATE OR REPLACE TRIGGER after_table123_update AFTER  UPDATE ON table123 
 FOR EACH ROW
 BEGIN
    INSERT INTO table123_trigger_table values ( 
				sysdate, 
				:new.nid, 
				:new.addr, 
				:new.phone, 
				'U' );
 END;
 /

CREATE OR REPLACE TRIGGER after_table123_delete AFTER  DELETE ON table123 
 FOR EACH ROW
 BEGIN
    INSERT INTO table123_trigger_table values ( 
				sysdate, 
				:new.nid, 
				:new.addr, 
				:new.phone, 
				'D' );
 END;
 /



Finally, you just need to write a Java program to periodically pull the records
from table123_trigger_table and write them into your target database table.
Table table123_trigger_table can be cleaned up periodically too.

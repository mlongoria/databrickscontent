-- Databricks notebook source
-- DBTITLE 1,Create the database/catalog
Create Catalog devcatalog1;
Use catalog devcatalog1;
Create schema myschema;

-- COMMAND ----------

--Create a table and insert two unique rows
Create table if not exists devcatalog1.myschema.table1 
 (id Int NOT NULL, columnB String, CONSTRAINT table1_pk Primary Key(id));

INSERT INTO TABLE devcatalog1.myschema.table1 
VALUES
  (1, "one"),
  (2, "two");

-- COMMAND ----------

--Create a second table with a primary key and a foreign key relationship back to the primary key of table1
Create table if not exists devcatalog1.myschema.table2
(table2id INT NOT NULL Primary Key, table1id INT NOT NULL, EventDate date NOT NULL,  
CONSTRAINT table2_table1_fk FOREIGN KEY(table1id) REFERENCES devcatalog1.myschema.table1);

Insert into table devcatalog1.myschema.table2
VALUES 
(1, 1, '2023-06-15'), 
(2, 1, '2023-06-15'), 
(3, 2, '2023-06-15');

-- COMMAND ----------

--Proof that table1 currently has no duplicate id values

Select id, count(id)
from devcatalog1.myschema.table1 
group by id 
having count(id) > 1


-- COMMAND ----------

update devcatalog1.myschema.table2 
set table1id = 2 
where table2id = 2

-- COMMAND ----------

--table2 has two rows in the FK column that reference the PK table1.id of 2
Select * from devcatalog1.myschema.table2

-- COMMAND ----------

/*
Inserting a new row in table1 that add a duplicate id value of 2. 
Because PKs and FKs are informational and not enforced, this is allowed.
*/

insert into devcatalog1.myschema.table1 
values (2, 'three');

select * from devcatalog1.myschema.table1;

-- COMMAND ----------

--Cleanup
DROP CATALOG devcatalog1 CASCADE


-- Created Table Employee_pay

CREATE TABLE Employee_pay(
    employee_pay_id int IDENTITY NOT null,
    employee_pay_firstname VARCHAR(50),
    employee_pay_lastname VARCHAR(50),
    employee_paydate date not null,
    employee_pay_amount money not null,
    employee_pay_hours INT not null,
    employee_pay_rate int not NULL,
    CONSTRAINT pk_Employee_pay_employee_pay_id PRIMARY KEY(employee_pay_id)
)

-- Inserted Employee Pay Details
insert into Employee_pay VALUES ('Sohan','Thakur','05-12-2023',100,10,15)
insert into Employee_pay VALUES ('Shravani','Jadhav','03-08-2023',200,20,15)
insert into Employee_pay VALUES ('Nimitha','Sathya','05-06-2023',300,12,15);
insert into Employee_pay VALUES ('Simran','Pathak','06-07-2023',600,11,14);
insert into Employee_pay VALUES ('Saurav','Makam','10-06-2023',550,12,15);

select * from Employee_pay;



-- Created Table Employee

create TABLE Employee (employee_id int IDENTITY not NULL,
                       employee_firstname VARCHAR(50) not null,
                       employee_lastname VARCHAR(50) not null,
                       employee_email VARCHAR(50) not NULL,
                       employee_phone_number VARCHAR(50) not null,
                       employee_availability int not null,
                       employee_pay_id int not null
                       CONSTRAINT pk_Employee_employee_id PRIMARY key(employee_id),
                       CONSTRAINT u_Employee_employee_email UNIQUE (employee_email),
                       CONSTRAINT fk_Employee_employee_id FOREIGN KEY (employee_pay_id) REFERENCES Employee_pay(employee_pay_id),
                       CONSTRAINT u_Employee_employee_phone_number UNIQUE (employee_phone_number)
                      
                       
)

-- Inserted Employee Details

insert into Employee values ('Sohan','Thakur','sohan.thakur@gmail.com','3154551200',10,1)
insert into Employee values ('Shravani','Jadhav','shravani.jadhav@gmail.com','3154551330',12,2)
insert into Employee values ('Nimitha','Sathya','nimitha.sathya@gmail.com','3154551203',11,3)
insert into Employee values ('Simran','Pathak','simran.pathak@gmail.com','3154551566',9,4)
insert into Employee values ('Saurav','Makam','saurav.makam@gmail.com','3154523540',12,5)

select * from Employee


-- Created Manager Table

create table Manager (manager_id int identity not null,
                      manager_email varchar(50) not null,
                      manager_firstname VARCHAR(50) not null,
                      manager_lastname VARCHAR(50) not null,
                      manager_phone_number VARCHAR(50) NOT null,
                      manager_availability int not null,
                      manager_employee_id int not null,
                      CONSTRAINT pk_Manager_manager_id PRIMARY KEY(manager_id),
                      CONSTRAINT fk_Manager_manager_employee_id FOREIGN KEY (manager_employee_id) REFERENCES Employee_pay(employee_pay_id),
                      CONSTRAINT u_Manager_manager_email UNIQUE (manager_email),
                      CONSTRAINT u_Manager_manager_phone_number UNIQUE (manager_phone_number)
)



create TABLE Employee (employee_id int IDENTITY not NULL,
                       employee_firstname VARCHAR(50) not null,
                       employee_lastname VARCHAR(50) not null,
                       employee_email VARCHAR(50) not NULL,
                       employee_phone_number VARCHAR(50) not null,
                       employee_availability int not null,
                       employee_pay_id int not null
                       CONSTRAINT pk_Employee_employee_id PRIMARY key(employee_id),
                       CONSTRAINT u_Employee_employee_email UNIQUE (employee_email),
                       CONSTRAINT fk_Employee_employee_id FOREIGN KEY (employee_pay_id) REFERENCES Employee_pay(employee_pay_id),
                       CONSTRAINT u_Employee_employee_phone_number UNIQUE (employee_phone_number)
                      
                       
)

-- Inserted Manager Details

INSERT into Manager VALUES ('shravani.jadhav@gmail.com','Shravani','Jadhav','3154551330',12,2)
INSERT into Manager VALUES ('nimitha.sathya@gmail.com','Nimitha','Sathya','3154551203',10,3)

select * from Manager



-- Created Availability Details table
CREATE table Availability_time(
    manager_id int not null,
    employee_id int not null,
    constraint fk_Availability_time_manager_id FOREIGN KEY (manager_id) REFERENCES Manager(manager_id),
    constraint fk_Availability_time_employee_id FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
    
)

-- Inserted Availability Details

insert into Availability_time values (1,1)
insert into Availability_time values (2,2)

select * from Availability_time



-- Created Store Table
CREATE TABLE Store(
    store_id int IDENTITY not null,
    store_street VARCHAR(20) not null,
    store_city varchar(20) not null,
    store_state varchar(20) not null,
    store_hours_operation int not null,
    store_date DATE not null,
    store_revenue money not null,
    store_manager_id INT not null,
    store_employee_id int not null,
    CONSTRAINT pk_Store_store_id PRIMARY KEY (store_id),
    CONSTRAINT fk_Store_store_manager_id FOREIGN key (store_manager_id) REFERENCES Manager(manager_id),
    constraint fk_Store_store_employee_id Foreign KEY (store_employee_id) REFERENCES Employee(employee_id)

)

-- Inserted Store Details into Table

insert into Store VALUES ('Westcott','Syracuse','NY',20,'05-03-2023',1000,2,1)
insert into Store VALUES ('Westcott','Syracuse','NY',20,'05-03-2023',1000,1,2)

update Store set store_street = 'Ackerman',store_revenue=1500 where store_id = 1



-- Business Questions and Query Solution
-- 1. Syracuse Food Franchise is working on monthly revenue audit. Store with highest revenue will get financial support to grow business.
SELECT * FROM Store where store_revenue = (select max(store_revenue) from Store)

go
create view Successful_Franchise as 
SELECT * FROM Store where store_revenue = (select max(store_revenue) from Store)



-- 2. Syracuse Food Franchise is working on monthly revenue audit. Store with highest revenue will get financial support to grow business.
select * from Employee_pay EP INNER JOIN Employee E on EP.employee_pay_id=E.employee_id
 where employee_pay_amount = (select max(employee_pay_amount) from Employee_pay)
 
-- 3. Franchise is facing issue to assign shifts evenly. Employees with highest available hours will help to schedule shifts accordingly.

select E.employee_id, E.employee_firstname, E.employee_lastname, E.employee_availability, E.employee_phone_number, E.employee_email
 from Employee E where employee_availability in (select top 2 employee_availability from Employee) 

/*
-- Stored Procedure to track refinement needed

CREATE PROCEDURE Manager_Refinement1
AS
 SELECT M.manager_id,M.manager_firstname, M.manager_lastname, S.store_id, S.store_street from Store S inner join Manager M on S.store_manager_id = m.manager_id  where store_revenue = (select min(store_revenue) from Store)
 
GO;

EXEC Manager_Refinement1


Select max(S.store_id),(E.employee_id) from Employee E LEFT OUTER JOIN Store S on E.employee_id=S.store_employee_id GROUP BY S.store_id

select S.store_street, count(S.store_employee_id) from Store S INNER JOIN Employee_ EP on  GROUP by S.store_street
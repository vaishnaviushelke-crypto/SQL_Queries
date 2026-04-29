#Create Database
create database SqlPresentation;

Use Sqlpresentation;
create table Departments
(department_ID varchar(10) primary key,
department_Name varchar(30) not null);

insert into departments
values("A","cardiology"),
		("B","Neurology"),
        ("C","orthopedic"),
        ("D","pediatrics"),
        ("E","general");

select * from departments;

create table Hospital
(patient_ID int primary key,
patient_Name varchar(100) not null,
location varchar(30),
department_ID varchar(10),
doctor_Name varchar(100),
fees int,
foreign key(department_ID)
references Departments(department_ID));

insert into hospital
values(1, "vaishnavi","pune","A","dr. neha desai",1200),
		(2,"diksha","mumbai","B","dr. anjali kulkarni",1300),
        (3,"kritika","nagpur","C","dr. priya iyer",1100),
        (4,"sayali","pune","D","dr. rohan joshi",1400),
        (5,"suraj","dehli","E","dr. raj sharma",900),
        (6,"nikhil","bangalore","A","dr. sanjay raut",1000),
        (7,"nita","chennai","B","dr. kavita shah",1200),
        (8,"karan","hyderabad","C","dr. suresh nair",900),
        (9,"mohit","mumbai","D","dr. arjun reddy",1100),
        (10,"ananya","pune","E","dr. bharat ithape",1300);
        

select * from hospital;

#Arithmetic operators(+,-,*,%,etc)
select patient_name, fees, fees+200 as Charges
from hospital;

select patient_name, fees, fees-0.22 as discount
from hospital;

select patient_name, fees,
case
when fees %3 != 0
then fees * 2
else fees
end as double_fees
from hospital;

#logical oprators(and,or,not)
select patient_ID, patient_Name
from hospital
where location="pune" and fees >1000;

select patient_ID, patient_Name,fees,doctor_name
from hospital
where location="mumbai" or location="dehli";

select * from hospital
where not location = "banglore";

#relational operator(>,<,=,!=)
select patient_ID, patient_Name,fees,doctor_name
from hospital
where fees >1200;

select patient_ID, patient_Name,fees,doctor_name
from hospital
where fees<1000;

select patient_ID, patient_Name,fees,doctor_name
from hospital
where location != "hyderabad";

select * from hospital 
where location = "dehli";

#special operators(in,between,like,not like,is null, not null)
select patient_ID, patient_Name,fees,doctor_name,location
from hospital
where location in("pune","dehli","hyderabad");

select patient_ID, patient_Name,fees,doctor_name
from hospital
where fees between 900 and 1100;

select patient_ID, patient_Name,doctor_name
from hospital
where doctor_name like "dr. A%";

select patient_ID, patient_Name,location
from hospital
where location not like "p%";

#where clause
select patient_ID, patient_Name,location
from hospital
where doctor_name is null;

#group by clause
select department_id,avg(fees) as Average_fees
from hospital
group by department_id;

Select location,
		sum(fees) as Total_fees,
		avg(fees) as Average_fees,
        max(fees) as Max_fees,
        min(fees) as Min_fees,
        count(patient_ID) as Total_patient 
from hospital
Group by location;

#order by clause
select patient_ID, patient_Name,doctor_name,fees
from hospital
order by fees asc;

select patient_ID, patient_Name,doctor_name,fees,location
from hospital
order by location asc, fees desc;

#having clause
select location, count(patient_id) as Total_patient
from hospital
group by location
having count(patient_id) > 1;


select location, avg(fees) as Avrage_Fees,
       sum(fees) AS Total_Fees,
       count(patient_id) as Total_Patients
from Hospital
group by location
having avg(fees) > 1000
order by Avrage_Fees desc;

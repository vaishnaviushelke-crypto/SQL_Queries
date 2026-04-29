use 18SepBatch;

create table hospital(
bill_id int primary key,
patient_name varchar(50),
department varchar(30),
doctor_name varchar(50),
visit_date date,
days_admitted int,
daily_charge decimal(10,2),
medicine_charge decimal(10,2)
);

insert into hospital(bill_id,patient_name,department,doctor_name,visit_date,days_admitted,daily_charge,medicine_charge)
values (1, "raj", "cardiology", "Dr. rao", "2024-01-05", 5, 4000, 8000),
(2, "neha", "neurology",  "Dr. mehta","2024-01-06", 3, 5000, 6000),
(3, "rahul","cardiology", "Dr. rao","2024-01-08", 7, 4000, 10000),
(4, "pooja", "orthopedic","Dr. singh","2024-01-10", 4, 3500, 5000),
(5, "karan", "neurology", "Dr. mehta","2024-01-12", 6, 5000, 9000),
(6, "sneha","cardiology", "Dr. rao","2024-01-15", 2, 4000, 3000),
(7, "rohit", "orthopedic","Dr. singh","2024-01-18", 8, 3500, 12000),
(8, "anita","cardiology", "Dr. verma","2024-01-20", 6, 4200, 7000),
(9, "vikas", "neurology","Dr. mehta","2024-01-22", 4, 5000, 6500),
(10,"meena",  "orthopedic","Dr. singh","2024-01-25", 3, 3500, 4000);
select * from hospital;
DELIMITER $$
create function room_charges(days int, rate decimal(10,2))
returns decimal(10,2)
deterministic
begin
    return days * rate;
END$$
DELIMITER ;

DELIMITER $$
create function total_bill(days int,rate decimal(10,2),medicine decimal(10,2)
)
returns decimal(10,2)
deterministic
begin
    return (days * rate) + medicine;
END$$
DELIMITER ;

DELIMITER $$
create function insurance_discount(amount decimal(10,2))
returns decimal(10,2)
deterministic
begin
    if amount > 30000 
    then return amount * 0.90;
    else
        return amount;
    end if;
END$$
DELIMITER ;

select bill_id,patient_name,room_charges(days_admitted, daily_charge) as room_cost,total_bill(days_admitted, daily_charge, medicine_charge) AS gross_bill,
insurance_discount(total_bill(days_admitted, daily_charge, medicine_charge)) as net_bill
from hospital;

#row_number
select patient_name,department,visit_date,
row_number() over (
partition by department
order by  visit_date) as visit_no
from hospital;

#ranK
select patient_name,department, total_bill(days_admitted, daily_charge, medicine_charge) as bill,
rank() over(partition by department
        order by  total_bill(days_admitted, daily_charge, medicine_charge) DESC) as dept_rank
from hospital;

#dense_rank
select patient_name,department, total_bill(days_admitted, daily_charge, medicine_charge) as bill,
dense_rank() over(partition by department
        order by  total_bill(days_admitted, daily_charge, medicine_charge) DESC) as dense_rank_dept
from hospital;

#sum
select patient_name,department, total_bill(days_admitted, daily_charge, medicine_charge) as bill,
sum(total_bill(days_admitted, daily_charge, medicine_charge))
over (order by  visit_date) as running_total
from hospital;

#average
select patient_name,department, total_bill(days_admitted, daily_charge, medicine_charge) as bill,
avg(total_bill(days_admitted, daily_charge, medicine_charge))
over (partition by department) as dept_avg_bill
from hospital;

#min & max
select patient_name,department, total_bill(days_admitted, daily_charge, medicine_charge) as bill,
min(total_bill(days_admitted, daily_charge, medicine_charge))
over (partition by department) as min_bill,
max(total_bill(days_admitted, daily_charge, medicine_charge))
over (partition by department) as  max_bill
from hospital;

#lag
select patient_name,department, total_bill(days_admitted, daily_charge, medicine_charge) as bill,
lag(total_bill(days_admitted, daily_charge, medicine_charge))
over (partition by department order by visit_date) as prev_bill
from hospital;

#lead
select patient_name,department, total_bill(days_admitted, daily_charge, medicine_charge) as bill,
lead(total_bill(days_admitted, daily_charge, medicine_charge))
over (partition by department order by visit_date) as next_bill
from hospital;

#ntile
select patient_name,department, total_bill(days_admitted, daily_charge, medicine_charge) as bill,
ntile(3) over (partition by department order by total_bill(days_admitted, daily_charge, medicine_charge) DESC) as cost_bucket
from hospital;

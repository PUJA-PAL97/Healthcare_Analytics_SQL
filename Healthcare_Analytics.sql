create database EMR_project;
use EMR_project;

select count(*) from patient;
select * from patient;

select count(*) from doctor;
select * from doctor;

select count(*) from visit;
select * from visit;

select count(*) from treatment;
select * from treatment;

select count(*) from lab_test;
select * from lab_test;

select count(*) from billing;
select * from billing;

select count(*) from department;
select * from department;

select count(*) from insurance_policy;
select * from insurance_policy;

select count(*) from insurance_provider;
select * from insurance_provider;

select count(*) from insurance_claims;
select * from insurance_claims;

-- KPI1: Total Patients
select distinct count(Patient_id) from patient;

-- KPI2 : Total Doctors
select distinct count(`doctor ID`) FROM DOCTOR;

-- KPI3 : Total Visits
select distinct count(visit_id) from visit;

-- KPI4 : Average Age of Patients
select 
CONCAT(ROUND(avg(timestampdiff(year,DateOfBirth,CurDate())),2),"Years") AS Avg_Age 
from patient;

-- KPI5: Top 5 Diagnosed Conditions
select Diagnosis, count(*) as total_patients
from visit
group by Diagnosis
order by total_patients DESC
limit 5 ;

-- KPI6 : Follow-Up Rate
select 
count(*) as total_visits, 
round(count(case when `Follow Up Required` = "Yes" then 1 end) * 100 / count(visit_id),2) as follow_up_rate
from visit;
  
  -- KPI7 : Avg. Treatment Cost Per Visit
select concat("$",round(avg(`Total Episode Cost ($)`),2)) as Avg_treatment_cost
 from treatment;
  
  -- KPI8 : Total lab test 
  select distinct count(lab_result_ID) from lab_test; 
  
  -- KPI9 : Percentage of Abnormal Lab Results
  select 
   concat(round(count(case when `test result` = "Abnormal" then 1 end)/100,0),"%")
   as abnormal_result
   from lab_test;
    
-- KPI10 : Doctor workload
select
  round(avg(patient_count),0) as avg_patients_per_doc
  from
    (select 
    `DOCTOR ID`,COUNT(visit_id) as Patient_count
	 from visit join doctor using(`doctor id`)
     group by `doctor id`) as Doc_workload;
     
-- KPI11: TOP 10 Doctors by no. of patients visits
select `Doctor Name`, count(visit_id) as patient_count
  from doctor join visit using(`Doctor id`)
  group by `Doctor Name`
  order by patient_count desc
  limit 10;
  
-- KPI12 : Top 10 Insurance Companies by Patients
select 	
  `Provider Name`,COUNT(`PATIENT ID`) AS 	PATIENT_COUNT
  FROM INSURANCE_POLICY
  GROUP BY `Provider Name`
  ORDER BY PATIENT_COUNT DESC
  LIMIT 10;
  
-- KPI13 : % of Genderwise Patient Distribution
select 
  Gender ,CONCAT(ROUND(count(patient_id)/100,0),"%")
  from patient 
  group by gender;

-- KPI14 :% of Lab Results  
select 
`Test Result`,
 concat(round(count(`visit id`)/100,0),"%") as count_patients
 from lab_test
 GROUP BY `Test Result`;

-- KPI15 : No. of Doctors in each Department
select `Department Name`,
 count(`Doctor ID`) AS Doc_count
 from department join doctor using(`Department ID`)
 GROUP BY `Department Name`;
 
-- KPI 16 : Year and QuarterWise No. of Patients
select 
  `Visit Year`,`Visit Quarter`, count(visit_id) as count_patients
   from visit
   group by `Visit Year`,`Visit Quarter`;

-- kpi17 : top 10 insurance claimed amount 
select 
  `bill id`,`Amount Claimed ($)`
  from insurance_claims
  order by `Amount Claimed ($)`desc
  limit 10;
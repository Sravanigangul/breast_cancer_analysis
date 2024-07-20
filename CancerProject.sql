use sravani_project;

CREATE table breast_cancer(
ID VARCHAR(15),
Breast_Cancer_Type TEXT,
Disease_Free_Event VARCHAR(3),
Disease_Free_Months Float,
ER_PCT_Primary VARCHAR(6),
Fraction_Genome_Altered VARCHAR(10),
Age VARCHAR(6),
Time_to_Diagnosis Float,
Tumor_Laterality TEXT,
Menopausal_Status TEXT,
Metastatic_Recurrence_Time VARCHAR(8),
Mutation_Count VARCHAR(8),
Overall_Survival_Months Float,
Overall_Patient_Receptor_Status VARCHAR(20),
Prior_Breast_Primary TEXT,
Site_of_Metastatis TEXT,
Sex TEXT,
Stage_At_Diagnosis TEXT,
Time_To_Death_Months VARCHAR(10),
TMB Float,
Patient_status TEXT
);
select * from breast_cancer;

SET SQL_safe_Updates = 0;
/*Filling the blanks with null*/
UPDATE breast_cancer
SET ID = NULLIF(ID, ''),
    Breast_Cancer_Type = NULLIF(Breast_Cancer_Type, ''),
    Disease_Free_Event = NULLIF(Disease_Free_Event, ''),
    Disease_Free_Months = NULLIF(Disease_Free_Months, ''),
    ER_PCT_Primary = NULLIF(ER_PCT_Primary, ''),
    Fraction_Genome_Altered = NULLIF(Fraction_Genome_Altered, ''),
    Age = NULLIF(Age, ''),
    Time_to_Diagnosis = NULLIF(Time_to_Diagnosis, ''),
    Tumor_Laterality = NULLIF(Tumor_Laterality, ''),
    Menopausal_Status = NULLIF(Menopausal_Status, ''),
    Metastatic_Recurrence_Time = NULLIF(Metastatic_Recurrence_Time, ''),
    Mutation_Count = NULLIF(Mutation_Count, ''),
    Overall_Survival_Months = NULLIF(Overall_Survival_Months, ''),
    Overall_Patient_Receptor_Status = NULLIF(Overall_Patient_Receptor_Status, ''),
    Prior_Breast_Primary = NULLIF(Prior_Breast_Primary, ''),
    Site_of_Metastatis = NULLIF(Site_of_Metastatis, ''),
    Sex = NULLIF(Sex, ''),
    Stage_At_Diagnosis = NULLIF(Stage_At_Diagnosis, ''),
    Time_To_Death_Months = NULLIF(Time_To_Death_Months, ''),
    TMB = NULLIF(TMB, ''),
    Patient_status = NULLIF(Patient_status, '');
/* code to check null values */
SELECT *
FROM breast_cancer
WHERE ID IS NULL
   OR Breast_Cancer_Type IS NULL
   OR Disease_Free_Event IS NULL
   OR Disease_Free_Months IS NULL
   OR ER_PCT_Primary IS NULL
   OR Fraction_Genome_Altered IS NULL
   OR Age IS NULL
   OR Time_to_Diagnosis IS NULL
   OR Tumor_Laterality IS NULL
   OR Menopausal_Status IS NULL
   OR Metastatic_Recurrence_Time IS NULL
   OR Mutation_Count IS NULL
   OR Overall_Survival_Months IS NULL
   OR Overall_Patient_Receptor_Status IS NULL
   OR Prior_Breast_Primary IS NULL
   OR Site_of_Metastatis IS NULL
   OR Sex IS NULL
   OR Stage_At_Diagnosis IS NULL
   OR Time_To_Death_Months IS NULL
   OR TMB IS NULL
   OR Patient_status IS NULL;
SET SQL_safe_Updates = 0;


SELECT * FROM breast_cancer;
/* Converting id from string to integer*/
WITH bc AS (
    SELECT ID,
           CAST(SUBSTRING(ID, 3, LENGTH(ID)) AS UNSIGNED) AS patient_ID
    FROM breast_cancer
)
SELECT Distinct(patient_ID) AS Pt_ID
FROM bc;

ALTER table breast_cancer
ADD column Pt_ID INT;

UPDATE breast_cancer
SET pt_ID = substring(ID, 3, LENGTH(ID));

ALTER Table breast_cancer
DROP column ID;

SELECT * FROM breast_cancer;
/* disease free months*/
UPDATE breast_cancer
SET Disease_Free_Months = 0
WHERE DISEASE_FREE_MONTHS IS NULL;
/* Filling ER_PCT_Primary null values based on patient status*/
UPDATE breast_cancer
SET ER_PCT_Primary = CASE 
                        WHEN Overall_Patient_Receptor_Status = 'Triple Negative' THEN 0
                        WHEN Overall_Patient_Receptor_Status = 'HR+/HER2-' AND ER_PCT_Primary IS NULL THEN FLOOR(10+RAND()*61)+10
                        WHEN Overall_Patient_Receptor_Status =  'HR+/HER2+' AND ER_PCT_Primary IS NULL THEN FLOOR(10+RAND()*61)+10
                        ELSE ER_PCT_Primary
                        END;
                        
UPDATE breast_cancer
SET Fraction_Genome_Altered = 0
WHERE Fraction_Genome_Altered IS NULL;

UPDATE breast_cancer
SET Metastatic_Recurrence_Time = 0
WHERE Metastatic_Recurrence_Time IS NULL;

SELECT Fraction_Genome_Altered, Mutation_Count, TMB 
FROM breast_cancer
WHERE Mutation_Count IS NULL;

UPDATE breast_cancer
SET Mutation_Count = 0 
WHERE Mutation_Count IS NULL;

UPDATE breast_cancer
SET TMB = 0 
WHERE TMB IS NULL;

UPDATE breast_cancer
SET Time_To_Death_Months = 0
WHERE Time_To_Death_Months IS NULL;

SELECT * FROM breast_cancer;

SELECT 
AVG(Mutation_Count), MAX(Mutation_Count), MIN(Mutation_Count), STD(Mutation_Count)
FROM breast_cancer;

SELECT 
AVG(ER_PCT_Primary), MAX(ER_PCT_Primary), MIN(ER_PCT_Primary), STD(ER_PCT_Primary)
FROM breast_cancer;

SELECT 
AVG(Fraction_Genome_Altered), MAX(Fraction_Genome_Altered), MIN(Fraction_Genome_Altered), STD(Fraction_Genome_Altered)
FROM breast_cancer;

SELECT 
AVG(Time_to_Diagnosis), MAX(Time_to_Diagnosis), MIN(Time_to_Diagnosis), STD(Time_to_Diagnosis)
FROM breast_cancer;

SELECT 
AVG(Metastatic_Recurrence_Time), MAX(Metastatic_Recurrence_Time), MIN(Metastatic_Recurrence_Time), STD(Metastatic_Recurrence_Time)
FROM breast_cancer;

SELECT 
AVG(Overall_Survival_Months), MAX(Overall_Survival_Months), MIN(Overall_Survival_Months), STD(Overall_Survival_Months)
FROM breast_cancer;

SELECT 
AVG(TMB), MAX(TMB), MIN(TMB), STD(TMB)
FROM breast_cancer;
/*Updating menopausal status based on age*/


/*Deleting Duplicate ID*/
WITH CTE AS (
SELECT Pt_ID, 
ROW_NUMBER() OVER (PARTITION BY Pt_ID) AS rn
FROM breast_cancer)
DELETE bc
FROM breast_cancer bc
JOIN CTE ON bc.Pt_ID= CTE.Pt_ID
WHERE CTE.rn > 1;
/*1. Count of patient with Type of breast_cancer*/
SELECT Breast_Cancer_Type, COUNT(*) AS Count_of_Types
FROM breast_cancer
GROUP BY Breast_Cancer_Type
ORDER BY COUNT_of_Types DESC;
/*2. Age distribution of patients*/
SELECT 
    CASE
        WHEN Age BETWEEN 20 AND 30 THEN 'young_age'
        WHEN Age BETWEEN 31 AND 50 THEN 'Middle_age'
        WHEN Age > 50 THEN 'Old_age'
        ELSE 'Unknown'
    END AS Age_Group,
    COUNT(*) AS Count
FROM breast_cancer
GROUP BY 
    CASE
        WHEN Age BETWEEN 20 AND 30 THEN 'young_age'
        WHEN Age BETWEEN 31 AND 50 THEN 'Middle_age'
        WHEN Age > 50 THEN 'Old_age'
        ELSE 'Unknown'
    END
ORDER BY 
    CASE
        WHEN Age_Group = 'young_age' THEN 1
        WHEN Age_Group = 'Middle_age' THEN 2
        WHEN Age_Group = 'Old_age' THEN 3
        ELSE 4
    END;
/* 3.Menopausal status of patients*/
SELECT Menopausal_Status, COUNT(*) AS COUNT
FROM breast_cancer
GROUP BY Menopausal_Status;

UPDATE breast_cancer
SET Menopausal_Status = CASE
                           WHEN Age BETWEEN 30 AND 40 THEN 'Peri'
                           WHEN Age > 41 THEN 'Post'
                       ELSE Menopausal_Status
                       END;
				
SELECT * FROM breast_cancer;
/*4. SEX of Patients*/
SELECT SEX, COUNT(*) AS COUNT
FROM breast_cancer
GROUP BY SEX
ORDER BY COUNT;
/* 5. Stage at diagnosis*/
SELECT Stage_At_Diagnosis, COUNT(*) AS COUNT
FROM breast_cancer
GROUP BY Stage_At_Diagnosis
Order BY COUNT DESC;
/*6. Count of patients with prior cancer*/
SELECT Prior_Breast_Primary, COUNT(*) AS COUNT
FROM breast_cancer
GROUP BY Prior_Breast_Primary
ORDER BY COUNT DESC;
/*7. Site of Metastatis */
SELECT Stage_At_Diagnosis, Site_of_Metastatis, COUNT(Site_of_Metastatis) AS COUNT
FROM breast_cancer
GROUP BY Stage_At_Diagnosis,Site_of_Metastatis
ORDER BY COUNT DESC;
/*8. Overall Patient receptor status*/
SELECT Overall_Patient_Receptor_Status, COUNT(*) AS COUNT
FROM breast_cancer
GROUP BY Overall_Patient_Receptor_Status
ORDER BY COUNT DESC;
/* 9. Patient Status after treatment*/
SELECT Patient_status, COUNT(*) AS COUNT
FROM breast_cancer
GROUP BY Patient_status
ORDER BY COUNT DESC;
/*10. maximum and minimum Time to diagnosis*/
SELECT MAX(Time_to_Diagnosis), MIN(Time_to_Diagnosis)
FROM breast_cancer;
/*11.The patient with maximum time to diagnosis*/
SELECT Pt_ID, Breast_Cancer_Type, Age,Overall_Patient_Receptor_Status, Tumor_Laterality,Stage_At_Diagnosis,Time_To_Death_Months,TMB,Patient_status, MAX(Time_to_Diagnosis)
FROM breast_cancer
GROUP BY Pt_ID, Breast_Cancer_Type, Age,Overall_Patient_Receptor_Status, Tumor_Laterality,Stage_At_Diagnosis,Time_To_Death_Months,TMB,Patient_status
ORDER BY MAX(TIME_to_Diagnosis) DESC
LIMIT 5; 
/* 12. The average age of the patient with Invasive ductal cancer*/
SELECT Breast_Cancer_Type,
AVG(Age) AS Avg_patient_age
FROM breast_cancer
WHERE Breast_Cancer_Type = 'IDC';
/*13. List all patients who have had a disease-free event*/
SELECT Count(Pt_ID), Disease_Free_Event
FROM breast_cancer
GROUP BY Disease_Free_Event;
/*14. List all patients who had a recurrence or progression with in 1 year of diagnosis*/
SELECT Count(Pt_ID), Disease_Free_Event, Breast_Cancer_Type
FROM breast_cancer
WHERE Disease_Free_Event = 1 AND Disease_Free_Months < 12
GROUP BY Disease_Free_Event, Breast_Cancer_Type;
/*15. correlation between estrogen receptor percentage (ER_PCT_Primary) and mutation count */
SELECT ER_PCT_Primary, Mutation_Count
FROM breast_cancer
WHERE ER_PCT_Primary = 99;
/*16.overall survival rate of patients based on receptor status*/
SELECT ROUND(AVG(Overall_Survival_Months),2), Overall_Patient_Receptor_Status
FROM breast_cancer
Group by Overall_Patient_Receptor_Status;
/*17.Average time to death for different stages of breastcancer*/
SELECT AVG(Time_To_Death_Months),Stage_At_Diagnosis, Breast_Cancer_Type
FROM breast_cancer
GROUP BY Stage_At_Diagnosis, Breast_Cancer_Type;
/*18.the fraction of the genome altered for patients who are alive versus those who are not.*/
SELECT AVG(Fraction_Genome_Altered), Patient_status
FROM breast_cancer
GROUP BY Patient_status;
/*19.mutation counts differ between patients with and without a prior breast cancer diagnosis?*/
SELECT AVG(Mutation_Count), Prior_Breast_Primary
FROM breast_cancer
GROUP BY Prior_Breast_Primary;
/*20.TMB based on cancer type*/
SELECT Breast_Cancer_Type, MAX(TMB)
FROM breast_cancer
GROUP BY Breast_Cancer_Type;


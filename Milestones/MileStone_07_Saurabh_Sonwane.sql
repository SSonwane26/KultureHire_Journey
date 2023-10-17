/* 
***MileStone_9*** 
*/

USE genzdataset;

SELECT * FROM learning_aspirations;

SELECT * FROM manager_aspirations;

SELECT * FROM mission_aspirations;

SELECT * FROM personalized_info;

# Q1. What percentage of male and female Genz wants to go to office Every Day?    
SELECT 
    Gender,
    ROUND((SUM(CASE
                WHEN LA.PreferredWorkingEnvironment LIKE 'Every Day%' THEN 1
                ELSE 0
            END) / COUNT(*)) * 100,
            2) AS Percentage
FROM
    personalized_info PI
        JOIN
    learning_aspirations LA ON PI.ResponseID = LA.ResponseID
WHERE
    Gender IS NOT NULL
GROUP BY Gender;

;

# Q2. What percentage of Genz's who have chosen their career in Business operations are most likely to be influenced by their Parents?
SELECT 
    ROUND((SUM(CASE
                WHEN CareerInfluenceFactor = 'My Parents' THEN 1
                ELSE 0
            END) / COUNT(*)) * 100,
            2) AS Percentage
FROM
    personalized_info PI
        JOIN
    learning_aspirations LA ON PI.ResponseID = LA.ResponseID
WHERE
    ClosestAspirationalCareer LIKE '%Business Operations%'
;

# Q3. What percentage of Genz prefer opting for higher studies, give a gender wise approach?
SELECT 
    Gender,
    ROUND((SUM(CASE
                WHEN HigherEducationAbroad LIKE 'Yes%' THEN 1
                ELSE 0
            END) / COUNT(LA.ResponseID)) * 100,
            2) AS Percentage
FROM
    learning_aspirations LA
        JOIN
    personalized_info PI ON LA.ResponseID = PI.ResponseID
WHERE
    Gender IS NOT NULL
GROUP BY Gender
;

# Q4. What percentage of Genz are willing & not willing to work for a company whose mission is misaligned with their public actions or even their products?
SELECT 
    Gender,
    ROUND((SUM(CASE
                WHEN MisalignedMissionLikelihood LIKE 'Will Work%' THEN 1
                ELSE 0
            END) / COUNT(MA.ResponseID)) * 100,
            2) Willing_to,
    ROUND((SUM(CASE
                WHEN MisalignedMissionLikelihood LIKE 'Will NOT Work%' THEN 1
                ELSE 0
            END) / COUNT(MA.ResponseID)) * 100,
            2) Not_willing_to
FROM
    mission_aspirations MA
        JOIN
    personalized_info PI ON MA.ResponseID = PI.ResponseID
WHERE
    Gender IS NOT NULL
GROUP BY Gender
;

# Q5. What is the most suitable working environment according to female genz's?
SELECT 
    PreferredWorkingEnvironment,
    COUNT(PreferredWorkingEnvironment) Total_Count
FROM
    learning_aspirations LA
        JOIN
    personalized_info PI ON LA.ResponseID = PI.ResponseID
WHERE
    gender LIKE 'Female%'
GROUP BY PreferredWorkingEnvironment
ORDER BY Total_Count DESC
LIMIT 5
;

# Q6. What is the percentage of Males who expected a salary 5 years >50k and also work under Employers who appreciates learning but doesn't enables an learning environment?
WITH table1 as (
	select 
		COUNT(*) count1
	FROM
		personalized_info PI
			JOIN
		mission_aspirations MA ON MA.ResponseID = PI.ResponseID
			JOIN
		manager_aspirations MAA ON MAA.ResponseID = MA.ResponseID
	WHERE
		PI.Gender LIKE 'Male%'
			AND PreferredEmployer = 'Employers who appreciates learning but doesn\'t enables an learning environment'
			AND MA.ExpectedSalary5Years NOT LIKE '30k to 50k%'
			),
table2 as (
	SELECT 
		count(*) count2 
    FROM 
		personalized_info
		)
SELECT  
	(count1/count2) Percentage 
FROM
	table1,table2
;

# Q7. Find out the correlation between gender about their PreferredWorkSetup.
SELECT 
    PreferredWorkSetup,
    SUM(CASE
        WHEN Gender LIKE 'Male%' THEN 1
        ELSE 0
    END) Male,
    SUM(CASE
        WHEN Gender LIKE 'Female%' THEN 1
        ELSE 0
    END) Female
FROM
    personalized_info PI
        JOIN
    manager_aspirations MAA ON PI.ResponseID = MAA.ResponseID
GROUP BY PreferredWorkSetup
;

# Q8. Calculate the total number of Female who aspire to work in their Closest Aspirational Career and have a No Social Impact Likelihood of "1 to 5".
SELECT 
    COUNT(*) AS Total_Females
FROM
    personalized_info PI
        JOIN
    learning_aspirations LA ON PI.ResponseID = LA.ResponseID
        JOIN
    mission_aspirations MA ON PI.ResponseID = MA.ResponseID
WHERE
    PI.Gender LIKE 'Female%'
        AND LA.ClosestAspirationalCareer IS NOT NULL
        AND MA.NoSocialImpactLikelihood >= 1
        AND MA.NoSocialImpactLikelihood <= 5
;

# Q9. Retrieve the Male who are interested in Higher Education Abroad and have a Career Influence Factor of "My Parents".
SELECT 
    PI.ResponseID
FROM
    personalized_info PI
        JOIN
    learning_aspirations LA ON PI.ResponseID = LA.ResponseID
WHERE
    PI.Gender LIKE 'Male%'
        AND LA.HigherEducationAbroad LIKE 'Yes%'
        AND LA.CareerInfluenceFactor = 'My Parents'
;

# Q10. Determine the percentage of gender who have a No Social Impact Likelihood of "8 to 10" among those who are interested in Higher Education Abroad.
SELECT 
    PI.Gender,
    ROUND((SUM(CASE
                WHEN
                    MA.NoSocialImpactLikelihood >= 8
                        AND MA.NoSocialImpactLikelihood <= 10
                THEN 1
                ELSE 0
            END) / COUNT(*)) * 100,
            2) AS Percentage
FROM
    personalized_info PI
        JOIN
    learning_aspirations LA ON PI.ResponseID = LA.ResponseID
        JOIN
    mission_aspirations MA ON PI.ResponseID = MA.ResponseID
WHERE
    LA.HigherEducationAbroad LIKE 'Yes%'
GROUP BY PI.Gender
;

# Q11. Give a detailed split of the GenZ preferences to work with Teams, Data should include Male, Female and Overall in counts and also the overall in %.
SELECT 
    SUM(CASE
        WHEN
            Gender LIKE 'Male%'
                AND PreferredWorkSetup LIKE '%My Team%'
        THEN
            1
        ELSE 0
    END) Male,
    SUM(CASE
        WHEN
            Gender LIKE 'Female%'
                AND PreferredWorkSetup LIKE '%My Team%'
        THEN
            1
        ELSE 0
    END) Female,
    SUM(CASE
        WHEN PreferredWorkSetup LIKE '%My Team%' THEN 1
        ELSE 0
    END) Overall,
    ROUND((SUM(CASE
                WHEN PreferredWorkSetup LIKE '%My Team%' THEN 1
                ELSE 0
            END) / COUNT(*)) * 100,
            2) Overall_Percentage
FROM
    personalized_info PI
        JOIN
    manager_aspirations MAA ON PI.ResponseID = MAA.ResponseID
;

# Q12. Give a detailed breakdown of "WorkLikelihood3 Years" for each gender.
SELECT 
    WorkLikelihood3Years,
    SUM(CASE
        WHEN Gender LIKE 'Male%' THEN 1
        ELSE 0
    END) Male,
    SUM(CASE
        WHEN Gender LIKE 'Female%' THEN 1
        ELSE 0
    END) Female
FROM
    personalized_info PI
        JOIN
    manager_aspirations MAA ON PI.ResponseID = MAA.ResponseID
GROUP BY WorkLikelihood3Years
;

# Q13. Give a detailed breakdown of "WorkLikelihood3 Years" for each state in India.
SELECT 
    LEFT(ZipCode, 2) StateCode,
    SUM(CASE
        WHEN WorkLikelihood3Years LIKE 'No%' THEN 1
        ELSE 0
    END) NoWay,
    SUM(CASE
        WHEN WorkLikelihood3Years LIKE 'Will%' THEN 1
        ELSE 0
    END) WillWorkFor3YearsOrMore,
    SUM(CASE
        WHEN WorkLikelihood3Years LIKE 'This%' THEN 1
        ELSE 0
    END) ThisWillBeHardToDoButIfItIsTheRightCo
FROM
    manager_aspirations MAA
        JOIN
    personalized_info PI ON MAA.ResponseID = PI.ResponseID
WHERE
    CurrentCountry = 'India'
GROUP BY StateCode
ORDER BY StateCode
;

# Q14. What is the Average Starting salary expectations at 3 year mark for each gender?
SELECT 
    Gender,
    ROUND(AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary3Years, ' to ', 1),
                'k',
                1)
        AS DECIMAL (10 , 2 ))),2) AS AverageSalary3YearsinThousands
FROM
    personalized_info PI
        JOIN
    mission_aspirations MA ON PI.ResponseID = MA.ResponseID
WHERE
    Gender IS NOT NULL
GROUP BY Gender
;

# Q15. What is the Average Starting salary expectations at 5 year mark for each gender?
SELECT 
    Gender,
    ROUND(AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary5Years, ' to ', 1),
                'k',
                1)
        AS DECIMAL (10 , 2 ))),2) AS AverageSalary5YearsinThousands
FROM
    personalized_info PI
        JOIN
    mission_aspirations MA ON PI.ResponseID = MA.ResponseID
WHERE
    Gender IS NOT NULL
GROUP BY Gender
;

# Q16. What is the Average Higher Bar salary expectations at 3 year mark for each gender?
SELECT 
    Gender,
    ROUND(AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary3Years, ' to ', -1),
                'k',
                1)
        AS DECIMAL (10 , 2 ))),2) AS AverageSalary3YearsinThousands
FROM
    personalized_info PI
        JOIN
    mission_aspirations MA ON PI.ResponseID = MA.ResponseID
WHERE
    Gender IS NOT NULL
GROUP BY Gender
;

# Q17. What is the Average Higher Bar salary expectations at 5 year mark for each gender?
SELECT 
    Gender,
    ROUND(AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary5Years, ' to ', -1),
                'k',
                1)
        AS DECIMAL (10 , 2 ))),2) AS AverageSalary5YearsinThousands
FROM
    personalized_info PI
        JOIN
    mission_aspirations MA ON PI.ResponseID = MA.ResponseID
WHERE
    Gender IS NOT NULL
GROUP BY Gender
;

# Q18. What is the Average Starting salary expectations at 3 year mark for each gender and each state in India?
SELECT 
    LEFT(ZipCode, 2) StateCode,
    Gender,
    ROUND(AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary3Years, ' to ', 1),
                'k',
                1)
        AS DECIMAL (10 , 2 ))),2) AS AverageSalary3YearsinThousands
FROM
    mission_aspirations MA
        JOIN
    personalized_info PI ON MA.ResponseID = PI.ResponseID
WHERE
    CurrentCountry = 'India'
GROUP BY StateCode , Gender
ORDER BY StateCode
;

# Q19. What is the Average Starting salary expectations at 5 year mark for each gender and each state in India?
SELECT 
    LEFT(ZipCode, 2) StateCode,
    Gender,
    ROUND(AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary5Years, ' to ', 1),
                'k',
                1)
        AS DECIMAL (10 , 2 ))),2) AS AverageSalary5YearsinThousands
FROM
    mission_aspirations MA
        JOIN
    personalized_info PI ON MA.ResponseID = PI.ResponseID
WHERE
    CurrentCountry = 'India'
GROUP BY StateCode , Gender
ORDER BY StateCode
;

# Q20. What is the Average Higher Bar salary expectations at 3 year mark for each gender and each state in India?
SELECT 
    LEFT(ZipCode, 2) StateCode,
    Gender,
    Round(AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary3Years, ' to ', -1),
                'k',
                1)
        AS DECIMAL (10 , 2 ))),2) AS AverageSalary3YearsinThousands
FROM
    mission_aspirations MA
        JOIN
    personalized_info PI ON MA.ResponseID = PI.ResponseID
WHERE
    CurrentCountry = 'India'
GROUP BY StateCode , Gender
ORDER BY StateCode
;

# Q21. What is the Average Higher Bar salary expectations at 5 year mark for each gender and each state in India?
SELECT 
    LEFT(ZipCode, 2) StateCode,
    Gender,
    ROUND(AVG(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ExpectedSalary5Years, ' to ', -1),
                'k',
                1)
        AS DECIMAL (10 , 2 ))),2) AS AverageSalary5YearsinThousands
FROM
    mission_aspirations MA
        JOIN
    personalized_info PI ON MA.ResponseID = PI.ResponseID
WHERE
    CurrentCountry = 'India'
GROUP BY StateCode , Gender
ORDER BY StateCode
;

# Q22. Give a detailed breakdown of the possibility of GenZ working for an Org if the "Mission is misaligned" for each state in India.
SELECT 
    LEFT(ZipCode, 2) StateCode,
    Gender,
    COUNT(MA.ResponseID) AS MisalignedMissionCount
FROM
    mission_aspirations MA
        JOIN
    personalized_info PI ON MA.ResponseID = PI.ResponseID
WHERE
    CurrentCountry = 'India'
GROUP BY StateCode,Gender
;

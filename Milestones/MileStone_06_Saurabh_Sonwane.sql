/* 
***MileStone_7*** 
*/

USE genzdataset;

SELECT * FROM learning_aspirations;

SELECT * FROM manager_aspirations;

SELECT * FROM mission_aspirations;

SELECT * FROM personalized_info;

# Q1: How many Male have responded to the survey from India?
SELECT 
    COUNT(ResponseID) AS Total_Males
FROM
    personalized_info
WHERE
    Gender LIKE 'Male%'
        AND CurrentCountry = 'India';

# Q2: How many Female have responded to the survey from India?
SELECT 
    COUNT(ResponseID) AS Total_Females
FROM
    personalized_info
WHERE
    Gender LIKE 'Female%'
        AND CurrentCountry = 'India';
    
# Q3: How many of the Gen-Z are influenced by their parents in regards to their career choices from India?
SELECT 
    COUNT(LA.ResponseID) AS Total_IDs
FROM
    learning_aspirations LA
        JOIN
    personalized_info PI ON LA.ResponseID = PI.ResponseID
WHERE
    CareerInfluenceFactor = 'My Parents'
        AND CurrentCountry = 'India';
    
# Q4: How many of the Female Gen-Z are influenced by their parents in regards to their career choices from India?
SELECT 
    COUNT(LA.ResponseID) AS Total_Female
FROM
    learning_aspirations LA
        JOIN
    personalized_info PI ON LA.ResponseID = PI.ResponseID
WHERE
    CareerInfluenceFactor = 'My Parents'
        AND Gender LIKE 'Female%'
        AND CurrentCountry = 'India';
        
# Q5: How many of the Male Gen-Z are influenced by their parents in regards to their career choices from India?
SELECT 
    COUNT(LA.ResponseID) AS Total_Males
FROM
    learning_aspirations LA
        JOIN
    personalized_info PI ON LA.ResponseID = PI.ResponseID
WHERE
    CareerInfluenceFactor = 'My Parents'
        AND Gender LIKE 'Male%'
        AND CurrentCountry = 'India';
        
# Q6: How many of the Male and Female (individually display in 2 different columns, but as part of the same query) Gen-Z are influenced by their parents in regards to their career choices from India?
SELECT 
    SUM(CASE
        WHEN gender LIKE 'Male%' THEN 1
        ELSE 0
    END) AS Total_Males,
    SUM(CASE
        WHEN gender LIKE 'Female%' THEN 1
        ELSE 0
    END) AS Total_Females
FROM
    learning_aspirations LA
        JOIN
    personalized_info PI ON LA.ResponseID = PI.ResponseID
WHERE
    careerinfluencefactor = 'my parents'
        AND currentcountry = 'India';
        
# Q7: How many Gen-Z are infuenced by Social Media and Influencers together from India?
SELECT 
    COUNT(LA.ResponseID) AS Total_IDs
FROM
    learning_aspirations LA
        JOIN
    personalized_info PI ON LA.ResponseID = PI.ResponseID
WHERE
    (CareerInfluenceFactor LIKE 'Social Media%'
        OR CareerInfluenceFactor LIKE 'Influencers%')
        AND CurrentCountry = 'India';
        
# Q8: How many Gen-Z are infuenced by Social Media and Influencers together, display for Male and Female seperately from India?
SELECT 
    SUM(CASE
        WHEN gender LIKE 'Male%' THEN 1
        ELSE 0
    END) AS Total_Males,
    SUM(CASE
        WHEN gender LIKE 'Female%' THEN 1
        ELSE 0
    END) AS Total_Females
FROM
    learning_aspirations LA
        JOIN
    personalized_info PI ON LA.ResponseID = PI.ResponseID
WHERE
    (CareerInfluenceFactor LIKE 'Social Media%'
        OR CareerInfluenceFactor LIKE 'Influencers%')
        AND currentcountry = 'India';
        
# Q9: How many of the Gen-Z who are influenced by the social media for their career aspiration are looking to go abroad?
SELECT 
    COUNT(ResponseID) AS Total_IDs
FROM
    learning_aspirations
WHERE
    CareerInfluenceFactor LIKE 'Social Media%'
        AND HigherEducationaBroad LIKE 'Yes%';

# Q10: How many of the Gen-Z who are influenced by "people in their circle" for career aspiration are looking to go abroad?
SELECT 
    COUNT(ResponseID) AS Total_IDs
FROM
    learning_aspirations
WHERE
    CareerInfluenceFactor LIKE 'People from my circle%'
        AND HigherEducationaBroad LIKE 'Yes%';
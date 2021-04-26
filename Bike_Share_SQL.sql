/*
Randy Miskuski
Project: Bixi
Date: 01.20.2020
Due Date: 01.24.2020
*/


# 1-1.) The total number of trips for the years of 2016.

# Aggregate using the count function to find the number of trips in 2016
# Specify our search condition where YEAR = 2016

SELECT 
    COUNT(*) AS Number_of_2016_Trips
FROM
    trips
WHERE
    YEAR(start_date) = 2016;
    
-- The total number of trips in 2016 was found to be 3,917,401

# 1-2.) The total number of trips for the years of 2017

# Aggregate using the count function to find the number of trips in 2017
# Specify our search condition where YEAR = 2017

SELECT 
    COUNT(*) AS Number_of_2017_Trips
FROM
    trips
WHERE
    YEAR(start_date) = 2017;
--  The total number of trips in 2017 was found to be 4,666,765


# 1- 3.) The total number of trips for the years of 2016 broken-down by month.

# Aggregate by selecting the month from the start date column and alliace as month,
# Find all instances where a trip was completed in 2016, and group by month

SELECT 
    MONTH(start_date) AS month, COUNT(*) AS Number_of_Trips
FROM
    trips
WHERE
    YEAR(start_date) = 2016
GROUP BY month; 


# 1- 4.) The total number of trips for the years of 2017 broken-down by month.

# Aggregate by selecting the month from the start date column and alliace as month,
# Find all instances where a trip was completed in 2017, and group by month

SELECT 
    MONTH(start_date) AS month, COUNT(*) AS Number_of_Trips
FROM
    trips
WHERE
    YEAR(start_date) = 2017
GROUP BY month; 


# 1- 5.) The average number of trips a day for each year-month combination in the dataset.

# Select our year, month, and day, from our start date and aggregate. We will alliace this as num_trips
# Make this ^^ into a subquery
# Aggregate our year, and month to find the average number of trips, then group by year and month

SELECT year, month, AVG(num_trips)
FROM
(
	SELECT YEAR(start_date) AS year, MONTH(start_date) AS month, DAY(start_date) AS day, COUNT(*) AS num_trips
	FROM trips
	GROUP BY year, month, day
) AS t
GROUP BY year, month;

# 1-6.) Save your query results from the previous question (Q1.5) by creating a table called working_table1

-- Select the query from 1.5, and CREATE TABLE as a "working_table1"


# Check if the table exists, then drop it
DROP TABLE IF EXISTS working_table1;

# Create a working table
CREATE TABLE working_table1 AS 
# Pasted from subquery above ^^
SELECT year, month, AVG(num_trips)
FROM
(
	SELECT YEAR(start_date) AS year, MONTH(start_date) AS month, DAY(start_date) AS day, COUNT(*) AS num_trips
	FROM trips
	GROUP BY year, month, day
) AS t
GROUP BY year, month;

# Check to ensure the working_table1 performs
SELECT * FROM working_table1;



# 2.1) The total number of trips in the year 2017 broken-down by membership status (member/non-member)

# Aggregate by membership from the trips table, and specify a search condition where the start_date = 2017
# Group by is_member

SELECT is_member, COUNT(*)
FROM trips
WHERE YEAR(start_date) = 2017
GROUP BY is_member;

-- in 2017 there were 3,784,682 rides by an active member (1) and 882,083 rides by non-members (0)


# 2.2) The fraction of total trips that were done by members for the year of 2017 broken-down by month

-- First we select the MONTH from our startdate to seperate our Datetime, the aggregate by finding the average
-- Since is_member is a boolean value (1 or 0) we can calculate the fraction

SELECT
MONTH(start_date) AS month, AVG(is_member) AS fraction_of_member
FROM trips
WHERE YEAR(start_date) = 2017
GROUP BY month;

-- 3.1) Which time of year the demand for Bixi bikes is at its peak?

# assuming 30 days in each month
# Select the start date as Year and Month, then count all occurances in months that had bike rentals.
# take each of the months rental SUM and divide by 30 days

SELECT 
    YEAR(start_date) AS Year,
    MONTH(start_date) AS Month,
    COUNT(*) / 30 AS Number_Of_Trips_By_Month
FROM
    trips
GROUP BY YEAR(start_date) , MONTH(start_date)
ORDER BY YEAR(start_date) , MONTH(start_date) ASC
LIMIT 16;

-- In both 2016, and 2017 the peak months for Bike rentals was July, then August. 2016 had 28,691 rentals, and 27,998 rentals respectively
-- In 2017 July and August had 23,308 rentals, and 22,426 rentals.


# 4.1 What are the names of the 5 most popular starting locations? Solve this problem without using a subquery
 
-- First we select our required fields: start_station_code, and name. Then use COUNT(*) to find all instances where a trip has been made
-- join trips onto stations, and group by the non aggregate functions start_station_code, and name, LIMIT the top 5 most used locations 

# Aggregate name from name from station and allias as num. 

SELECT s.name, COUNT(*) AS num
FROM trips AS t
JOIN stations AS s
ON t.start_station_code = s.code
GROUP BY s.name
ORDER BY num DESC
LIMIT 5;


# 4.2 Solve the same question as Q4.1, but now use a subquery. Is there a difference in the query run time between 4.1 and 4.2?

-- first we create the subquery and select our start_station_code, and our aggregate COUNT function to count all instances where a station was used
-- group the subquery by the start_station_code, then we, and alliace as Station Starts. 
-- then we join our stations table to our sub query, and ORDER BY the number_Of_Station_Uses, Then Limit

SELECT s.name, num
FROM
(
	SELECT start_station_code, COUNT(*) AS num
	FROM trips 
	GROUP BY start_station_code
	ORDER BY num DESC
	LIMIT 5
) AS t
JOIN stations AS s
ON t.start_station_code = s.code;

-- the subquery ran at 2.985 seconds, the original query took 6.797 secodnds

# 5.1) If we break-up the hours of the day as follows:
	# 5.1) How is the number of starts and ends distributed for the station Mackay / de Maisonneuve throughout the day?
    
    # End station count Mackay / de Maisonneuve 
-- first we use our CASE WHEN statement to define what hours are morning, afternoon, evening, and night. 
-- then we count the instances where a bike was rented in our CASE WHEN parameters
-- then we JOIN stations with trips on the condition that our START_date = to our station table code
-- then we make sure that we are only looking at the "Mackay / de Maisonneuve" station
-- Then we GROUP BY our CASE WHEN "time_of_day"
    
    

# First, get the start station code
SELECT *
FROM stations
WHERE name = 'Mackay / de Maisonneuve';

# Find the START trips distribution throughout the day for the Mackay Station 6100

SELECT 
    CASE
        WHEN HOUR(start_date) BETWEEN 7 AND 11 THEN 'morning'
        WHEN HOUR(start_date) BETWEEN 12 AND 16 THEN 'afternoon'
        WHEN HOUR(start_date) BETWEEN 17 AND 21 THEN 'evening'
        ELSE 'night'
    END AS 'time_of_day',
    COUNT(*)
FROM trips
WHERE start_station_code = 6100
GROUP BY time_of_day
ORDER BY time_of_day;

# Find the END trips distribution throughout the day for Mckay Station 6100

SELECT 
    CASE
        WHEN HOUR(end_date) BETWEEN 7 AND 11 THEN 'morning'
        WHEN HOUR(end_date) BETWEEN 12 AND 16 THEN 'afternoon'
        WHEN HOUR(end_date) BETWEEN 17 AND 21 THEN 'evening'
        ELSE 'night'
    END AS 'time_of_day',
    COUNT(*)
FROM trips
WHERE end_station_code = 6100
GROUP BY time_of_day
ORDER BY time_of_day;

# Now we can join the queries

SELECT a.time_of_day, start_trips, end_trips
FROM
(
SELECT CASE
        WHEN HOUR(start_date) BETWEEN 7 AND 11 THEN 'morning'
        WHEN HOUR(start_date) BETWEEN 12 AND 16 THEN 'afternoon'
        WHEN HOUR(start_date) BETWEEN 17 AND 21 THEN 'evening'
        ELSE 'night'
    END AS 'time_of_day',
    COUNT(*) AS start_trips
FROM trips
WHERE start_station_code = 6100
GROUP BY time_of_day
ORDER BY time_of_day
) AS a
JOIN
(
SELECT 
    CASE
        WHEN HOUR(end_date) BETWEEN 7 AND 11 THEN 'morning'
        WHEN HOUR(end_date) BETWEEN 12 AND 16 THEN 'afternoon'
        WHEN HOUR(end_date) BETWEEN 17 AND 21 THEN 'evening'
        ELSE 'night'
    END AS 'time_of_day',
    COUNT(*) AS end_trips
FROM trips
WHERE end_station_code = 6100
GROUP BY time_of_day
ORDER BY time_of_day
) AS b
ON a.time_of_day = b.time_of_day;


# 6.0 ) List all stations for which at least 10% of trips are round trips. Only consider stations with at least 500 starting trips.
# 6.1) First, write a query that counts the number of starting trips per station.

-- first we select our starting location, station name, and Count the number of instances that a bike has left a specific station
-- then we JOIN the trips table with the stations table

SELECT start_station_code, COUNT(*) AS num_trips
FROM trips
JOIN stations AS s
ON s.code = start_station_code
GROUP BY start_station_code;


# 6.2) Second, write a query that counts, for each station, and the number of round trips


SELECT start_station_code, COUNT(*) as num_round_trips
FROM trips
JOIN stations AS s
ON s.code = trips.start_station_code
WHERE start_station_code = end_station_code
GROUP BY start_station_code;

# 6.3) Combine the above queries and calculate the fraction of round trips to the total number of starting trips for each location.

SELECT a.start_station_code,
	COUNT(a.start_station_code) AS num_start_trips,
	b.num_round_trips/COUNT(a.start_station_code) AS num_round_trips
    FROM trips AS a
INNER JOIN(
	SELECT start_station_code, COUNT(*) as num_round_trips
	FROM trips
	WHERE start_station_code = end_station_code
	GROUP BY start_station_code, end_station_code
) AS b
ON a.start_station_code = b.start_station_code
GROUP BY a.start_station_code;







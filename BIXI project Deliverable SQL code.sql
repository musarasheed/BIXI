/*1.1*/
SELECT COUNT(*)
FROM trips
WHERE YEAR(start_date) = 2016;

/*1.2*/
SELECT COUNT(*)
FROM trips
WHERE YEAR(start_date) = 2017;

/*1.3*/
SELECT MONTH(start_date),COUNT(*)
FROM trips
WHERE YEAR(start_date) = 2016
GROUP BY MONTH(start_date);

/*1.4*/
SELECT MONTH(start_date),COUNT(*)
FROM trips
WHERE YEAR(start_date) = 2017
GROUP BY MONTH(start_date);

/*1.5*/
SELECT MONTH(start_date), COUNT(*)/(DAY(LAST_DAY(start_date))) AS Average
FROM trips
WHERE YEAR(start_date) = 2016 /*Change to 2017 for 2017*/
GROUP BY MONTH(start_date);

/*1.6*/
SELECT *
FROM working_table1;

/*2.1*/
SELECT is_member, COUNT(*)
FROM trips
WHERE YEAR(start_date) = 2017
GROUP BY is_member;

/*2.2*/
SELECT MONTH(start_date), COUNT(*)
FROM trips
WHERE YEAR(start_date) = 2017 AND is_member = 1
GROUP BY MONTH(start_date);

         /*Then Use*/ 

SELECT MONTH(start_date), COUNT(*)
FROM trips
WHERE YEAR(start_date) = 2017
GROUP BY MONTH(start_date);

        /*And divide these 2 tables by each other*/

/*3.2*/
SELECT is_member, MONTH(start_date), COUNT(*)
FROM trips 
WHERE YEAR(start_date) = 2016 /*switch to 2017 for 2017*/
GROUP BY MONTH(start_date), is_member
HAVING is_member = 0;

/*4.1*/
SELECT stations.code, stations.name, COUNT(*) AS num
FROM trips JOIN stations
ON trips.start_station_code = stations.code
GROUP BY stations.code
ORDER BY num DESC
LIMIT 5;

/*4.2*/
SELECT frequency.code, stations.name, frequency.frequency
FROM(
	SELECT start_station_code AS code, COUNT(*) AS Frequency
	FROM trips
	GROUP BY start_station_code
	ORDER BY Frequency DESC
	LIMIT 5
	) AS Frequency JOIN stations
ON frequency.code = stations.code;

/*5.1*/
SELECT CASE
       WHEN HOUR(start_date) BETWEEN 7 AND 11 THEN "morning"
       WHEN HOUR(start_date) BETWEEN 12 AND 16 THEN "afternoon"
       WHEN HOUR(start_date) BETWEEN 17 AND 21 THEN "evening"
       ELSE "night"
       END AS "time_of_day", COUNT(*)
FROM trips
WHERE end_station_code = 6100 /*Switch end with start for start station*/
GROUP BY time_of_day;

/*6.1*/
SELECT start_station_code, COUNT(*) AS total
FROM trips
GROUP BY start_station_code;

/*6.2*/
SELECT start_station_code, end_station_code, COUNT(*) AS round
FROM trips
WHERE start_station_code = end_station_code
GROUP BY start_station_code;

/*6.3*/
SELECT total_trips.start_station_code, round_trips.round/total_trips.total
FROM 
(	SELECT start_station_code, COUNT(*) AS total
	FROM trips
	GROUP BY start_station_code
) AS total_trips JOIN
(
	SELECT start_station_code, end_station_code, COUNT(*) AS round
	FROM trips
	WHERE start_station_code = end_station_code
	GROUP BY start_station_code
) AS round_trips
ON total_trips.start_station_code = round_trips.start_station_code;

/*6.4*/

SELECT sum_trip.start_station_code, stations.name, fractions
FROM
(
	SELECT total_trips.start_station_code, round_trips.round/total_trips.total AS fractions
	FROM 
	(	SELECT start_station_code, COUNT(*) AS total
		FROM trips
		GROUP BY start_station_code
	) AS total_trips 
          
          JOIN

	(
		SELECT start_station_code, end_station_code, COUNT(*) AS round
		FROM trips
		WHERE start_station_code = end_station_code
		GROUP BY start_station_code
	) AS round_trips

	ON total_trips.start_station_code = round_trips.start_station_code
	WHERE total_trips.total>=500 AND (round_trips.round/total_trips.total)>=0.1
) AS sum_trip JOIN stations
ON sum_trip.start_station_code = stations.code;



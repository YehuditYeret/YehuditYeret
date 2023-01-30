DROP VIEW IF EXISTS forestation;

CREATE VIEW forestation 
AS
SELECT f.*,
	   l.total_area_sq_mi,
       2.59* total_area_sq_mi AS total_area_sqkm,
	   r.region,
	   r.income_group,
	   forest_area_sqkm/(2.59* total_area_sq_mi)* 100 AS forest_percent
 FROM forest_area f
 JOIN land_area l
 ON f.country_code = l.country_code AND f.year = l.year
 JOIN regions r
 ON f.country_code = r.country_code
 
 
SELECT *
FROM forestation
WHERE country_name = 'World'


SELECT *
FROM forestation
WHERE year = 2016
ORDER BY total_area_sqkm DESC


SELECT region,year, SUM(forest_area_sqkm)/SUM(total_area_sqkm)*100 AS forest_percent
FROM forestation
WHERE year = 2016 OR year = 1990
GROUP BY 1,2
ORDER BY 2,3


WITH year_2016 AS (
              SELECT country_name,
					 region,
			         forest_area_sqkm
			  FROM forestation
			  WHERE year = 2016),
	 year_1990 AS (
              SELECT country_name,			         
			         forest_area_sqkm
			  FROM forestation
			  WHERE year = 1990)

SELECT year_2016.country_name,
       year_2016.region,
       year_1990.forest_area_sqkm AS forest_area_1990,
	   year_2016.forest_area_sqkm AS forest_area_2016,
	   year_2016.forest_area_sqkm - year_1990.forest_area_sqkm AS forest_area_chance,
	   (year_2016.forest_area_sqkm - year_1990.forest_area_sqkm)*100/year_1990.forest_area_sqkm AS percent_change
FROM year_2016
JOIN year_1990
ON year_2016.country_name = year_1990.country_name				 
ORDER BY 5

WITH quartiles_table AS
     (SELECT country_name,
	         forest_percent,
	         CASE WHEN forest_percent < 25 THEN '0 - 25'
	              WHEN forest_percent >= 25 AND forest_percent < 50 THEN '25 - 50'
			      WHEN forest_percent >= 50 AND forest_percent < 75 THEN '50 - 75'
			      ELSE '75 - 100' END AS quartiles
	  FROM forestation
	  WHERE year = 2016 AND forest_percent IS NOT NULL)
SELECT quartiles, COUNT(*)
FROM quartiles_table
GROUP BY 1


SELECT country_name,
	   forest_percent,
	   region
FROM forestation
WHERE year = 2016 AND forest_percent >= 75
ORDER BY 2 DESC

SELECT country_name,
	   forest_percent,
	   region
FROM forestation
WHERE year = 2016 AND forest_percent > 33.9297857030622
ORDER BY 2 DESC
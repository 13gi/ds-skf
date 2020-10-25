
/* ---------------------------------------
	Задание 4.2.0
------------------------------------------ */


select 
	* --раздел select остается неизменным
from 
	information_schema."tables" t -- указываем первую таблицу, не забываем дать alias
		join information_schema.columns c -- пишем join на вторую таблицу 
			on t.table_name = c.table_name 
			and t.table_schema = c.table_schema 
;


/* ---------------------------------------
	Задание 4.2.1
------------------------------------------ */

select 
	city_name, avg(population)
--	, min(population), max(population), count(population) 
from shipping.city as c
group by city_name 


/* 
 select avg(population) from shipping.city LIMIT 1
 165718.755407653910
*/
SELECT count(c.city_name)
FROM shipping.city c
WHERE c.population > 165718.755407653910


/*
	Второе решение
*/
SELECT 
	count(DISTINCT city_name)
FROM shipping.city
WHERE population > (select avg(population) from shipping.city LIMIT 1)
;



/* ---------------------------------------
	Задание 4.2.2
------------------------------------------ */
SELECT * FROM shipping.city c 



/*
	Второе решение
*/

SELECT 
	count(DISTINCT city_name)
--	*
FROM shipping.city
WHERE area > (select avg(area) from shipping.city LIMIT 1)
;


/* ---------------------------------------
	Задание 4.3
------------------------------------------ */
select 	*
	from
		shipping.shipment s
			join shipping.driver d on s.driver_id = d.driver_id



/* ---------------------------------------
	Задание 4.3.1
------------------------------------------ */

SELECT *
FROM shipping.shipment s 
JOIN shipping.city c ON s.city_id = c.city_id 
			



/* ---------------------------------------
	Задание 4.3
------------------------------------------ */

select 	
	s.driver_id,
	d.driver_id
from
	shipping.shipment s
		join shipping.driver d on s.driver_id = d.driver_id


/* ---------------------------------------
	Задание 4.3.2
ERR
------------------------------------------ */

SELECT 
	--*
	DISTINCT (s.city_id, c.city_id)
	--s.city_id, c.city_id
FROM shipping.shipment s 
LEFT JOIN shipping.customer c ON s.cust_id = c.cust_id 




/* ---------------------------------------
	Задание 4.3.3
------------------------------------------ */
select 	
	d.last_name,
	count(distinct s.city_id) uniq_cities
from
	shipping.shipment s
		join shipping.driver d on s.driver_id = d.driver_id
group by d.last_name
order by count(distinct s.city_id) desc
limit 5
offset 1




/* ---------------------------------------
	Задание 4.3.3
------------------------------------------ */
SELECT 
	c.city_name
	, count(s.ship_id) AS count_ship
FROM shipping.shipment s 
JOIN shipping.city c 
	ON s.city_id = c.city_id 
GROUP BY c.city_name
ORDER BY count_ship DESC 
OFFSET 1 LIMIT 1


/* ---------------------------------------
	Задание 4.3
------------------------------------------ */
SELECT * FROM shipping.truck 

SELECT * FROM shipping.truck t 
WHERE t.truck_id = 8


-- Следующий запрос выводит список всех грузовиков, 
-- выпущенных не раньше грузовика с идентификатором 8, 
-- исключая этот грузовик:
select 
	t1.*
from shipping.truck t 
join shipping.truck t1 
	on t.model_year <= t1.model_year and t.truck_id != t1.truck_id
where t.truck_id = 8



/* ---------------------------------------
	Задание 4.3.4
------------------------------------------ */
--	Выведите среднее население, среднюю площадь и плотность населения городов, чья площадь больше города Paramount. 
--	Плотность населения в этом задании рассчитывается как сумма населения, деленная на сумму площади.






/* ---------------------------------------
	Задание 4.
------------------------------------------ */


/* ---------------------------------------
	Задание 4.
------------------------------------------ */


/* ---------------------------------------
	Задание 4.
------------------------------------------ */


/* ---------------------------------------
	Задание 4.
------------------------------------------ */


/* ---------------------------------------
	Задание 4.
------------------------------------------ */


/* ---------------------------------------
	Задание 4.
------------------------------------------ */



/* ---------------------------------------
	Задание 4.
------------------------------------------ */


/* ---------------------------------------
	Задание 3.2.0
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
	Задание 3.2.1
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
	Задание 3.2.2
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
	Задание 3.3
------------------------------------------ */
select 	*
	from
		shipping.shipment s
			join shipping.driver d on s.driver_id = d.driver_id



/* ---------------------------------------
	Задание 3.3.1
------------------------------------------ */

SELECT *
FROM shipping.shipment s 
JOIN shipping.city c ON s.city_id = c.city_id 
			



/* ---------------------------------------
	Задание 3.3
------------------------------------------ */

select 	
	s.driver_id,
	d.driver_id
from
	shipping.shipment s
		join shipping.driver d on s.driver_id = d.driver_id


/* ---------------------------------------
	Задание 3.3.2
------------------------------------------ */

SELECT 
	--*
	DISTINCT s.city_id, c.city_id
	--s.city_id, c.city_id
FROM shipping.shipment s 
JOIN shipping.customer c 
	ON s.cust_id = c.cust_id 




/* ---------------------------------------
	Задание 3.3.3
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
	Задание 3.3.3
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
	Задание 3.3
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
	Задание 3.2.3.4
------------------------------------------ */
--	Выведите среднее население, среднюю площадь и плотность населения городов, чья площадь больше города Paramount. 
--	Плотность населения в этом задании рассчитывается как сумма населения, деленная на сумму площади.
SELECT * FROM shipping.city
WHERE city_name = 'Paramount'



SELECT 
	  avg(c2.population) AS avg_population
	, avg(c2.area) AS avg_area
	, sum(c2.population)/sum(c2.area) AS avg_density
	--	c2.*
FROM shipping.city c1 
JOIN shipping.city c2
	ON c1.area < c2.area AND c1.city_id != c2.city_id 
WHERE c1.city_id = 109


/* ---------------------------------------
	Задание 3.2.3
------------------------------------------ */

select 
	s.ship_date,
	t.model_year,
	c.city_name,
	count(*) shipments
from 
	shipping.shipment s
		join shipping.truck t on s.truck_id = t.truck_id
		join shipping.city c on s.city_id = c.city_id
group by 	
	s.ship_date,
	t.model_year,
	c.city_name


/* ---------------------------------------
	Задание 3.2.3.5
------------------------------------------ */

select 
	  d.first_name
	, d.last_name
	, c.city_name 
	, max(s.ship_date) AS max_ship_date
from 
	shipping.driver d
		join shipping.city c on c.city_id = d.city_id
		JOIN shipping.shipment s ON d.driver_id = s.driver_id 
group by 	
	  d.first_name
	, d.last_name
	, c.city_name 
ORDER BY d.last_name 
	


/* ---------------------------------------
	Задание 3.2.3.6
------------------------------------------
Посчитайте количество доставок и среднюю массу груза в разрезе клиентов и города доставки. 
Выведите таблицу со следующими полями: 
	имя клиента, 
	город доставки, 
	количество доставок и 
	средняя масса груза. 

Отсортируйте по имени клиента в алфавитном порядке, затем по массе среднего груза по убыванию.

Подсказка: 
количество доставок и средняя масса груза содержатся в таблице shipment, 
имя клиента содержится в таблице customer, а название городов — в таблице city.

------------------------------------------ */

SELECT 
	  cu.cust_name 
	, ci.city_name 
	, count(s.ship_id) AS count_shipping
	, avg(s.weight) AS avg_weight
FROM shipping.shipment as s 
	JOIN shipping.customer as cu ON cu.cust_id = s.cust_id 
	JOIN shipping.city AS ci ON ci.city_id = s.city_id 
GROUP BY cu.cust_name
	, ci.city_name 
ORDER BY cu.cust_name, avg_weight DESC 


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


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
	Задание 3.2.2.1
		
Напишите запрос в Metabase, который считает среднее население города в таблице shipping.city. 
Сохраните или скопируйте его результат.
После этого в поле ответа напишите запрос, который выводит количество городов с населением выше среднего 
(подставив результат предыдущего запроса в условие) и оставьте любой комментарий, объясняющий, откуда было взято это число.

------------------------------------------ */

/* 
 Получена из этого запроса:
 select avg(population) from shipping.city
 165718.755407653910
*/
SELECT count(c.city_id) -- count(DISTINCT city_name) этот вариант платформа не принимает
FROM city c
WHERE population > 165718.76 -- 165718.755407653910


-- |------
-- | Второе решение - более точное. Так как отбрасывает повторяющиеся города
-- |	
SELECT 
	count(DISTINCT city_name)
FROM city
WHERE population > (select avg(population) from city LIMIT 1)




/* ---------------------------------------
	Задание 3.2.2.2
------------------------------------------ */
SELECT 
	city_name , area 
FROM shipping.city c 
ORDER BY 2 DESC 




/*
Средняя площадь города получена из этого запроса:
select avg(area) from shipping.city
Результат: 56.7266222961730449
*/
SELECT 
	count(DISTINCT city_name)
FROM shipping.city
WHERE area > 56.7266222961730449


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
	Задание 3.2.4.1
------------------------------------------
Напишите запрос, который выводит 
	все названия штатов 
	и количество клиентов в них, 
используя LEFT JOIN. 

Упорядочите список штатов по количеству клиентов по убыванию, 
а затем по штату в алфавитном порядке.

------------------------------------------ */

-- |------
-- | этот джоин в другом направлении
-- |

--SELECT
--	ci.state AS customer_state
--	, count(cu.cust_id) AS customer_count 
--FROM shipping.customer cu
--LEFT JOIN shipping.city ci ON ci.city_id = cu.city_id 
--GROUP BY ci.state
--ORDER BY customer_count DESC, customer_state

SELECT
	ci.state AS customer_state
	, count(cu.cust_id) AS customer_count 
FROM shipping.city as ci
LEFT JOIN shipping.customer AS cu ON ci.city_id = cu.city_id 
GROUP BY ci.state
ORDER BY customer_count DESC, customer_state



/* ---------------------------------------
	3.2.5
------------------------------------------ */

-- можно найти клиентов, которые никогда не совершали заказ
--
select 
	c.cust_id
from 
	shipping.customer c 
	left join shipping.shipment s on c.cust_id = s.cust_id
where s.ship_id is null


-- |------
-- | Возьмем два города: в один город доставки есть, а в другой — нет
-- |
select 
    c.city_id, 
    c.city_name,
    s.ship_id
    , s.weight 
from shipping.city c
    left join shipping.shipment s on s.city_id = c.city_id
where c.city_id in (697,698)


-- |------
-- | Теперь попробуем отфильтровать доставки с весом более 1000 кг:
-- |
select 
    c.city_id, 
    c.city_name,
    s.ship_id
from shipping.city c
    left join shipping.shipment s on s.city_id = c.city_id
where c.city_id in (697,698) and s.weight > 1000

-- |------
-- | 
-- |



-- |------
-- | 
-- |

/* ---------------------------------------
	Задание 3.2.5.1
	Выполните следующие запросы в Metabase и проверьте, какие из них возвращают значение, отличное от null.
	
------------------------------------------ */
SELECT TRUE AND NULL 

SELECT TRUE or NULL -- V

SELECT NULL IS NULL -- V

SELECT NULL = NULL 


/* ---------------------------------------
	Задание 3.2.5.2
------------------------------------------
Напишите запрос, который выводит 
	названия городов, куда осуществлялись доставки, 
	но их вес меньше 10000. 
	
Используйте несколько операторов JOIN на таблицу с доставками. 
Отсортируйте по названию города.

------------------------------------------ */

select 
	ci.city_name
from shipment s
    join shipment as s2 on s.weight=s2.weight
    left join city as ci on s2.city_id=ci.city_id
where s.weight < 10000
group by ci.city_name
ORDER BY ci.city_name



/* ---------------------------------------
	Задание 3.2.5.3
------------------------------------------
Напишите запрос, который выдает сводную статистику по городам: 
	количество 
		клиентов, 
		заказов 
		и водителей. 
Оставьте города, в которых хотя бы один из этих показателей ненулевой, 
и отсортируйте по первому столбцу. 

Используйте LEFT JOIN для таблицы с городами.

------------------------------------------ */

select 
	ci.city_name,
	count(DISTINCT cu.cust_id),
	count(DISTINCT s.ship_id),
	count(DISTINCT d.driver_id)
from city AS ci
LEFT JOIN customer cu ON cu.city_id = ci.city_id
LEFT JOIN driver d ON d.city_id = ci.city_id 
LEFT JOIN shipment s ON s.city_id = ci.city_id 
GROUP BY ci.city_name
HAVING (count(cu.cust_id) + count(s.ship_id) + count(d.driver_id) ) > 0
ORDER BY 1





/* ---------------------------------------
	Задание 3.2.6.1 
------------------------------------------
Напишите запрос, который выведет имена всех водителей и их телефоны. 
В случае, если телефон не заполнен, укажите номер из одних девяток в том же формате. 
Отсортируйте по имени водителя в алфавитном порядке.

------------------------------------------ */

select 
	d.first_name ,
	coalesce(d.phone, '(999) 999-9999') phone
from driver d 
order by 1




/* ---------------------------------------
	Задание 3.2.6.2 
------------------------------------------
Напишите запрос, который выдает сводную статистику по городам 
(для идентификации используйте city_id): 
количество клиентов, заказов и водителей. Не используйте таблицу shipping.city. 

Оставьте города, в которых хотя бы один из этих показателей ненулевой, 
отсортируйте по столбцу с id города.

------------------------------------------ */

select 
	coalesce(s.city_id, d.city_id, c.city_id) city_id,
	count(DISTINCT c.cust_id),
	count(DISTINCT s.ship_id),
	count(DISTINCT d.driver_id)
from customer c
full outer JOIN shipment s ON c.city_id = s.city_id
full outer join driver d ON d.city_id = s.city_id 
GROUP BY 1
HAVING (count(c.cust_id) + count(s.ship_id) + count(d.driver_id)) > 0
ORDER BY 1



/* ---------------------------------------
	Задание 3.2.7.1 
------------------------------------------

Напишите запрос, который выводит все возможные уникальные пары даты доставки и имени водителя, 
упорядоченные по дате и имени по возрастанию.

------------------------------------------ */

select 
	DISTINCT s.ship_date,
	d.first_name 
from driver d 
cross join shipment s
order by 1, 2


/* ---------------------------------------
	Задание 3.2.7.2 
------------------------------------------

Переписать запрос без использования cross join

------------------------------------------ */


-- |------
-- |	Было 
-- |


select 
	s.ship_date,
	max(c.area) area,
	min(t.model_year) model_year
from 
	shipping.shipment s,
	shipping.city c,
	shipping.truck t
where 
	s.city_id = c.city_id
	and s.truck_id = t.truck_id
group by 1
order by 1


-- |------
-- | Стало 
-- |

select 
	s.ship_date,
	max(c.area) area,
	min(t.model_year) model_year
from 
	shipping.shipment s
	LEFT JOIN shipping.city c ON s.city_id = c.city_id 
	LEFT JOIN shipping.truck t ON s.truck_id = t.truck_id 
group by 1
order by 1






-- |----------------------------------------------------------
-- | 
-- | 	SQL-4. Сложные объединения
-- |




/* ---------------------------------------
	4.1. UNION 

------------------------------------------ */
SELECT 
 t.table_name object_name,
 'таблица' object_type
FROM 
 information_schema."tables" t
union all
SELECT 
 c.column_name object_name,
 'столбец' object_type
FROM 
 information_schema.columns c
union  all
select 
 s.schema_name,
 'схема' 
from 
 information_schema.schemata s
order by 1




/* ---------------------------------------
	Задание 4.1.1
------------------------------------------
Напишите запрос, который создает уникальный алфавитный справочник 
всех городов, штатов, имен водителей и производителей грузовиков. 
Результатом запроса должны быть два столбца 
(название объекта и тип объекта — city, state, driver, truck). 

Отсортируйте список по названию объекта, а затем по типу.

------------------------------------------ */

SELECT 
	c.city_name AS object_name,
	'city' AS object_type
FROM city AS c 
UNION
SELECT 
	c2.state AS object_name,
	'state' AS object_type
FROM city AS c2 
UNION
SELECT 
	d.first_name AS object_name,
	'driver' AS object_type
FROM driver d
UNION
SELECT 
	t.make AS object_name,
	'truck' AS object_type
FROM truck t
ORDER BY 1, 2

/* ---------------------------------------
	4.2. UNION и ограничения типов данных 
------------------------------------------ */

select 
 c.city_id::text
from 
 shipping.city c
union all
select 
 cc.city_name
from 
 shipping.city cc

 
/* ---------------------------------------
	Задание 4.2.1
------------------------------------------ */

 SELECT 
 	 d.zip_code::TEXT 
 	,d.first_name 
 	,'zip' AS type
 FROM driver d 
-- WHERE d.zip_code NOTNULL 
 UNION
  SELECT 
 	 d.phone 
 	,d.first_name
 	, 'phone' AS type
 FROM driver d 
-- WHERE d.phone NOTNULL 
 ORDER BY 1, 2

/* ---------------------------------------
	Задание 4.2.2
------------------------------------------ */


SELECT '541' > '-500' AS result
-- true


/* ---------------------------------------
	4.3. UNION ALL и промежуточные итоги 

------------------------------------------ */
select  
 c.city_name,
 c.population
from 
 shipping.city c
union all
select 
 'total' total_name,
 sum(c.population) total_population
from 
 shipping.city c
order by 2 desc



/* ---------------------------------------
	Задание 4.3.1

------------------------------------------ */

SELECT 
s.ship_date::text AS date_period,
count(s.ship_id) as cnt_shipping
FROM shipment s
GROUP BY s.ship_date
UNION 
SELECT 
	'total_shippings',
	count(s.ship_id) 
FROM shipment s 
ORDER BY 1 desc



-- |------
-- | 4.4. Другие способы применения UNION
-- |
-- |	UNION как аналог LEFT JOIN

select 
 d.first_name,
 d.last_name,
 'телефон заполнен' phone_info
from 
 shipping.driver d
where phone is not null
union all 
select 
 d.first_name,
 d.last_name,
 'телефон не заполнен' phone_info
from 
 shipping.driver d
where phone is  null





/* ---------------------------------------
	Задание 4.4.1
------------------------------------------ */

SELECT 
	c.city_name AS city_name,
	count(s.ship_id) AS shippings_fake
FROM city c 
JOIN shipment s ON s.city_id = c.city_id 
GROUP BY c.city_name 
HAVING count(s.ship_id) > 10
UNION
SELECT 
	c.city_name AS city_name,
	count(s.ship_id) + 5 AS shippings_fake
FROM city c 
JOIN shipment s ON s.city_id = c.city_id 
GROUP BY c.city_name 
HAVING count(s.ship_id) <= 10
ORDER BY 2 DESC, 1



-- |------
-- | 	Ручная генерация
-- |	UNION можно использовать для создания справочников прямо в коде запроса


select 'a'::text letter, '1' ordinal_position
union 
select 'b','2' ordinal_position
union 
select 'c','3' ordinal_position


/* ---------------------------------------
	Задание 
------------------------------------------


------------------------------------------ */

select 
	c.* 
from 
	information_schema."tables" t
		join information_schema.columns c 
			on t.table_name = c.table_name 
			and t.table_schema = c.table_schema 
--WHERE shipping.shipment


SELECT 
	c.column_name AS column_name
FROM information_schema.COLUMNS c
WHERE
	c.table_name = 'shipment' 
	AND c.table_schema = 'shipping'
EXCEPT 
SELECT 
	c.column_name
FROM information_schema.COLUMNS c
WHERE
	c.table_name != 'shipment' 
	AND c.table_schema = 'shipping'
ORDER BY 1	



/* ---------------------------------------
	Задание 4.5.2
------------------------------------------
Выведите список id городов, в которых есть и клиенты, и доставки, и водители.

------------------------------------------ */

SELECT 
	c.city_id 
FROM city c 
INTERSECT
SELECT
	c2.city_id 
FROM customer c2 
INTERSECT
SELECT
	s.city_id 
FROM shipment s 
INTERSECT
SELECT 
	d.city_id 
FROM driver d 



-- |----------------------------
-- | Дополнительный анализ данных
-- |
SELECT 
	city_name	
	,count(city_name) 
FROM city
GROUP BY city_name 
HAVING count(city_name) > 1
ORDER BY 2 DESC, 1


SELECT  
	c.city_name
	, state 
FROM city c
WHERE c.city_name in ('Springfield', 'Lakewood', 'Bloomington')
ORDER BY 1, 2



-- |------------------------------------------------------------------------
-- | 5.1. EXISTS
-- |
-- |	




/* ---------------------------------------
	Задание 5.1.1
------------------------------------------ */

SELECT 
	DISTINCT c.state 
FROM shipment s 
LEFT JOIN city c ON c.city_id = s.city_id 
ORDER BY 1



SELECT
	DISTINCT state
FROM
	shipping.city c
WHERE
	EXISTS (
	SELECT
		*
	FROM
		shipping.shipment s
	WHERE
		s.city_id = c.city_id )
ORDER BY
	1


/* ---------------------------------------
	Задание 5.1.2 
------------------------------------------
выводит все схемы и названия таблиц в базе, в которых нет первичных ключей. 
Отсортируйте оба столбца в алфавитном порядке (по возрастанию).
------------------------------------------ */

SELECT
	t.table_schema,
	t.table_name
FROM
	information_schema.tables t
WHERE
	NOT EXISTS(
	SELECT
		*
	FROM
		information_schema.table_constraints c
	WHERE
		c.table_schema = t.table_schema
		AND c.table_name = t.table_name
		AND c.constraint_type IN ('PRIMARY KEY')
		)
	ORDER BY 1, 2
	


-- |------
-- | 
-- |


SELECT 
	city_name,
	exists 
		(
			select 
				*
			from 
				shipping.shipment s 
			where 
				s.city_id = c.city_id
			) has_shipments
from 
	shipping.city c
order by 1



/* ---------------------------------------
	Задание 5.1.3 
------------------------------------------
Напишите запрос, который выводит названия всех городов и булевы поля, 
показывающие наличие клиентов, наличие водителей и наличие доставок в этом городе. 

Добавьте сортировку по названию городов.
------------------------------------------ */
SELECT 
	c.city_name
	, exists(
		SELECT * FROM customer c2 
		WHERE c2.city_id  = c.city_id 
	) has_customer
	, exists(
		SELECT * FROM driver d2 
		WHERE d2.city_id  = c.city_id 
	) has_driver
	, exists(
		SELECT * FROM shipment s2 
		WHERE s2.city_id  = c.city_id 
	) has_customer
FROM city c 
order by 1




-- |-----------------------------------------------------------
-- | 5.2. IN
-- |
SELECT
	DISTINCT state
FROM
	shipping.city c
WHERE
	c.city_id IN (
	SELECT
		d.city_id
	FROM
		shipping.driver d
	WHERE
		d.phone IS NOT NULL )
ORDER BY
	1


	
select 
	*
from 
	information_schema."tables" t
where t.table_name in (
						select 
							c.table_name
						from 
							information_schema.columns c
						where 
							c.data_type = 'numeric'
							and c.table_schema = 'shipping'
						union  
						select 
							cc.table_name
						from 
							information_schema.table_constraints cc
						where 
							cc.constraint_type = 'FOREIGN KEY'
							and cc.constraint_schema = 'shipping'
						)	




/* ---------------------------------------
	Задание 5.2.1
------------------------------------------
	Напишите запрос, который выводит все поля из таблицы доставок по водителям, 
	совершившим более 90 доставок.
	
	Отсортируйте запрос по первому и второму столбцу.
------------------------------------------ */

SELECT 
	s.*
FROM shipment s
WHERE 
	driver_id IN (
		SELECT driver_id
			--, count(ship_id) 
		FROM shipment 
		GROUP BY driver_id 
		HAVING count(ship_id) > 90 
		)
ORDER BY 1, 2




-- |------------------------------------------------------------------------------------------------
-- | 	5.3. SELECT FROM SELECT
-- | 
-- | 
-- | ------------
-- | запрос выводит среднее по средним массам груза доставки на каждого водителя
-- | 

SELECT
	avg(a.avg_weight) avg_avg_weight
FROM
	(
	SELECT
		s.driver_id, avg(s.weight) avg_weight
	FROM
		shipping.shipment s
	GROUP BY 1 
	) a

	
-- | ------------
-- | запрос выводит идентификатор доставки, ее дату, массу груза, 
-- | среднюю массу доставленных в этот день грузов и признак того, 
-- | что масса груза больше средней в этот день на сто кг.
-- | 

	
select 
	s.ship_id,
	s.ship_date,
	s.weight,
	a.avg_weight avg_weight_this_day,
	s.weight > a.avg_weight + 100 is_heavyweighted
from 
	(
	select 
		s.ship_date,
		avg(s.weight)avg_weight
	from 
		shipping.shipment s
	group by 1
	) a 
	join  shipping.shipment s 
		on a.ship_date = s.ship_date


/* ---------------------------------------
	Задание 5.3.1 
------------------------------------------
	Напишите запрос, который найдет водителя, совершившего наибольшее количество доставок одному клиенту. 
	В выводе должна быть одна строка, которая содержит
	 	имя водителя (first_name), 
	 	имя клиента 
	 	и количество доставок водителя этому клиенту.
	
------------------------------------------ */
SELECT 
--	d.driver_id,
	d2.first_name
	, c.cust_name 
	, d.count_customer_shipment
FROM 
	(SELECT 
		driver_id 
		, cust_id 
		, count(ship_id) AS count_customer_shipment
	FROM shipment
	GROUP BY driver_id , cust_id 
	ORDER BY count(ship_id) DESC 
	LIMIT 1
			) AS d
JOIN driver d2 ON d2.driver_id = d.driver_id
JOIN customer c ON c.cust_id = d.cust_id



-- проверочный вывод данных
SELECT * FROM shipment s 
WHERE driver_id  = 27 and cust_id = 1775



/* ---------------------------------------
	Задание 5.3.2 
------------------------------------------
	
ы	
------------------------------------------ */




/* ---------------------------------------
	Задание 5.3.3 
------------------------------------------
	
	
------------------------------------------ */



/* ---------------------------------------
	Задание 5.3.4 
------------------------------------------
	
	
------------------------------------------ */




/* ---------------------------------------
	Задание 
------------------------------------------
	
	
------------------------------------------ */



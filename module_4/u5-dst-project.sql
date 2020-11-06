-- |----------------------------------------
-- |
-- | DBeaver: перед выполнением скриптов неободимо выбрать схему dst_project
-- | ПКМ \ Задать по умолчанию
-- | 
-- | 

SHOW search_path

SELECT current_schema()

SELECT current_schemas(true)


/* ---------------------------------------
	Задание 4.1
------------------------------------------

	База данных содержит список аэропортов практически всех крупных городов России. 
	В большинстве городов есть только один аэропорт. 
	Исключение составляет:
	
------------------------------------------ */

select 
	city,
	count(airport_name) as airport_count
from airports
group by city 
having count(airport_name) > 1
order by 2 desc 


/* ---------------------------------------
	Задание 4.2
------------------------------------------ */


-- |----------------------------------------
-- | Вопрос 1. Таблица рейсов содержит всю информацию о прошлых, текущих и запланированных рейсах. 
-- | Сколько всего статусов для рейсов определено в таблице?
-- |

select 
	count(distinct status)
from flights f 



-- |----------------------------------------
-- | Вопрос 2. Какое количество самолетов находятся в воздухе на момент среза в базе 
-- | (статус рейса «самолёт уже вылетел и находится в воздухе»).
-- |


select 
	count(*)
from flights f 
where status = 'Departed'



-- |----------------------------------------
-- | Вопрос 3. Места определяют схему салона каждой модели. 
-- | Сколько мест имеет самолет модели  (Boeing 777-300)?
-- |

select 
	count(s.*)
from aircrafts a
join seats s on s.aircraft_code = a.aircraft_code 
where 
	a.aircraft_code = '773'





-- |----------------------------------------
-- | Вопрос 4. Сколько состоявшихся (фактических) рейсов 
-- | было совершено между 1 апреля 2017 года и 1 сентября 2017 года?
-- |
-- | P.S. 
-- | состоявшийся рейс означает, что он не отменён, и самолёт прибыл в пункт назначения
-- | 


select 
	count(f.flight_id)
from flights f 
where status = 'Arrived'
	and (actual_departure between '2017-04-01' and '2017-09-01'
		or actual_arrival between '2017-04-01' and '2017-09-01')


		


/* ---------------------------------------
	Задание 4.3 
------------------------------------------ */
	
-- |----------------------------------------
-- | Вопрос 1. Сколько всего рейсов было отменено по данным базы?
-- |
-- |
	
select 
	count(*)
	--f.*
from flights f 
where status = 'Cancelled'
	
	
-- |----------------------------------------
-- | Вопрос 2. Сколько самолетов моделей типа: 
-- | 	Boeing, 
-- | 	Sukhoi Superjet, 
-- | 	Airbus 
-- | находится в базе авиаперевозок?

select
	split_part(a.model, ' ', 1) as model,
	count(*) 
from aircrafts a 
where a.model like 'Boeing%'
		or a.model like 'Sukhoi Superjet%'
		or a.model like 'Airbus%'
group by 1
order by 1




/* -----------------------------------------------------------------------------------
	Размышление на тему - сколько же на самом деле самолетов выполняют полетное расписание 

-------------------------------------------------------------------------------------- */

-- |----------------------------------------
-- | В задании смущает, что указанное полетное расписание не смогли выполнить бы самолеты в таком количестве.
-- | По логике полетное расписание должно перекрываться парком самолетов.
-- | Для простоты посчитаем что 1 самолет выполняет 1 рейс "туда" и "обратно"
-- | Не будем учитывать более слжоные перестановки, а также что некоторые самолеты могут исполнять более 2-х рейсов


-- |----------------------------------------
-- | Boeing
-- |

select 
	count(distinct f.flight_no)/2 as model_count_Boeing
	--, f.aircraft_code 
from dst_project.flights f 
join dst_project.aircrafts a on a.aircraft_code  = f.aircraft_code 
where a.model like 'Boeing%'
-- 36


-- |----------------------------------------
-- | Sukhoi Superjet
-- |

select 
	count(distinct f.flight_no)/2 as model_count_Sukhoi_Superjet
	--, f.aircraft_code 
from dst_project.flights f 
join dst_project.aircrafts a on a.aircraft_code  = f.aircraft_code 
where a.model like 'Sukhoi Superjet%'
-- 79


-- |----------------------------------------
-- | Airbus
-- |

select 
	count(distinct f.flight_no)/2 as model_count_Airbus
	--, f.aircraft_code 
from dst_project.flights f 
join dst_project.aircrafts a on a.aircraft_code  = f.aircraft_code 
where a.model like 'Airbus%'
-- 39

-- | 
-- | Вывод - полученные цифры более правдоподобней. Фактическое же количество все же будет меньше указанных.
-- | 



-- |----------------------------------------
-- | Вопрос 3. В какой части (частях) света находится больше аэропортов?
-- |
-- |

select 
	split_part(a.timezone, '/', 1) as world_region,
	count(*) 
from dst_project.airports a
group by 1
union 
select
	'Europe+Asia',
	count(*) 
from dst_project.airports a
where a.timezone like 'Europe%'
	or a.timezone like 'Asia%'
order by 2 desc



-- |----------------------------------------
-- | Вопрос 4. У какого рейса была самая большая задержка прибытия за все время сбора данных? Введите id рейса (flight_id)
-- |
-- | 157571

select
	(f.actual_arrival - f.scheduled_arrival) as delay_arrival
	, f.flight_id
from dst_project.flights f
where f.status = 'Arrived'
order by 1 desc 
limit 1



/* ---------------------------------------
	Задание 4.4 
------------------------------------------ */

-- |----------------------------------------
-- | Вопрос 1. Когда был запланирован самый первый вылет, сохраненный в базе данных?
-- |

select 
	to_char(date_trunc('day', min(f.scheduled_departure)), 'DD.MM.YYYY') as min_scheduled_departure
from flights f
where 
	f.status != 'Cancelled'



-- |----------------------------------------
-- | Вопрос 2. Сколько минут составляет запланированное время полета в самом длительном рейсе?
-- |


-- | 
-- | решение №1, без конвертации в минуты
-- | 

	select
	distinct f.flight_no
	, f.scheduled_arrival - f.scheduled_departure as flight_duration
	, f.departure_airport, f.arrival_airport 
from flights f 
order by 2 desc, 1
limit 3



-- | 
-- |  решение №2, с конвертацией в минуты (с использованием CTE)
-- | 
with mfd(duration) as (
	select
		 max(f.scheduled_arrival - f.scheduled_departure)
	from flights f 
		group by f.flight_no
		order by 1 desc
		limit 1
	) 
select
	date_part('hour', duration) * 60 + date_part('minute', duration) as duration_mm
from mfd 
-- | 530




-- |----------------------------------------
-- | Вопрос 3. Между какими аэропортами пролегает самый длительный по времени запланированный рейс?
-- | DME - UUS
-- | DME - AAQ
-- | DME - PSC
-- | SVO - UUS

select
	distinct f.flight_no
	, f.scheduled_arrival - f.scheduled_departure as flight_duration
	, f.departure_airport
	, f.arrival_airport 
from flights f 
where 
	(f.departure_airport = 'DME' and f.arrival_airport = 'UUS')
	or (f.departure_airport = 'DME' and f.arrival_airport = 'AAQ')
	or (f.departure_airport = 'DME' and f.arrival_airport = 'PSC')
	or (f.departure_airport = 'SVO' and f.arrival_airport = 'UUS')
order by 2 desc, 1
limit 1
	
-- | DME - UUS



-- |----------------------------------------
-- | Вопрос 4. Сколько составляет средняя дальность полета среди всех самолетов в минутах? 
-- | Секунды округляются в меньшую сторону (отбрасываются до минут).
-- |


-- | первый вариант решения
select
	date_trunc('minute', avg(f.scheduled_arrival - f.scheduled_departure))
from flights f 
-- | 02:08:00


-- | второй вариант решения
select
	date_part('hour', avg(f.scheduled_arrival - f.scheduled_departure))*60
	+ date_part('minute', avg(f.scheduled_arrival - f.scheduled_departure)) as avg_duration_mm
from flights f 
-- | 128



/* ---------------------------------------
	Задание 4.5 
------------------------------------------ */

-- |----------------------------------------
-- | Вопрос 1. Мест какого класса у SU9 больше всего?
-- |

select
	s.fare_conditions,
	count(*)
from aircrafts a 
join seats s on s.aircraft_code = a.aircraft_code 
where a.aircraft_code = 'SU9'
group by 1
order by 2 desc
-- | Economy



-- |----------------------------------------
-- | Вопрос 2. Какую самую минимальную стоимость составило бронирование за всю историю?
-- |

select 
	min(b.total_amount)
from bookings b 


-- |----------------------------------------
-- | Вопрос 3. Какой номер места был у пассажира с id = '4313 788533'?
-- |

select
	t.passenger_id,
	bp.seat_no 
from tickets t 
join boarding_passes bp on bp.ticket_no = t.ticket_no 
where t.passenger_id = '4313 788533'







/* -----------------------------------------------------------------------------------
	
	5. Предварительный анализ 

-------------------------------------------------------------------------------------- */

select 
	airport_code,
	airport_name, 
	timezone 
from airports
where city = 'Anapa'


-- |----------------------------------------
-- | Вопрос 1. Анапа — курортный город на юге России. Сколько рейсов прибыло в Анапу за 2017 год?
-- |

select
	2017 as year,
	count(*) as flight_count
from flights f 
where 
	f.arrival_airport = 'AAQ'
	and f.status = 'Arrived'
	and date_part('year', f.actual_arrival) = 2017


	
-- |----------------------------------------
-- | Вопрос 2. Сколько рейсов из Анапы вылетело зимой 2017 года?
-- |


-- | первый вариант решения
select
	count(*) as flight_count
from flights f 
where 
	f.departure_airport = 'AAQ'
	and f.status != 'Cancelled'
	and (f.actual_arrival between '2017-01-01 00:00:00' and '2017-02-28 23:59:59'
	or f.actual_arrival between '2017-12-01 00:00:00' and '2017-12-31 23:59:59')


-- | второе решение
select
	count(*) as flight_count
from flights f 
where 
	f.departure_airport = 'AAQ'
	and f.status != 'Cancelled'
	and date_part('year', f.actual_arrival) = 2017
	and date_part('month', f.actual_arrival) in (01, 02, 12)	









-- |----------------------------------------
-- | Вопрос 3. Посчитайте количество отмененных рейсов из Анапы за все время
-- |

select
	count(*) as flight_count
from flights f 
where 
	f.departure_airport = 'AAQ'
	and f.status = 'Cancelled'



-- |----------------------------------------
-- | Вопрос 4. Сколько рейсов из Анапы не летают в Москву?
-- |

select 
	--count(distinct f.flight_no) 
	count(f.flight_id) 
from flights f
join airports a on a.airport_code = f.arrival_airport 
where 
	a.city != 'Moscow'
	and f.departure_airport = 'AAQ'




-- |----------------------------------------
-- | Вопрос 5. Какая модель самолета летящего на рейсах из Анапы имеет больше всего мест?
-- |

select 
	a2.model,
	count(s.seat_no) as seat_count
from seats s
join aircrafts a2 on a2.aircraft_code = s.aircraft_code 
where s.aircraft_code in (
		select 
			f.aircraft_code
		from flights f
		where 
			f.departure_airport = 'AAQ'
		group by f.aircraft_code
		)
group by 1
order by 2 desc 




/* -----------------------------------------------------------------------------------
	6. Переходим к реальной аналитике 
--------------------------------------------------------------------------------------
	
	 Выгрузка данных для анализа
-------------------------------------------------------------------------------------- */


with ticket_sold (flight_id, fare_conditions, ticket_count, amount_sold) as (
	select
		tf.flight_id,
		tf.fare_conditions ,
		count(tf.ticket_no) as ticket_count,
		sum(tf.amount) as amount_sold
	from ticket_flights tf 
	join flights fl on tf.flight_id = fl.flight_id
	where 
		fl.departure_airport = 'AAQ'
		and (date_trunc('month', fl.scheduled_departure) in ('2017-01-01', '2017-02-01', '2017-12-01'))
		and fl.status not in ('Cancelled')
	group by tf.flight_id, tf.fare_conditions 
), 
flight_ticket_sold (flight_id, class2, ticket_count2, amount_sold2, avg_price_class2, class1, ticket_count1, amount_sold1, avg_price_class1) as (
	select 
		t1.flight_id
		, t1.fare_conditions as class2
		, t1.ticket_count
		, t1.amount_sold::int
		, (t1.amount_sold / t1.ticket_count)::int as avg_price_class2
		, t2.fare_conditions as class1
		, t2.ticket_count
		, t2.amount_sold::int
		,  (t2.amount_sold / t2.ticket_count)::int as avg_price_class1
	from ticket_sold t1
	join ticket_sold t2 on t2.flight_id = t1.flight_id 
		and t1.fare_conditions != t2.fare_conditions
		and t1.fare_conditions = 'Economy'
) --select * from flight_ticket_sold
select
	f.flight_id, 	
	date_part('year', f.scheduled_departure)::int as sched_year,
	date_part('month', f.scheduled_departure)::int as sched_month,
	date_part('day', f.scheduled_departure)::int as sched_day,
	f.departure_airport,
	f.flight_no,
	f.arrival_airport,
	f.scheduled_departure,
	f.scheduled_arrival,
	f.actual_departure - f.scheduled_departure as delay_departure,
	f.status,
	f.actual_arrival - f.actual_departure as flight_duration,
	a2.city,
	a2.timezone,
	f.actual_departure,
	f.actual_arrival,
	f.actual_arrival - f.scheduled_arrival as delay_arrival,
	f.aircraft_code,
	split_part(a.model, ' ', 1) as manufacturer,
	split_part(a.model, ' ', 2) as board_model, 
	a."range" as flights_range_km,
	--a.model as full_model,
	fts.class2, 
	fts.ticket_count2, 
	fts.amount_sold2, 
	fts.avg_price_class2, 
	fts.class1, 
	fts.ticket_count1, 
	fts.amount_sold1, 
	fts.avg_price_class1,
	(fts.amount_sold2 + fts.amount_sold1)::int as total_amount
from
	flights as f
join aircrafts a on a.aircraft_code = f.aircraft_code
join airports a2 on a2.airport_code = f.arrival_airport 
left join flight_ticket_sold fts on f.flight_id = fts.flight_id
where
	f.departure_airport = 'AAQ'
	and (date_trunc('month', f.scheduled_departure) in ('2017-01-01', '2017-02-01', '2017-12-01'))
	and f.status not in ('Cancelled')
order by f.scheduled_departure 






-- |----------------------------------------
-- |	End of script 
-- |
/*




*/

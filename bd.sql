USE task5;
SELECT * FROM cars;
-- 1.	Создайте представление, в которое попадут автомобили 
-- стоимостью до 25 000 долларов
CREATE VIEW cars25 AS
	SELECT * FROM cars
    WHERE Cost<25000;
-- 2.	Изменить в существующем представлении порог для стоимости: пусть цена будет 
-- до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW cars25 AS
	SELECT * FROM cars
    WHERE Cost<30000;
-- 3.	Создайте представление, в котором будут только 
-- автомобили марки “Шкода” и “Ауди”
CREATE VIEW cars_audi_skoda AS
	SELECT * FROM cars
    WHERE Name IN ('Audi', 'Skoda');
-- 4.	Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 и всю следующую неделю.
SELECT ord_datetime, an_name, an_price
FROM orders
LEFT JOIN  analysis
ON Analysis.an_id = Orders.ord_an
WHERE Orders.ord_datetime >= '2020-02-05'
AND Orders.ord_datetime < '2020-02-13';

-- 5.	Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. Проще это сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить результат. В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее.
ALTER TABLE stations
ADD COLUMN time_to_next_station TIME;

SET SQL_SAFE_UPDATES = 0;
UPDATE stations s
JOIN (
    SELECT train_id, station, station_time, 
	LEAD(station_time) OVER (PARTITION BY train_id ORDER BY station_time) 
    AS next_station_time
    FROM stations) t 
    ON s.train_id = t.train_id AND s.station = t.station 
    AND s.station_time = t.station_time
	SET s.time_to_next_station = TIMEDIFF(t.next_station_time, s.station_time);

SELECT * FROM stations;

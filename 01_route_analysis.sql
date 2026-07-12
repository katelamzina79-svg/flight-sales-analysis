-- Топ-10 маршрутов по количеству рейсов
SELECT 
    dep.city->>'ru' AS departure_city,
    arr.city->>'ru' AS arrival_city,
    COUNT(*) AS flights_count
FROM bookings.flights f
JOIN bookings.airports_data dep ON f.departure_airport = dep.airport_code
JOIN bookings.airports_data arr ON f.arrival_airport = arr.airport_code
GROUP BY dep.city->>'ru', arr.city->>'ru'
ORDER BY flights_count DESC
LIMIT 10;


-- Топ-10 маршрутов по выручке
SELECT 
    dep.city->>'ru' AS departure_city,
    arr.city->>'ru' AS arrival_city,
    COUNT(DISTINCT f.flight_id) AS flights_count,
    SUM(tf.amount) AS total_revenue,
    ROUND(AVG(tf.amount)) AS avg_ticket_price
FROM bookings.flights f
JOIN bookings.airports_data dep ON f.departure_airport = dep.airport_code
JOIN bookings.airports_data arr ON f.arrival_airport = arr.airport_code
JOIN bookings.ticket_flights tf ON f.flight_id = tf.flight_id
GROUP BY dep.city->>'ru', arr.city->>'ru'
ORDER BY total_revenue DESC
LIMIT 10;
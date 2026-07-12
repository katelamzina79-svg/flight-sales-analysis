-- Доля отмен по модели самолёта
SELECT 
    a.model->>'ru' AS aircraft_model,
    COUNT(*) AS total_flights,
    COUNT(*) FILTER (WHERE f.status = 'Cancelled') AS cancelled_flights,
    ROUND(100.0 * COUNT(*) FILTER (WHERE f.status = 'Cancelled') / COUNT(*), 2) AS cancel_rate_pct
FROM bookings.flights f
JOIN bookings.aircrafts_data a ON f.aircraft_code = a.aircraft_code
GROUP BY a.model->>'ru'
ORDER BY cancel_rate_pct DESC;


-- Динамика вылетов и выручки по месяцам
SELECT 
    DATE_TRUNC('month', f.scheduled_departure)::date AS month,
    COUNT(DISTINCT f.flight_id) AS flights_count,
    SUM(tf.amount) AS total_revenue
FROM bookings.flights f
JOIN bookings.ticket_flights tf ON f.flight_id = tf.flight_id
GROUP BY DATE_TRUNC('month', f.scheduled_departure)
ORDER BY month;


-- Средняя загрузка (кол-во пассажиров на рейс) по моделям самолёта
SELECT 
    a.model->>'ru' AS aircraft_model,
    COUNT(DISTINCT f.flight_id) AS flights_count,
    COUNT(bp.ticket_no) AS total_boarded,
    ROUND(COUNT(bp.ticket_no)::numeric / COUNT(DISTINCT f.flight_id), 1) AS avg_passengers_per_flight
FROM bookings.flights f
JOIN bookings.aircrafts_data a ON f.aircraft_code = a.aircraft_code
LEFT JOIN bookings.boarding_passes bp ON f.flight_id = bp.flight_id
WHERE f.status = 'Arrived'
GROUP BY a.model->>'ru'
ORDER BY avg_passengers_per_flight DESC;
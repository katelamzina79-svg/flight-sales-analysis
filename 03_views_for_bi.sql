CREATE VIEW bookings.flight_sales_summary AS
SELECT 
    f.flight_id,
    f.flight_no,
    f.scheduled_departure::date AS flight_date,
    DATE_TRUNC('month', f.scheduled_departure)::date AS flight_month,
    TO_CHAR(f.scheduled_departure, 'Day') AS day_of_week,
    dep.city->>'ru' AS departure_city,
    arr.city->>'ru' AS arrival_city,
    a.model->>'ru' AS aircraft_model,
    f.status AS flight_status,
    tf.fare_conditions,
    tf.amount AS ticket_price
FROM bookings.flights f
JOIN bookings.airports_data dep ON f.departure_airport = dep.airport_code
JOIN bookings.airports_data arr ON f.arrival_airport = arr.airport_code
JOIN bookings.aircrafts_data a ON f.aircraft_code = a.aircraft_code
JOIN bookings.ticket_flights tf ON f.flight_id = tf.flight_id;
-- Distinct passenger_count values with row counts (2023 only; your clean view already filters)
SELECT
  CAST(TRY_CAST(passenger_count AS FLOAT) AS INT) AS passenger_count_int,
  COUNT(*) AS trips
FROM dbo.v_yellow_clean_all
GROUP BY CAST(TRY_CAST(passenger_count AS FLOAT) AS INT)
ORDER BY passenger_count_int;


USE nyc_taxi;
GO

CREATE OR ALTER VIEW dbo.v_passenger_buckets_base AS
SELECT
  CASE
    WHEN TRY_CAST(passenger_count AS FLOAT) >= 6 THEN '6+'
    WHEN TRY_CAST(passenger_count AS FLOAT) >= 0 THEN
         CAST(CAST(TRY_CAST(passenger_count AS FLOAT) AS INT) AS VARCHAR(10))
    ELSE 'Unknown'
  END AS passenger_bucket,

  TRY_CAST(trip_distance AS FLOAT)   AS trip_km,
  TRY_CAST(trip_minutes  AS INT)     AS trip_minutes,
  TRY_CAST(total_amount  AS FLOAT)   AS total_amt,
  TRY_CAST(tip_amount    AS FLOAT)   AS tip_amt,
  CASE WHEN q_distance_pos=1 AND q_duration_pos=1 AND q_amount_nonneg=1 THEN 1.0 ELSE 0.0 END AS is_valid
FROM dbo.v_yellow_clean_all;

 
 USE nyc_taxi;
GO

CREATE OR ALTER VIEW dbo.v_metrics_by_passenger_bucket AS
SELECT
  passenger_bucket,
  COUNT(*)                                        AS trips,
  AVG(trip_km)                                    AS avg_trip_km,
  AVG(CAST(trip_minutes AS FLOAT))                AS avg_trip_minutes,
  SUM(total_amt)                                  AS total_revenue,
  AVG(total_amt)                                  AS avg_revenue_per_trip,
  SUM(total_amt) / NULLIF(SUM(trip_km), 0)        AS revenue_per_km,
  AVG(tip_amt)                                    AS avg_tip_per_trip,
  AVG(CASE WHEN total_amt > 0 THEN tip_amt/total_amt END) AS avg_tip_rate,
  AVG(is_valid)                                   AS valid_pct
FROM dbo.v_passenger_buckets_base
GROUP BY passenger_bucket;


-- confirm it’s there
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME = 'v_metrics_by_passenger_bucket';

-- now preview, ORDER BY is fine in the SELECT
SELECT TOP 50 *
FROM dbo.v_metrics_by_passenger_bucket
ORDER BY
  CASE passenger_bucket
    WHEN 'Unknown' THEN 0
    WHEN '0' THEN 1
    WHEN '1' THEN 2
    WHEN '2' THEN 3
    WHEN '3' THEN 4
    WHEN '4' THEN 5
    WHEN '5' THEN 6
    ELSE 7
  END;



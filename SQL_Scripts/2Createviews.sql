-- Step 1: quick sanity check (ad-hoc query)
SELECT TOP 20 *
FROM OPENROWSET(
  BULK 'yellow_tripdata_2023-01.parquet',    -- adjust if inside folders
  DATA_SOURCE = 'nyc_datalake',
  FORMAT = 'PARQUET'
) AS r;
GO

-- Step 2: create a raw view (no schema override)
CREATE OR ALTER VIEW dbo.v_yellow_2023_01_raw
AS
SELECT *
FROM OPENROWSET(
  BULK 'yellow_tripdata_2023-01.parquet',    -- adjust path if needed
  DATA_SOURCE = 'nyc_datalake',
  FORMAT = 'PARQUET'
) AS r;
GO

-- Step 3: create a typed view (casting Parquet doubles to usable types)
CREATE OR ALTER VIEW dbo.v_yellow_2023_01_typed
AS
SELECT
  TRY_CAST(VendorID               AS INT)        AS VendorID,
  TRY_CAST(tpep_pickup_datetime   AS DATETIME2)  AS tpep_pickup_datetime,
  TRY_CAST(tpep_dropoff_datetime  AS DATETIME2)  AS tpep_dropoff_datetime,

  TRY_CAST(passenger_count        AS FLOAT)      AS passenger_count,
  TRY_CAST(trip_distance          AS FLOAT)      AS trip_distance,

  TRY_CAST(RatecodeID             AS INT)        AS RatecodeID,
  TRY_CAST(store_and_fwd_flag     AS VARCHAR(1)) AS store_and_fwd_flag,
  TRY_CAST(PULocationID           AS INT)        AS PULocationID,
  TRY_CAST(DOLocationID           AS INT)        AS DOLocationID,

  TRY_CAST(payment_type           AS FLOAT)      AS payment_type,
  TRY_CAST(fare_amount            AS FLOAT)      AS fare_amount,
  TRY_CAST(extra                  AS FLOAT)      AS extra,
  TRY_CAST(mta_tax                AS FLOAT)      AS mta_tax,
  TRY_CAST(tip_amount             AS FLOAT)      AS tip_amount,
  TRY_CAST(tolls_amount           AS FLOAT)      AS tolls_amount,
  TRY_CAST(improvement_surcharge  AS FLOAT)      AS improvement_surcharge,
  TRY_CAST(total_amount           AS FLOAT)      AS total_amount,
  TRY_CAST(congestion_surcharge   AS FLOAT)      AS congestion_surcharge,
  TRY_CAST(airport_fee            AS FLOAT)      AS airport_fee
FROM dbo.v_yellow_2023_01_raw;
GO

-- Test the typed view
SELECT TOP 20 * FROM dbo.v_yellow_2023_01_typed;

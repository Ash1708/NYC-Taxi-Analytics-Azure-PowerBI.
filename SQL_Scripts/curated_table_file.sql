CREATE EXTERNAL FILE FORMAT parquet_ff
WITH (FORMAT_TYPE = PARQUET);
 GO

 CREATE EXTERNAL TABLE dbo.yellow_curated_2023_01_sample_run2
WITH (
  LOCATION    = 'curated/yellow/sample_run2_2023_01/',  -- must be a brand-new/empty folder
  DATA_SOURCE = nyc_datalake,
  FILE_FORMAT = parquet_ff
)
AS
SELECT TOP 1000 *
FROM dbo.v_yellow_2023_01_clean;
 GO

--Read back what we just wrote (prove rows exist)
 SELECT COUNT(*) AS rows_written
FROM OPENROWSET(
  BULK 'curated/yellow/sample_run2_2023_01/',   -- match the folder you used above
  DATA_SOURCE = 'nyc_datalake',
  FORMAT = 'PARQUET'
) AS r;

SELECT TOP 20 *
FROM OPENROWSET(
  BULK 'curated/yellow/sample_run2_2023_01/',
  DATA_SOURCE = 'nyc_datalake',
  FORMAT = 'PARQUET'
) AS r;

GO

--Point a stable table to the parent curated folder (no IF)

-- If a previous table name collides, rename this to ..._all_v2
CREATE EXTERNAL TABLE dbo.yellow_curated_all
(
  VendorID                INT,
  tpep_pickup_datetime    DATETIME2,
  tpep_dropoff_datetime   DATETIME2,
  passenger_count         FLOAT,
  trip_distance           FLOAT,
  RatecodeID              INT,
  store_and_fwd_flag      VARCHAR(1),
  PULocationID            INT,
  DOLocationID            INT,
  payment_type            INT,
  fare_amount             FLOAT,
  extra                   FLOAT,
  mta_tax                 FLOAT,
  tip_amount              FLOAT,
  tolls_amount            FLOAT,
  improvement_surcharge   FLOAT,
  total_amount            FLOAT,
  congestion_surcharge    FLOAT,
  airport_fee             FLOAT,
  trip_minutes            INT,
  speed_kmh               FLOAT,
  q_distance_pos          INT,
  q_duration_pos          INT,
  q_amount_nonneg         INT
)
WITH (
  LOCATION    = 'curated/yellow/',   -- parent folder (will include future months)
  DATA_SOURCE = nyc_datalake,
  FILE_FORMAT = parquet_ff
);

-- Test it
SELECT TOP 20 * FROM dbo.yellow_curated_all;


USE nyc_taxi;
SELECT TOP 50 *
FROM OPENROWSET(
  BULK 'abfss://datalake@akash1708.dfs.core.windows.net/yellow_tripdata_2023-01.parquet',
  FORMAT = 'PARQUET'
) AS rows;
CREATE EXTERNAL DATA SOURCE nyc_datalake
WITH (
  LOCATION = 'abfss://datalake@akash1708.dfs.core.windows.net/'
);
SELECT TOP 50 *
FROM OPENROWSET(
  BULK 'yellow_tripdata_2023-01.parquet',   -- relative to the container root
  DATA_SOURCE = 'nyc_datalake',
  FORMAT = 'PARQUET'
) AS rows;

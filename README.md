# NYC-Taxi-Analytics-Azure-PowerBI.
## End-to-end cloud analytics project with Azure Data Lake, Synapse, Data Factory, and Power BI using NYC Taxi dataset (2023)

### Overview
This project demonstrates a real-world data pipeline and business intelligence solution using
* Azure Data Lake — raw storage of large Parquet files (NYC Taxi dataset).
* Azure Synapse Analytics (serverless SQL) — data cleaning, transformations, and aggregation.
* Azure Data Factory — pipeline automation (load monthly files into Data Lake).
* Power BI — interactive dashboards answering real-world business questions.
* Dataset: NYC Taxi Trip Records 2023 (public open data).

### Architecture

* Data Source: NYC Yellow Taxi Open Data (Parquet files).
* Storage: Azure Data Lake Gen2.
* Orchestration: Azure Data Factory (monthly parameterized pipeline).
* Transformations: Azure Synapse Serverless SQL (views: raw → clean → curated).
* Analytics & BI: Power BI (DirectQuery, dashboards).

### Data Ingestion

* Downloaded Yellow Taxi Trip Records (Jan–Dec 2023).
* Uploaded to Azure Data Lake Gen2 → structured as:
  * raw/tlc_trips/year=2023/month=01/yellow_tripdata_2023-01.parquet, 
  * raw/tlc_trips/year=2023/month=02/yellow_tripdata_2023-02.parquet

### Data Transformation (Synapse)

* Created external tables and views: v_yellow_raw_all — read Parquet directly from Data Lake.

* v_yellow_clean_all — applied quality rules:
   * Distance > 0
   * Duration 1–480 minutes
   * Speed 0–120 km/h
   * Non-negative fares

* v_yellow_clean_all_plus — added derived fields:
  * pickup_date, year_month
  * trip_minutes, speed_kmh

* v_passenger_buckets_base — grouped passenger counts into buckets (0–5, 6+, Unknown).
* v_metrics_by_passenger_bucket — aggregated KPIs by bucket.

### Pipeline Automation (Data Factory)
* Configured parameterized pipeline with ForEach loop to ingest monthly data automatically.
* Set up automation to process each year/month into Data Lake.

### Visualization (Power BI)
* Connected DirectQuery to Synapse SQL endpoint. Built visuals answering real-world business questions.


### Business Questions & Insights
Q1: How does taxi demand & revenue vary by month?
   * Visuals: Line charts (Trips per Month, Revenue per Month). ![Revenue and Trips by Month](Visuals/Revenue%20and%20trip%20according%20to%20different%20months.png)


   * Insight:
     Seasonal variation visible; revenue trends follow trip volume.

Q2: At what times of day and days of the week is demand highest?
   * Visual: Heatmap (Matrix with Conditional Formatting).
   * Insight:
    Weekday peaks during morning/evening commute hours.

Weekend late-night peaks (Fri/Sat).

Q3: Do more passengers mean longer trips or higher revenue?

  * Visuals:Bar chart (Avg Revenue & Distance per Passenger Bucket).
  * Scatter plot (Passenger Count vs Avg Revenue, bubble size = trips).
  * Insight:
    Single-passenger trips dominate in volume.
    Group trips (3–6+) are longer and generate higher revenue per trip.
    Tip % varies by group size.

## 💡 Key Skills Demonstrated
- Cloud data engineering: Azure Data Lake, Synapse, Data Factory  
- SQL for data cleaning, feature engineering, and aggregation  
- Business Intelligence dashboarding with Power BI (DirectQuery)  
- Translating business questions into data-driven insights  
- Building an end-to-end data pipeline from ingestion → transformation → visualization  


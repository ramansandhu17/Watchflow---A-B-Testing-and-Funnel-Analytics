# WatchFlow: A/B Testing & Funnel Optimization 

##  Overview
This project simulates a video streaming app and analyzes user behavior across a typical engagement funnel using only SQL. It includes funnel construction, drop-off analysis, and A/B testing for a new vertical-scroll layout.

## Key Goals
- Funnel conversion: visit → watch_start → watch_complete → like/share
- Drop-off rate analysis
- A/B testing (control vs test group impact)
- Segmentation by user type: new vs returning

## Dataset
- Synthetic data generated with 500 users, 1000 sessions
- Columns: user_id, session_id, event_time, event_type, content_id, group

## 📊 SQL Analyses
| File | Description |
|------|-------------|
| `01_funnel_conversion.sql` | Calculate conversion rate at each funnel step |
| `02_dropoff_analysis.sql` | Identify biggest drop-off points |
| `03_ab_test_results.sql` | Compare metrics between control and test |
| `04_segment_analysis.sql` | Funnel performance by user type |
| `05_metrics_by_group_and_time.sql` | Optional: engagement trends over time |

## 💼 Case Study
See [`case_study_summary.md`](case_study_summary.md) for STAR-format summary.

## Tools
- PostgreSQL (can run on BigQuery or Redshift)
- GitHub for version control

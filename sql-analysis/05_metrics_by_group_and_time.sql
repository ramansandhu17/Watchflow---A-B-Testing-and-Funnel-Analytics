-- Goal is to analyze how engagement changes over time broken down by day and A/B test group

WITH cleaned_events AS (
  SELECT
    DATE(event_time) AS event_day,
    group_type,
    event_type,
    user_id
  FROM engagement_events
  WHERE event_type IN ('visit', 'watch_start', 'watch_complete', 'like', 'share')
),
event_counts AS (
  SELECT
    event_day,
    group_type,
    event_type,
    COUNT(DISTINCT user_id) AS user_count
  FROM cleaned_events
  GROUP BY event_day, group_type, event_type
),
pivoted AS (
  SELECT
    event_day,
    group_type,
    MAX(CASE WHEN event_type = 'visit' THEN user_count END) AS visit_count,
    MAX(CASE WHEN event_type = 'watch_start' THEN user_count END) AS start_count,
    MAX(CASE WHEN event_type = 'watch_complete' THEN user_count END) AS complete_count,
    MAX(CASE WHEN event_type = 'like' THEN user_count END) AS like_count,
    MAX(CASE WHEN event_type = 'share' THEN user_count END) AS share_count
  FROM event_counts
  GROUP BY event_day, group_type
)
SELECT
  event_day,
  group_type,
  visit_count,
  ROUND(100.0 * start_count / NULLIF(visit_count, 0), 2) AS start_rate,
  ROUND(100.0 * complete_count / NULLIF(visit_count, 0), 2) AS complete_rate,
  ROUND(100.0 * like_count / NULLIF(visit_count, 0), 2) AS like_rate,
  ROUND(100.0 * share_count / NULLIF(visit_count, 0), 2) AS share_rate
FROM pivoted
ORDER BY event_day, group_type;

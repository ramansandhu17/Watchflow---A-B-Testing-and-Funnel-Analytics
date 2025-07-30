WITH group_events AS (
  SELECT
    group_type,
    event_type,
    COUNT(DISTINCT user_id) AS users
  FROM engagement_events
  WHERE event_type IN ('visit', 'watch_start', 'watch_complete', 'like', 'share')
  GROUP BY group_type, event_type
),
-- to gather the column level analysis
  group_funnel AS (
  SELECT
    group_type,
    MAX(CASE WHEN event_type = 'visit' THEN users END) AS visit_count,
    MAX(CASE WHEN event_type = 'watch_start' THEN users END) AS start_count,
    MAX(CASE WHEN event_type = 'watch_complete' THEN users END) AS complete_count,
    MAX(CASE WHEN event_type = 'like' THEN users END) AS like_count,
    MAX(CASE WHEN event_type = 'share' THEN users END) AS share_count
  FROM group_events
  GROUP BY group_type
)
SELECT
  group_type,
  visit_count,
  start_count,
  ROUND(100.0 * start_count / visit_count, 2) AS start_rate,

  complete_count,
  ROUND(100.0 * complete_count / visit_count, 2) AS complete_rate,

  like_count,
  ROUND(100.0 * like_count / visit_count, 2) AS like_rate,

  share_count,
  ROUND(100.0 * share_count / visit_count, 2) AS share_rate
FROM group_funnel
ORDER BY group_type;

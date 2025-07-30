-- CLassify users as new or returning
-- For each segment, calculate the watch start date, completion rate and Like/share rate


--  Identify new vs returning users
WITH user_session_counts AS (
  SELECT user_id,
         COUNT(DISTINCT session_id) AS session_count
  FROM engagement_events
  GROUP BY user_id
),
labeled_users AS (
  SELECT user_id,
         CASE
           WHEN session_count = 1 THEN 'new'
           ELSE 'returning'
         END AS user_type
  FROM user_session_counts
),

events_with_user_type AS (
  SELECT
    e.user_id,
    l.user_type,
    e.event_type
  FROM engagement_events e
  JOIN labeled_users l ON e.user_id = l.user_id
  WHERE e.event_type IN ('visit', 'watch_start', 'watch_complete', 'like', 'share')
),
funnel_by_type AS (
  SELECT
    user_type,
    event_type,
    COUNT(DISTINCT user_id) AS users
  FROM events_with_user_type
  GROUP BY user_type, event_type
),
pivoted_funnel AS (
  SELECT
    user_type,
    MAX(CASE WHEN event_type = 'visit' THEN users END) AS visit_count,
    MAX(CASE WHEN event_type = 'watch_start' THEN users END) AS start_count,
    MAX(CASE WHEN event_type = 'watch_complete' THEN users END) AS complete_count,
    MAX(CASE WHEN event_type = 'like' THEN users END) AS like_count,
    MAX(CASE WHEN event_type = 'share' THEN users END) AS share_count
  FROM funnel_by_type
  GROUP BY user_type
)

-- Final Output
SELECT
  user_type,
  visit_count,
  ROUND(100.0 * start_count / visit_count, 2) AS start_rate,
  ROUND(100.0 * complete_count / visit_count, 2) AS complete_rate,
  ROUND(100.0 * like_count / visit_count, 2) AS like_rate,
  ROUND(100.0 * share_count / visit_count, 2) AS share_rate
FROM pivoted_funnel;

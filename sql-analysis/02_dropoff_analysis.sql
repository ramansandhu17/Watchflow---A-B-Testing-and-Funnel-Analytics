WITH funnel_counts AS (
  SELECT
    event_type,
    COUNT(DISTINCT user_id) AS users
  FROM engagement_events
  WHERE event_type IN ('visit', 'watch_start', 'watch_complete', 'like', 'share')
  GROUP BY event_type
),
funnel AS (
  SELECT
    MAX(CASE WHEN event_type = 'visit' THEN users END) AS visit_count,
    MAX(CASE WHEN event_type = 'watch_start' THEN users END) AS start_count,
    MAX(CASE WHEN event_type = 'watch_complete' THEN users END) AS complete_count,
    MAX(CASE WHEN event_type = 'like' THEN users END) AS like_count,
    MAX(CASE WHEN event_type = 'share' THEN users END) AS share_count
  FROM funnel_counts
)
SELECT
  visit_count,
  start_count,
  visit_count - start_count AS drop_from_visit_to_start,
  ROUND(100.0 * (visit_count - start_count) / visit_count, 2) AS drop_rate_start,

  complete_count,
  start_count - complete_count AS drop_from_start_to_complete,
  ROUND(100.0 * (start_count - complete_count) / start_count, 2) AS drop_rate_complete,

  like_count,
  complete_count - like_count AS drop_from_complete_to_like,
  ROUND(100.0 * (complete_count - like_count) / complete_count, 2) AS drop_rate_like,

  share_count,
  like_count - share_count AS drop_from_like_to_share,
  ROUND(100.0 * (like_count - share_count) / like_count, 2) AS drop_rate_share
FROM funnel;

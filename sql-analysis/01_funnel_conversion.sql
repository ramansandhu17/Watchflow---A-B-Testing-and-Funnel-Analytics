WITH step_counts AS
    (
        Select event_type,
               COUNT(DISTINCT user_id) AS users
        from engagement_events
        where event_type IN ('visit','watch_start','watch_complete','like','share'
            )
        group by event_type
    ),
funnel AS (
  SELECT
    MAX(CASE WHEN event_type = 'visit' THEN users END) AS visited_users,
    MAX(CASE WHEN event_type = 'watch_start' THEN users END) AS started_watch,
    MAX(CASE WHEN event_type = 'watch_complete' THEN users END) AS completed_watch,
    MAX(CASE WHEN event_type = 'like' THEN users END) AS liked,
    MAX(CASE WHEN event_type = 'share' THEN users END) AS shared
  FROM step_counts
)
SELECT
  visited_users,
  started_watch,
  ROUND(100.0 * started_watch / visited_users, 2) AS start_rate,
  completed_watch,
  ROUND(100.0 * completed_watch / visited_users, 2) AS complete_rate,
  liked,
  ROUND(100.0 * liked / visited_users, 2) AS like_rate,
  shared,
  ROUND(100.0 * shared / visited_users, 2) AS share_rate
FROM funnel;

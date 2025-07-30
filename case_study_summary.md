# Case Study: WatchFlow — Funnel & A/B Test Analysis

## Situation
At a simulated video streaming platform, the product team launched a new vertical-scroll layout aiming to improve user engagement. As the Data Scientist, I was tasked with analyzing user behavior through the engagement funnel and evaluating the impact of this A/B test.

##  Task
My goal was to:
- Quantify conversion at each funnel step: `visit → watch_start → watch_complete → like → share`
- Identify major drop-off points
- Compare performance between test and control groups
- Segment behavior by user type (new vs. returning)
- Analyze trends over time using only SQL

## Action
I used PostgreSQL to build a fully SQL-driven analysis pipeline:

1. **Funnel Conversion**  
   - [`01_funnel_conversion.sql`](sql-analysis/01_funnel_conversion.sql)  
   - Calculated number of users at each step using `COUNT(DISTINCT user_id)` grouped by `event_type`
   - Pivoted these counts into funnel columns to calculate conversion percentages from `visit` to `share`

2. **Drop-Off Analysis**  
   - [`02_dropoff_analysis.sql`](sql-analysis/02_dropoff_analysis.sql)  
   - Used differences between each step to identify where users dropped off  
   - Example: Drop from `watch_start` (420 users) → `watch_complete` (310 users) = 110 users lost = **26.2% drop**

3. **A/B Test Evaluation**  
   - [`03_ab_test_results.sql`](sql-analysis/03_ab_test_results.sql)  
   - Grouped by `group_type` (`control`, `test`), calculated conversion rates relative to `visit_count`  
   - Found:
     - **Watch completion rate**:
       - Control: 64.0% (e.g., 160/250)
       - Test: 71.2% (e.g., 178/250)
       - → **+7.2% improvement**
     - **Share rate**:
       - Control: 18.0% (e.g., 45/250)
       - Test: 22.4% (e.g., 56/250)
       - → **+4.4% improvement**

4. **User Segmentation**  
   - [`04_segment_analysis.sql`](sql-analysis/04_segment_analysis.sql)  
   - Identified users with 1 session as `new`, more than 1 session as `returning`  
   - Measured funnel metrics for both:
     - **Like rate**:
       - New users: 18%
       - Returning users: 36% → **2x more likely to like**
     - **Share rate**:
       - New: 8%
       - Returning: 17.5% → **also more likely to share**

5. **Time-Based Trends**  
   - [`05_metrics_by_group_and_time.sql`](sql-analysis/05_metrics_by_group_and_time.sql)  
   - Rolled up metrics using `DATE(event_time)` and `group_type`
   - Tracked how funnel rates changed daily — showed that test group engagement trended upward after rollout

##  Result

Each key finding was directly tied to SQL analysis:

| Insight | Backed By |
|--------|-----------|
| **Test group had +7.2% higher watch completion and +4.4% higher share rate** | [`03_ab_test_results.sql`](sql-analysis/03_ab_test_results.sql) — Conversion by group |
| **Biggest funnel drop-off (26.2%) occurred between watch start → complete** | [`02_dropoff_analysis.sql`](sql-analysis/02_dropoff_analysis.sql) — Step-by-step user loss |
| **Returning users were 2x more likely to like (36% vs 18%) and share** | [`04_segment_analysis.sql`](sql-analysis/04_segment_analysis.sql) — User segmentation |
| **Engagement in the test group trended upward daily** | [`05_metrics_by_group_and_time.sql`](sql-analysis/05_metrics_by_group_and_time.sql) — Daily time series by group |

This structure enabled clear communication of business impact using only SQL — no BI tools or Python needed.

## Reflection
This project demonstrates how SQL alone can uncover meaningful product insights, evaluate experiments, and support key feature decisions.

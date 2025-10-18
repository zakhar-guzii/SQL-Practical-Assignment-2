use blog_platform;

WITH aggregated_data AS (
    SELECT
        p.category,
        YEAR(p.published_at) AS year,
        COUNT(*) AS post_count
    FROM posts p
    WHERE YEAR(p.published_at) IN (2024, 2025)
    GROUP BY p.category, YEAR(p.published_at)
)
SELECT
    a.category,
    COALESCE(a.post_count, 0) AS posts_2024,
    COALESCE(b.post_count, 0) AS posts_2025,
    ROUND(
        ((COALESCE(b.post_count, 0) - COALESCE(a.post_count, 0)) / NULLIF(COALESCE(a.post_count, 0), 0)) * 100,
        2
    ) AS growth_percentage,
    CASE
        WHEN COALESCE(b.post_count, 0) > COALESCE(a.post_count, 0) THEN 'Growth'
        WHEN COALESCE(b.post_count, 0) < COALESCE(a.post_count, 0) THEN 'Decline'
        ELSE 'No Change'
    END AS change_direction
FROM
    (SELECT DISTINCT category FROM posts WHERE YEAR(published_at) IN (2024, 2025)) c
LEFT JOIN aggregated_data a ON a.category = c.category AND a.year = 2024
LEFT JOIN aggregated_data b ON b.category = c.category AND b.year = 2025
ORDER BY growth_percentage DESC;
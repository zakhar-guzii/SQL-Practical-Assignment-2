use blog_platform;

-- Дуже не оптимізований запит (AI-generated)
SELECT
    u.user_id,
    u.username,
    u.display_name,
    p.post_id,
    p.title,
    p.category,
    p.published_at,
    c.comment_id,
    c.comments_text,
    c.created_at AS comment_date,
    sub.total_comments,
    sub.approved_comments,
    r.recent_comment_text,
    r.recent_comment_date
FROM users u
JOIN posts p ON u.user_id = p.author_id
LEFT JOIN comments c ON p.post_id = c.post_id
LEFT JOIN (
    SELECT
        post_id,
        COUNT(*) AS total_comments,
        SUM(CASE WHEN is_approved = 1 THEN 1 ELSE 0 END) AS approved_comments
    FROM comments
    GROUP BY post_id
) sub ON sub.post_id = p.post_id
LEFT JOIN (
    SELECT c1.post_id, c1.comments_text AS recent_comment_text, c1.created_at AS recent_comment_date
    FROM comments c1
    WHERE c1.created_at = (
        SELECT MAX(c2.created_at)
        FROM comments c2
        WHERE c2.post_id = c1.post_id
    )
) r ON r.post_id = p.post_id
WHERE p.published_at >= '2023-01-01'
  AND p.category IN ('technology', 'programming', 'science', 'art', 'design')
  AND u.username LIKE '%dev%'
  AND EXISTS (
      SELECT 1
      FROM comments c3
      WHERE c3.post_id = p.post_id
        AND c3.is_approved = 1
        AND c3.created_at > '2024-01-01'
  )
ORDER BY p.published_at DESC, r.recent_comment_date ASC, c.comment_id DESC;
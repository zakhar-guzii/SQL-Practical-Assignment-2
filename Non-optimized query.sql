use blog_platform;

SELECT
    u.user_id,
    u.username,
    u.display_name,
    (SELECT COUNT(*)
     FROM posts p
     WHERE p.author_id = u.user_id
       AND p.published_at > '2022-01-01') AS recent_posts,
    (SELECT COUNT(*)
     FROM comments c2
     WHERE c2.author_id = u.user_id
       AND c2.is_approved = 1) AS approved_comments,
    (SELECT GROUP_CONCAT(title)
     FROM posts p2
     WHERE p2.author_id = u.user_id
       AND p2.category = 'technology') AS tech_post_titles,
    c.comments_text,
    c.created_at,
    (SELECT category
     FROM posts p3
     WHERE p3.post_id = c.post_id) AS comment_post_category
FROM users u
LEFT JOIN comments c ON c.author_id = u.user_id
WHERE u.creation_date > '2020-01-01'
ORDER BY c.created_at DESC;
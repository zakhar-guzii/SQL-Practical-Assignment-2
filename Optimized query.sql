use blog_platform;

create index idx_posts_published_at on posts (published_at);
create index idx_posts_category_published_at on posts (category, published_at);
create index idx_posts_author_category_published on posts (author_id, category, published_at);


with post_comments as (select p.post_id,
                              count(c.comment_id) as comment_count
                       from posts p
                                left join comments c on c.post_id = p.post_id
                       where p.published_at >= '2024-01-01'
                         and p.published_at < '2026-01-01'
                       group by p.post_id),

     category_stats as (select p.category,
                               sum(case when year(p.published_at) = 2024 then 1 else 0 end)                      as posts_2024,
                               sum(case when year(p.published_at) = 2025 then 1 else 0 end)                      as posts_2025,
                               count(distinct case
                                                  when year(p.published_at) = 2024
                                                      then p.author_id end)                                      as unique_authors_2024,
                               count(distinct case
                                                  when year(p.published_at) = 2025
                                                      then p.author_id end)                                      as unique_authors_2025,
                               avg(case
                                       when year(p.published_at) = 2024
                                           then coalesce(pc.comment_count, 0) end)                               as avg_comments_2024,
                               avg(case
                                       when year(p.published_at) = 2025
                                           then coalesce(pc.comment_count, 0) end)                               as avg_comments_2025
                        from posts p
                                 left join post_comments pc on p.post_id = pc.post_id
                        where p.published_at >= '2024-01-01'
                          and p.published_at < '2026-01-01'
                        group by p.category),

     post_diffs as (select category,
                           author_id,
                           avg(datediff(next_published_at, published_at)) as avg_days_between
                    from (select author_id,
                                 category,
                                 published_at,
                                 lead(published_at)
                                      over (partition by author_id, category order by published_at) as next_published_at
                          from posts
                          where published_at >= '2024-01-01'
                            and published_at < '2026-01-01') t
                    where next_published_at is not null
                    group by category, author_id)
select cs.category,
       cs.posts_2024,
       cs.posts_2025,
       cs.unique_authors_2024,
       cs.unique_authors_2025,
       cs.avg_comments_2024,
       cs.avg_comments_2025,
       avg(pd.avg_days_between) as avg_days_between_posts
from category_stats cs
         left join post_diffs pd on cs.category = pd.category
group by cs.category;
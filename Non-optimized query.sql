use blog_platform;
explain
select p_main.category,

       (select count(*)
        from posts p1
        where p1.category = p_main.category
          and year(p1.published_at) = 2024
          and exists (select 1 from posts p1a where p1a.post_id = p1.post_id))     as posts_2024,

       (select count(*)
        from posts p2
        where p2.category = p_main.category
          and year(p2.published_at) = 2025
          and exists (select 1 from posts p2a where p2a.post_id = p2.post_id))     as posts_2025,

       (select count(distinct p3.author_id)
        from posts p3
        where p3.category = p_main.category
          and year(p3.published_at) = 2024
          and exists (select 1 from posts p3a where p3a.author_id = p3.author_id)) as unique_authors_2024,

       (select count(distinct p4.author_id)
        from posts p4
        where p4.category = p_main.category
          and year(p4.published_at) = 2025
          and exists (select 1 from posts p4a where p4a.author_id = p4.author_id)) as unique_authors_2025,

       (select avg(c_count)
        from (select count(*) as c_count
              from comments c1
                       join posts p5 on p5.post_id = c1.post_id
              where p5.category = p_main.category
                and year(p5.published_at) = 2024
                and exists (select 1 from comments c1a where c1a.post_id = c1.post_id)
              group by c1.post_id) sub1)                                           as avg_comments_2024,

       (select avg(c_count)
        from (select count(*) as c_count
              from comments c2
                       join posts p6 on p6.post_id = c2.post_id
              where p6.category = p_main.category
                and year(p6.published_at) = 2025
                and exists (select 1 from comments c2a where c2a.post_id = c2.post_id)
              group by c2.post_id) sub2)                                           as avg_comments_2025,

       (select avg(diff_days)
        from (select datediff(
                             (select min(p_next.published_at)
                              from posts p_next
                              where p_next.author_id = p_sub.author_id
                                and p_next.category = p_sub.category
                                and p_next.published_at > p_sub.published_at
                                and exists (select 1 from posts p_next_a where p_next_a.post_id = p_next.post_id)
                                and p_next.published_at >= '2024-01-01'
                                and p_next.published_at < '2026-01-01'),
                             p_sub.published_at
                     ) as diff_days
              from posts p_sub
                       join posts p_sub_dup on p_sub_dup.author_id = p_sub.author_id
                  and p_sub_dup.category = p_sub.category
              where p_sub.category = p_main.category
                and p_sub.published_at >= '2024-01-01'
                and p_sub.published_at < '2026-01-01'
                and exists (select 1 from posts p_sub_exist where p_sub_exist.post_id = p_sub.post_id)) sub_diff
        where diff_days is not null)                                               as avg_days_between_posts

from posts p_main

         left join posts p_extra1 on p_extra1.category = p_main.category
         left join posts p_extra2 on p_extra2.author_id = p_main.author_id
         left join comments c_extra1 on c_extra1.post_id = p_main.post_id
         left join comments c_extra2 on c_extra2.post_id = p_main.post_id

group by p_main.category;
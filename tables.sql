create database blog_platform;
use blog_platform;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) unique,
    display_name varchar(50),
    creation_date datetime
);

create table posts (
    post_id int primary key auto_increment,
    title varchar(255),
    category enum(
        'technology', 'business-startups', 'education', 'science', 'culture', 'travel',
        'health-sport', 'food-recipes', 'lifestyle', 'art', 'design', 'marketing',
        'programming', 'movies-series', 'music', 'economics', 'politics', 'ecology',
        'psychology', 'history', 'social-media', 'games', 'books', 'analytics', 'interviews'
    ),
    author_id int,
    published_at datetime,
    comments_count int,
    foreign key (author_id) references users(user_id)
);

create table comments
(
    comment_id    int primary key auto_increment,
    post_id       int,
    author_id     int,
    created_at    datetime,
    is_approved   bool,
    comments_text text,
    foreign key (post_id) references posts (post_id),
    foreign key (author_id) references users (user_id)
);

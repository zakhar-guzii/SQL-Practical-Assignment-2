import random
import mysql.connector
from faker import Faker

fake = Faker()
conn = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    passwd="MySQL_Student123",
    database='blog_platform'
)
cursor = conn.cursor(buffered=True)


def generate_user():
    username = fake.user_name()[:50]
    display_name = fake.user_name()[:50]
    creation_date = fake.date_between(start_date="-5y", end_date="now")
    return username, display_name, creation_date


def inset_users(n, batch_size = 100000):
    sql = """
          insert into users (username, display_name, creation_date)
          values (%s, %s, %s)"""
    to_insert = []
    inserted = 0
    for _ in range(n):
        to_insert.append(generate_user())
        if len(to_insert) >= batch_size:
            cursor.executemany(sql, to_insert)
            conn.commit()
            inserted += len(to_insert)
            to_insert = []
    if to_insert:
        cursor.executemany(sql, to_insert)
        conn.commit()
        inserted += len(to_insert)


inset_users(1000000)

categories = ['technology', 'business-startups', 'education', 'science', 'culture', 'travel',
              'health-sport', 'food-recipes', 'lifestyle', 'art', 'design', 'marketing',
              'programming', 'movies-series', 'music', 'economics', 'politics', 'ecology',
              'psychology', 'history', 'social-media', 'games', 'books', 'analytics', 'interviews'
              ]


def generate_post(user_ids):
    title = fake.sentence()[:255]
    category_choice = random.choice(categories)
    author_id = random.choice(user_ids)
    published_at = fake.date_between(start_date="-5y", end_date="now")
    comments_count = random.randint(0, 50)
    return title, category_choice, author_id, published_at, comments_count


def insert_posts(user_ids, n, batch_size = 100000):
    sql = """
          insert into posts (title, category, author_id, published_at, comments_count)
          values (%s, %s, %s, %s, %s)"""
    to_insert = []
    inserted = 0
    for _ in range(n):
        to_insert.append(generate_post(user_ids))
        if len(to_insert) >= batch_size:
            cursor.executemany(sql, to_insert)
            conn.commit()
            inserted += len(to_insert)
            to_insert = []
    if to_insert:
        cursor.executemany(sql, to_insert)
        conn.commit()
        inserted += len(to_insert)


cursor.execute("SELECT user_id FROM users")
users_ids = [row[0] for row in cursor.fetchall()]
insert_posts(users_ids, 1000000)


def generate_comment(post_id, author_id):
    is_approved = fake.boolean()
    created_at = fake.date_between(start_date="-5y", end_date="now")
    comments_text = fake.sentence()[:1000]
    return post_id, author_id, created_at, is_approved, comments_text


def insert_comments(post_ids, user_ids, n_per_post, batch_size = 100000):
    sql = """
          insert into comments (post_id, author_id, created_at, is_approved, comments_text)
          values (%s, %s, %s, %s, %s)"""
    to_insert = []
    inserted = 0
    for post_id in post_ids:
        for _ in range(n_per_post):
            to_insert.append(generate_comment(post_id, random.choice(user_ids)))
            if len(to_insert) >= batch_size:
                cursor.executemany(sql, to_insert)
                conn.commit()
                inserted += len(to_insert)
                to_insert = []
        if to_insert:
            cursor.executemany(sql, to_insert)
            conn.commit()
            inserted += len(to_insert)


cursor.execute("SELECT post_id FROM posts")
post_ids = [r[0] for r in cursor.fetchall()]
insert_comments(post_ids, users_ids, n_per_post=random.randint(1, 2))
cursor.close()
conn.close()

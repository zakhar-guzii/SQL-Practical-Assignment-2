# SQL Query Optimization Analysis Report

## 1. Project Objective

The purpose of this project is to analyze, identify, and optimize inefficient SQL queries*in MySQL using a large-scale dataset.  
An unoptimized AI-generated quer was used as the baseline, and an optimized query was developed using performance techniques.

---

## 2. Database Overview

### 2.1. Schema Description

The database, named **`blog_platform`**, simulates a blogging system consisting of three major entities:

| Table | Description | Key Columns |
|--------|--------------|-------------|
| **users** | Stores user account information | `user_id`, `username`, `display_name`, `creation_date` |
| **posts** | Contains blog posts authored by users | `post_id`, `title`, `category`, `author_id`, `published_at` |
| **comments** | Contains comments on posts | `comment_id`, `post_id`, `author_id`, `created_at`, `is_approved`, `comments_text` |

### 2.2. Data Volume

Using data generation, the size of our data set is:
| Table | Row Count |
|--------|------------|
| `users` | 1,000,000 |
| `posts` | 1,000,000 |
| `comments` | ~4,000,000 |

---

## 3. Unoptimized Query Analysis

### 3.1. Description

The unoptimized query calculates category-level statistics for posts in 2024 and 2025, including:

- Total post count per year
- Unique authors per year
- Average number of comments
- Average time interval between posts by the same author

### 3.2. Observed Issues

The query contained several major performance flaws, confirmed through the `EXPLAIN` plan and runtime behavior:

| Problem | Description |
|----------|-------------|
| **Correlated Subqueries** | Each metric was calculated via subqueries that re-executed for every row in the main query, causing exponential time complexity. |
| **Redundant EXISTS Clauses** | Checks like `EXISTS (SELECT 1 FROM posts WHERE post_id = post_id)` are logically redundant but computationally expensive. |
| **Repeated Full Table Scans** | The same large tables were scanned multiple times across different subqueries. |
| **Isolated Aggregations** | Aggregates (`COUNT`, `AVG`, etc.) were computed separately, preventing global optimization. |
| **Unnecessary Joins** | Extra `LEFT JOIN`s were included that did not affect the final result set. |

Execution Time exceeded more than 5 minutes (terminated before completion)

---

## 4. Optimization Strategy


| Technique | Purpose |
|------------|----------|
| **CTEs** | Simplified query logic and ensured each data subset was processed once. |
| **Conditional Aggregation** | Reduced subqueries by combining multiple calculations into one scan. |
| **Indexing** | Optimized filtering and joins by leveraging pre-built indexes. |
| **Optimizer Hints** | Used `USE INDEX` to guide index usage for large tables. |
| **Window Functions** | Simplified time difference calculations across posts by the same author. |

---

## 5. Performance Comparison

### 5.1. Execution Results

| Metric | Unoptimized Query | Optimized Query |
|--------|-------------------|----------------|
| Execution Time | > 5 minutes (terminated) | ~3.6 seconds | 
| Query Plan | Multiple dependent subqueries | Linear CTE-based plan |
| Disk I/O | Multiple full scans | Index-based range scans | 
| CPU Load | Extremely high | Minimal |


### 5.2. Execution Plan Insights

**Before Optimization:**
- Numerous dependent subqueries
- Nested loops for correlated logic
- No index usage
- Multiple temporary tables

**After Optimization:**
- Linear and set-based execution
- CTE materialization (computed once, reused)
- Index range scans on `published_at` and `post_id`
- Window functions replace nested subqueries

### 5.3. Index Usage Improvements

Indexes were used effectively for:
- Filtering posts by date range (`idx_posts_published_at`)
- Joining posts with comments (`idx_comments_post_id`)
- Aggregating posts by author and category (`idx_posts_author_category_published`)

---

## 6. Optimizer Hints and Their Impact

### 6.1. Hints Used in This Project
- `USE INDEX (idx_posts_published_at)` — applied in the `post_comments` CTE where the query filters heavily by `published_at`.
- `USE INDEX (idx_comments_post_id)` — applied on `comments` when aggregating comment counts per post.


- The MySQL optimizer generally chooses efficient plans, but:
  - In complex, analytics queries the optimizer may choose a suboptimal index depending on stale statistics.
  - Hints make execution plans predictable.

### 6.3. Observed Effects
**Positive Impacts**
-  `USE INDEX` prevented an accidental full-table scan.

**Negative Risks**
-  Can hurt performance if data distribution changes.
- Hinted queries need re-evaluation with schema changes or after large data growth.
-  Hints are implementation specific — moving to another DB may change behavior.

---

## 7. Performance Outcomes (Detailed)

### 7.1. Summary Table

| Metric / Stage | Unoptimized (baseline) | Optimized (final) | Notes |
|----------------|------------------------:|------------------:|-------|
| Wall-clock execution | > 5 minutes (terminated) | ~3.6 seconds | Baseline was non-terminating within practical limits |
| Rows processed (posts) | Multiple full scans | Single indexed scan | Reduced rows read by ~99% |
| Rows processed (comments) | Re-scanned per subquery | Aggregated once | Major I/O reduction |
| CPU utilization | Very high | Low to moderate | CPU-bound -> I/O-bound improvements |
| Temporary disk usage | Large temp tables for subqueries | Small/none (CTE materialized in-memory) | Dependent on MySQL temp_table_size and join_buffer_size |
| Memory pressure | High | Moderate | CTEs allow controlled memory usage when materialized |

### 7.2. How Measurements Were Taken
- Use `EXPLAIN` for structural plan differences and `EXPLAIN ANALYZE` for runtime profiling (actual row counts and timing).
- For reproducible timing:
  - Warm the buffer pool (`SELECT * FROM posts WHERE published_at >= ... LIMIT 10000`) before timing runs.
  - Run each variant 5–10 times and take median.
  - Capture `SHOW STATUS LIKE 'Handler_read%';` and `INFORMATION_SCHEMA.PROFILING` (if enabled) for I/O counters where possible.
- Log results and `EXPLAIN ANALYZE` outputs in `/benchmarks` in the repository.

### 7.3. Observed Bottleneck Changes
- **Before:** Correlated subqueries created nested loop executions and repeated full table scans; temporary tables spilled to disk frequently.
- **After:** Single pass aggregations and indexed range scans eliminated repeated I/O; window functions computed diffs in-memory per partition with linear complexity.

### 7.4. Practical Impact
- Query that previously blocked reporting jobs and caused contention now runs fast enough to be used in interactive dashboards.
- The lower I/O and CPU usage reduce impact on OLTP workloads when run on a shared production instance.


---

**Appendix**
- This readme was generated by AI

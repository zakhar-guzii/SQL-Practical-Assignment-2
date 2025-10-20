| id | select\_type | table | partitions | type | possible\_keys | key | key\_len | ref | rows | filtered | Extra |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | PRIMARY | &lt;derived2&gt; | null | ALL | null | null | null | null | 4974992 | 100 | Using temporary |
| 1 | PRIMARY | &lt;derived4&gt; | null | ref | &lt;auto\_key0&gt; | &lt;auto\_key0&gt; | 2 | cs.category | 10 | 100 | null |
| 4 | DERIVED | &lt;derived5&gt; | null | ALL | null | null | null | null | 497497 | 90 | Using where; Using temporary |
| 5 | DERIVED | posts | null | index | idx\_posts\_published\_at,idx\_posts\_author\_category\_published | idx\_posts\_author\_category\_published | 13 | null | 994994 | 50 | Using where; Using index; Using filesort |
| 2 | DERIVED | p | null | index | idx\_posts\_published\_at,idx\_posts\_category\_published\_at,idx\_posts\_author\_category\_published | idx\_posts\_category\_published\_at | 8 | null | 994994 | 50 | Using where |
| 2 | DERIVED | &lt;derived3&gt; | null | ref | &lt;auto\_key0&gt; | &lt;auto\_key0&gt; | 4 | blog\_platform.p.post\_id | 10 | 100 | null |
| 3 | DERIVED | p | null | range | idx\_posts\_published\_at | idx\_posts\_published\_at | 6 | null | 497497 | 100 | Using where; Using index; Using temporary |
| 3 | DERIVED | c | null | ref | idx\_comments\_post\_id | idx\_comments\_post\_id | 5 | blog\_platform.p.post\_id | 3 | 100 | Using index |

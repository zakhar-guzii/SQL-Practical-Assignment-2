| id | select\_type | table | partitions | type | possible\_keys | key | key\_len | ref | rows | filtered | Extra |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | PRIMARY | p\_main | null | index | idx\_posts\_category\_published\_at,idx\_posts\_author\_category\_published | idx\_posts\_category\_published\_at | 8 | null | 994994 | 100 | null |
| 1 | PRIMARY | p\_extra1 | null | ref | idx\_posts\_category\_published\_at | idx\_posts\_category\_published\_at | 2 | blog\_platform.p\_main.category | 41458 | 100 | Using index |
| 1 | PRIMARY | p\_extra2 | null | ref | idx\_posts\_author\_category\_published | idx\_posts\_author\_category\_published | 5 | blog\_platform.p\_main.author\_id | 1 | 100 | Using index |
| 1 | PRIMARY | c\_extra1 | null | ref | idx\_comments\_post\_id | idx\_comments\_post\_id | 5 | blog\_platform.p\_main.post\_id | 3 | 100 | Using index |
| 1 | PRIMARY | c\_extra2 | null | ref | idx\_comments\_post\_id | idx\_comments\_post\_id | 5 | blog\_platform.p\_main.post\_id | 3 | 100 | Using index |
| 16 | DEPENDENT SUBQUERY | &lt;derived17&gt; | null | ALL | null | null | null | null | 21075 | 90 | Using where |
| 17 | DEPENDENT DERIVED | p\_sub | null | ref | PRIMARY,idx\_posts\_published\_at,idx\_posts\_category\_published\_at,idx\_posts\_author\_category\_published | idx\_posts\_category\_published\_at | 2 | func | 41458 | 50 | Using index condition; Using where |
| 17 | DEPENDENT DERIVED | p\_sub\_exist | null | eq\_ref | PRIMARY | PRIMARY | 4 | blog\_platform.p\_sub.post\_id | 1 | 100 | Using index |
| 17 | DEPENDENT DERIVED | p\_sub\_dup | null | ref | idx\_posts\_category\_published\_at,idx\_posts\_author\_category\_published | idx\_posts\_author\_category\_published | 7 | blog\_platform.p\_sub.author\_id,func | 1 | 100 | Using where; Using index |
| 18 | DEPENDENT SUBQUERY | p\_next | null | ref | PRIMARY,idx\_posts\_published\_at,idx\_posts\_category\_published\_at,idx\_posts\_author\_category\_published | idx\_posts\_author\_category\_published | 7 | blog\_platform.p\_sub.author\_id,blog\_platform.p\_sub.category | 1 | 50 | Using where; Using index |
| 18 | DEPENDENT SUBQUERY | p\_next\_a | null | eq\_ref | PRIMARY | PRIMARY | 4 | blog\_platform.p\_next.post\_id | 1 | 100 | Using index |
| 13 | DEPENDENT SUBQUERY | &lt;derived14&gt; | null | ALL | null | null | null | null | 149875 | 100 | null |
| 14 | DEPENDENT DERIVED | p6 | null | ref | PRIMARY,idx\_posts\_category\_published\_at | idx\_posts\_category\_published\_at | 2 | func | 41458 | 100 | Using where; Using index; Using temporary |
| 14 | DEPENDENT DERIVED | c2 | null | ref | idx\_comments\_post\_id | idx\_comments\_post\_id | 5 | blog\_platform.p6.post\_id | 3 | 100 | Using index |
| 14 | DEPENDENT DERIVED | c2a | null | ref | idx\_comments\_post\_id | idx\_comments\_post\_id | 5 | blog\_platform.p6.post\_id | 3 | 100 | Using index; FirstMatch\(c2\) |
| 10 | DEPENDENT SUBQUERY | &lt;derived11&gt; | null | ALL | null | null | null | null | 149875 | 100 | null |
| 11 | DEPENDENT DERIVED | p5 | null | ref | PRIMARY,idx\_posts\_category\_published\_at | idx\_posts\_category\_published\_at | 2 | func | 41458 | 100 | Using where; Using index; Using temporary |
| 11 | DEPENDENT DERIVED | c1 | null | ref | idx\_comments\_post\_id | idx\_comments\_post\_id | 5 | blog\_platform.p5.post\_id | 3 | 100 | Using index |
| 11 | DEPENDENT DERIVED | c1a | null | ref | idx\_comments\_post\_id | idx\_comments\_post\_id | 5 | blog\_platform.p5.post\_id | 3 | 100 | Using index; FirstMatch\(c1\) |
| 8 | DEPENDENT SUBQUERY | p4 | null | ref | idx\_posts\_category\_published\_at,idx\_posts\_author\_category\_published | idx\_posts\_category\_published\_at | 2 | func | 41458 | 100 | Using index condition; Using where |
| 8 | DEPENDENT SUBQUERY | p4a | null | ref | idx\_posts\_author\_category\_published | idx\_posts\_author\_category\_published | 5 | blog\_platform.p4.author\_id | 1 | 100 | Using index; FirstMatch\(p4\) |
| 6 | DEPENDENT SUBQUERY | p3 | null | ref | idx\_posts\_category\_published\_at,idx\_posts\_author\_category\_published | idx\_posts\_category\_published\_at | 2 | func | 41458 | 100 | Using index condition; Using where |
| 6 | DEPENDENT SUBQUERY | p3a | null | ref | idx\_posts\_author\_category\_published | idx\_posts\_author\_category\_published | 5 | blog\_platform.p3.author\_id | 1 | 100 | Using index; FirstMatch\(p3\) |
| 4 | DEPENDENT SUBQUERY | p2 | null | ref | PRIMARY,idx\_posts\_category\_published\_at | idx\_posts\_category\_published\_at | 2 | func | 41458 | 100 | Using where; Using index |
| 4 | DEPENDENT SUBQUERY | p2a | null | eq\_ref | PRIMARY | PRIMARY | 4 | blog\_platform.p2.post\_id | 1 | 100 | Using index |
| 2 | DEPENDENT SUBQUERY | p1 | null | ref | PRIMARY,idx\_posts\_category\_published\_at | idx\_posts\_category\_published\_at | 2 | func | 41458 | 100 | Using where; Using index |
| 2 | DEPENDENT SUBQUERY | p1a | null | eq\_ref | PRIMARY | PRIMARY | 4 | blog\_platform.p1.post\_id | 1 | 100 | Using index |

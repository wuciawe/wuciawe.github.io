---
layout: post
category: [database]
tags: [mysql]
infotext: "Behaviour of mysql when inserted entry containing contradicted unique keys."
---
{% include JB/setup %}

Last week, I find a bug in the project, where I forgot to build up unique key on table, and tried 
to use 'INSERT INTO ... ON DUPLICATE KEY UPDATE ...' syntax to insert data into that table. That 
of course led to failures on proposed updating.

You have to have unique keys first, to get that syntax to work properly. But what is the behaviour 
of mysql if the keys are contradicted?

Suppose we have a table with fields: `A`, `B`, `C`, `D`, where `A` is primary key, and `B` and `C` 
are unique keys. And suppose the table contains data entries: A:1,B:1,C:1,D:1, and A:2,B:2,C:2,D:2.

What will happen, if we do `INSERT INTO table (A,B,D) VALUES (1,2,3) ON DUPLICATE KEY UPDATE D=3;`?

The data entries will become: A:1,B:1,C:1,D:3, and A:2,B:2,C:2,D:2.

The primary key wins, the primary key has higher priority than common unique keys.

What will happen, if we then do `INSERT INTO table (B,C,D) VALUES (1,2,4) ON DUPLICATE KEY UPDATE D=4;`?

Now, the two common unique keys get contradicted, which one will win?

After some experiments, it seems there is a rule over it. If you open the database connection with 
MySQL Workbench, and look at the index information of the table, the unique key at a higher position 
has higher priority. (Of course, the primary is at the highest position and can not be changed.)

So, suppose unique key on C is at a higher position than B's, the data entries will become:
A:1,B:1,C:1,D:3, and A:2,B:2,C:2,D:4.

Otherwise the data entries will become: A:1,B:1,C:1,D:4, and A:2,B:2,C:2,D:2.
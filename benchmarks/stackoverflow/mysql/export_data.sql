--USERS
SELECT * 
FROM users
INTO OUTFILE '/fastdisk/mysql_data/users.csv' 
FIELDS ENCLOSED BY '"'
TERMINATED BY ',';

--Posts
SELECT *
FROM posts
INTO OUTFILE '/fastdisk/mysql_data/posts.csv'
FIELDS ENCLOSED BY '"'
TERMINATED BY ',';

--PostLinks
SELECT *
FROM post_links
INTO OUTFILE '/fastdisk/mysql_data/post_links.csv'
FIELDS ENCLOSED BY '"'
TERMINATED BY ',';

--PostHistory
FROM post_history
INTO OUTFILE '/fastdisk/mysql_data/post_history.csv'
FIELDS ENCLOSED BY '"'
TERMINATED BY ',';

--Comments
FROM comments
INTO OUTFILE '/fastdisk/mysql_data/comments.csv'
FIELDS ENCLOSED BY '"'
TERMINATED BY ',';

--Votes
FROM votes
INTO OUTFILE '/fastdisk/mysql_data/votes.csv'
FIELDS ENCLOSED BY '"'
TERMINATED BY ',';

--Badges
FROM badges
INTO OUTFILE '/fastdisk/mysql_data/badges.csv'
FIELDS ENCLOSED BY '"'
TERMINATED BY ',';


CREATE TYPE role_types AS ENUM ('admin', 'normal');

CREATE TABLE users (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    role role_types DEFAULT 'normal'
);

CREATE TABLE categories (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE articles (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id),
    category_id INTEGER NOT NULL REFERENCES categories(id)
);

CREATE TABLE comments (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    comment TEXT NOT NULL,
    user_id INTEGER NOT NULL REFERENCES users(id),
    article_id INTEGER NOT NULL REFERENCES articles(id)
);

INSERT INTO users (name, role) VALUES
('user1', 'admin'),
('user2', 'normal'),
('user3', 'normal');

INSERT INTO categories (name) VALUES
('Technology'),
('Sports');

INSERT INTO articles (title, content, user_id, category_id) VALUES
('Ruby', 'Ruby basics', 3, 1),
('PostgreSQL', 'SQL basics', 3, 1),
('Football', 'Football news', 2, 2),
('Cricket', 'Cricket news', 1, 2);

INSERT INTO comments (comment, user_id, article_id) VALUES
('Good', 1, 1),
('Nice', 2, 1),
('Helpful', 2, 1),
('Another comment', 1, 1),
('Great', 1, 2),
('Excellent', 1, 2),
('Amazing', 1, 2),
('Good work', 3, 3);

-- select all articles whose author's name is user3 (Do this exercise using variable also).

SELECT a.id, a.title, a.content
FROM articles AS a
JOIN users u ON a.user_id = u.id
WHERE u.name = 'user3';


-- For all the articles being selected above, select all the articles and also the comments associated with 
-- those articles in a single query (Do this using subquery also)

SELECT a.id, a.title, a.content, c.comment
FROM articles AS a
JOIN comments AS c ON a.id = c.article_id
JOIN users AS u ON u.id = a.user_id
WHERE u.name = 'user3';


SELECT a.id, a.title, a.content, c.comment
FROM articles AS a
JOIN comments AS c
    ON c.article_id = a.id
WHERE a.id IN (
    SELECT a.id
    FROM articles AS a
    JOIN users AS u
        ON u.id = a.user_id
    WHERE u.name = 'user3'
);

-- Write a query to select all articles which do not have any comments (Do using subquery also)

SELECT a.id, a.title, a.content
FROM articles a
LEFT JOIN comments c
    ON c.article_id = a.id
WHERE c.comment IS NULL;


SELECT a.id, a.title, a.content
FROM articles a
WHERE a.id NOT IN (
    SELECT c.article_id
    FROM comments c
);

-- Write a query to select article which has maximum comments

WITH article_total_comments AS (
    SELECT article_id, COUNT(*) AS number_of_comments
    FROM comments
    GROUP BY article_id
)
SELECT a.id, a.title, a.content
FROM articles a
WHERE a.id IN (
    SELECT article_id
    FROM article_total_comments
    WHERE number_of_comments = (
        SELECT MAX(number_of_comments)
        FROM article_total_comments
    )
);

-- Write a query to select article which does not have more than one comment by the same user 
-- ( do this using left join and group by )

SELECT a.id, a.title, a.content
FROM articles a
LEFT JOIN comments c ON a.id = c.article_id
GROUP BY a.id
HAVING COUNT(c.id) = COUNT(DISTINCT c.user_id);

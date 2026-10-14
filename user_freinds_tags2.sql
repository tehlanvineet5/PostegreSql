CREATE TABLE users (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE friends (
    user_id INTEGER NOT NULL REFERENCES users(id),
    friend_id INTEGER NOT NULL REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, friend_id),
    CHECK (user_id <> friend_id)
);

CREATE TABLE images (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    image_user INTEGER NOT NULL REFERENCES users(id),
    filename TEXT NOT NULL
);

CREATE TABLE tags (
    image_id INTEGER NOT NULL REFERENCES images(id) ON DELETE CASCADE,
    tagged_user INTEGER NOT NULL REFERENCES users(id),
    PRIMARY KEY (image_id, tagged_user)
);

INSERT INTO users (name)
VALUES
    ('user 1'),
    ('user 2'),
    ('user 3'),
    ('user 4'),
    ('user 5');

INSERT INTO friends (user_id, friend_id)
VALUES
    (1, 2),
    (1, 3),
    (1, 4),
    (2, 1),
    (3, 1),
    (4, 1),
    (2, 3),
    (2, 4),
    (3, 2),
    (4, 2);

INSERT INTO images (image_user, filename)
VALUES
    (1, 'user1_pic1.jpg'),
    (1, 'user1_pic2.jpg'),
    (2, 'user2_pic1.jpg'),
    (2, 'user2_pic2.jpg'),
    (2, 'user2_pic3.jpg'),
    (3, 'user3_pic1.jpg'),
    (3, 'user3_pic2.jpg'),
    (4, 'user4_pic1.jpg'),
    (4, 'user4_pic2.jpg'),
    (5, 'user5_pic1.jpg');

INSERT INTO tags (image_id, tagged_user)
VALUES
    (1, 2),
    (1, 3),
    (2, 2),
    (2, 3),
    (3, 1),
    (4, 1),
    (5, 1),
    (6, 1),
    (7, 1),
    (8, 1),
    (9, 2),
    (10, 1);

SELECT * FROM users;

SELECT * FROM friends;

SELECT * FROM images;

SELECT * FROM tags;

CREATE INDEX idx_images_image_user
ON images(image_user);

CREATE INDEX idx_tags_tagged_user
ON tags(tagged_user);

--Find the image that has been tagged the most number of times.


SELECT i.id, i.filename
FROM images AS i
JOIN tags AS t ON i.id = t.image_id
GROUP BY i.id, i.filename
ORDER BY COUNT(*) DESC
LIMIT 1;


-- Find all images belonging to the friends of a particular user.( USER 1)

with friends_id as (
	select friend_id from friends f
	join users u on f.user_id = u.id
	where u.name = 'user 1'
)
select i.id,i.filename 
from images i 
where i.image_user in (select friend_id from friends_id);



-- Find all friends of a particular user (say, user 1) who have tagged him(user 1) in all of their pics.

WITH friends_id AS (
    SELECT friend_id
    FROM friends f
    JOIN users u ON f.user_id = u.id
    WHERE u.name = 'user 1'
),
users_tagged_user1 AS (
    SELECT i.image_user
    FROM images i
    JOIN tags t ON i.id = t.image_id
    WHERE t.tagged_user = 1
    GROUP BY i.image_user
    HAVING COUNT(DISTINCT i.id) = (
        SELECT COUNT(*)
        FROM images i2
        WHERE i2.image_user = i.image_user
    )
)
SELECT friend_id
FROM friends_id
WHERE friend_id IN (
    SELECT image_user
    FROM users_tagged_user1
);



-- Find the friend(s) of a particular user (say, user 1) who has tagged him(user 1) 
-- the most number of times in their images.


WITH friends_id AS (
    SELECT friend_id
    FROM friends
    JOIN users ON users.id = friends.user_id
    WHERE users.name = 'user 1'
),
images_users_count AS (
    SELECT image_user, COUNT(*) AS total_count
    FROM images i
    JOIN tags t ON t.image_id = i.id
    WHERE t.tagged_user = 1
    GROUP BY image_user
)
SELECT f.friend_id
FROM friends_id f
JOIN images_users_count iuc
    ON f.friend_id = iuc.image_user
ORDER BY iuc.total_count DESC
LIMIT 1;


CREATE TABLE subscribers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT UNIQUE
        CHECK (TRIM(email) ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'),
    phone_number TEXT
        CHECK (TRIM(phone_number) ~ '^[0-9]+$'),
    city TEXT NOT NULL
        CHECK (TRIM(city) <> '')
);


-- What all cities did people respond from
SELECT DISTINCT city
FROM subscribers
ORDER BY city;

-- How many people responded from each city
SELECT city, COUNT(*) AS people_responded
FROM subscribers
GROUP BY city
ORDER BY people_responded DESC;

-- Which city were the maximum respondents from?
SELECT city, COUNT(*) AS people_responded
FROM subscribers
GROUP BY city
ORDER BY people_responded DESC
LIMIT 1;

-- What all email domains did people respond from ?
SELECT DISTINCT SPLIT_PART(email, '@', 2) AS email_domain
FROM subscribers
ORDER BY email_domain;

-- Which is the most popular email domain among the respondents ?
SELECT
    SPLIT_PART(email, '@', 2) AS email_domain,
    COUNT(*) AS respondent
FROM subscribers
GROUP BY SPLIT_PART(email, '@', 2)
ORDER BY respondent DESC
LIMIT 1;



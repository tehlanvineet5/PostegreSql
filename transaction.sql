CREATE TABLE IF NOT EXISTS accounts (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_no TEXT UNIQUE
        CHECK (account_no ~ '^[0-9]{5,15}$'),
    balance NUMERIC(10,2)
        CHECK (balance >= 0)
);


CREATE TABLE IF NOT EXISTS users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE
        CHECK (email ~* '^[A-Z0-9.-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'),
    account_id INT UNIQUE
        REFERENCES accounts(id)
);

INSERT INTO accounts (account_no, balance)
VALUES
('100100100', 5000.00),
('200200200', 3000.00),
('300300300', 7000.00);

INSERT INTO users (name, email, account_id)
VALUES
('User A', 'usera@gmail.com', 1),
('User B', 'userb@gmail.com', 2),
('User C', 'userc@gmail.com', 3);

SELECT * FROM users;

SELECT * FROM accounts;

-- USER A DEPOSIT 1000 Rs.

BEGIN;

UPDATE accounts 
SET balance = balance + 1000
WHERE id = (
	SELECT account_id
	from users
	WHERE name = 'User A'
);

COMMIT;

SELECT * FROM accounts;

-- USER A WITHDRAWS 500 Rs.

BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE id = (
    SELECT account_id
    FROM users
    WHERE name = 'User A'
)
AND balance >= 500;

COMMIT;

SELECT * FROM accounts;

-- USER A transfers 200 RS. to USER B

BEGIN;

UPDATE accounts
SET balance = balance - 200
WHERE id = (
    SELECT account_id
    FROM users
    WHERE name = 'User A'
)
AND balance >= 200;

UPDATE accounts
SET balance = balance + 200
WHERE id = (
    SELECT account_id
    FROM users
    WHERE name = 'User B'
);

COMMIT;

SELECT * FROM accounts;
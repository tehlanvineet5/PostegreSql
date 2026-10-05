CREATE TABLE IF NOT EXISTS testing_table (
	name TEXT,
	contact_name TEXT,
	roll_no TEXT
);

ALTER TABLE testing_table DROP COLUMN IF EXISTS name;

ALTER TABLE testing_table
RENAME COLUMN contact_name TO username;

ALTER TABLE testing_table
ADD COLUMN IF NOT EXISTS first_name TEXT,
ADD COLUMN IF NOT EXISTS last_name TEXT;

ALTER TABLE testing_table
ALTER COLUMN roll_no TYPE INTEGER
USING roll_no::INTEGER;
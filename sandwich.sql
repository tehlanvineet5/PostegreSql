CREATE TABLE IF NOT EXISTS Tastes(
	Name TEXT,
	Filling TEXT,
	PRIMARY KEY(Name, Filling)
);
CREATE TABLE IF NOT EXISTS Locations(
	LName TEXT PRIMARY KEY,
	Phone TEXT,
	Address TEXT
);
CREATE TABLE IF NOT EXISTS Sandwiches(
	Location TEXT REFERENCES Locations(Lname),
	Bread TEXT,
	Filling TEXT,
	Price NUMERIC(10,2),
	PRIMARY KEY(Location, Bread, Filling)
);
INSERT INTO Tastes (Name, Filling) VALUES
('Brown', 'Turkey'),
('Brown', 'Beef'),
('Brown', 'Ham'),
('Jones', 'Cheese'),
('Green', 'Beef'),
('Green', 'Turkey'),
('Green', 'Cheese');

INSERT INTO Locations (LName, Phone, Address) VALUES
('Lincoln', '683 4523', 'Lincoln Place'),
('O''Neils', '674 2134', 'Pearse St'),
('Old Nag', '767 8132', 'Dame St'),
('Buttery', '702 3421', 'College St');

INSERT INTO Sandwiches (Location, Bread, Filling, Price) VALUES
('Lincoln', 'Rye', 'Ham', 1.25),
('O''Neils', 'White', 'Cheese', 1.200),
('O''Neils', 'Whole', 'Ham', 1.25),
('Old Nag', 'Rye', 'Beef', 1.35),
('Buttery', 'White', 'Cheese', 1.00),
('O''Neils', 'White', 'Turkey', 1.35),
('Buttery', 'White', 'Ham', 1.10),
('Lincoln', 'Rye', 'Beef', 1.35),
('Lincoln', 'White', 'Ham', 1.30),
('Old Nag', 'Rye', 'Ham', 1.40);

-- places where Jones can eat (using a nested subquery)
SELECT *
FROM Locations
WHERE LName IN (
    SELECT Location
    FROM Sandwiches
    WHERE Filling IN (
        SELECT Filling
        FROM Tastes
        WHERE Name = 'Jones'
    )
);

-- places where Jones can eat (without using a nested subquery)
SELECT l.LName, l.Phone, l.Address
FROM Locations AS l
JOIN Sandwiches AS s
    ON l.LName = s.Location
JOIN Tastes AS t
    ON s.Filling = t.Filling
WHERE t.Name = 'Jones';

-- for each location the number of people who can eat there
SELECT s.Location,
       COUNT(DISTINCT t.Name) AS number_of_people
FROM Sandwiches AS s
JOIN Tastes AS t
    ON s.Filling = t.Filling
GROUP BY s.Location;
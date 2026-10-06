CREATE TABLE IF NOT EXISTS Branch
(
	BCode TEXT PRIMARY KEY,
	Librarian TEXT,
	Address TEXT
);

CREATE TABLE IF NOT EXISTS Titles
(
	Title TEXT PRIMARY KEY ,
	Author TEXT,
	Publisher TEXT
);

CREATE TABLE IF NOT EXISTS Holdings
(
	Branch TEXT REFERENCES Branch(BCode),
	Title TEXT REFERENCES Titles(Title),
	Copies INTEGER,
	PRIMARY KEY(Branch, Title)
);

INSERT INTO Branch (BCode, Librarian, Address) VALUES
('B1', 'John Smith', '2 Anglesea Rd'),
('B2', 'Mary Jones', '34 Pearse St'),
('B3', 'Francis Owens', 'Grange X');

INSERT INTO Titles (Title, Author, Publisher) VALUES
('Susannah', 'Ann Brown', 'Macmillan'),
('How to Fish', 'Amy Fly', 'Stop Press'),
('A History of Dublin', 'David Little', 'Wiley'),
('Computers', 'Blaise Pascal', 'Applewoods'),
('The Wife', 'Ann Brown', 'Macmillan');

INSERT INTO Holdings (Branch, Title, Copies) VALUES
('B1', 'Susannah', 3),
('B1', 'How to Fish', 2),
('B1', 'A History of Dublin', 1),
('B2', 'How to Fish', 4),
('B2', 'Computers', 2),
('B2', 'The Wife', 3),
('B3', 'A History of Dublin', 1),
('B3', 'Computers', 4),
('B3', 'Susannah', 3),
('B3', 'The Wife', 1);

-- Names of all library books published by Macmillan
SELECT Title
FROM Titles
WHERE Publisher = 'Macmillan';

-- Branches that hold any books by Ann Brown(using a nested subquery)
SELECT DISTINCT Branch
FROM Holdings
WHERE Title IN (
    SELECT Title
    FROM Titles
    WHERE Author = 'Ann Brown'
);

-- Branches that hold any books by Ann Brown (without using a nested subquery)
SELECT DISTINCT h.Branch
FROM Holdings AS h
JOIN Titles AS t
    ON h.Title = t.Title
WHERE t.Author = 'Ann Brown';

-- Total number of books held at each branch
SELECT Branch,
       SUM(Copies) AS number_of_books
FROM Holdings
GROUP BY Branch;

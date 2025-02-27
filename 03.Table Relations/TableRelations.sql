CREATE DATABASE TableRelationsExercise

USE TableRelationsExercise

-- Task 1 - One-To-One Relationship
	CREATE TABLE Persons (
		PersonID INT IDENTITY(1,1),
		FirstName NVARCHAR(60) NOT NULL,
		Salary MONEY NOT NULL,
		PassportID INT UNIQUE NOT NULL
	)

	CREATE TABLE Passports (
		PassportID INT UNIQUE NOT NULL,
		PassportNumber VARCHAR(100)
	)

	INSERT INTO Persons
	VALUES
	('Roberto', 43300.00, 102),
	('Tom', 56100.00, 103),
	('Yana', 60200.00, 101)

	INSERT INTO Passports
	VALUES
	(101, 'N34FG21B'),
	(102, 'K65LO4R7'),
	(103, 'ZE657QP2')

	ALTER TABLE Persons
	ADD CONSTRAINT PK_PersonID PRIMARY KEY(PersonID)

	ALTER TABLE Passports
	ADD CONSTRAINT PK_PassportID PRIMARY KEY(PassportID)

	ALTER TABLE Persons
	ADD CONSTRAINT FK_PersonID FOREIGN KEY(PassportID) REFERENCES Passports(PassportID)
--

-- Task 2 - One-To-Many Relationship
	CREATE TABLE Models (
		ModelID INT UNIQUE NOT NULL,
		Name NVARCHAR(60) NOT NULL,
		ManufacturerID INT NOT NULL
	)

	CREATE TABLE Manufacturers (
		ManufacturerID INT IDENTITY(1,1),
		Name VARCHAR(60) NOT NULL,
		EstablishedOn SMALLDATETIME NOT NULL
	)

	INSERT INTO Models
	VALUES
	(101, 'X1', 1),
	(102, 'i6', 1),
	(103, 'Model S', 2),
	(104, 'Model X', 2),
	(105, 'Model 3', 2),
	(106, 'Nova', 3)

	INSERT INTO Manufacturers
	VALUES
	('BMW', '07/03/1916'),
	('Tesla', '01/01/2003'),
	('Lada', '01/05/1966')

	ALTER TABLE Manufacturers
	ADD CONSTRAINT PK_ManufacturerID PRIMARY KEY (ManufacturerID)

	ALTER TABLE Models
	ADD CONSTRAINT PK_ModelID PRIMARY KEY (ModelID)

	ALTER TABLE Models
	ADD CONSTRAINT FK_ManufacturerID FOREIGN KEY (ManufacturerID) REFERENCES Manufacturers (ManufacturerID)
--

-- Task 3 - Many-To-Many Relationship
	CREATE TABLE Students (
		StudentID INT IDENTITY(1,1) PRIMARY KEY,
		Name NVARCHAR(60) NOT NULL
)

	CREATE TABLE Exams (
		ExamID INT NOT NULL PRIMARY KEY,
		Name NVARCHAR(60) NOT NULL
)

	CREATE TABLE StudentsExams (
		StudentID INT NOT NULL,
		ExamID INT NOT NULL,
		PRIMARY KEY (StudentID, ExamID),
		FOREIGN KEY (StudentID) REFERENCES Students (StudentID),
		FOREIGN KEY (ExamID) REFERENCES Exams (ExamID)
)

	INSERT INTO Students (Name)
	VALUES
	('Mila'),
	('Toni'),
	('Ron')
	
	INSERT INTO Exams (ExamID, Name)
	VALUES
    (101, 'SpringMVC'),
    (102, 'Neo4j'),
    (103, 'Oracle 11g')

	INSERT INTO StudentsExams (StudentID, ExamID)
	VALUES
    (1, 101),
    (1, 102),
    (2, 101),
    (3, 103),
    (2, 102),
    (2, 103)
--

-- Task 4 - Self-Referencing
	CREATE TABLE Teachers (
		TeacherID INT PRIMARY KEY,
		Name NVARCHAR(60) NOT NULL,
		ManagerID INT,
		FOREIGN KEY (ManagerID) REFERENCES Teachers (TeacherID)
	)

	INSERT INTO Teachers (TeacherID, Name, ManagerID)
	VALUES
	(101, 'John', NULL),
	(102, 'Maya', 106),
	(103, 'Silvia', 106),
	(104, 'Ted', 105),
	(105, 'Mark', 101),
	(106, 'Greta', 101)
--

-- Task 5 - Online Store Database
	CREATE TABLE ItemTypes (
		ItemTypeID INT PRIMARY KEY NOT NULL,
		Name NVARCHAR(60) NOT NULL
	)

	CREATE TABLE Items (
		ItemID INT PRIMARY KEY NOT NULL,
		Name NVARCHAR(60) NOT NULL,
		ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes (ItemTypeID) NOT NULL
	)

	CREATE TABLE Cities (
		CityID INT PRIMARY KEY NOT NULL,
		Name NVARCHAR(60) NOT NULL,
	)

	CREATE TABLE Customers (
		CustomerID INT PRIMARY KEY NOT NULL,
		Name NVARCHAR(60) NOT NULL,
		Birthday DATETIME2 NOT NULL,
		CityID INT FOREIGN KEY REFERENCES Cities (CityID) NOT NULL
	)

	CREATE TABLE Orders (
		OrderID INT PRIMARY KEY NOT NULL,
		CustomerID INT FOREIGN KEY REFERENCES Customers (CustomerID) NOT NULL
	)

	CREATE TABLE OrderItems (
		OrderID INT NOT NULL,
		ItemID INT NOT NULL,
		PRIMARY KEY (OrderID, ItemID),
		FOREIGN KEY (ItemID) REFERENCES Items (ItemID),
		FOREIGN KEY (OrderID) REFERENCES Orders (OrderID)
	)
--

-- Task 6 - Univerity Database
	CREATE TABLE Subjects (
		SubjectID INT PRIMARY KEY NOT NULL,
		SubjectName NVARCHAR(100) NOT NULL
	)

	CREATE TABLE Majors (
		MajorID INT PRIMARY KEY NOT NULL,
		Name NVARCHAR(60)
	)

	CREATE TABLE Students (
		StudentID INT PRIMARY KEY NOT NULL,
		StudentNumber INT NOT NULL,
		StudentName NVARCHAR(60) NOT NULL,
		MajorID INT FOREIGN KEY REFERENCES Majors (MajorID)
	)

	CREATE TABLE Agenda (
		StudentID INT NOT NULL,
		SubjectID INT NOT NULL,
		PRIMARY KEY (StudentID, SubjectID),
		FOREIGN KEY (StudentID) REFERENCES Students (StudentID),
		FOREIGN KEY (SubjectID) REFERENCES Subjects (SubjectID)
	)

	CREATE TABLE Payments (
		PaymentID INT PRIMARY KEY NOT NULL,
		PaymentDate DATETIME2 NOT NULL,
		PaymentAmount MONEY NOT NULL,
		StudentID INT FOREIGN KEY REFERENCES Students (StudentID) NOT NULL
	)
--

-- Task 9 - Peaks in Rila		
	SELECT 		mr.MountainRange AS MountainRange,
				p.PeakName AS PeakName,
				p.Elevation AS Elevation

	FROM		Mountains AS mr
   
	JOIN		Peaks AS p ON mr.Id = p.MountainId
    
	WHERE		mr.MountainRange = 'Rila'
	ORDER BY	p.Elevation DESC

--
-- Task 1 - Create Database
	CREATE DATABASE [Minions]
--

USE [Minions]

-- Task 2 - Create Tables
	CREATE TABLE [Minions] (
	[Id] INT NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(80) NOT NULL,
	[Age] TINYINT
	)

	CREATE TABLE [Towns] (
	[Id] INT NOT NULL PRIMARY KEY,
	[Name] NVARCHAR(80) NOT NULL,
	)
--

-- Task 3 - Alter Minions Table
	ALTER TABLE [Minions] 
	ADD [TownId] INT
	
	ALTER TABLE [Minions]
	ADD CONSTRAINT Make_TownId_FK FOREIGN KEY ([TownId]) REFERENCES [Towns]([Id]);
--

-- Task 4 - Insert Records in Both Tables
	INSERT INTO [Towns]([Id], [Name])
	VALUES
	(1, 'Sofia'),
	(2, 'Plovdiv'),
	(3, 'Varna')

	INSERT INTO Minions([Id], [Name], [Age], [TownId])
	VALUES
	(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', NULL, 2)
--

-- Task 5 - Truncate Table Minions
	TRUNCATE TABLE [Minions] 
--

-- Task 6 - Drop All Tables
	DROP TABLE [Minions], [Towns]
--

--Task 7 - Create Table People
	CREATE TABLE [People] (
    [Id] BIGINT IDENTITY(1, 1) PRIMARY KEY,
    [Name] NVARCHAR(200) NOT NULL,
    [Picture] VARBINARY(MAX) NULL,
    [Height] DECIMAL(4, 2) NULL,
    [Weight] DECIMAL(5, 2) NULL,
    [Gender] CHAR(1) NOT NULL CHECK (Gender IN ('m', 'f')),
    [Birthdate] DATE NOT NULL,
    [Biography] NVARCHAR(MAX) NULL
	)


	INSERT INTO [People] ([Name], [Picture], [Height], [Weight], [Gender], [Birthdate], [Biography]) 
VALUES
    ('Ivan M.', NULL, 1.56, 96.00, 'm', '2000-01-01', NULL),
    ('George J.', NULL, 2.06, 90.00, 'm', '1995-05-15', 'Professional basketball player.'),
    ('Maria K.', NULL, 1.60, 60.00, 'f', '1998-12-25', 'Loves painting and traveling.'),
    ('Steven S.', NULL, 1.86, 75.00, 'm', '1985-07-20', 'Software engineer with a passion for AI.'),
    ('Alexandra I.', NULL, 1.66, 58.00, 'f', '1992-03-08', 'Aspiring writer and marathon runner.');
--												  							   
												  
-- Task 8 - Create Table Users
	CREATE TABLE [Users] (
    [Id] BIGINT IDENTITY(1, 1) PRIMARY KEY,
    [Username] CHAR(30) UNIQUE NOT NULL,
    [Password] CHAR(26) NOT NULL,
    [ProfilePicture] VARBINARY(MAX) NULL,
    [LastLoginTime] DATETIME2 NULL,
    [IsDeleted] TINYINT NOT NULL CHECK (IsDeleted IN (0, 1))
	)


	INSERT INTO [Users] ([Username], [Password], [ProfilePicture], [LastLoginTime], [IsDeleted]) 
	VALUES
    ('user1', 'password1234567890abcdef', NULL, GETDATE(), 0),
    ('user2', 'password0987654321abcdef', NULL, GETDATE(), 0),
    ('user3', 'password112233445566778899', NULL, GETDATE(), 1),
    ('user4', 'passwordabcdefgh12345678', NULL, GETDATE(), 0),
    ('user5', 'passwordqwertyuiopasdfgh', NULL, GETDATE(), 0);
--

-- Task 9 - Change Primary Key	
	ALTER TABLE [Users]
	DROP CONSTRAINT PK__Users__3214EC07F7D7EBA9;

	ALTER TABLE [Users]
	ADD CONSTRAINT PK_Users_Composite PRIMARY KEY ([Id], [Username]);
--

-- Task 10 - Add Check Constraint
	ALTER TABLE [Users]
	ADD CONSTRAINT CHK_Password_Length CHECK (LEN([Password]) >= 5);
--

-- Task 11 - Set Default Value of a Field
	ALTER TABLE [Users]
	ADD CONSTRAINT DF_Users_LastLoginTime DEFAULT (GETDATE()) FOR [LastLoginTime];
--

-- Task 12 - Set Unique Field
	ALTER TABLE [Users]
	DROP CONSTRAINT PK_Users_Composite;

	ALTER TABLE [Users]
	ADD CONSTRAINT PK_Users PRIMARY KEY ([Id]);

	ALTER TABLE [Users]
	ADD CONSTRAINT UQ_Users_Username UNIQUE ([Username]);

	ALTER TABLE [Users]
	ADD CONSTRAINT CHK_Username_Length CHECK (LEN([Username]) >= 3);
--

-- Task 13 - Movies Database
	CREATE DATABASE [Movies]

	USE [Movies]

	CREATE TABLE [Directors] (
		[Id] INT IDENTITY(1,1) PRIMARY KEY,
		[DirectorName] NVARCHAR(100) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [Genres] (
		[Id] INT IDENTITY(1,1) PRIMARY KEY,
		[GenreName] NVARCHAR(50) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [Categories] (
		[Id] INT IDENTITY(1,1) PRIMARY KEY,
		[CategoryName] NVARCHAR(50) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [Movies] (
		[Id] INT IDENTITY(1,1) PRIMARY KEY,
		[Title] NVARCHAR(150) NOT NULL,
		[DirectorId] INT NOT NULL,
		[CopyrightYear] INT NOT NULL CHECK ([CopyrightYear] >= 1888),
		[Length] DECIMAL(5, 2) NULL,
		[GenreId] INT NOT NULL,
		[CategoryId] INT NOT NULL,
		[Rating] NVARCHAR(10) NULL,
		[Notes] NVARCHAR(MAX) NULL,
		CONSTRAINT [FK_Movies_Directors] FOREIGN KEY ([DirectorId]) REFERENCES [Directors]([Id]),
		CONSTRAINT [FK_Movies_Genres] FOREIGN KEY ([GenreId]) REFERENCES [Genres]([Id]),
		CONSTRAINT [FK_Movies_Categories] FOREIGN KEY ([CategoryId]) REFERENCES [Categories]([Id])
	);

	INSERT INTO [Directors] ([DirectorName], [Notes])
	VALUES
	('Steven Spielberg', 'Famous for blockbusters like Jaws and E.T.'),
	('Christopher Nolan', 'Known for complex narratives'),
	('Martin Scorsese', 'Renowned for gangster films'),
	('Greta Gerwig', 'Prominent modern female director'),
	('Quentin Tarantino', 'Master of dialogues and non-linear storytelling');

	INSERT INTO [Genres] ([GenreName], [Notes])
	VALUES
	('Action', 'Fast-paced movies with lots of excitement'),
	('Drama', 'Emotionally driven narratives'),
	('Comedy', 'Humorous and entertaining films'),
	('Horror', 'Scary and suspenseful movies'),
	('Science Fiction', 'Explores futuristic and imaginative themes');

	INSERT INTO [Categories] ([CategoryName], [Notes])
	VALUES
	('Blockbuster', 'High-budget, high-grossing movies'),
	('Indie', 'Independent films with low budgets'),
	('Classic', 'Timeless movies from past decades'),
	('Modern', 'Contemporary movies from the 21st century'),
	('Animation', 'Movies created using animated techniques');

	INSERT INTO [Movies] ([Title], [DirectorId], [CopyrightYear], [Length], [GenreId], [CategoryId], [Rating], [Notes])
	VALUES
	('Inception', 2, 2010, 2.28, 5, 4, 'PG-13', 'A mind-bending thriller by Nolan'),
	('Jaws', 1, 1975, 2.04, 1, 3, 'PG', 'The original summer blockbuster'),
	('Pulp Fiction', 5, 1994, 2.34, 2, 3, 'R', 'Quentin Tarantino''s masterpiece'),
	('Little Women', 4, 2019, 2.15, 2, 4, 'PG', 'Modern adaptation of the classic novel'),
	('The Shining', 3, 1980, 2.26, 4, 3, 'R', 'A horror classic by Stanley Kubrick');
--

-- Task 14 - Car Rental Database
	CREATE DATABASE [CarRental];

	USE [CarRental];

	CREATE TABLE [Categories] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[CategoryName] NVARCHAR(50) NOT NULL,
		[DailyRate] DECIMAL(10, 2) NOT NULL,
		[WeeklyRate] DECIMAL(10, 2) NOT NULL,
		[MonthlyRate] DECIMAL(10, 2) NOT NULL,
		[WeekendRate] DECIMAL(10, 2) NOT NULL
	);

	CREATE TABLE [Cars] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[PlateNumber] NVARCHAR(20) UNIQUE NOT NULL,
		[Manufacturer] NVARCHAR(50) NOT NULL,
		[Model] NVARCHAR(50) NOT NULL,
		[CarYear] INT NOT NULL CHECK ([CarYear] >= 1886),
		[CategoryId] INT NOT NULL,
		[Doors] TINYINT NOT NULL CHECK ([Doors] BETWEEN 2 AND 5),
		[Picture] VARBINARY(MAX) NULL,
		[Condition] NVARCHAR(20) NOT NULL,
		[Available] TINYINT NOT NULL CHECK ([Available] IN (0, 1)),
		CONSTRAINT [FK_Cars_Categories] FOREIGN KEY ([CategoryId]) REFERENCES [Categories]([Id])
	);

	CREATE TABLE [Employees] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[FirstName] NVARCHAR(50) NOT NULL,
		[LastName] NVARCHAR(50) NOT NULL,
		[Title] NVARCHAR(50) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [Customers] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[DriverLicenceNumber] NVARCHAR(20) UNIQUE NOT NULL,
		[FullName] NVARCHAR(100) NOT NULL,
		[Address] NVARCHAR(150) NOT NULL,
		[City] NVARCHAR(50) NOT NULL,
		[ZIPCode] NVARCHAR(10) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [RentalOrders] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[EmployeeId] INT NOT NULL,
		[CustomerId] INT NOT NULL,
		[CarId] INT NOT NULL,
		[TankLevel] TINYINT NOT NULL CHECK ([TankLevel] BETWEEN 0 AND 100),
		[KilometrageStart] DECIMAL(10, 2) NOT NULL,
		[KilometrageEnd] DECIMAL(10, 2) NULL,
		[TotalKilometrage] DECIMAL(10, 2) NULL,
		[StartDate] DATETIME2 NOT NULL,
		[EndDate] DATETIME2 NULL,
		[TotalDays] INT NULL,
		[RateApplied] DECIMAL(10, 2) NOT NULL,
		[TaxRate] DECIMAL(5, 2) NOT NULL,
		[OrderStatus] NVARCHAR(20) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL,
		CONSTRAINT [FK_RentalOrders_Employees] FOREIGN KEY ([EmployeeId]) REFERENCES [Employees]([Id]),
		CONSTRAINT [FK_RentalOrders_Customers] FOREIGN KEY ([CustomerId]) REFERENCES [Customers]([Id]),
		CONSTRAINT [FK_RentalOrders_Cars] FOREIGN KEY ([CarId]) REFERENCES [Cars]([Id])
	);

	INSERT INTO [Categories] ([CategoryName], [DailyRate], [WeeklyRate], [MonthlyRate], [WeekendRate])
	VALUES 
	('Economy', 29.99, 199.99, 699.99, 39.99),
	('SUV', 49.99, 329.99, 1099.99, 59.99),
	('Luxury', 99.99, 699.99, 2499.99, 129.99);

	INSERT INTO [Cars] ([PlateNumber], [Manufacturer], [Model], [CarYear], [CategoryId], [Doors], [Picture], [Condition], [Available])
	VALUES 
	('ABC123', 'Toyota', 'Corolla', 2020, 1, 4, NULL, 'Excellent', 1),
	('DEF456', 'Ford', 'Explorer', 2019, 2, 4, NULL, 'Good', 1),
	('GHI789', 'BMW', '7 Series', 2022, 3, 4, NULL, 'New', 1);

	INSERT INTO [Employees] ([FirstName], [LastName], [Title], [Notes])
	VALUES 
	('John', 'Doe', 'Manager', NULL),
	('Alice', 'Smith', 'Clerk', 'Works on weekends'),
	('Bob', 'Johnson', 'Mechanic', 'Specialist in SUVs');

	INSERT INTO [Customers] ([DriverLicenceNumber], [FullName], [Address], [City], [ZIPCode], [Notes])
	VALUES 
	('DL12345', 'Jane Doe', '123 Main St', 'Springfield', '12345', NULL),
	('DL67890', 'Tom Hardy', '456 Elm St', 'Riverdale', '67890', 'VIP Customer'),
	('DL11223', 'Anna Bell', '789 Oak St', 'Greenville', '11223', 'Prefers economy cars');

	INSERT INTO [RentalOrders] ([EmployeeId], [CustomerId], [CarId], [TankLevel], [KilometrageStart], [KilometrageEnd], [TotalKilometrage], [StartDate], [EndDate], [TotalDays], [RateApplied], [TaxRate], [OrderStatus], [Notes])
	VALUES 
	(1, 1, 1, 100, 12000.50, NULL, NULL, GETDATE(), NULL, NULL, 29.99, 10.00, 'Pending', 'First rental'),
	(2, 2, 2, 50, 15000.75, 15050.75, 50.00, GETDATE(), DATEADD(DAY, 3, GETDATE()), 3, 49.99, 12.50, 'Completed', 'Returned with minor scratches'),
	(3, 3, 3, 75, 8000.00, 8050.00, 50.00, GETDATE(), DATEADD(DAY, 1, GETDATE()), 1, 99.99, 15.00, 'Completed', 'One-day luxury rental');
--

-- Task 15 - Hotel Database
	CREATE DATABASE [Hotel];

	USE [Hotel];

	CREATE TABLE [Employees] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[FirstName] NVARCHAR(50) NOT NULL,
		[LastName] NVARCHAR(50) NOT NULL,
		[Title] NVARCHAR(50) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [Customers] (
		[AccountNumber] NVARCHAR(20) PRIMARY KEY,
		[FirstName] NVARCHAR(50) NOT NULL,
		[LastName] NVARCHAR(50) NOT NULL,
		[PhoneNumber] NVARCHAR(15) NOT NULL,
		[EmergencyName] NVARCHAR(50) NULL,
		[EmergencyNumber] NVARCHAR(15) NULL,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [RoomStatus] (
		[RoomStatus] NVARCHAR(20) PRIMARY KEY,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [RoomTypes] (
		[RoomType] NVARCHAR(20) PRIMARY KEY,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [BedTypes] (
		[BedType] NVARCHAR(20) PRIMARY KEY,
		[Notes] NVARCHAR(MAX) NULL
	);

	CREATE TABLE [Rooms] (
		[RoomNumber] INT PRIMARY KEY,
		[RoomType] NVARCHAR(20) NOT NULL,
		[BedType] NVARCHAR(20) NOT NULL,
		[Rate] DECIMAL(10, 2) NOT NULL,
		[RoomStatus] NVARCHAR(20) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL,
		CONSTRAINT [FK_Rooms_RoomTypes] FOREIGN KEY ([RoomType]) REFERENCES [RoomTypes]([RoomType]),
		CONSTRAINT [FK_Rooms_BedTypes] FOREIGN KEY ([BedType]) REFERENCES [BedTypes]([BedType]),
		CONSTRAINT [FK_Rooms_RoomStatus] FOREIGN KEY ([RoomStatus]) REFERENCES [RoomStatus]([RoomStatus])
	);

	CREATE TABLE [Payments] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[EmployeeId] INT NOT NULL,
		[PaymentDate] DATETIME2 NOT NULL,
		[AccountNumber] NVARCHAR(20) NOT NULL,
		[FirstDateOccupied] DATETIME2 NOT NULL,
		[LastDateOccupied] DATETIME2 NOT NULL,
		[TotalDays] INT NOT NULL,
		[AmountCharged] DECIMAL(10, 2) NOT NULL,
		[TaxRate] DECIMAL(5, 2) NOT NULL,
		[TaxAmount] DECIMAL(10, 2) NOT NULL,
		[PaymentTotal] DECIMAL(10, 2) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL,
		CONSTRAINT [FK_Payments_Employees] FOREIGN KEY ([EmployeeId]) REFERENCES [Employees]([Id]),
		CONSTRAINT [FK_Payments_Customers] FOREIGN KEY ([AccountNumber]) REFERENCES [Customers]([AccountNumber])
	);

	CREATE TABLE [Occupancies] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[EmployeeId] INT NOT NULL,
		[DateOccupied] DATETIME2 NOT NULL,
		[AccountNumber] NVARCHAR(20) NOT NULL,
		[RoomNumber] INT NOT NULL,
		[RateApplied] DECIMAL(10, 2) NOT NULL,
		[PhoneCharge] DECIMAL(10, 2) NOT NULL,
		[Notes] NVARCHAR(MAX) NULL,
		CONSTRAINT [FK_Occupancies_Employees] FOREIGN KEY ([EmployeeId]) REFERENCES [Employees]([Id]),
		CONSTRAINT [FK_Occupancies_Customers] FOREIGN KEY ([AccountNumber]) REFERENCES [Customers]([AccountNumber]),
		CONSTRAINT [FK_Occupancies_Rooms] FOREIGN KEY ([RoomNumber]) REFERENCES [Rooms]([RoomNumber])
	);

	INSERT INTO [Employees] ([FirstName], [LastName], [Title], [Notes])
	VALUES 
	('John', 'Doe', 'Manager', NULL),
	('Jane', 'Smith', 'Receptionist', NULL),
	('Bob', 'Johnson', 'Housekeeper', NULL);

	INSERT INTO [Customers] ([AccountNumber], [FirstName], [LastName], [PhoneNumber], [EmergencyName], [EmergencyNumber], [Notes])
	VALUES 
	('CUST001', 'Alice', 'Brown', '1234567890', 'Tom Brown', '9876543210', NULL),
	('CUST002', 'Mark', 'Davis', '1122334455', 'Anna Davis', '5544332211', NULL),
	('CUST003', 'Emma', 'Wilson', '2233445566', 'John Wilson', '6655443322', NULL);

	INSERT INTO [RoomStatus] ([RoomStatus], [Notes])
	VALUES 
	('Available', NULL),
	('Occupied', NULL),
	('Maintenance', NULL);

	INSERT INTO [RoomTypes] ([RoomType], [Notes])
	VALUES 
	('Standard', NULL),
	('Deluxe', NULL),
	('Suite', NULL);

	INSERT INTO [BedTypes] ([BedType], [Notes])
	VALUES 
	('Single', NULL),
	('Double', NULL),
	('Queen', NULL);

	INSERT INTO [Rooms] ([RoomNumber], [RoomType], [BedType], [Rate], [RoomStatus], [Notes])
	VALUES 
	(101, 'Standard', 'Single', 100.00, 'Available', NULL),
	(102, 'Deluxe', 'Double', 200.00, 'Occupied', NULL),
	(103, 'Suite', 'Queen', 300.00, 'Maintenance', NULL);

	INSERT INTO [Payments] ([EmployeeId], [PaymentDate], [AccountNumber], [FirstDateOccupied], [LastDateOccupied], [TotalDays], [AmountCharged], [TaxRate], [TaxAmount], [PaymentTotal], [Notes])
	VALUES 
	(1, GETDATE(), 'CUST001', '2025-01-01', '2025-01-03', 2, 200.00, 10.00, 20.00, 220.00, NULL),
	(2, GETDATE(), 'CUST002', '2025-01-02', '2025-01-05', 3, 600.00, 10.00, 60.00, 660.00, NULL),
	(3, GETDATE(), 'CUST003', '2025-01-04', '2025-01-06', 2, 600.00, 10.00, 60.00, 660.00, NULL);

	INSERT INTO [Occupancies] ([EmployeeId], [DateOccupied], [AccountNumber], [RoomNumber], [RateApplied], [PhoneCharge], [Notes])
	VALUES 
	(1, '2025-01-01', 'CUST001', 101, 100.00, 10.00, NULL),
	(2, '2025-01-02', 'CUST002', 102, 200.00, 20.00, NULL),
	(3, '2025-01-04', 'CUST003', 103, 300.00, 30.00, NULL);
--

-- Task 16 - Create SoftUni Database
	CREATE DATABASE [SoftUni];	

	USE [SoftUni];

	CREATE TABLE [Towns] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[Name] NVARCHAR(100) NOT NULL
	);

	CREATE TABLE [Addresses] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[AddressText] NVARCHAR(200) NOT NULL,
		[TownId] INT NOT NULL,
		CONSTRAINT [FK_Addresses_Towns] FOREIGN KEY ([TownId]) REFERENCES [Towns]([Id])
	);

	CREATE TABLE [Departments] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[Name] NVARCHAR(100) NOT NULL
	);

	CREATE TABLE [Employees] (
		[Id] INT IDENTITY(1, 1) PRIMARY KEY,
		[FirstName] NVARCHAR(50) NOT NULL,
		[MiddleName] NVARCHAR(50) NULL,
		[LastName] NVARCHAR(50) NOT NULL,
		[JobTitle] NVARCHAR(100) NOT NULL,
		[DepartmentId] INT NOT NULL,
		[HireDate] DATETIME2 NOT NULL,
		[Salary] DECIMAL(10, 2) NOT NULL,
		[AddressId] INT NULL,
		CONSTRAINT [FK_Employees_Departments] FOREIGN KEY ([DepartmentId]) REFERENCES [Departments]([Id]),
		CONSTRAINT [FK_Employees_Addresses] FOREIGN KEY ([AddressId]) REFERENCES [Addresses]([Id])
	);

	-- Insert records into Towns table
	INSERT INTO [Towns] ([Name])
	VALUES
	('Sofia'),
	('Plovdiv'),
	('Varna'),
	('Burgas'),
	('Ruse');

	-- Insert records into Addresses table
	INSERT INTO [Addresses] ([AddressText], [TownId])
	VALUES
	('100 Main St', 1),
	('200 High St', 2),
	('300 Low St', 3),
	('400 Middle St', 4),
	('500 Central St', 5);

	-- Insert records into Departments table
	INSERT INTO [Departments] ([Name])
	VALUES
	('Human Resources'),
	('IT'),
	('Finance'),
	('Marketing'),
	('Sales');

	-- Insert records into Employees table
	INSERT INTO [Employees] ([FirstName], [MiddleName], [LastName], [JobTitle], [DepartmentId], [HireDate], [Salary], [AddressId])
	VALUES
	('John', NULL, 'Doe', 'Software Developer', 2, '2020-05-15', 5000.00, 1),
	('Jane', 'Marie', 'Smith', 'HR Manager', 1, '2018-03-10', 4500.00, 2),
	('Michael', NULL, 'Brown', 'Financial Analyst', 3, '2019-11-20', 4800.00, 3),
	('Emily', 'Grace', 'Davis', 'Marketing Specialist', 4, '2021-01-25', 4000.00, 4),
	('Chris', NULL, 'Wilson', 'Sales Representative', 5, '2022-07-10', 3500.00, 5);
--

-- Task 17 - Backup Database
--

-- Task 18 - Basic Insert
	USE [SoftUni];

	INSERT INTO [Towns] ([Name])
	VALUES
	('Sofia'),
	('Plovdiv'),
	('Varna'),
	('Burgas');

	INSERT INTO [Departments] ([Name])
	VALUES
	('Engineering'),
	('Sales'),
	('Marketing'),
	('Software Development'),
	('Quality Assurance');

	INSERT INTO [Employees] ([FirstName], [MiddleName], [LastName], [JobTitle], [DepartmentId], [HireDate], [Salary], [AddressId])
	VALUES
	('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 
		(SELECT TOP 1 [Id] FROM [Departments] WHERE [Name] = 'Software Development'), 
		'2013-02-01', 3500.00, NULL),
	('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 
		(SELECT TOP 1 [Id] FROM [Departments] WHERE [Name] = 'Engineering'), 
		'2004-03-02', 4000.00, NULL),
	('Maria', 'Petrova', 'Ivanova', 'Intern', 
		(SELECT TOP 1 [Id] FROM [Departments] WHERE [Name] = 'Quality Assurance'), 
		'2016-08-28', 525.25, NULL),
	('Georgi', 'Teziev', 'Ivanov', 'CEO', 
		(SELECT TOP 1 [Id] FROM [Departments] WHERE [Name] = 'Sales'), 
		'2007-12-09', 3000.00, NULL),
	('Peter', 'Pan', 'Pan', 'Intern', 
		(SELECT TOP 1 [Id] FROM [Departments] WHERE [Name] = 'Marketing'), 
		'2016-08-28', 599.88, NULL);
--

-- Task 19 - Basic Select All Fields
	USE [SoftUni];

	SELECT * FROM [Towns];

	SELECT * FROM [Departments];

	SELECT * FROM [Employees];
--

-- Task 20 - Basic Select All Fields and Order Them
	USE [SoftUni];

	SELECT * FROM [Towns]
	ORDER BY [Name] ASC;

	SELECT * FROM [Departments]
	ORDER BY [Name] ASC;

	SELECT * FROM [Employees]
	ORDER BY [Salary] DESC;
--

-- Task 21 - Basic Select Some Fields
	SELECT [Name] FROM [Towns]
	ORDER BY [Name] ASC;

	SELECT [Name] FROM [Departments]
	ORDER BY [Name] ASC;

	SELECT [FirstName], [LastName], [JobTitle], [Salary] FROM [Employees]
	ORDER BY [Salary] DESC;
--

-- Task 22 - Increase Employees Salary
	UPDATE [Employees]
	SET [Salary] = [Salary] * 1.10;

	SELECT [Salary] FROM [Employees];
--

-- Task 23 - Decrease Tax Rate
	USE [Hotel];

-- Decrease the tax rate by 3% for all payments
	USE [Hotel]

	UPDATE [Payments]
	SET [TaxRate] = [TaxRate] - ([TaxRate] * 0.03);

	SELECT [TaxRate] FROM [Payments];
--

-- Task 24 - Delete All Records
	USE [Hotel];

	DELETE FROM [Occupancies];
--
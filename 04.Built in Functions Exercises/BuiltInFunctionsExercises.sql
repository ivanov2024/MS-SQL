-- Part I – Queries for SoftUni Database
	-- Task 1 - Find Names of All Employees by First Name
		SELECT	FirstName
				,LastName
		FROM	Employees
		Where	FirstName LIKE 'Sa%'
	--

	-- Task 2 - Find Names of All Employees by Last Name
		SELECT	FirstName
				,LastName
		FROM	Employees
		Where	LastName LIKE '%ei%'
	--

	-- Task 3 - Find First Names of all Employees
		SELECT	FirstName
		FROM	Employees
		WHERE	(DepartmentID = 3 OR DepartmentID = 10)
				AND HireDate BETWEEN '1995-01-01' AND '2005-12-31'
	--

	-- Task 4 - Find All Employees Except Engineers 
		SELECT	FirstName
				,LastName
		FROM	Employees
		WHERE	JobTitle NOT LIKE '%engineer%'
	--

	-- Task 5 - Find Towns with Name Length
		SELECT Name
		FROM Towns
		WHERE LEN(Name) IN (5, 6)
		ORDER BY Name ASC
	--

	-- Task 6 - Find Towns Starting With
		SELECT	TownID
				,Name
		FROM	Towns
		WHERE	Name LIKE 'M%' 
				OR Name LIKE 'K%' 
				OR Name LIKE 'B%' 
				OR Name LIKE 'E%'
		ORDER BY Name ASC
	--

	-- Таsk 7 - Find Towns Not Starting With
		SELECT	TownID
				,Name
		FROM	Towns
		WHERE	Name NOT LIKE 'R%' 
				AND Name NOT LIKE 'B%' 
				AND Name NOT LIKE 'D%' 
		ORDER BY Name ASC
	--

	-- Task 8 - Create View Employees Hired After 2000 Year
		CREATE VIEW	V_EmployeesHiredAfter2000 AS
		SELECT		FirstName, LastName
		FROM		Employees
		WHERE		HireDate > '2000-12-31'
	--

	-- Task 9 - Length of Last Name
		SELECT	 FirstName
				,LastName
		FROM	Employees
		WHERE LEN(LastName) = 5
	--

	-- Task 10 - Rank Employees by Salary 
		SELECT EmployeeID
			  ,FirstName
			  ,LastName
			  ,Salary,
		DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank
		FROM Employees
		WHERE Salary BETWEEN 10000 AND 50000
		ORDER BY Salary DESC
	--

	-- Task 11 - Find All Employees with Rank 2
		SELECT EmployeeID
			  ,FirstName
			  ,LastName
			  ,Salary
			  ,Rank
		FROM (
		SELECT EmployeeID
				,FirstName
				,LastName
				,Salary
				,DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS Rank
		FROM Employees
		WHERE Salary BETWEEN 10000 AND 50000) 
		AS RankedEmployees
		WHERE Rank = 2
		ORDER BY Salary DESC
	--
--

-- Part II – Queries for Geography Database
	-- Task 12 - Countries Holding 'A' 3 or More Times
		SELECT	CountryName
				,IsoCode
		FROM	Countries
		WHERE LEN(REPLACE(LOWER(CountryName), 'a', '')) <= LEN(CountryName) - 3
		ORDER BY IsoCode;
	--

	-- Task 13 - Mix of Peak and River Names
		SELECT	p.PeakName
				,r.RiverName
				,LOWER(CONCAT(LEFT(p.PeakName, LEN(p.PeakName) - 1), r.RiverName)) AS Mix
		FROM	Peaks AS p
		JOIN	Rivers AS r ON RIGHT(p.PeakName, 1) = LEFT(r.RiverName, 1)
		ORDER BY Mix
	--
--

-- Part III – Queries for Diablo Database
	-- Task 14 - Games from 2011 and 2012 Year
		SELECT TOP (50) 
						[Name],
						FORMAT([Start], 'yyyy-MM-dd') AS [Start]
		FROM			Games
		WHERE			[Start] BETWEEN '2011-01-01' AND '2012-12-31'
		ORDER BY		[Start], [Name];

	--

	-- Task 15 - User Email Providers
		SELECT		u.Username
					,SUBSTRING(u.Email, CHARINDEX('@', u.Email) + 1, LEN(u.Email)) AS [Email Provider]
		FROM		Users AS u
		ORDER BY	[Email Provider], u.Username
	--

	-- Task 16 - Get Users with IP Address Like Pattern
		SELECT		Username
					,IpAddress AS [IP Address]
		FROM		Users AS u
		WHERE		PATINDEX( '%___.1%.%.___%' , IpAddress)> 0
		ORDER BY	u.Username
	--

	-- Task 17 - Show All Games with Duration and Part of the Day
		SELECT		[Name] AS Game
					,CASE 
						WHEN DATEPART(hour, [Start]) >= 0 AND DATEPART(hour, [Start]) < 12 THEN 'Morning'
						WHEN DATEPART(hour, [Start]) >= 12 AND DATEPART(hour, [Start]) < 18 THEN 'Afternoon'
						ELSE 'Evening'
					END AS [Part of the Day]
					,CASE
						WHEN Duration <= 3 THEN 'Extra Short'
						WHEN Duration >= 4 AND Duration <= 6 THEN 'Short'
						WHEN Duration > 6 THEN 'Long'
						ELSE 'Extra Long'
					END AS Duration
		FROM		Games
		ORDER BY	Game, Duration, [Part of the Day]
	--
--

-- Part IV – Date Functions Queries
	-- Task 18 - Order Table
		SELECT	ProductName
				,OrderDate
				,DATEADD(day, 3, OrderDate) AS [Pay Due]
				,DATEADD(month, 1, OrderDate) AS [Delivery Due]
		FROM	Orders
	--
--
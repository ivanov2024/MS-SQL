-- Part I – Queries for SoftUni Database
	-- Task 01 - Employees with Salary Above 35000
		CREATE OR ALTER PROC dbo.usp_GetEmployeesSalaryAbove35000
		AS 
		SELECT	FirstName AS [First Name],
				LastName AS [Last Name]
		FROM	Employees
		WHERE	Salary > 35000

		GO

		EXEC dbo.usp_GetEmployeesSalaryAbove35000

		GO
	--

	-- Task 02 - Employees with Salary Above Number
		CREATE OR ALTER PROC dbo.usp_GetEmployeesSalaryAboveNumber 
							(@number DECIMAL(18,4))
		AS 
		SELECT	FirstName AS [First Name],
				LastName AS [Last Name]
		FROM	Employees
		WHERE	Salary >= @number

		GO

		EXEC dbo.usp_GetEmployeesSalaryAboveNumber 48100

		GO
	--

	-- Task 03 - Town Names Starting With
		CREATE OR ALTER PROC dbo.usp_GetTownsStartingWith  
							(@string  VARCHAR(50))
		AS 
		SELECT	[Name] AS Town
		FROM	Towns
		WHERE   LOWER([Name]) LIKE LOWER(@string + '%')

		GO

		EXEC dbo.usp_GetTownsStartingWith 'b'

		GO
	--

	-- Task 04 - Employees from Town
		CREATE OR ALTER PROC dbo.usp_GetEmployeesFromTown   
							(@townName  VARCHAR(50))
		AS 
		SELECT		FirstName AS [First Name],
					LastName AS [Last Name]
		FROM		Employees AS e
		LEFT JOIN	Addresses AS a ON e.AddressID = a.AddressID
		LEFT JOIN	Towns AS t ON a.TownID = t.TownID
		WHERE		t.[Name] = @townName

		GO

		EXEC dbo.usp_GetEmployeesFromTown 'Sofia'

		GO
	--

	-- Task 05 - Salary Level Function
		CREATE OR ALTER FUNCTION dbo.ufn_GetSalaryLevel
								(@salary DECIMAL(18,4)) 
		RETURNS VARCHAR(7)
		AS
		BEGIN
			DECLARE @salaryLevel VARCHAR(7)
			
			SET @salaryLevel = CASE 
				WHEN @salary < 30000 THEN 'Low'
				WHEN @salary BETWEEN 30000 AND 50000 THEN 'Average' 
				WHEN @salary > 50000 THEN 'High'
				ELSE 'Unknown'
			END 

			RETURN @salaryLevel
		END

		GO

		SELECT	Salary,
				dbo.ufn_GetSalaryLevel(Salary)
		FROM	Employees	

		GO
	--

	-- Task 06 - Employees by Salary Level
		CREATE OR ALTER PROC dbo.usp_EmployeesBySalaryLevel  
							( @salaryLevel VARCHAR(7))
		AS 
		SELECT		FirstName AS [First Name],
					LastName AS [Last Name]
		FROM		Employees
		WHERE		dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel

		GO

		EXEC dbo.usp_EmployeesBySalaryLevel 'High'

		GO
	--

	-- Task 07 - Define Function
		CREATE OR ALTER FUNCTION dbo.ufn_IsWordComprised
						(@setOfLetters VARCHAR(255), @word VARCHAR(255))
		RETURNS BIT
		AS
		BEGIN
			DECLARE @index INT

			SET @index = 1
			WHILE(@index <= LEN(@word))
			BEGIN
				IF(CHARINDEX(LOWER(SUBSTRING(@word, @index, 1)), LOWER(@setOfLetters)) = 0)
					RETURN 0

				SET @index = @index + 1
			END

			RETURN 1
		END

		GO
	
		SELECT dbo.ufn_IsWordComprised ('bobr', 'Rob')
	
		GO
	--

	-- Task 08 - Delete Employees and Departments
		CREATE OR ALTER PROCEDURE dbo.usp_DeleteEmployeesFromDepartment
								(@departmentId INT)
		AS
			DELETE 
			FROM	EmployeesProjects
			WHERE	EmployeeID IN 
					(
						SELECT	EmployeeID
						FROM	Employees
						WHERE	DepartmentID = @departmentId
					)

			UPDATE	Employees
			SET		ManagerID = NULL
			WHERE	ManagerID IN
					(
						SELECT	EmployeeID
						FROM	Employees
						WHERE	DepartmentID = @departmentId
					)

			ALTER TABLE		Departments
			ALTER COLUMN	ManagerID INT NULL

			UPDATE		Departments
			SET			ManagerID = NULL
			WHERE		ManagerID IN
						(
							SELECT	EmployeeID
							FROM	Employees
							WHERE	DepartmentID = @departmentId
						)

			DELETE 
			FROM		Employees
			WHERE		DepartmentID = @departmentId

			DELETE
			FROM		Departments
			WHERE		DepartmentID = @departmentId

			SELECT		COUNT(*)
			FROM		Employees
			WHERE		DepartmentID = @departmentId

		GO

		EXEC	dbo.usp_DeleteEmployeesFromDepartment 1 

		GO
	--
--

-- Part II – Queries for Bank Database
	-- Task 09 - Find Full Name
		CREATE OR ALTER PROCEDURE dbo.usp_GetHoldersFullName 
		AS
			SELECT		CONCAT(FirstName, ' ', LastName) AS [Full Name]
			FROM		AccountHolders

		GO

		EXEC dbo.usp_GetHoldersFullName

		GO
	--	

	-- Task 10 - People with Balance Higher Than
		CREATE OR ALTER PROCEDURE dbo.usp_GetHoldersWithBalanceHigherThan 
								(@number INT)
		AS
			SELECT
			DISTINCT	ah.FirstName AS [First Name],
						ah.LastName AS [Last Name]
			FROM		AccountHolders AS ah
			INNER JOIN	Accounts AS a ON ah.Id = a.AccountHolderId
			GROUP BY	ah.FirstName, ah.LastName
			HAVING		SUM(a.Balance) > @number
			ORDER BY	ah.FirstName, ah.LastName

		GO

		EXEC dbo.usp_GetHoldersWithBalanceHigherThan 300

		GO
	--

	-- Task 11 - Future Value Function
		CREATE OR ALTER FUNCTION dbo.ufn_CalculateFutureValue 
								(@sum DECIMAL(22,4), @yearlyInterestRate FLOAT, @numberOfYears INT)
		RETURNS DECIMAL(22,4)
		AS
		BEGIN
			DECLARE @result DECIMAL(22,4)

			SET @result = @sum * (POWER((1 + @yearlyInterestRate), @numberOfYears))

			RETURN @result
		END

		GO

		SELECT dbo.ufn_CalculateFutureValue (1000, 0.1, 5) AS [Output]

		GO
	--	

	-- Task 12 - Calculating Interest
		CREATE OR ALTER PROCEDURE dbo.usp_CalculateFutureValueForAccount  
								(@accountID INT, @yearlyInterestRate FLOAT)
		AS
			SELECT		a.Id AS [Account ID],
						ah.FirstName AS [First Name],
						ah.LastName AS [Last Name],
						a.Balance AS [Current Balance],
						dbo.ufn_CalculateFutureValue(a.Balance, @yearlyInterestRate, 5) 
						AS [Balance in 5 years]
			FROM		AccountHolders AS ah
			INNER JOIN	Accounts AS a ON ah.Id = a.AccountHolderId
			WHERE		a.Id = @accountID

		GO

		EXEC dbo.usp_CalculateFutureValueForAccount 1, 0.1

		GO
	--
--

-- Part III – Queries for Diablo Database
	-- Task 13 - Scalar Function: Cash in User Games Odd Rows
		CREATE OR ALTER FUNCTION dbo.ufn_CashInUsersGames 
								(@gameName NVARCHAR(50))
		RETURNS TABLE
		AS
		RETURN	(
					SELECT	SUM(Cash) AS SumCash
					FROM	(
								SELECT		ug.Cash, ROW_NUMBER() OVER 
											(ORDER BY ug.Cash DESC) AS RowNumber
								FROM		UsersGames AS ug
								INNER JOIN	Games AS g ON g.Id = ug.GameId
								WHERE		g.[Name] = @gameName
							)	AS			RowedGames
					WHERE	RowNumber % 2 = 1
				)
		GO


		SELECT	* 
		FROM	dbo.ufn_CashInUsersGames('Love in a mist') 
	--
--
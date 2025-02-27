-- Part I – Queries for Gringotts Database
	-- Task 01 - Records' Count
		SELECT		COUNT(*) AS [Count]
		FROM		WizzardDeposits		
	--

	-- Task 02 - Longest Magic Wand
		SELECT	MAX(MagicWandSize) AS LongestMagicWand
		FROM	WizzardDeposits
	--

	-- Task 03 - Longest Magic Wand Per Deposit Groups
		SELECT		DepositGroup,
					MAX(MagicWandSize) AS LongestMagicWand
		FROM		WizzardDeposits
		GROUP BY	DepositGroup
	--

	-- Task 04 - Smallest Deposit Group Per Magic Wand Size
		SELECT
		TOP(2)  DepositGroup
		FROM	WizzardDeposits
		WHERE	MagicWandSize IN
				(
					SELECT	 MIN(MagicWandSize)
					FROM	 WizzardDeposits
					GROUP BY DepositGroup
				)
		GROUP BY DepositGroup
	--

	-- Task 05 - Deposit Sum
		SELECT		DepositGroup,
					SUM(DepositAmount) AS TotalSum
		FROM		WizzardDeposits
		GROUP BY	DepositGroup
	--

	-- Task 06 - Deposits Sum for Ollivander Family
		SELECT		DepositGroup,
					SUM(DepositAmount) AS TotalSum
		FROM		WizzardDeposits
		WHERE		MagicWandCreator = 'Ollivander family'
		GROUP BY	DepositGroup
	--

	-- Task 07 - Deposit Filter
		SELECT		DepositGroup,
					SUM(DepositAmount) AS TotalSum
		FROM		WizzardDeposits
		WHERE		MagicWandCreator = 'Ollivander family' 
		GROUP BY	DepositGroup
		HAVING      SUM(DepositAmount) < 150000
		ORDER BY	TotalSum DESC
	--

	-- Task 08 - Deposit Change
		SELECT		DepositGroup,
					MagicWandCreator,
					MIN(DepositCharge) AS MinDepositCharge
		FROM		WizzardDeposits
		GROUP BY	DepositGroup, MagicWandCreator
		ORDER BY	MagicWandCreator, MinDepositCharge
	--

	-- Task 09 - Age Groups
		SELECT
	    CASE
	        WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
	        WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
	        WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
	        WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
	        WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
	        WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
	        WHEN Age >= 61 THEN '[61+]'
	    END AS		AgeGroup,
	    COUNT(*) AS WizardCount
		FROM		WizzardDeposits
		GROUP BY
	    CASE
	        WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
	        WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
	        WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
	        WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
	        WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
	        WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
	        WHEN Age >= 61 THEN '[61+]'
	    END
		ORDER BY	AgeGroup
	--

	-- Task 10 - First Letter
		SELECT		 SUBSTRING(FirstName, 1, 1) AS FirstLetter
		FROM		(
						SELECT		FirstName
						FROM		WizzardDeposits
						WHERE		DepositGroup = 'Troll Chest'
						GROUP BY	FirstName
					) AS Result
		ORDER BY	FirstLetter

		SELECT		SUBSTRING(FirstName, 1, 1) AS FirstLetter
		FROM		WizzardDeposits
		WHERE		DepositGroup = 'Troll Chest'
		GROUP BY	FirstName
		ORDER BY	FirstLetter
	--

	-- Task 11 - Average Interest
		SELECT		DepositGroup,
					IsDepositExpired,
					AVG(DepositInterest) AS AverageInterest
		FROM		WizzardDeposits
		WHERE		DepositStartDate > '1985-01-01'
		GROUP BY	DepositGroup, IsDepositExpired
		ORDER BY	DepositGroup DESC, IsDepositExpired ASC
	--

	-- Task 12 - Rich Wizard, Poor Wizard
		SELECT		ABS(SUM(NextDepositAmount - DepositAmount)) AS TotalDepositDifference
		FROM		(
						SELECT DepositAmount,
						LEAD(DepositAmount) OVER (ORDER BY Id) AS NextDepositAmount
						FROM WizzardDeposits
					) AS DepositDifferences
		WHERE NextDepositAmount IS NOT NULL
	--
--

-- Part II – Queries for SoftUni Database
	-- Task 13 - Departments Total Salaries
		SELECT		DepartmentID,
					SUM(Salary) AS TotalSalay
		FROM		Employees
		GROUP BY	DepartmentID
	--

	-- Task 14 - Employees Minimum Salaries
		SELECT		DepartmentID,
					MIN(Salary) AS MinimumSalary
		FROM		Employees
		WHERE		DepartmentID IN (2,5,7) AND HireDate > '2000-01-01'
		GROUP BY	DepartmentID
	--

	-- Task 15 - Employees Average Salaries
		SELECT		DepartmentID,
					Salary,
					ManagerID
		INTO		EmployeesCopy
		FROM		Employees
		WHERE		Salary > 30000 

		DELETE
		FROM		EmployeesCopy
		WHERE		ManagerID = 42

		UPDATE		EmployeesCopy
		SET			Salary = Salary + 5000
		WHERE		DepartmentID = 1

		SELECT		DepartmentID,
					AVG(Salary) AS AverageSalary
		FROM		EmployeesCopy
		GROUP BY	DepartmentID
	--

	-- Task 16 - Employees Maximum Salaries
		SELECT		DepartmentID,
					MAX(Salary) AS MaxSalary
		FROM		Employees
		GROUP BY	DepartmentID
		HAVING		MAX(Salary) NOT BETWEEN 30000 AND 70000
	--

	-- Task 17 - Employees Count Salaries
		SELECT		COUNT(*) AS [Count]
		FROM		Employees
		WHERE		ManagerID IS NULL
	--

	-- Task 18 - 3rd Highest Salary
		SELECT		DepartmentID,
					MAX(Salary) AS ThirdHighestSalary
		FROM		(
						SELECT	DepartmentID,
								Salary,
								 DENSE_RANK() OVER 
								 (PARTITION BY DepartmentID ORDER BY Salary DESC) 
								 AS SalaryRank
						FROM	Employees
					) AS RankedSalaries
		WHERE	    SalaryRank = 3
		GROUP BY	DepartmentID
	--

	-- Task 19 - Salary Challange
		SELECT 
		TOP(10)		FirstName,
					LastName,
					DepartmentID
		FROM		Employees AS e
		WHERE		e.Salary > 
					(
						SELECT AVG(Salary) 
						FROM Employees AS sub 
						WHERE sub.DepartmentID = e.DepartmentID
					)
		ORDER BY	DepartmentID
	--
--
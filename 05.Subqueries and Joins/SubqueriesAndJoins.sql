-- Part I – Queries for SoftUni Database
	-- Task 01 - Employee Address
		SELECT
		TOP(5)		e.EmployeeID
					,e.JobTitle
					,e.AddressID
					,a.AddressText
		FROM		Employees AS e
		JOIN		Addresses AS a ON e.AddressID = a.AddressID
		ORDER BY	e.AddressID
	--

	-- Task 02 - Address with Towns
		SELECT
		TOP(50)		e.FirstName
					,e.LastName
					,t.[Name]
					,a.AddressText
		FROM		Employees AS e
		JOIN		Addresses AS a ON e.AddressID = a.AddressID
		JOIN		Towns AS t ON t.TownID = a.TownID
		ORDER BY	e.FirstName, e.LastName
	--

	-- Task 03 - Sales Employee 
		SELECT		e.EmployeeID
					,e.FirstName
					,e.LastName
					,d.[Name] AS DepartmentName
		FROM		Employees AS e
		JOIN		Departments AS d ON e.DepartmentID = d.DepartmentID AND d.[Name] = 'Sales'
		ORDER BY	e.EmployeeID
	--

	-- Task 04 - Employee Departments
		SELECT
		TOP(5)		e.EmployeeID
					,e.FirstName
					,e.Salary
					,d.[Name] AS DepartmentName
		FROM		Employees AS e
		JOIN		Departments AS d ON e.DepartmentID = d.DepartmentID AND e.Salary > 15000
		ORDER BY	e.DepartmentID
	--

	-- Task 05 - Employees Without Project
		SELECT 
		TOP(3)		e.EmployeeID,
					e.FirstName
		FROM		Employees AS e
		LEFT JOIN	EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
		WHERE		ep.EmployeeID IS NULL
		ORDER BY	e.EmployeeID ASC
	--

	-- Task 06 - Employees Hired After
		SELECT		e.FirstName,
					e.LastName,
					e.HireDate,
					d.[Name] AS DeptName
		FROM		Employees AS e
		JOIN		Departments AS d ON e.DepartmentID = d.DepartmentID
		WHERE		e.HireDate > '1999-01-01'
					AND (d.[Name] = 'Sales' OR d.[Name] = 'Finance')
		ORDER BY	e.HireDate
	--

	-- Task 07 - Employees with Project
		SELECT 
		TOP(5)		e.EmployeeID,
					e.FirstName,
					p.[Name] AS ProjectName
		FROM		Employees AS e
		JOIN		EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
		JOIN		Projects AS p ON ep.ProjectID = p.ProjectID
		WHERE		p.StartDate > '2002-08-13' AND p.EndDate IS NULL
		ORDER BY	e.EmployeeID ASC
	--

	-- Task 08 - Employee 24
		SELECT		e.EmployeeID,
					e.FirstName,
					CASE
						WHEN p.StartDate >= '2005-01-01' THEN NULL
						ELSE p.[Name]
					END AS [ProjectName]
		FROM		Employees AS e
		JOIN		EmployeesProjects AS ep ON e.EmployeeID = ep.EmployeeID
		JOIN		Projects AS p ON ep.ProjectID = p.ProjectID
		WHERE		e.EmployeeID = 24
		ORDER BY	e.EmployeeID ASC
	--

	-- Task 09 - Employee Manager
		SELECT		e1.EmployeeID,
					e1.FirstName,
					e1.ManagerID,
					e2.FirstName AS ManagerName
		FROM		Employees AS e1
		JOIN		Employees AS e2 ON e1.ManagerID = e2.EmployeeID
		WHERE		e1.ManagerID IN (3,7)
		ORDER BY	e1.EmployeeID
	--

	-- Task 10 - Employees Summary
		SELECT		
		TOP(50)		e1.EmployeeID,
					CONCAT_WS(' ', e1.FirstName, e1.LastName) AS EmployeeName,
					CONCAT_WS(' ', e2.FirstName, e2.LastName) AS ManagerName,
					d.[Name] AS DepartmentName
		FROM		Employees AS e1
		JOIN		Employees AS e2 ON e1.ManagerID = e2.EmployeeID
		JOIN		Departments AS d ON e1.DepartmentID = d.DepartmentID
		ORDER BY	e1.EmployeeID
	--

	-- Task 11 - Min Average Salary
		SELECT MIN(DeptAverageSalary) AS MinAverageSalary
		FROM (
				SELECT AVG(e.Salary) AS DeptAverageSalary
				FROM Employees AS e
				JOIN Departments AS d ON e.DepartmentID = d.DepartmentID
				GROUP BY d.DepartmentID
			)	AS SalaryData
	--
--

-- Part II – Queries for Geography Database
	-- Task 12 - Highest Peaks in Bulgaria
		SELECT		c.CountryCode,
					m.MountainRange,
					p.PeakName,
					p.Elevation
		FROM		Countries AS c
		JOIN		MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		JOIN		Mountains AS m ON mc.MountainId = m.Id
		JOIN		Peaks AS p ON m.Id = p.MountainId
		WHERE		c.CountryName = 'Bulgaria' AND p.Elevation > 2835
		ORDER BY	p.Elevation DESC
	--

	-- Task 13 - Count Mountain Ranges
		SELECT		c.CountryCode,
					COUNT(m.MountainRange) AS MountainRanges
		FROM		Countries AS c
		JOIN		MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		JOIN		Mountains AS m ON mc.MountainId = m.Id
		WHERE		c.CountryName IN ('United States', 'Russia', 'Bulgaria')
		GROUP BY	c.CountryCode
	--

	-- Task 14 - Countries With Or Without River
		SELECT
		TOP(5)		c.CountryName,
					r.RiverName
		FROM		Countries AS c
		LEFT JOIN	CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
	    LEFT JOIN  Rivers AS r ON cr.RiverId = r.Id
		LEFT JOIN	Continents AS ct ON c.ContinentCode = ct.ContinentCode
		WHERE		ct.ContinentName = 'Africa'
		ORDER BY	c.CountryName
	--

	-- Task 15 - Continents and Currencies
		SELECT		ContinentCode,
					CurrencyCode,
					CurrencyUsage
		FROM (
				SELECT		c.ContinentCode,  
							cu.CurrencyCode,  
							COUNT(co.CountryCode) AS CurrencyUsage,
							DENSE_RANK() OVER 
							(PARTITION BY c.ContinentCode ORDER BY COUNT(co.CountryCode) DESC) 
							AS Rank
				FROM		Continents AS c
				JOIN		Countries AS co ON c.ContinentCode = co.ContinentCode
				JOIN		Currencies AS cu ON co.CurrencyCode = cu.CurrencyCode
				GROUP BY	c.ContinentCode, cu.CurrencyCode
				HAVING		COUNT(co.CountryCode) > 1
				) AS RankedCurrencies
		WHERE Rank = 1
		ORDER BY ContinentCode
	--

	-- Task 16 - Countries Without Any Mountains 
		SELECT		COUNT(c.ContinentCode) AS [Count]
		FROM		Countries AS c
		LEFT JOIN	MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		WHERE		mc.CountryCode IS NULL
	--

	-- Task 17 - Highest Peak and Longest River by Country
		SELECT
		TOP(5)		c.CountryName,
					MAX(p.Elevation) AS HighestPeakElevation,
					MAX(r.[Length]) AS LongestRiverLength
		FROM		Countries AS c
		LEFT JOIN	MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		LEFT JOIN	Mountains AS m ON mc.MountainId = m.Id
		LEFT JOIN	Peaks AS p ON m.Id = p.MountainId
		LEFT JOIN	CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
		LEFT JOIN	Rivers AS r ON cr.RiverId = r.Id
		GROUP BY	c.CountryName
		ORDER BY	HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName
	--

	-- Task 18 - Highest Peak Name and Elevation by Country
		SELECT
		TOP(5)		c.CountryName AS Country,
					COALESCE(p.PeakName, '(no highest peak)') AS [Highest Peak Name],
					COALESCE(p.Elevation, 0) AS [Highest Peak Elevation],
					COALESCE(m.MountainRange, '(no mountain)') AS Mountain
		FROM		   Countries AS c
		LEFT JOIN	MountainsCountries AS mc ON c.CountryCode = mc.CountryCode
		LEFT JOIN	Mountains AS m ON mc.MountainId = m.Id
		LEFT JOIN	Peaks AS p ON m.Id = p.MountainId
		WHERE		p.Elevation = (SELECT MAX(Elevation) 
						FROM Peaks 
						WHERE MountainId = m.Id) OR p.Elevation IS NULL
		ORDER BY	c.CountryName, p.PeakName
	--
--
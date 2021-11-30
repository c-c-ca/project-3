DROP DATABASE IF EXISTS Project_3;
CREATE DATABASE Project_3;
USE Project_3; 

CREATE TABLE Employee
	(
		EmployeeID      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        LastName        VARCHAR(30),
        FirstName       VARCHAR(30),
        CellPhone       VARCHAR(30),
        ExperienceLevel VARCHAR(30)
    );
    
INSERT INTO Employee (LastName, FirstName, CellPhone, ExperienceLevel)
VALUES ('Smith', 'Sam', '206-254-1234', 'Master'),
       ('Evanston', 'John', '206-254-2345', 'Senior'),
	   ('Murray', 'Dale', '425-545-7654', 'Junior'),
       ('Murphy', 'Jerry', '425-545-8765', 'Master'),
       ('Fontaine', 'John', '206-254-3546', 'Senior');
    
CREATE TABLE GG_Service
	(
		ServiceID          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        ServiceDescription VARCHAR(30),
        CostPerHour        DECIMAL(5, 2)
    );
    
INSERT INTO GG_Service (ServiceDescription, CostPerHour)
VALUES ('Mow Lawn', 25.0),
	   ('Plant Annuals', 25.0),
       ('Weed Garden', 30.0),
       ('Trim Hedge', 45.0),
       ('Prune Small Tree', 60.0),
       ('Trim Medium Tree', 100.0),
       ('Trim Large Tree', 125.0);

CREATE TABLE Owner
	(
		OwnerID    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        OwnerName  VARCHAR(30),
        OwnerEmail VARCHAR(30),
        OwnerType  VARCHAR(30)
    );
    
INSERT INTO Owner (OwnerName, OwnerEmail, OwnerType)
VALUES ('Mary Jones', 'Mary.Jones@somewhere.com', 'Individual'),
	   ('DT Enterprises', 'DTE@dte.com', 'Corporation'),
       ('Sam Douglas', 'Sam.Douglas@somewhere.com', 'Individual'),
       ('UNY Enterprises', 'UNYE@unye.com', 'Corporation'),
       ('Doug Samuels', 'Doug.Samuels@somewhere.com', 'Individual');

CREATE TABLE Owned_Property
	(
		PropertyID   INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        PropertyName VARCHAR(30),
        PropertyType VARCHAR(30),
        Street       VARCHAR(30),
        City         VARCHAR(30),
        State        VARCHAR(30),
        ZIP          INT,
        OwnerID      INT,
        FOREIGN KEY (OwnerID) REFERENCES Owner(OwnerID)
    );
    
INSERT INTO Owned_Property (PropertyName, PropertyType, Street, City, State, ZIP, OwnerID)
VALUES ('Eastlake Building', 'Office', '123 Eastlake', 'Seattle', 'WA', 98119, 2),
       ('Elm St Apts', 'Apartments', '4 East Elm', 'Lynwood', 'WA', 98223, 1),
       ('Jefferson Hill', 'Office', '42 West 7th St', 'Bellevue', 'WA', 98007, 2),
       ('Lake View Apts', 'Apartments', '1265 32nd Avenue', 'Redmond', 'WA', 98052, 3),
       ('Kodak Heights Apts', 'Apartments', '65 32nd Avenue', 'Redmond', 'WA', 98052, 4),
       ('Jones House', 'Private Residence', '1456 48th St', 'Bellevue', 'WA', 98007, 1),
       ('Douglas House', 'Private Residence', '1567 51st St', 'Bellevue', 'WA', 98007, 3),
       ('Samuels House', 'Private Residence', '567 151st St', 'Redmond', 'WA', 98052, 5);

CREATE TABLE Property_Service
	(
		PropertyServiceID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        PropertyID INT,
        FOREIGN KEY (PropertyID) REFERENCES Owned_Property(PropertyID),
        ServiceID INT,
        FOREIGN KEY (ServiceID) REFERENCES GG_Service(ServiceID),
        ServiceDate DATE,
        EmployeeID INT,
        FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
        HoursWorked DECIMAL(4, 2)
    );

INSERT INTO Property_Service (PropertyID, ServiceID, ServiceDate, EmployeeID, HoursWorked)
VALUES (1, 2, '2014-05-05', 1, 4.5),
       (3, 2, '2014-05-08', 3, 4.5),
       (2, 1, '2014-05-08', 2, 2.75),
       (6, 1, '2014-05-10', 5, 2.5),
       (5, 4, '2014-05-12', 4, 7.5),
       (8, 1, '2014-05-15', 4, 2.75),
       (4, 4, '2014-05-19', 1, 1.0),
       (7, 1, '2014-05-21', 2, 2.5),
       (6, 3, '2014-06-03', 5, 2.5),
       (5, 7, '2014-06-08', 4, 10.5),
       (8, 3, '2014-06-12', 4, 2.75),
       (4, 5, '2014-06-15', 1, 5.0),
       (7, 3, '2014-06-19', 2, 4.0);

-- 1.
SELECT * FROM Owner;

-- 2.
SELECT
	LastName,
    FirstName,
    CellPhone
FROM Employee
WHERE ExperienceLevel = 'Master';

-- 3.
SELECT
	LastName,
    FirstName,
    CellPhone
FROM Employee
WHERE ExperienceLevel = 'Master' AND FirstName LIKE 'J%';

-- 4.
SELECT
	LastName,
    FirstName
FROM Employee
WHERE EmployeeID IN
	(
		SELECT EmployeeID
        FROM Property_Service
        WHERE PropertyID IN
			(
				SELECT PropertyID
                FROM Owned_Property
                WHERE city = 'Seattle'
			)
    );
    
-- 5.
SELECT
	LastName,
    FirstName
FROM Employee
JOIN Property_Service
	ON Employee.EmployeeID = Property_Service.EmployeeID
JOIN Owned_Property
	ON Property_Service.PropertyID = Owned_Property.PropertyID
WHERE city = 'Seattle';

-- 6.
SELECT
	LastName,
    FirstName
FROM Employee
WHERE EmployeeID IN
	(
		SELECT EmployeeID
        FROM Property_Service
        WHERE PropertyID IN
			(
				SELECT PropertyID
                FROM Owned_Property
                WHERE OwnerID IN
					(
						SELECT OwnerID
						FROM Owner
						WHERE OwnerType = 'Corporation'
					)
			)
    );

-- 7.
SELECT DISTINCT
	LastName,
    FirstName
FROM Employee
JOIN Property_Service
	ON Employee.EmployeeID = Property_Service.EmployeeID
JOIN Owned_Property
	ON Property_Service.PropertyID = Owned_Property.PropertyID
JOIN Owner
	ON Owned_Property.OwnerID = Owner.OwnerID
WHERE OwnerType = 'Corporation';

-- 8.
SELECT
	LastName,
    FirstName,
    SUM(HoursWorked) AS TotalHoursWorked
FROM Employee
JOIN Property_Service
	ON Employee.EmployeeID = Property_Service.EmployeeID
GROUP BY
	LastName,
    FirstName;

-- 9.
SELECT
	ExperienceLevel,
    SUM(HoursWorked) AS TotalHoursWorked
FROM Employee
JOIN Property_Service
	ON Employee.EmployeeID = Property_Service.EmployeeID
GROUP BY ExperienceLevel
ORDER BY TotalHoursWorked DESC;

-- 10.
SELECT
	OwnerType,
    SUM(HoursWorked) AS TotalHoursWorked
FROM Employee
JOIN Property_Service
	ON Employee.EmployeeID = Property_Service.EmployeeID
JOIN Owned_Property
	ON Property_Service.PropertyID = Owned_Property.PropertyID
JOIN Owner
	ON Owned_Property.OwnerID = Owner.OwnerID
WHERE Employee.ExperienceLevel != 'Junior'
GROUP BY OwnerType;

-- 11. Alter a table
ALTER TABLE Employee
ADD COLUMN is_closed_flag TINYINT(1) DEFAULT 0;

SELECT * FROM Employee;
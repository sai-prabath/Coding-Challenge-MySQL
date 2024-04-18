-- database
CREATE DATABASE IF NOT EXISTS CrimeManagement;

USE CrimeManagement;

-- tables
CREATE TABLE IF NOT EXISTS Crime (
    CrimeID INT PRIMARY KEY,
    IncidentType VARCHAR(255),
    IncidentDate DATE,
    Location VARCHAR(255),
    Description TEXT,
    Status VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS Victim (
    VictimID INT PRIMARY KEY,
    CrimeID INT,
    Name VARCHAR(255),
    ContactInfo VARCHAR(255),
    Injuries VARCHAR(255),
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

CREATE TABLE IF NOT EXISTS Suspect (
    SuspectID INT PRIMARY KEY,
    CrimeID INT,
    Name VARCHAR(255),
    Description TEXT,
    CriminalHistory TEXT,
    FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

-- Values

INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status) VALUES
(1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
(2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'),
(3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed'),
(4, 'Assault', '2023-09-25', '321 Pine St, Suburbia', 'Physical altercation between two individuals', 'Open'),
(5, 'Burglary', '2023-09-05', '555 Cedar Ave, Downtown', 'Break-in and theft at a residential property', 'Closed'),
(6, 'Vandalism', '2023-09-12', '777 Oak St, Villagetown', 'Property damage incident', 'Open'),
(7, 'Arson', '2023-09-08', '999 Maple Ave, Countryside', 'Fire deliberately set to property', 'Under Investigation');

INSERT INTO Victim (VictimID, CrimeID, Name,age, ContactInfo, Injuries) VALUES
(1, 1, 'John Doe', 25 , 'johndoe@example.com', 'Minor injuries'),
(2, 2, 'Jane Smith', 32 , 'janesmith@example.com', 'Deceased'),
(3, 3, 'Alice Johnson', 40 , 'alicejohnson@example.com', 'None'),
(4, 4, 'Michael Brown', 35 , 'michaelbrown@example.com', 'Bruises'),
(5, 5, 'Emily Johnson', 28 , 'emilyjohnson@example.com', 'None'),
(6, 6, 'Sarah Johnson', 22 , 'sarahjohnson@example.com', 'None'),
(7, 6, 'David Brown', 41 , 'davidbrown@example.com', 'Property damage'),
(8, 7, 'Mark Wilson', 29 , 'markwilson@example.com', 'None'),
(9, 7, 'Jessica Lee', 26 , 'jessicalee@example.com', 'Smoke inhalation');

INSERT INTO Suspect (SuspectID, CrimeID, Name,age, Description, CriminalHistory) VALUES
(1, 1, 'Robber 1',30 , 'Armed and masked robber', 'Previous robbery convictions'),
(2, 2, 'Unknown',, 'Investigation ongoing', NULL),
(3, 3, 'Suspect 1',35 , 'Shoplifting suspect', 'Prior shoplifting arrests'),
(4, 4, 'Suspect 2',40 , 'Physical assault suspect', 'Prior assault charges'),
(5, 5, 'Burglar 1',45 , 'Suspected burglar', 'Previous burglary convictions'),
(6, 6, 'Scammer 1',50 , 'Mastermind behind the fraud scheme', 'Previous fraud convictions'),
(7, 7, 'Arsonist 1',55 , 'Primary suspect believed to have started the fire', 'No prior criminal history');


SELECT * FROM Crime WHERE Status = 'Open';

SELECT COUNT(*) AS TotalIncidents FROM Crime;

SELECT DISTINCT IncidentType FROM Crime;

SELECT * FROM Crime WHERE IncidentDate BETWEEN '2023-09-01' AND '2023-09-10';


SELECT Name FROM Victim ORDER BY age DESC;





SELECT AVG(age) AS AverageAge FROM Victim;


SELECT IncidentType, COUNT(*) AS IncidentCount FROM Crime WHERE Status = 'Open' GROUP BY IncidentType;

SELECT * FROM Victim WHERE Name LIKE '%Doe%';

SELECT Name FROM Victim WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open')
UNION
SELECT Name FROM Victim WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status <> 'Open');

-- Assuming age is not explicitly stored but can be calculated from birthdate
-- Assuming birthdate is stored in Victim table
SELECT DISTINCT c.IncidentType 
FROM Crime c 
JOIN Victim v ON c.CrimeID = v.CrimeID 
WHERE DATEDIFF(CURRENT_DATE, v.Birthdate) / 365 IN (30, 35);



SELECT v.Name, v.age, v.ContactInfo, v.Injuries
FROM Victim v
ORDER BY v.age DESC;



SELECT Name FROM Victim WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open' or Status = 'close' )


SELECT DISTINCT c.IncidentType
FROM Crime c
JOIN Victim v ON c.CrimeID = v.CrimeID
WHERE v.age IN (30, 35);

SELECT c.IncidentType
FROM Crime c
WHERE c.CrimeID in
(SELECT v.CrimeID FROM Victim v WHERE age=30 or age=35)


JOIN Victim v ON c.CrimeID = v.CrimeID
WHERE v.age BETWEEN 30 and 35;

--

SELECT v.Name
FROM Victim v
JOIN Crime c ON v.CrimeID = c.CrimeID
WHERE c.IncidentType = 'Robbery';

SELECT IncidentType, COUNT(*) AS OpenCasesCount
FROM Crime
WHERE Status = 'Open'
GROUP BY IncidentType
HAVING COUNT(*) > 1;

SELECT c.*, v.Name AS VictimName, s.Name AS SuspectName
FROM Crime c
JOIN Victim v ON c.CrimeID = v.CrimeID
JOIN Suspect s ON c.CrimeID = s.CrimeID AND v.Name = s.Name;

SELECT c.CrimeID,c.IncidentType, v.Name AS VictimName, s.SuspectID
FROM Crime c
LEFT JOIN Victim v ON c.CrimeID = v.CrimeID
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

SELECT c.*, v.Name AS VictimName, v.age AS VictimAge, s.Name AS SuspectName, s.age AS SuspectAge
FROM Crime c
JOIN Victim v ON c.CrimeID = v.CrimeID
JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.age > ANY (SELECT age FROM Victim WHERE CrimeID = c.CrimeID);

--

SELECT SuspectID, Name, COUNT(*) AS IncidentCount
FROM Suspect
GROUP BY SuspectID, Name
HAVING COUNT(*) > 1;

SELECT c.*
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.SuspectID IS NULL;

SELECT DISTINCT c1.*
FROM Crime c1
JOIN Crime c2 ON c1.CrimeID = c2.CrimeID AND c2.IncidentType = 'Robbery'
WHERE c1.IncidentType = 'Homicide';

SELECT c.*, 
COALESCE(s.Name, 'No Suspect') AS SuspectName
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

SELECT DISTINCT s.*
FROM Suspect s
JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType IN ('Robbery', 'Assault');



SELECT Name, Age
FROM (SELECT Name, Age FROM Victim
    UNION ALL
    SELECT Name, Age FROM Suspect
    ) AS temp
ORDER BY Age DESC;

SELECT ROUND(AVG(Age),0) AS AverageAge
FROM (SELECT Name, Age FROM Victim
    UNION ALL
    SELECT Name, Age FROM Suspect
    ) AS temp

SELECT Name
FROM (
    SELECT Name
    FROM Victim
    WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open' or Status = 'Closed' )
    UNION
    SELECT Name
    FROM Suspect
    WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE Status = 'Open' or Status = 'Closed' )
) AS temp;

SELECT Name
FROM (
    SELECT Name
    FROM Victim
    WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery')
    UNION
    SELECT Name
    FROM Suspect
    WHERE CrimeID IN (SELECT CrimeID FROM Crime WHERE IncidentType = 'Robbery')
) AS temp;

SELECT c.*
FROM Crime c
INNER JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.Age > ANY (SELECT v.Age FROM Victim v WHERE v.CrimeID = c.CrimeID);

SELECT SuspectID, Name
FROM Suspect
GROUP BY SuspectID, Name
HAVING COUNT(DISTINCT CrimeID) > 1;

SELECT c.*
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID
WHERE s.SuspectID IS NULL;


SELECT DISTINCT s.SuspectID, s.Name
FROM Suspect s
INNER JOIN Crime c ON s.CrimeID = c.CrimeID
WHERE c.IncidentType IN ('Robbery', 'Assault');


SELECT c.CrimeID, c.IncidentType, c.IncidentDate, c.Location, c.Description, 
COALESCE(s.Name, 'No Suspect') AS SuspectName
FROM Crime c
LEFT JOIN Suspect s ON c.CrimeID = s.CrimeID;

SELECT IncidentType,COUNT(*) from crime group by IncidentType
HAVING COUNT(IncidentType)>1

SELECT * FROM Crime WHERE IncidentType = 'Homicide';
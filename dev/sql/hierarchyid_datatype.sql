USE hierarchy_test;

/**
 * Create `EmployeeOrg` table using a hierarchyid data type.
 * https://msdn.microsoft.com/en-us/library/bb677169.aspx
**
GO
CREATE TABLE EmployeeOrg
(
	OrgNode hierarchyid PRIMARY KEY CLUSTERED,
	OrgLevel AS OrgNode.GetLevel(),
	EmployeeID int UNIQUE NOT NULL,
	EmpName varchar(20) NOT NULL,
	Title varchar(20) NULL
);
GO

CREATE UNIQUE INDEX EmployeeOrgNc1
ON EmployeeOrg(OrgLevel, OrgNode);
GO
**/

/**
 * Insert the root of the hierarchy tree.
 * https://msdn.microsoft.com/en-us/library/bb677174.aspx
**
GO
INSERT EmployeeOrg (OrgNode, EmployeeID, EmpName, Title)
VALUES (hierarchyid::GetRoot(), 6, 'David', 'Marketing Manager');
GO
**/

/**
 * Get the root level from the `EmployeeOrg` table, and insert a
 * child of the root user.
 * https://msdn.microsoft.com/en-us/library/bb677174.aspx
**
DECLARE @Manager hierarchyid;
SELECT @Manager = hierarchyid::GetRoot()
FROM EmployeeOrg;

INSERT EmployeeOrg (OrgNode, EmployeeID, EmpName, Title)
VALUES (@Manager.GetDescendant(NULL, NULL), 46, 'Sariya', 'Marketing Specialist');
**/

/**
 * Create a procedure for adding an employee with a given manager.
 * https://msdn.microsoft.com/en-us/library/bb677174.aspx
**
GO
CREATE PROC AddEmp(@mgrid int, @empid int, @e_name varchar(20), @title varchar(20)) 
AS
BEGIN
	DECLARE @mOrgNode hierarchyid, @lc hierarchyid;
	SELECT @mOrgNode = OrgNode
	FROM EmployeeOrg
	WHERE EmployeeID = @mgrid;
	
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
	BEGIN TRANSACTION
		SELECT @lc = max(OrgNode)
		FROM EmployeeOrg
		WHERE OrgNode.GetAncestor(1) = @mOrgNode;

		INSERT EmployeeOrg (OrgNode, EmployeeID, EmpName, Title)
		VALUES (@mOrgNode.GetDescendant(@lc, NULL), @empid, @e_name, @title);
	COMMIT
END;
GO
**/

/**
 * Use the `AddEmp` procedure that was created to add all employees with their specified
 * managers hierarchy.
 * https://msdn.microsoft.com/en-us/library/bb677174.aspx
**
EXEC AddEmp 6, 271, 'John', 'Marketing Specialist';
EXEC AddEmp 6, 119, 'Jill', 'Marketing Specialist';
EXEC AddEmp 46, 269, 'Wanida', 'Marketing Assistant';
EXEC AddEmp 271, 272, 'Mary', 'Marketing Assistant';
**/

/**
 * Select records from the `EmployeeOrg` table. Run the ToString method on the `OrdNode`
 * column to get a more easily read value.
 * https://msdn.microsoft.com/en-us/library/bb677174.aspx
**/
SELECT OrgNode.ToString() AS Text_OrgNode, 
OrgNode, OrgLevel, EmployeeID, EmpName, Title
FROM EmployeeOrg;

/**
 * Query to find all subordinates of the selected employee.
 * https://msdn.microsoft.com/en-us/library/bb677191.aspx
**/
DECLARE @CurrentEmployee hierarchyid;
SELECT @CurrentEmployee = OrgNode
FROM EmployeeOrg
WHERE EmployeeID = 6;

SELECT * 
FROM EmployeeOrg
WHERE OrgNode.IsDescendantOf(@CurrentEmployee) = 1;

/**
 * Query to find all ancestors of the selected employee.
**/
DECLARE @CurrentEmployee hierarchyid;
SELECT @CurrentEmployee = OrgNode
FROM EmployeeOrg
WHERE EmployeeID = 6;

SELECT * 
FROM EmployeeOrg
WHERE OrgNode.GetAncestor(@CurrentEmployee) = 1;

/**
 * Query using the GetLevel method to see how many levels down each row is in the hierarchy.
 * https://msdn.microsoft.com/en-us/library/bb677191.aspx
**
SELECT OrgNode.ToString() AS Text_OrgNode,
OrgNode.GetLevel() AS EmpLevel, *
FROM EmployeeOrg;
GO
**/

/**
 * Query using the GetRoot method to select the row that is the root of the hierarchy.
 * https://msdn.microsoft.com/en-us/library/bb677191.aspx
**
SELECT OrgNode.ToString() AS Text_OrgNode, *
FROM EmployeeOrg
WHERE OrgNode = hierarchyid::GetRoot();
GO
**/
$userQuery = @'
SELECT v_R_User.ResourceID AS UserID, User_Name0 AS [UserName], Full_User_Name0 AS FullName, Mail0 AS Email, telephoneNumber0 AS OfficePhone, Windows_NT_Domain0 AS UserDomain
FROM v_R_User
'@

$computerQuery = @'
SELECT v_R_System_Valid.ResourceID AS ComputerID, v_R_System_Valid.Netbios_Name0 AS ComputerName FROM v_R_System_Valid
'@

$collectionQuery = @'
SELECT CollectionID, Name AS CollectionName, MemberCount FROM v_Collection
'@

$assignmentCiQuery = @'
SELECT v_CIAssignment.AssignmentID AS AssignmentID, CollectionID, CI_ID, StartTime, EnforcementDeadline AS Deadline, DesiredConfigType AS Action, NotifyUser
FROM v_CIAssignment INNER JOIN v_CIAssignmentToCI ON v_CIAssignment.AssignmentID = v_CIAssignmentToCI.AssignmentID
'@

$complianceUserQuery = @'
SELECT CI_ID, v_CICurrentComplianceStatus.ResourceID AS ComputerID, v_R_User.ResourceID AS UserID, ComplianceState, EnforcementState, LastComplianceMessageTime, LastEnforcementMessageTime
FROM v_CICurrentComplianceStatus LEFT JOIN v_R_User ON v_CICurrentComplianceStatus.FullName = v_R_User.Unique_User_Name0
WHERE v_R_User.ResourceID IN (@UserID) AND CI_ID IN (@CI_ID)
'@

$complianceComputerQuery = @'
SELECT CI_ID, v_CICurrentComplianceStatus.ResourceID AS ComputerID, v_R_User.ResourceID AS UserID, ComplianceState, EnforcementState, LastComplianceMessageTime, LastEnforcementMessageTime
FROM v_CICurrentComplianceStatus LEFT JOIN v_R_User ON v_CICurrentComplianceStatus.FullName = v_R_User.Unique_User_Name0
WHERE CI_ID IN (@CI_ID) AND v_CICurrentComplianceStatus.ResourceID IN (@ComputerID)
'@

$applicationQuery = @'
SELECT DisplayName AS AppName, CI_ID, ModelName AS AppModelName, CIVersion, Manufacturer, SoftwareVersion AS AppVersion, NumberOfDevicesWithApp, NumberOfUsersWithApp, NumberOfDeployments, NumberOfDeploymentTypes, SDMPackageDigest
FROM dbo.fn_ListLatestApplicationCIs(1033)
'@

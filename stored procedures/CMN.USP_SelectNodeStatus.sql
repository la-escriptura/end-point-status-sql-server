-- =============================================
-- Author     : Aguilar, Christopher B.
-- Email      : 
-- Create date: 
-- Description:
-- =============================================
CREATE PROCEDURE CMN.USP_SelectNodeStatus
AS
BEGIN
	SELECT CONCAT('<img style="width:20px;height:20px" src="/',StatusCode,'.jpg" title="',StatusCode,'" />') AS [  ],
	SecurityTool, Instance, Domain,
	CASE WHEN (MonitoringLevel <> 3) THEN IP
	ELSE CONCAT('<a target="_blank" href="',CASE WHEN (IsTlsEncryted = 1) THEN 'https' ELSE 'http' END,'://',CASE WHEN (UseFqdnInsteadOfIP = 1) THEN fqdn ELSE [IP] END,':',Port,Path,'">',[IP],'</a>') END AS IP,
	hostname, fqdn, 
	CASE [MonitoringLevel] WHEN 3 THEN 'http >> telnet >> ping' WHEN 2 THEN 'telnet >> ping' WHEN 1 THEN 'ping' END AS [MonitoringLevel], 
	Status, StatusDescription, StatusCode, UpdatedDate
	FROM CMN.VW_NodeStatus
	ORDER BY CASE StatusCode
	WHEN 'Red' THEN 0
	WHEN 'Orange' THEN 1
	WHEN 'Yellow' THEN 2
	WHEN 'Green' THEN 3
	END, CASE MonitoringLevel
	WHEN 3 THEN 0
	WHEN 2 THEN 1
	WHEN 1 THEN 2
	END, SecurityTool, Instance, Domain

END
GO

-- =============================================
-- Author      : Aguilar, Christopher B.
-- Email       : 
-- Create date : 
-- Description : 
-- =============================================
CREATE PROCEDURE CMN.USP_SelectMonitoredNode
AS
BEGIN
	SELECT
		MonitoredNodeId,
		CASE WHEN (UseFqdnInsteadOfIP = 1) THEN fqdn ELSE [IP] END AS Domain,
		Port,
		Path,
		IsTlsEncryted,
		MonitoringLevel
	FROM CMN.MonitoredNode
	WHERE [IsActive] = 1
END
GO

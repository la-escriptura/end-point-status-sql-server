-- =============================================
-- Author      : Aguilar, Christopher B.
-- Email       : 
-- Create date : 
-- Description : 
-- =============================================
CREATE PROCEDURE CMN.USP_CrudSelectMonitoredNodeById
	@MonitoredNodeId INT
AS
BEGIN
	SELECT 
	s.SecurityTool, 
	i.Instance, 
	d.Domain, 
	m.IP, 
	m.hostname, 
	m.fqdn, 
	m.Port, 
	m.Path, 
	m.UseFqdnInsteadOfIP, 
	m.IsTlsEncryted, 
	m.MonitoringLevel 
	FROM [CMN].[MonitoredNode] m, CMN.SecurityTools s, CMN.Instances i, CMN.Domains d  
	WHERE m.SecToolId = s.SecToolId
	AND m.InstanceId = i.InstanceId
	AND m.DomainId = d.DomainId
	AND m.[IsActive] = 1 
	AND m.MonitoredNodeId = @MonitoredNodeId;
END
GO

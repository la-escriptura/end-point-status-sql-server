CREATE VIEW CMN.VW_NodeStatus AS 
	SELECT s.SecurityTool
	,i.Instance
	,d.Domain
	,m.[IP]
	,m.[hostname]
	,m.[fqdn]
	,m.[Port]
	,m.[Path]
	,m.[UseFqdnInsteadOfIP]
	,m.[IsTlsEncryted]
	,m.[MonitoringLevel]
	,CASE WHEN m.[StatusCode] = 0 THEN 'Unknown'
	ELSE CONCAT(CASE WHEN m.[StatusCode] > 0 THEN 'YES' ELSE 'NOT' END,' able to ',
	CASE ABS(m.[StatusCode]) WHEN 3 THEN 'http' WHEN 2 THEN 'telnet' WHEN 1 THEN 'ping' END) END AS [Status]
	,m.[StatusDescription]
	,CASE WHEN (m.[StatusCode] > 0) THEN 'Green'
	WHEN (m.[StatusCode] = 0) THEN 'Gray'
	WHEN (m.[StatusCode] = -1) THEN 'Red'
	WHEN ((m.[StatusCode] * -1) >= m.[MonitoringLevel]) THEN 'Yellow'
	ELSE 'Orange' END AS [StatusCode]
	,m.UpdatedDate
	FROM [CMN].[MonitoredNode] m, CMN.SecurityTools s, CMN.Instances i, CMN.Domains d 
	WHERE m.SecToolId = s.SecToolId
	AND m.InstanceId = i.InstanceId
	AND m.DomainId = d.DomainId
	AND m.[IsActive] = 1 

CREATE TABLE CMN.MonitoredNode (
	MonitoredNodeId INT NOT NULL IDENTITY(1,1)
	,SecToolId INT NOT NULL REFERENCES CMN.SecurityTools (SecToolId)
	,InstanceId INT NOT NULL REFERENCES CMN.Instances (InstanceId)
	,DomainId INT NOT NULL REFERENCES CMN.Domains (DomainId)
	,IP NVARCHAR(50) NOT NULL
	,hostname NVARCHAR(50) NULL
	,fqdn NVARCHAR(100) NULL
	,Port NVARCHAR(10) NULL
	,Path NVARCHAR(400) NULL
	,UseFqdnInsteadOfIP BIT NULL
	,IsTlsEncryted BIT NULL
	,MonitoringLevel TINYINT NOT NULL
	,StatusCode SMALLINT NULL
	,StatusDescription NVARCHAR(2000) NULL
	,UserAccount NVARCHAR(50) NOT NULL
	,IsActive BIT NULL
	,DateActive DATETIME NULL
	,DateInactive DATETIME NULL
	,UpdatedBy NVARCHAR(50) NULL
	,UpdatedDate DATETIME NULL
	,PRIMARY KEY (MonitoredNodeId))

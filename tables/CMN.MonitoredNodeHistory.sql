CREATE TABLE CMN.MonitoredNodeHistory (
	MonitoredNodeHistoryId INT NOT NULL IDENTITY(1,1)
	,MonitoredNodeId INT NOT NULL
	,StatusCode SMALLINT NULL
	,StatusDescription NVARCHAR(2000) NULL
	,UpdatedBy NVARCHAR(50) NULL
	,UpdatedDate DATETIME NULL
	,PRIMARY KEY (MonitoredNodeHistoryId))

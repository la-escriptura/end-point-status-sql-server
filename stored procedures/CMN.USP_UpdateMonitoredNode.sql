-- =============================================
-- Author      : Aguilar, Christopher B.
-- Email       : 
-- Create date : 
-- Description : 
-- =============================================
CREATE PROCEDURE CMN.USP_UpdateMonitoredNode
	@MonitoredNodeId INT,
	@StatusCode SMALLINT,
	@StatusDescription NVARCHAR(2000)
AS
BEGIN
	UPDATE CMN.MonitoredNode SET 
		StatusCode = @StatusCode, 
		StatusDescription = @StatusDescription, 
		UpdatedBy = SUSER_NAME(), 
		UpdatedDate = GETDATE()
	OUTPUT 
		DELETED.MonitoredNodeId, 
		DELETED.StatusCode, 
		DELETED.StatusDescription, 
		DELETED.UpdatedBy, 
		DELETED.UpdatedDate
	INTO CMN.MonitoredNodeHistory (
		MonitoredNodeId, 
		StatusCode, 
		StatusDescription, 
		UpdatedBy, 
		UpdatedDate
	) WHERE MonitoredNodeId = @MonitoredNodeId;
END

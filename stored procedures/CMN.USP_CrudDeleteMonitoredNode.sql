-- =============================================
-- Author      : Aguilar, Christopher B.
-- Email       : 
-- Create date : 
-- Description : 
-- =============================================
CREATE PROCEDURE CMN.USP_CrudDeleteMonitoredNode
	@MonitoredNodeIds NVARCHAR(1000),
	@UserAccount NVARCHAR(50)
AS
BEGIN
	UPDATE CMN.MonitoredNode SET
		UserAccount = @UserAccount,
		IsActive = 0,
		DateInactive = GETDATE(),
		UpdatedBy = SUSER_NAME(),
		UpdatedDate = GETDATE()	
	WHERE MonitoredNodeId IN (SELECT val FROM CMN.UFN_Split(@MonitoredNodeIds, ',')) 
END
GO

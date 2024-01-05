-- =============================================
-- Author      : Aguilar, Christopher B.
-- Email       : 
-- Create date : 
-- Description : 
-- =============================================
CREATE PROCEDURE CMN.USP_CrudUpdateMonitoredNode
	@MonitoredNodeId INT,
	@SecurityTool NVARCHAR(300),
	@Instance NVARCHAR(300),
	@Domain NVARCHAR(300),
	@IP NVARCHAR(50),
	@hostname NVARCHAR(50),
	@fqdn NVARCHAR(100),
	@Port NVARCHAR(10),
	@Path NVARCHAR(400),
	@UseFqdnInsteadOfIP BIT,
	@IsTlsEncryted BIT,
	@MonitoringLevel TINYINT,
	@UserAccount NVARCHAR(50)
AS
BEGIN
	DECLARE @SecToolId INT
	DECLARE @InstanceId INT
	DECLARE @DomainId INT
	
	SELECT @SecToolId = SecToolId FROM CMN.SecurityTools WHERE SecurityTool = @SecurityTool
	IF (@SecToolId IS NULL)
	BEGIN
		INSERT INTO CMN.SecurityTools (SecurityTool) VALUES (@SecurityTool);
		SET @SecToolId = SCOPE_IDENTITY();
	END
	SELECT @InstanceId = InstanceId FROM CMN.Instances WHERE Instance = @Instance
	IF (@InstanceId IS NULL)
	BEGIN
		INSERT INTO CMN.Instances (Instance) VALUES (@Instance);
		SET @InstanceId = SCOPE_IDENTITY();
	END
	SELECT @DomainId = DomainId FROM CMN.Domains WHERE Domain = @Domain
	IF (@DomainId IS NULL)
	BEGIN
		INSERT INTO CMN.Domains (Domain) VALUES (@Domain);
		SET @DomainId = SCOPE_IDENTITY();
	END

	UPDATE CMN.MonitoredNode SET
		SecToolId = @SecToolId,
		InstanceId = @InstanceId,
		DomainId = @DomainId,
		IP = @IP,
		hostname = @hostname,
		fqdn = @fqdn,
		Port = @Port,
		Path = @Path,
		UseFqdnInsteadOfIP = @UseFqdnInsteadOfIP,
		IsTlsEncryted = @IsTlsEncryted,
		MonitoringLevel = @MonitoringLevel,
		UserAccount = @UserAccount,
		UpdatedBy = SUSER_NAME(),
		UpdatedDate = GETDATE()	
	WHERE MonitoredNodeId = @MonitoredNodeId
END
GO

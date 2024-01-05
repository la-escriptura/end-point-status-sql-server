-- =============================================
-- Author      : Aguilar, Christopher B.
-- Email       : 
-- Create date : 
-- Description : 
-- =============================================
CREATE PROCEDURE CMN.USP_CrudSelectMonitoredNode
	@TotalRowCount INT OUTPUT,
	@PageNo INT OUTPUT,
	@RowCountPerPage INT,
	@SecurityTool NVARCHAR(300) = NULL,
	@Instance NVARCHAR(300) = NULL,
	@Domain NVARCHAR(300) = NULL,
	@IP NVARCHAR(50) = NULL,
	@hostname NVARCHAR(50) = NULL,
	@fqdn NVARCHAR(100) = NULL,
	@Port NVARCHAR(10) = NULL,
	@Path NVARCHAR(400) = NULL,
	@UseFqdnInsteadOfIP BIT = NULL,
	@IsTlsEncryted BIT = NULL,
	@MonitoringLevel TINYINT = NULL,
	@Sort VARCHAR(300) = NULL
AS
BEGIN
	DECLARE @SQLCount NVARCHAR(2000);
	DECLARE @SQLString VARCHAR(2000);

	SET @SQLCount = N'SELECT @TotalRowCount = COUNT(*) '
		+ N'FROM [CMN].[MonitoredNode] m, CMN.SecurityTools s, CMN.Instances i, CMN.Domains d '
		+ N'WHERE m.SecToolId = s.SecToolId '
		+ N'AND m.InstanceId = i.InstanceId '
		+ N'AND m.DomainId = d.DomainId '
		+ N'AND m.[IsActive] = 1 ';

	SET @SQLString = 'SELECT '
		+ 'm.MonitoredNodeId, '
		+ 's.SecurityTool, '
		+ 'i.Instance, '
		+ 'd.Domain, '
		+ 'm.IP, '
		+ 'm.hostname, '
		+ 'm.fqdn, '
		+ 'm.Port, '
		+ 'm.Path, '
		+ 'm.UseFqdnInsteadOfIP, '
		+ 'm.IsTlsEncryted, '
		+ 'CASE m.MonitoringLevel '
		+ 'WHEN 1 THEN ''ping'' '
		+ 'WHEN 2 THEN ''telnet >> ping'' '
		+ 'WHEN 3 THEN ''http >> telnet >> ping'' '
		+ 'END AS MonitoringLevel '
		+ 'FROM [CMN].[MonitoredNode] m, CMN.SecurityTools s, CMN.Instances i, CMN.Domains d '
		+ 'WHERE m.SecToolId = s.SecToolId '
		+ 'AND m.InstanceId = i.InstanceId '
		+ 'AND m.DomainId = d.DomainId '
		+ 'AND m.[IsActive] = 1 ';
	IF (@SecurityTool IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND s.SecurityTool LIKE ''%' + @SecurityTool + N'%'' ';
		SET @SQLString = @SQLString +  'AND s.SecurityTool LIKE ''%' + @SecurityTool +  '%'' ';
	END	
	IF (@Instance IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND i.Instance LIKE ''%' + @Instance + N'%'' ';
		SET @SQLString = @SQLString +  'AND i.Instance LIKE ''%' + @Instance +  '%'' ';
	END	
	IF (@Domain IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND d.Domain LIKE ''%' + @Domain + N'%'' ';
		SET @SQLString = @SQLString +  'AND d.Domain LIKE ''%' + @Domain +  '%'' ';
	END	
	IF (@IP IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND m.IP LIKE ''%' + @IP + N'%'' ';
		SET @SQLString = @SQLString +  'AND m.IP LIKE ''%' + @IP +  '%'' ';
	END	
	IF (@hostname IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND m.hostname LIKE ''%' + @hostname + N'%'' ';
		SET @SQLString = @SQLString +  'AND m.hostname LIKE ''%' + @hostname +  '%'' ';
	END	
	IF (@fqdn IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND m.fqdn LIKE ''%' + @fqdn + N'%'' ';
		SET @SQLString = @SQLString +  'AND m.fqdn LIKE ''%' + @fqdn +  '%'' ';
	END	
	IF (@Port IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND m.Port LIKE ''%' + @Port + N'%'' ';
		SET @SQLString = @SQLString +  'AND m.Port LIKE ''%' + @Port +  '%'' ';
	END	
	IF (@Path IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND m.Path LIKE ''%' + @Path + N'%'' ';
		SET @SQLString = @SQLString +  'AND m.Path LIKE ''%' + @Path +  '%'' ';
	END	
	IF (@UseFqdnInsteadOfIP IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND m.UseFqdnInsteadOfIP = ' + CAST(@UseFqdnInsteadOfIP AS VARCHAR(10)) + N' ';
		SET @SQLString = @SQLString +  'AND m.UseFqdnInsteadOfIP = ' + CAST(@UseFqdnInsteadOfIP AS VARCHAR(10)) +  ' ';
	END	
	IF (@IsTlsEncryted IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND m.IsTlsEncryted = ' + CAST(@IsTlsEncryted AS VARCHAR(10)) + N' ';
		SET @SQLString = @SQLString +  'AND m.IsTlsEncryted = ' + CAST(@IsTlsEncryted AS VARCHAR(10)) +  ' ';
	END	
	IF (@MonitoringLevel IS NOT NULL)
	BEGIN
		SET @SQLCount  = @SQLCount  + N'AND m.MonitoringLevel = ' + CAST(@MonitoringLevel AS VARCHAR(10)) + N' ';
		SET @SQLString = @SQLString +  'AND m.MonitoringLevel = ' + CAST(@MonitoringLevel AS VARCHAR(10)) +  ' ';
	END	
	
	IF (@Sort IS NOT NULL)
	BEGIN
		SET @SQLString = @SQLString + 'ORDER BY ' + @Sort + ' ';
	END	
	ELSE
	BEGIN
		SET @SQLString = @SQLString + 'ORDER BY m.MonitoredNodeId ';
	END
	
	EXEC SP_EXECUTESQL @SQLCount, N'@TotalRowCount INT OUTPUT', @TotalRowCount = @TotalRowCount OUTPUT
	IF (((@PageNo - 1) * @RowCountPerPage) >= @TotalRowCount)
	BEGIN
		SET @PageNo = CEILING(CAST(@TotalRowCount AS FLOAT) / CAST(@RowCountPerPage AS FLOAT))
		IF (@PageNo < 1)
		BEGIN
			SET @PageNo = 1
		END
	END

	SET @SQLString = @SQLString + 'OFFSET (' + CAST(@PageNo AS VARCHAR(10)) + ' - 1) * ' + CAST(@RowCountPerPage AS VARCHAR(10)) + ' ROWS '
		+ 'FETCH NEXT ' + CAST(@RowCountPerPage AS VARCHAR(10)) + ' ROWS ONLY; ';
	EXEC (@SQLString)
END

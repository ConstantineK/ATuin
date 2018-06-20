function Get-DefaultBackupLocation {
  Publish-DebugInfo
  
  $BackupLocationQuery = "DECLARE @output TABLE (Value nvarchar(50), Data nvarchar(500))
    DECLARE @path nvarchar(500)

    INSERT @output (Value, Data)
    EXEC master.dbo.xp_instance_regread
      N'HKEY_LOCAL_MACHINE',
      N'Software\Microsoft\MSSQLServer\MSSQLServer',N'BackupDirectory'
    SET @path = (SELECT TOP 1 Data FROM @output)
    SELECT @path as backup_location"

    Write-Error "Incomplete"
}
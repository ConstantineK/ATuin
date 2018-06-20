function Get-BackupFiles {
  # Get backup default location
  Publish-DebugInfo
  
  $BackupPath = Get-DefaultBackupLocation
  Write-Error "Incomplete"
}
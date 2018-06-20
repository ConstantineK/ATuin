Set-StrictMode -Version 2
function Get-SqlConnection {
    Param(
        [string]$ServerInstance,
        [string]$Database,
        [string]$Script,
        [string]$Username,
        [string]$Password,
        [int]$Timeout = 300
      )
      Publish-DebugInfo

    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    if($Username -or $Password){
      $SqlConnection.ConnectionString = "Server=$ServerInstance;Database=$Database;User Id=$Username;Password=$Password;Trusted_Connection=False;Connection Timeout=$Timeout;"
    }
    else {
      $SqlConnection.ConnectionString = "Server=$ServerInstance;Database=$Database;Trusted_Connection=True;Connection Timeout=$Timeout;"
    }
    $handler = Get-SqlErrorHandler
  
    $SqlConnection.add_InfoMessage($handler)
    $SqlConnection.FireInfoMessageEventOnUserErrors = $true
    $SqlConnection.Open()

    return $SqlConnection
}

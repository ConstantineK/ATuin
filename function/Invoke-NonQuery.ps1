function Invoke-NonQuery {
  Param(
    [string]$ServerInstance,
    [string]$Database,
    [string]$Script,
    [string]$Username,
    [string]$Password,
    [int]$Timeout = 300
  )
  Publish-DebugInfo

  # from https://www.robinosborne.co.uk/2014/10/13/getting-past-powershell-sqls-incorrect-syntax-near-go-message/
  # plus edits to make this logging work
  $Global:message_capture = New-Object System.Collections.ArrayList
  $Global:query_logger = New-Object System.Collections.ArrayList

  $batches = $Script -split "GO\r\n"
  $SqlConnection = Get-SqlConnection @PSBoundParameters

  $stopWatch = New-Timer
  $batch_counter = 0
  Write-Debug "Starting query batches"
  foreach($batch in $batches)
  {
      if ($batch.Trim() -ne ""){
        $batch_counter += 1
        $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
        
        Write-Verbose "Running Query:"
        Write-Verbose $batch

        $null = $Global:query_logger.Add($batch)
        
        $SqlCmd.CommandText = $batch
        $SqlCmd.Connection = $SqlConnection
        
        $stopWatch.Start()
        [int]$out = $SqlCmd.ExecuteNonQuery()        
        
        Write-Debug "Last batch: $($stopWatch.TimeElapsed())"
        Write-Debug "Total Batches $batch_counter"
        $len = 50
        if ($batch.length -lt 50){
          $len = $batch.length
        }
        Write-Debug $batch.Substring(0,$len)
      }
  }
  $SqlConnection.Close()
  return , $Global:message_capture
}

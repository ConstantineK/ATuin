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
# Consider something like Dep Injection, you would have global state as a singleton or shared for this run 
# So how would we name and track runs? 
# We could start and pass around a GUID 
# However passing things around by reference is a bit weird in powershell 

# Otherwise, each batch actually has its own logger so we can log to each batch 
Set-StrictMode -Version 2
function Invoke-Query {
  Param(
    [parameter(ValueFromPipeline, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$ServerInstance,
    [parameter(ValueFromPipeline, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Database,
    [parameter(ValueFromPipeline, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Script,
    [string]$Username,
    [string]$Password,
    [int]$Timeout = 300
  )
  Write-Debug "Invoke-Query"
  Write-Debug "$ServerInstance $Database $Username $Timeout"

  $Global:message_capture = New-Object System.Collections.ArrayList
  $Global:query_logger = New-Object System.Collections.ArrayList

  $batches = Expand-SqlScript -DocumentString $Script
  $SqlConnection = Get-SqlConnection @PSBoundParameters

  $stopWatch = New-Timer
  $batch_counter = 0

  # Because GO is used as a batch separator, we perform each query in the context of the same connection
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
        $Datatable = $SqlCmd.ExecuteReader()

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

  return @{
    result = $DataTable
    $messages = $Global:message_capture
  }
}
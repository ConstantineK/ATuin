foreach ($file in $(Get-ChildItem "$PSScriptRoot\function\internal\*.ps1")){
    . $file.FullName
}
foreach ($file in $(Get-ChildItem "$PSScriptRoot\function\*.ps1")){
    . $file.FullName
}

$Script:QueryLogger = New-Object System.Collections.ArrayList
# The query logger is a list of the queries we ran, along with useful information 
# An example record:
# @( 
#     @{ 
#         Query = QueryText
#         TimeRan = DateTime
#         Caller = FunctionName 
#         Scope = GUID 
#     },
# )
# Queries run in a scope, have a distinct query, ordered by time, and were run by a specific function name 
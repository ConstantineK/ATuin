foreach ($file in $(Get-ChildItem "$PSScriptRoot\function\internal\*.ps1")){
    . $file.FullName
}
foreach ($file in $(Get-ChildItem "$PSScriptRoot\function\*.ps1")){
    . $file.FullName
}
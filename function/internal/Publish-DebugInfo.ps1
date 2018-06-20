function Publish-DebugInfo {
    # logs all the information that helps with debugging

    # Why assign to variables? Well PS cant check the contents of the variable in a watch otherwise
    $Command = ($MyInvocation.PSCommandPath | Split-Path -Leaf) -replace ".ps1",""

    Write-Debug $Command
}
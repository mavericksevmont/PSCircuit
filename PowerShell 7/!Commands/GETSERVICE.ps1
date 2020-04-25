<#
<strong>Name: </strong> !GETSERVICE <strong>Description:</strong>  Get-Service cmdlet and send results to Circuit.<br>
#>

$Message = "Results for $env:COMPUTERNAME :"
[string]$Table = Get-Service | select Name, Status | ConvertTo-Html -Fragment

Send-CircuitMessage -Token $Token -ConversationID $ConversationID -Message "$Message $Table" -ItemID $ItemID

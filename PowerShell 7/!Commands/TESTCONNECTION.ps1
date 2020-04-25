<#
<strong>Name: </strong> !TESTCONNECTION <strong>Description:</strong> Test-Connection to machine running ProdBot.<br>
#>

try {
Test-Connection -ComputerName $env:COMPUTERNAME -Count 1 -OutVariable TCResults
$Status = 'SUCCESS!'
$Dest = $TCResults.Destination
$Results = "$Status $Dest"

} catch {
    $Status = 'FAILED :('
    $Results = "$Status" 
}

if ($AutoProxy -eq $true) {
    Send-CircuitMessage -Token $Token -ConversationID $ConversationID -Message $Results -ItemID $ItemID -AutoProxy } else {
    Send-CircuitMessage -Token $Token -ConversationID $ConversationID -Message $Results  -ItemID $ItemID
    
    }
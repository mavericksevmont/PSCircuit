<#
<strong>Name: </strong> !CIRCUITMESSAGE <strong>Description:</strong> Sends a Test Circuit Message from PowerShell to the Conversation.<br>
#>

if ($AutoProxy -eq $true) {
    Send-CircuitMessage -Token $Token -ConversationID $ConversationID -Message 'Message Sent from PowerShell!' -AutoProxy } else {
    Send-CircuitMessage -Token $Token -ConversationID $ConversationID -Message 'Message Sent from PowerShell!'
    
    }
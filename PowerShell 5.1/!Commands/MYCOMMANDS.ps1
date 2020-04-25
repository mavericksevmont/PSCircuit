<#
<strong>Name: </strong> !MYCOMMANDS <strong>Description:</strong> Gets all commands available for this Conversation.<br>
#>

<#
Get-ChildItem $PSScriptRoot\*.ps1 | foreach {"!$($_.BaseName)"} -OutVariable MyCommands
if ($Proxy -eq $false) {
            Send-CircuitMessage -Token $Token -ConversationID $ConversationID -Message "Available Commands: $MyCommands " -ItemID $ItemID } else {
            Send-CircuitMessage -Token $Token -ConversationID $ConversationID -Message "Available Commands: $MyCommands " -ItemID $ItemID -Proxy
} #>

Get-Content $PSScriptRoot\*.ps1 | Select-String -Pattern 'Name:\s' -OutVariable MyCommands
if ($AutoProxy -eq $false) {
    Send-CircuitMessage -Token $Token -ConversationID $ConversationID -Message "$MyCommands" -ItemID $ItemID } else {
        Send-CircuitMessage -Token $Token -ConversationID $ConversationID -Message "$MyCommands"-ItemID $ItemID  -AutoProxy

}
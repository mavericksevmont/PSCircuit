<#
<strong>Name: </strong> !CIRCUITUPLOADTXT <strong>Description:</strong> Uploads an attachment from PowerShell results to the Conversation.<br>
#>

$Head       = "Results for $env:COMPUTERNAME`r`n"
$TestContent = "`r`nThis is a test content for file upload"
$Date       = (Get-Date).ToString('yyyyMMdd-hhmmss')
$OutFile = "C:\temp\TestFile$Date.txt"
"$Head $TestContent" | Out-File $OutFile -Force

Send-CircuitAttachment -Token $Token -ConversationID $ConversationID -ItemID $ItemID -FilePath $OutFile 

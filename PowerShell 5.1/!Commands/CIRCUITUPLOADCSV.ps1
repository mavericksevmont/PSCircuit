<#
<strong>Name: </strong> !CIRCUITUPLOADCSV <strong>Description:</strong> Uploads an attachment from PowerShell results to the Conversation.<br>
#>

$Date       = (Get-Date).ToString('yyyyMMdd-hhmmss')
$OutFile = "C:\temp\TestFile_$env:COMPUTERNAME`_$Date.csv"
Get-Service |Select Name, Status -First 10 | Export-Csv -Path $OutFile -Force -NoTypeInformation

Send-CircuitAttachment -Token $Token `
                       -ConversationID $ConversationID `
                       -ItemID $ItemID `
                       -FilePath $OutFile `
                       -ContentType 'text/csv'

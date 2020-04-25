function Send-CircuitAttachment{

<#
.SYNOPSIS
    Upload an attachment to Circut conversations.

.DESCRIPTION
    This function uploads attachments to Circuit conversations using the REST API's.

.PARAMETER Token
    The mandatory parameter Token is used to define the Token ID necessary to authenticate for the REST API calls.

.PARAMETER ConversationID
    The mandatory parameter ConversationID is used to specify a Conversation you want to attach the file to. 

.PARAMETER ItemID
    The optional parameter ItemID is used to specify a Conversation item you want to attach the file to.

.PARAMETER FilePath
    The mandatory parameter FilePath is used to specify the file and directory location of the attachment.

.PARAMETER ContentType
    The optional parameter ContentType is used to specify the MIME type associated to the file you are attaching. Default value is text/plain.

.PARAMETER Title
    The optional parameter Title is used to add a text subject for the attachment message.

.PARAMETER Message
    The optional parameter Message is used to add text content for the attachment message.

.PARAMETER AutoProxy
    The optional switch AutoProxy is used to automatically detect and use default Proxy and credentials if required, useful behind VPN's. Windows only.

.EXAMPLE
    Send-CircuitAttachment -Token g4ohd4lems6b4qxs339iu2n8r79j29kn -ConversationID s12f25dr-4f68-6952-85ef-41b14daeabf2 -FilePath C:\temp\text.txt
    Send-CircuitAttachment -Token g4ohd4lems6b4qxs339iu2n8r79j29kn -ConversationID s12f25dr-4f68-6952-85ef-41b14daeabf2 -FilePath C:\temp\file.csv -ContentType text/csv
    Send-CircuitAttachment -Token g4ohd4lems6b4qxs339iu2n8r79j29kn -ConversationID s12f25dr-4f68-6952-85ef-41b14daeabf2 -FilePath C:\temp\text.txt -Title 'New Subject' -Message 'This is your attachment'

OUTPUT EXAMPLE:

type                 : TEXT
itemId               : 7256c9d4-w8ht-a1s9-onhl-d9bwmcsquq1m
convId               : s12f25dr-4f68-6952-85ef-41b14daeabf2
attachments          : {@{fileId=56ccc93d-33cb-4f8d-9b03-fce7e169ea5a; fileName=test.txt; mimeType=text/plain;
                       size=18; itemId=7256c9d4-w8ht-a1s9-onhl-d9bwmcsquq1m; creationTime=1570151295582;
                       modificationTime=1570151295582; creatorId=cac9998d-8755-4f10-a693-105387951e4b;
                       url=/fileapi?fileid=56ccc93d-33cb-4f8d-9b03-fce7e169ea5a;
                       deleteUrl=/fileapi?fileid=56ccc93d-33cb-4f8d-9b03-fce7e169ea5a}}
text                 : @{state=CREATED; subject=; content=; isWebhookMessage=False}
creationTime         : 1570151295582
modificationTime     : 1570151295582
creatorId            : cac9998d-8755-4f10-a693-105387951e4b
includeInUnreadCount : True

.NOTES
    Author:    <Erick Sevilla> 
    Contact:   <https://www.linkedin.com/in/ericksevilla> <http://tech.mavericksevmont.com>
    More info: <https://circuitsandbox.net/rest/v2/swagger/ui/index.html>
    Creation:  2019-06-24
    Version 1.0 - initial release

#> 

[cmdletbinding()]
Param (

        [switch]$AutoProxy,

        [Parameter( Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Token,

                [Parameter( Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ConversationID,

        [Parameter( Mandatory=$false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ItemID,

        [Parameter( Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath,

        [Parameter( Mandatory=$false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ContentType = 'text/plain',

        [Parameter( Mandatory=$false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Title = '',

        [Parameter( Mandatory=$false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Message = ''
        
        ) #Param end


        $FileName = (Get-Item $FilePath).Name

        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("Authorization", " Bearer $Token")
        $headers.Add("Cache-Control", ' no-cache')
        $headers.Add("Content-Disposition", " attachment; filename=`"$FileName`"")
        $headers.Add("Content-Type", "$ContentType")

        $body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $body.Add("subject", "$Title")
        $body.Add("content", "$Message")
        


                $uriupload = "$($config.circuit.uri)/rest/v2/fileapi"
                $uriattach = "$($config.circuit.uri)/rest/v2/conversations/$ConversationID/messages/$itemID"
                $Root = Get-Module PSCircuit; [string]$Dir = $Root.ModuleBase # Root dir to grab curl.exe's path based on module's import location.
                
                if ($AutoProxy -eq $false) {
                #$Upload = Invoke-RestMethod $uriupload -Method 'POST' -Headers $headers -InFile $FilePath # Fails due to bug in Windows PowerShell 5.1, replaced with curl call
                #$AttachmentID = $Upload.attachmentId # Fails due to bug in Windows PowerShell 5.1, replaced with curl call
                $arguments = "--location --request POST `"$uriupload`" --header `"Authorization:  Bearer $Token`" --header `"Cache-Control:  no-cache`" --header `"Content-Disposition:  attachment; filename=\`"$Filename\`"`" --header `"Content-Type: $ContentType`" --data-binary `"@$Filepath`" "
                $Upload = Invoke-Process -FilePath $Dir\Utils\curl.exe -ArgumentList $arguments # Using curl.exe for this REST call only in Windows PowerShell due to bug in it.
                [string]$FileID = $Upload.Split(',')[0].Split(':')[1].trim('`"')
                [string]$AttachmentID = $Upload.Split(',')[1].Split(':')[1].trim('}]').trim('`"')

                $body.Add("attachments",$AttachmentID)
                Invoke-RestMethod $uriattach -Method 'POST' -Headers $headers -Body $body

                } else {
                
                $GetProxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy("$uriupload").OriginalString
                #$Upload = Invoke-RestMethod $uriupload -Method 'POST' -Headers $headers -InFile $FilePath -Proxy $GetProxy -ProxyUseDefaultCredentials # Fails due to bug in Windows PowerShell 5.1, replaced with curl call
                #$AttachmentID = $Upload.attachmentId # Fails due to bug in Windows PowerShell 5.1, replaced with curl call
                $arguments = "--location --request POST `"$uriupload`" --header `"Authorization:  Bearer $Token`" --header `"Cache-Control:  no-cache`" --header `"Content-Disposition:  attachment; filename=\`"$Filename\`"`" --header `"Content-Type: $ContentType`" --data-binary `"@$Filepath`" -x `"$GetProxy`" -U : --proxy-ntlm"
                $Upload = Invoke-Process -FilePath $Dir\Utils\curl.exe -ArgumentList $arguments # Using curl.exe for this REST call only in Windows PowerShell due to bug in it.
                [string]$FileID = $Upload.Split(',')[0].Split(':')[1].trim('`"')
                [string]$AttachmentID = $Upload.Split(',')[1].Split(':')[1].trim('}]').trim('`"')

                $body.Add("attachments",$AttachmentID)
                Invoke-RestMethod $uriattach -Method 'POST' -Headers $headers -Body $body -Proxy $GetProxy -ProxyUseDefaultCredentials

                                             
                                             }

                                             }

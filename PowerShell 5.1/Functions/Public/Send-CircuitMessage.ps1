function Send-CircuitMessage {

<#
.SYNOPSIS
    Send messages to Circut conversations.

.DESCRIPTION
    This function sends text messages to Circuit conversations using the REST API's.

.PARAMETER Token
    The mandatory parameter Token is used to define the Token ID necessary to authenticate for the REST API calls.

.PARAMETER ConversationID
    The mandatory parameter ConversationID is used to specify a Conversation you want to send the message to. 

.PARAMETER ItemID
    The optional parameter ItemID is used to specify a Conversation item you want to send the message to.

.PARAMETER Title
    The optional parameter Title is used to add a text subject for the message.

.PARAMETER Message
    The mandatory parameter Message is used to add text content for the message.

.PARAMETER AutoProxy
    The optional switch AutoProxy is used to automatically detect and use default Proxy and credentials if required, useful behind VPN's. Windows only.

.EXAMPLE
    Send-CircuitMessage -Token g4ohd4lems6b4qxs339iu2n8r79j29kn -ConversationID s12f25dr-4f68-6952-85ef-41b14daeabf2 -Message 'Here's Johnny!'
    Send-CircuitMessage -Token g4ohd4lems6b4qxs339iu2n8r79j29kn -ConversationID s12f25dr-4f68-6952-85ef-41b14daeabf2 -Title 'Good morning, Dave' -Message 'I'm sorry, Dave. I'm afraid I can't do that'
    Send-CircuitMessage -Token g4ohd4lems6b4qxs339iu2n8r79j29kn -ConversationID s12f25dr-4f68-6952-85ef-41b14daeabf2 -ItemID 7256c9d4-w8ht-a1s9-onhl-d9bwmcsquq1m -Message 'Wendy, I'm home'

OUTPUT EXAMPLE:

type                 : TEXT
itemId               : 40801336-c692-43fd-b7f0-81377091660a
convId               : 56ccc93d-33cb-4f8d-9b03-fce7e169ea5a
text                 : @{parentId=ee5c20aa-4681-43b5-8b15-e1b2cd0ee74a; state=CREATED; content=Here's Johnny!;
                       isWebhookMessage=False}
creationTime         : 1570152557720
modificationTime     : 1570152557720
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
        
        [Parameter( Mandatory=$True,
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

        [Parameter( Mandatory=$false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Title = '',

        [Parameter( Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$Message
        
        
        ) # Param end

                $uri = "$($config.circuit.uri)/rest/v2/conversations/$ConversationID/messages/$itemID"
                $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                $headers.Add("accept", 'application/json')
                $headers.Add("content-type", 'application/x-www-form-urlencoded')
                $headers.Add("Authorization", "Bearer $Token")

                $body = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                $body.Add("subject", "$Title")
                $body.Add("content", "$Message")


                
                if ($AutoProxy -eq $false) {
                                Invoke-RestMethod -URI "$uri" -Method 'POST' -Headers $headers -Body $body } else {
                                    
                                $GetProxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy("$uri")
                                Invoke-RestMethod -URI $uri -Method 'POST' -Headers $headers -Body $body -Proxy $GetProxy -ProxyUseDefaultCredentials }
                                     
                }

function Get-CircuitItems {

<#
.SYNOPSIS
    Get Circuit Item information from Conversations the Bot is a member of.

.DESCRIPTION
    This function connects to your Circuit application using the REST API's to get Item information from Conversations the bot is a member of.
    Queries items before current time of request.

.PARAMETER Token
    The mandatory parameter Token is used to define the Token ID necessary to authenticate for the REST API calls.

.PARAMETER ConversationID
    The mandatory parameter ConversationID is used to specify a Conversation you want to get the item information from.

.PARAMETER Results
    The optional parameter Results is used to to specify the maximum number of returned results (default is 25). The maximum allowed value is 100.

.PARAMETER AutoProxy
    The optional switch AutoProxy is used to automatically detect and use default Proxy and credentials if required, useful behind VPN's. Windows only.

.EXAMPLE
    
    Get-CircuitItems -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ConversationID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m'
    Get-CircuitItems -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ConversationID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m' -Results 1
    Get-CircuitItems -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ConversationID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m' -AutoProxy

OUTPUT EXAMPLE:

type                 : TEXT
itemId               : dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m
convId               : s12f25dr-4f68-6952-85ef-41b14daeabf2
text                 : @{parentId=s12f25dr-4f68-6952-85ef-41b14daeabf2; state=CREATED; content=Hey there, processing your request!; isWebhookMessage=False}
creationTime         : 1569942763745
modificationTime     : 1569942763745
creatorId            : 56ccc93d-33cb-4f8d-9b03-fce7e169ea5a
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
        [int]$Results = '25'
        
        ) #Param end


                $uri = "$($config.circuit.uri)/rest/v2/conversations/$ConversationID/items?results=$Results"
                $postdata= @{ authorization="bearer $token"}

                
                if ($AutoProxy -eq $false) {
                Invoke-RestMethod -URI "$uri" -Method Get -Headers $postdata} else {$GetProxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy("$uri")
                                             Invoke-RestMethod -URI "$uri" -Method Get -Headers $postdata -Proxy $GetProxy -ProxyUseDefaultCredentials}

                                             }
function Get-CircuitMessages {

<#
.SYNOPSIS
    Get Circuit Messages from Conversations the Bot is a member of.

.DESCRIPTION
    This function connects to your Circuit application using the REST API's to get text messages from conversation items the bot is a member of.

.PARAMETER Token
    The mandatory parameter Token is used to define the Token ID necessary to authenticate for the REST API calls.

.PARAMETER ItemID
    The mandatory parameter ItemID is used to specify a Conversation item you want to get the text messages from.

.PARAMETER AutoProxy
    The optional switch AutoProxy is used to automatically detect and use default Proxy and credentials if required, useful behind VPN's. Windows only.

.EXAMPLE
    
    Get-CircuitMessages -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ItemID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m'
    Get-CircuitMessages -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ItemID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m' -AutoProxy

OUTPUT EXAMPLE:

type                 : TEXT
itemId               : dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m
convId               : s12f25dr-4f68-6952-85ef-41b14daeabf2
text                 : @{state=CREATED; content=Came here to kick bots and chew bubblegum, and I'm outta bubblegum!; isWebhookMessage=False}
creationTime         : 1566659989669
modificationTime     : 1566659989669
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
        [string]$ItemID
        
        ) #Param end


                $uri = "$($config.circuit.uri)/rest/v2/conversations/messages/$ItemID"
                $postdata= @{ authorization="bearer $token"}

                
                if ($AutoProxy -eq $false) {
                Invoke-RestMethod -URI "$uri" -Method Get -Headers $postdata} else {$GetProxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy("$uri")
                                             Invoke-RestMethod -URI "$uri" -Method Get -Headers $postdata -Proxy $GetProxy -ProxyUseDefaultCredentials}

                                             }
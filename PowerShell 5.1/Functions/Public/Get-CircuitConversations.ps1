function Get-CircuitConversations {

<#
.SYNOPSIS
    Get Circuit Conversation information which the Bot is a member of.

.DESCRIPTION
    This function connects to the Circuit application using the REST API's to get information from Conversations the bot is a member of.

.PARAMETER Token
    The mandatory parameter Token is used to define the Token ID necessary to authenticate for the REST API calls.

.PARAMETER ConversationID
    The optional parameter ConversationID is used to specify a Conversation you want to get the information from. 

.PARAMETER AutoProxy
    The optional switch AutoProxy is used to automatically detect and use default Proxy and credentials if required, useful behind VPN's. Windows only.

.EXAMPLE
    
    Get-CircuitConversations -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m
    Get-CircuitConversations -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ConversationID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m'
    Get-CircuitConversations -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ConversationID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m' -AutoProxy

OUTPUT EXAMPLE:

type                  : GROUP
convId                : dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m
participants          : {djuodnw-w8ht-a1s9-onhl-d9bwmcsquq1m, s12f25dr-4f68-6952-85ef-41b14daeabf2}
topic                 : MyNewConversation2
isModerated           : False
creationTime          : 1562913484680
modificationTime      : 1562913484680
creatorId             : 56ccc93d-33cb-4f8d-9b03-fce7e169ea5a
creatorTenantId       : dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m
description           : DifferentConversation2
isGuestAccessDisabled : False

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
        
        [Parameter( Mandatory=$false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [string]$ConversationID
        
        ) #Param end

                $uri = "$($config.circuit.uri)/rest/v2/conversations/"
                $postdata= @{ authorization="bearer $token"}

                if ($AutoProxy -eq $false) {
                if ($ConversationID) {Invoke-RestMethod -URI "$uri/$ConversationID" -Method Get -Headers $postdata} else {

                if ($AutoProxy -eq $false){Invoke-RestMethod -URI $uri -Method Get -Headers $postdata} else
                   {                   $GetProxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy("$uri")
                                       Invoke-RestMethod -URI $uri -Method Get -Headers $postdata -Proxy $GetProxy -ProxyUseDefaultCredentials}
                }
                                     } else {$GetProxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy("$uri")
                                             Invoke-RestMethod -URI "$uri/$ConversationID" -Method Get -Headers $postdata -Proxy $GetProxy -ProxyUseDefaultCredentials}


                
                }
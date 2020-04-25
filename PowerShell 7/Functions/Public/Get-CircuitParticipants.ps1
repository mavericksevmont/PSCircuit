function Get-CircuitParticipants {

<#
.SYNOPSIS
    Performs a search for participants.

.DESCRIPTION
    This function performs a search for participants.
    The max number of participants is configurable. If more participants are available a search pointer is returned for consecutive calls.

.PARAMETER Token
    The mandatory parameter Token is used to define the Token ID necessary to authenticate for the REST API calls.

.PARAMETER ConversationID
    The mandatory parameter ConversationID is used to specify a Conversation you want to get the item information from
    .
.PARAMETER PageSize
    The optional parameter PageSize of the hit list. Default is 25.

.PARAMETER AutoProxy
    The optional switch AutoProxy is used to automatically detect and use default Proxy and credentials if required, useful behind VPN's. Windows only.

.EXAMPLE
    
    Get-CircuitParticipants -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ConversationID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m'
    Get-CircuitParticipants -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ConversationID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m' -PageSize 1

OUTPUT EXAMPLE:

participantList
---------------
{@{type=REGULAR; userId=56ccc93d-33cb-4f8d-9b03-fce7e169ea5a; displayName=Isaac Newton; isDeleted=True; firstName=Isaac; lastName=Newton}, @{ty...

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
        [int]$PageSize = '25'
        
        ) #Param end


                $uri = "$($config.circuit.uri)/rest/v2/conversations/$ConversationID/participants?pageSize=$PageSize"
                $postdata= @{ authorization="bearer $token"}

                
                if ($AutoProxy -eq $false) {
                #(Invoke-RestMethod -URI "$uri" -Method Get -Headers $postdata).participantList
                Invoke-RestMethod -URI "$uri" -Method Get -Headers $postdata
                
                } else {$GetProxy = powershell.exe -command "& {[System.Net.WebRequest]::GetSystemWebproxy().GetProxy('$uri').OriginalString}"
                                             #(Invoke-RestMethod -URI "$uri" -Method Get -Headers $postdata -Proxy $GetProxy -ProxyUseDefaultCredentials).participantList
                                             Invoke-RestMethod -URI "$uri" -Method Get -Headers $postdata -Proxy $GetProxy -ProxyUseDefaultCredentials
                                             }

                                             }
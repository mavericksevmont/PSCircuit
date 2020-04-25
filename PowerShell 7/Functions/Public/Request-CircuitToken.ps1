# Request OAuth 2.0 token
function Request-CircuitToken {

<#
.SYNOPSIS
    Request an access OAuth 2.0 Token from Circuit.

.DESCRIPTION
    This function connects to your specified Circuit application using the REST API's to get an access token.

.PARAMETER ClientID
    The mandatory parameter ClientID is used to define the value of the app's Unique Identifier (Client ID).

.PARAMETER ClientSecret
    The mandatory parameter ClientSecret is used to define the value of the app's Secret Key. 
    The client secret is securely stored in server side and cannot be revealed. 
    If you believe that the secret key is no longer secret, generate a new one.

.PARAMETER Scope
    The optional parameter Scope is used to define the permission levels the app can access from the user's Circuit Data,
    it is 'ALL' by default.

.PARAMETER AutoProxy
    The optional switch AutoProxy is used to automatically detect and use default Proxy and credentials if required, useful behind VPN's. Windows only.

.EXAMPLE
    
    Request-CircuitToken -ClientID dcxyyihfw8hta1s9onhld9bwmcsquq1m -ClientSecret 5506fs0kaktr875lnb61r77zacw11m97
    Request-CircuitToken -ClientID dcxyyihfw8hta1s9onhld9bwmcsquq1m -ClientSecret 5506fs0kaktr875lnb61r77zacw11m97 -AutoProxy
    Request-CircuitToken -ClientID dcxyyihfw8hta1s9onhld9bwmcsquq1m -ClientSecret 5506fs0kaktr875lnb61r77zacw11m97 -SCOPE READ_USER_PROFILE
    Request-CircuitToken -ClientID dcxyyihfw8hta1s9onhld9bwmcsquq1m -ClientSecret 5506fs0kaktr875lnb61r77zacw11m97 -SCOPE 'READ_USER_PROFILE,WRITE_USER_PROFILE'

    OUTPUT EXAMPLE:

    access_token                     token_type scope                              
    ------------                     ---------- -----                              
    g4ohd4lems6b4qxs339iu2n8r79j29kn Bearer     {READ_USER_PROFILE, WRITE_USER_P...

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
        [string]$ClientID,

        [Parameter( Mandatory=$false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true )]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$ClientSecret,

        [Parameter( Mandatory=$false,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        [ValidateSet('READ_USER_PROFILE','WRITE_USER_PROFILE','READ_CONVERSATIONS','WRITE_CONVERSATIONS','READ_USER')]
        [string]$Scope='READ_USER_PROFILE,WRITE_USER_PROFILE,READ_CONVERSATIONS,WRITE_CONVERSATIONS,READ_USER'
        ) # Param end

        $uri = "$($config.circuit.uri)/oauth/token"
        $postdata= @{ client_id=$ClientID;
                      client_secret=$ClientSecret;
                      grant_type='client_credentials';
                      scope=$Scope; }
        
        if ($AutoProxy -eq $false) {Invoke-RestMethod -URI $uri -Method Post -Body $postdata} else 
           {                    $GetProxy = powershell.exe -command "& {[System.Net.WebRequest]::GetSystemWebproxy().GetProxy('$uri').OriginalString}"
                                Invoke-RestMethod -URI $uri -Method Post -Body $postdata -Proxy $GetProxy -ProxyUseDefaultCredentials }

        }
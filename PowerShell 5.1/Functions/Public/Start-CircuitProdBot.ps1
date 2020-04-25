function Start-CircuitProdBot {

<#
.SYNOPSIS
    Start PowerShell's Circuit Conversation Listener.

.DESCRIPTION
    This function starts PowerShell's Circuit Conversation Listener. 
    It awaits commands to interact between the Circuit Bot and run predefined scripts in the OS via PowerShell.

.PARAMETER Token
    The mandatory parameter Token is used to define the Token ID necessary to authenticate for the REST API calls.

.PARAMETER ConversationID
    The mandatory parameter ConversationID is used to specify a Conversation you want to get the item information from.

.PARAMETER AutoProxy
    The optional switch AutoProxy is used to automatically detect and use default Proxy and credentials if required, useful behind VPN's. Windows only.

.EXAMPLE
    
    Start-CircuitProdBot -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ConversationID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m'
    Start-CircuitProdBot -Token ke-dcxyyihfw8hta1s9onhld9bwmcsquq1m - ConversationID 'dcxyyihf-w8ht-a1s9-onhl-d9bwmcsquq1m' -AutoProxy

OUTPUT EXAMPLE:

Start Time: 10/03/2019 21:06:05
ProdBot is listening, it's only 10/03/2019 21:06:05
ProdBot is listening, it's only 10/03/2019 21:06:06
ProdBot is listening, it's only 10/03/2019 21:06:06
ProdBot is listening, it's only 10/03/2019 21:06:07
ProdBot is listening, it's only 10/03/2019 21:06:07
ProdBot is listening, it's only 10/03/2019 21:06:08

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
        [string]$ConversationID

        ) # Param end

        $script:Token = $Token
        $script:ConversationID = $ConversationID
        $Root = Get-Module PSCircuit; [string]$Dir = $Root.ModuleBase
        $Commands = Get-ChildItem "$Dir\Powershell 5.1\!Commands\*.ps1"
        Set-Variable Commands -Option AllScope

        $script:TimeStart = Get-Date
        $script:PreviousTime = ([DateTimeOffset](Get-date)).ToUnixTimeMilliseconds() # Avoids loading pre-script commands
        Write-Host "Start Time: $TimeStart"
        $uri = "$($config.circuit.uri)/rest/v2/conversations/$script:ConversationID/items"
        $postdata= @{authorization="bearer $script:Token"}
        
        if ($AutoProxy -eq $false) {

#AutoProxy False starts here

        while($true) {
         $TimeNow = Get-Date
         Write-Host "ProdBot is listening, it's only $TimeNow"
        $Listener = Invoke-RestMethod -URI $uri -Method Get -Headers $postdata
        $Listener | foreach {
                    $script:ItemID = $_.text.parentId;if ($script:ItemID -eq $null) {$script:ItemID = $_.itemId}
                    $script:TextContent = $_.text.content

                    # Commands go here 
                    foreach ($Command in $Commands) { 
                    Run-ProdBotCommand -CommandName $Command.BaseName -Action {& $Command.Fullname} 
                    }
                    # Commands End Here 


                    } #End ForEach loop
        
            
            
             } #End While loop 

        
        } else #End If Proxy $false 
        { 
           
           
#AutoProxy True starts here:
            $script:GetProxy = ([System.Net.WebRequest]::GetSystemWebproxy()).GetProxy("$uri")
            while($true) {
            $TimeNow = Get-Date
            Write-Host "ProdBot is listening, it's only $TimeNow"
            $Listener = Invoke-RestMethod -URI $uri -Method Get -Headers $postdata -Proxy $GetProxy -ProxyUseDefaultCredentials
            $Listener | foreach {
                    $script:ItemID = $_.text.parentId;if ($script:ItemID -eq $null) {$script:ItemID = $_.itemId}
                    
                    $script:TextContent = $_.text.content
                    # Commands go here
                    foreach ($Command in $Commands) { 
                    Run-ProdBotCommand -CommandName $Command.BaseName -Action {& $Command.Fullname} -AutoProxy
                    }

                    # Commands End Here 


                    } #End ForEach loop
        
            
            
             } #End While loop  
                                }

        }
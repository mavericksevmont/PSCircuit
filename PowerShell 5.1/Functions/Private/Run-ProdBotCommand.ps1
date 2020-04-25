function Run-ProdBotCommand {

<#
.SYNOPSIS
    Create Keyword Commands and run scripts within Start-CircuitProdBot function.

.DESCRIPTION
    Ths function creates a Keyword Command to be called within the Circuit Conversation and assigns a specific PowerShell script to be run.
    This is a Private function, available only within this module's functions, such as Start-CircuitProdBot.

.PARAMETER CommandName
    The mandatory parameter CommandName is used to specify the name of the "!Command" Keyword sent from the  Circuit conversation.

.PARAMETER Action
    The mandatory parameter Action is used to specify the script being called by the related "!Command" Keyword sent from the  Circuit conversation.

.PARAMETER AutoProxy
    The optional switch AutoProxy is used to automatically detect and use default Proxy and credentials if required, useful behind VPN's. Windows only.

.EXAMPLE
    
    Run-ProdBotCommand -CommandName HelloWorld -Action C:\Commands\HelloWorld.ps1
    Run-ProdBotCommand -CommandName HelloWorld -Action C:\Commands\HelloWorld.ps1 -AutoProxy

OUTPUT EXAMPLE:

Script's output.

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
            [string]$CommandName,

            [Parameter( Mandatory=$true,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true )]
            [scriptblock]$Action

            ) # Param end
            
            $uri = $($Config.circuit.uri)
            if ($AutoProxy -eq $false) {
                                if ($($script:TextContent | select -last 1) -match "!$CommandName$" -and $_.modificationTime -gt $script:PreviousTime) {
                        
                        Write-Host "Pingback! $script:ItemID your command was !$CommandName" -ForegroundColor Green
    
                        $CID = $_.CreatorId
                        $headersN = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                        $headersN.Add("accept", 'application/json')
                        $headersN.Add("Authorization", "Bearer $script:Token")
                        $Name = Invoke-RestMethod "$uri/rest/v2/users/$CID" -Method 'GET' -Headers $headersN
                        $Requestor = $Name.firstName
                        Write-Output "Logged - User: $($Name.displayName) UserID: $($Name.userId) Command: !$CommandName Time: $(Get-Date)"
    
                        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                        $headers.Add("accept", 'application/json')
                        $headers.Add("content-type", 'application/x-www-form-urlencoded')
                        $headers.Add("Authorization", "Bearer $script:Token")
                        $body = "content=Hey $Requestor, processing your '!$CommandName' request!"
                        Invoke-RestMethod "$uri/rest/v2/conversations/$script:ConversationID/messages/$script:ItemID" -Method 'POST' -Headers $headers -Body $body
                        
                        & $Action # Your command goes here
    
                        $script:PreviousTime = $_.modificationTime
          
                        }
    
                        } else {
                        
                                
                                if ($($script:TextContent | select -last 1) -match "!$CommandName$" -and $_.modificationTime -gt $script:PreviousTime) {
                        
                        Write-Host "Pingback! $script:ItemID your command was !$CommandName" -ForegroundColor Green
    
                        $CID = $_.CreatorId
                        $headersN = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                        $headersN.Add("accept", 'application/json')
                        $headersN.Add("Authorization", "Bearer $script:Token")
                        $Name = Invoke-RestMethod "$Uri/rest/v2/users/$CID" -Method 'GET' -Headers $headersN -Proxy $script:GetProxy -ProxyUseDefaultCredentials
                        $Requestor = $Name.firstName
                        Write-Output "Logged - User: $($Name.displayName) UserID: $($Name.userId) Command: !$CommandName Time: $(Get-Date)"
    
                        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
                        $headers.Add("accept", 'application/json')
                        $headers.Add("content-type", 'application/x-www-form-urlencoded')
                        $headers.Add("Authorization", "Bearer $script:Token")
                        $body = "content=Hey $Requestor, processing your '!$CommandName' request!"
                        Invoke-RestMethod "$Uri/rest/v2/conversations/$script:ConversationID/messages/$script:ItemID" -Method 'POST' -Headers $headers -Body $body -Proxy $script:GetProxy  -ProxyUseDefaultCredentials
                        
                        & $Action # Your command goes here
    
                        $script:PreviousTime = $_.modificationTime
          
                        }
                        
                        }
    
    
    
    
    
    
    
    }
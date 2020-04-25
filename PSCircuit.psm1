
# Get public and private functions definition files depending on version
switch ($PSVersionTable.PSEdition) {
   "Desktop"  {
        $Public  = @( Get-ChildItem -Path "$PSScriptRoot\PowerShell 5.1\Functions\Public\*.ps1" -ErrorAction SilentlyContinue   )
        $Private = @( Get-ChildItem -Path "$PSScriptRoot\PowerShell 5.1\Functions\Private\*.ps1" -ErrorAction SilentlyContinue )
                    ; break}
   "Core"     {
        $Public  = @( Get-ChildItem -Path "$PSScriptRoot\PowerShell 7\Functions\Public\*.ps1" -ErrorAction SilentlyContinue   )
        $Private = @( Get-ChildItem -Path "$PSScriptRoot\PowerShell 7\Functions\Private\*.ps1" -ErrorAction SilentlyContinue  )

                    ; break}
}

 # Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

#Import Configuration File
$Config = Import-PowerShellDataFile -LiteralPath "$PSScriptRoot\Config\Config.psd1"
# Here I might...
# Read in or create an initial config file and variable
    # Export Public functions ($Public.BaseName) for WIP modules
    # Set variables visible to the module and its functions only

Export-ModuleMember -Function $Public.Basename -Variable Config
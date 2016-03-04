function Copy-VMFolder {

	<#
		.SYNOPSIS
			Copies a folder to a virtual machine
		.DESCRIPTION
			Copies a folder from the host operating system into the guest operating system of the virtual machine. 		
		.LINK
			https://github.com/abillimore/Copy-VMFolder
		.PARAMETER Name
			Specifies an array of virtual machine objects by name. The cmdlet copies a folder to the virtual machines you specify.
		.PARAMETER SourcePath
			Specifies a path. The cmdlet copies the folder from the source path.
		.PARAMETER DestinationPath
			Specifies a path. The cmdlet copies the folder to the destination path.
		.PARAMETER ComputerName
			Specifies an array of Hyper-V hosts. The cmdlet copies the folder from the hosts you specify to the virtual machines you specify.
		.PARAMETER Force
			Forces the command to run without asking for user confirmation.
		.EXAMPLE    
			Copy-VMFolder -Name 'Vm' -SourcePath 'C:\Windows\Temp' -DestinationPath 'C:\' -Force
	#>

	[cmdletbinding()]
	param( 
		[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string[]]$Name,
		[Parameter(Mandatory=$true)][ValidateScript({Test-Path $_ -PathType Container})][string]$SourcePath,
		[Parameter(Mandatory=$true)][string]$DestinationPath,
		[string[]]$ComputerName='.', # default localhost
		[switch]$Force
	)

	Get-ChildItem $SourcePath -File -Recurse | % { 
		Copy-VMFile -ComputerName $ComputerName -Name $Name -SourcePath "$($_.FullName)" -DestinationPath "$($_.FullName)".Replace($(Split-Path $(Resolve-Path -Path $SourcePath) -Parent), $DestinationPath) -FileSource Host -CreateFullPath -Force:$Force
	}
	
}
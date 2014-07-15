
$PuttyRoot = "HKCU:\Software\SimonTatham\PuTTY"
$SessionRoot = "$($PuttyRoot)\Sessions"
$TemplateRoot = "$($PuttyRoot)\Templates"

Function ApplyTemplate( $TargetPath, $SourcePath){
		if ( Test-Path $SourcePath ) {
			# If template name exists
			$TemplateName = (Get-ItemProperty  $SourcePath).TemplateName
			if ($TemplateName -ne $null   ){
#					Write-Host "Template Definition : $($TemplateName)"
					$TemplateName.Split(",") | ForEach {
#						Write-Host "Template Definition, split : $($_)"
						Write-Host "  Apply Template $($TemplateRoot)\$($_)"
						ApplyTemplate $TargetPath "$($TemplateRoot)\$($_)"
					} 
			}
			# If this is the Session root, don't copy properties
			if ($TargetPath -eq $SourcePath){
#				Write-Host "Root, dont copy properties"
			}
			else 
			{
#				Write-Output "Copy properties"
				Get-Item $SourcePath | 
					Select-Object -ExpandProperty property |
					ForEach-Object {
						if ($_ -ne "TemplateName" ){
							Write-Host "    Copy Property $_ ";
							copy-itemproperty -path $SourcePath -destination $TargetPath -name $_
						}
					}
			}
		}
		else {
			Write-Error "  Template not found : $($SourcePath)"
		}
}

# Loop Sessions
Get-Item "$($SessionRoot)\*" |
	ForEach-Object {
		$SessionName = $_.PSPath
		Write-Host "Session: $($SessionName)"
		ApplyTemplate $SessionName $SessionName;
		
	}


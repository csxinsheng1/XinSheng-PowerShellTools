#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
$ErrorActionPreference = 'Inquire'

[bool]$IsLocaleChinese = (Get-WinSystemLocale).DisplayName | Select-String -Pattern "中文" -SimpleMatch -Quiet
if ($IsLocaleChinese) { $host.ui.RawUI.WindowTitle = '搜索无heic后缀的HEIC文件头' }
else { $host.ui.RawUI.WindowTitle = 'Search HEIC file header wihout heic extension name' }

if ($IsLocaleChinese) {
	Write-Host 'SHA1 批量校验器'
	Write-Host '版权所有 © 2024 csxinsheng1'
	Write-Host '源码：https://github.com/csxinsheng1'
	Write-Host ''
	Write-Host '本程序是自由软件：您可以基于自由软件基金会发布的 GNU General Public License 第三版或者（由您选择）任何后续版本的条款下重新分发和/或修改它。'
	Write-Host '分发本程序是希望它能派上用场，但没有任何担保，甚至也没有对其适销性或特定目的适用性的默示担保。更多细节请参见 GNU General Public License。'
	Write-Host '您应该已收到本程序随附的 GNU General Public License 的副本。如未收到，请参见：http://www.gnu.org/licenses/ 。'
	Write-Host ''
} else {
	Write-Host 'SHA1 Batch Verifier'
	Write-Host 'Copyright © 2024 csxinsheng1'
	Write-Host 'Source: https://github.com/csxinsheng1'
	Write-Host ''
	Write-Host 'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.'
	Write-Host 'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.'
	Write-Host 'You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.'
	Write-Host '' 
}

[string]$InputPath = $null
Do{
	if ($IsLocaleChinese) { $InputPath = (Read-Host -Prompt "请输入目标目录") }
	else { $InputPath = (Read-Host -Prompt "Please input target directory") }
	$InputPath = $InputPath -replace '^"(.*)"$', '$1'
	$InputPath = $InputPath -replace '^(.*)\\$', '$1'
}while(-not (Test-Path -LiteralPath $InputPath -PathType Container))
[string]$InputPathEscaped = [Management.Automation.WildcardPattern]::Escape($InputPath)

$images = Get-ChildItem -Path $InputPathEscaped -Exclude "*.heic","*.heif" -Recurse -File
if ($IsLocaleChinese) { Write-Host "以下文件拥有HEIC文件头：" }
else { Write-Host "Files with HEIC file header in below:" }
Write-Host ""
foreach ($image in $images){
	[string]$sFileHeader = Get-Content -LiteralPath "$image" -Encoding Byte -TotalCount 32
	if($sFileHeader | Select-String -Pattern '102 116 121 112 104 101 105 99' -SimpleMatch -Quiet){
		Write-Host "$($image.FullName)"
	}
}
Write-Host ""

if ($IsLocaleChinese) {
	while($true){ if((Read-Host -Prompt "输入`"yes`"退出") -eq 'yes'){break} }
} else {
	while($true){ if((Read-Host -Prompt "Input `"yes`" to quit") -eq 'yes'){break} }
}
#$sFileHeader | Format-Hex
#"0 0 0 24 102 116 121 112 104 101 105 99 0 0 0 0" | Select-String -Pattern '102 116 121 112 104 101 105 99' -SimpleMatch
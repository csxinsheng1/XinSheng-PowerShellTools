#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
$ErrorActionPreference = 'Inquire'

[bool]$IsLocaleChinese = (Get-WinSystemLocale).DisplayName | Select-String -Pattern "中文" -SimpleMatch -Quiet
if ($IsLocaleChinese) { $host.ui.RawUI.WindowTitle = '搜索超过255字节的长文件名' }
else { $host.ui.RawUI.WindowTitle = 'Search filename longer than 255 bytes' }

if ($IsLocaleChinese) {
	Write-Host '搜索超过255字节的长文件名'
	Write-Host '版权所有 © 2024 csxinsheng1'
	Write-Host '源码：https://github.com/csxinsheng1'
	Write-Host ''
	Write-Host '本程序是自由软件：您可以基于自由软件基金会发布的 GNU General Public License 第三版或者（由您选择）任何后续版本的条款下重新分发和/或修改它。'
	Write-Host '分发本程序是希望它能派上用场，但没有任何担保，甚至也没有对其适销性或特定目的适用性的默示担保。更多细节请参见 GNU General Public License。'
	Write-Host '您应该已收到本程序随附的 GNU General Public License 的副本。如未收到，请参见：http://www.gnu.org/licenses/ 。'
	Write-Host ''
} else {
	Write-Host 'Search filename longer than 255 bytes'
	Write-Host 'Copyright © 2024 csxinsheng1'
	Write-Host 'Source: https://github.com/csxinsheng1'
	Write-Host ''
	Write-Host 'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.'
	Write-Host 'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.'
	Write-Host 'You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.'
	Write-Host '' 
}

[string]$InputBuffer = ''
while($true){
	if ($IsLocaleChinese) { $InputBuffer = Read-Host -Prompt "Input path" }
	else { $InputBuffer = Read-Host -Prompt "Input path" }
	if(Test-Path -LiteralPath $InputBuffer -PathType Container){break;}
	else{
		if ($IsLocaleChinese) { Write-Host "路径不存在！" -ForegroundColor red }
		else { Write-Host "Path doesn't exist!" -ForegroundColor red }
	}
}

[array]$arrItems = Get-ChildItem -LiteralPath $InputBuffer -Recurse -File
if ($IsLocaleChinese) { Write-Host "以下文件的名称过长：" -ForegroundColor green }
else { Write-Host "Files have too long name:" -ForegroundColor green }
[int]$iLength = ''
foreach ($objItem in $arrItems) {
	$iLength = [System.Text.Encoding]::UTF8.GetByteCount($objItem.Name)
	if($iLength -gt 255){
		Write-Host "$($objItem.FullName)" -ForegroundColor green
		#Write-Host "$sBuffer 长度：$iLength Bytes" -ForegroundColor green
	}
}

if ($IsLocaleChinese) {
	while($true){
		if((Read-Host -Prompt "输入`"yes`"退出") -eq 'yes'){break}
	}
} else {
	while($true){
		if((Read-Host -Prompt "Input `"yes`" to quit") -eq 'yes'){break}
	}
}
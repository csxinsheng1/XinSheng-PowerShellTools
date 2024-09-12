#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
$ErrorActionPreference = 'Inquire'

[bool]$IsLocaleChinese = (Get-WinSystemLocale).DisplayName | Select-String -Pattern "中文" -SimpleMatch -Quiet
if ($IsLocaleChinese) { $host.ui.RawUI.WindowTitle = '一键挂载OSFMount内存盘到A' }
else { $host.ui.RawUI.WindowTitle = 'Mount OSFMount Ramdisk to A in one key' }

[string]$PathOSFM = 'C:\Program Files\OSFMount\osfmount'
[console]::WindowHeight=32;
#[console]::WindowWidth=60;
#[console]::BufferWidth=[console]::WindowWidth

if ($IsLocaleChinese) {
	Write-Host '一键挂载OSFMount内存盘到A'
	Write-Host '版权所有 © 2024 csxinsheng1'
	Write-Host '源码：https://github.com/csxinsheng1'
	Write-Host ''
	Write-Host '本程序是自由软件：您可以基于自由软件基金会发布的 GNU General Public License 第三版或者（由您选择）任何后续版本的条款下重新分发和/或修改它。'
	Write-Host '分发本程序是希望它能派上用场，但没有任何担保，甚至也没有对其适销性或特定目的适用性的默示担保。更多细节请参见 GNU General Public License。'
	Write-Host '您应该已收到本程序随附的 GNU General Public License 的副本。如未收到，请参见：http://www.gnu.org/licenses/ 。'
	Write-Host ''
} else {
	Write-Host 'Mount OSFMount Ramdisk to A in one key'
	Write-Host 'Copyright © 2024 csxinsheng1'
	Write-Host 'Source: https://github.com/csxinsheng1'
	Write-Host ''
	Write-Host 'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.'
	Write-Host 'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.'
	Write-Host 'You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.'
	Write-Host '' 
}

if (Get-PSDrive A -ErrorAction SilentlyContinue) {
    if ($IsLocaleChinese) { Write-Host 'A盘已存在！' }
	else { Write-Host 'Partition A is exist!' }
} else {
	& $PathOSFM -a -t vm -m A: -s 512M -o logical,format:ntfs,hd
}
timeout /t -1
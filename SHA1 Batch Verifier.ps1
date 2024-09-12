#Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
$ErrorActionPreference = 'Inquire'

[bool]$IsLocaleChinese = (Get-WinSystemLocale).DisplayName | Select-String -Pattern "中文" -SimpleMatch -Quiet
if ($IsLocaleChinese) { $host.ui.RawUI.WindowTitle = 'SHA1 批量校验器' }
else { $host.ui.RawUI.WindowTitle = 'SHA1 Batch Verifier' }

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

[string]$InputBufferMain = $null
if ($IsLocaleChinese) {
	Write-Host '输入 1 为自动验证文本文件'
	Write-Host '输入 2 为批量计算文件'
} else {
	Write-Host 'Input `"1`" for auto verify text file'
	Write-Host 'Input `"2`" for calculate files in batches'
}

Do{
	if ($IsLocaleChinese) { $InputBufferMain = (Read-Host -Prompt "输入") }
	else { $InputBufferMain = (Read-Host -Prompt "Input") }
	if($InputBufferMain -ine '1' -and $InputBufferMain -ine '2'){$InputBufferMain = $null}
}while(-not $InputBufferMain)

Switch($InputBufferMain){
	'1'{
		if ($IsLocaleChinese) { Write-Host "自动验证文本文件" }
		else { Write-Host "Auto verify text file" }
		[string]$InputBuffer1 = $null
		Do{
			if ($IsLocaleChinese) { $InputBuffer1 = (Read-Host -Prompt "输入文件路径") }
			else { Write-Host "Input file path: " }
			$InputBuffer1 = $InputBuffer1 -replace '^"(.*)"$', '$1'
			#Write-Host $InputBuffer1
		}while(-not (Test-Path -LiteralPath $InputBuffer1 -PathType leaf))

		[string]$InputPath1 = Split-Path -LiteralPath $InputBuffer1
		[array]$LineArray1 = Get-Content -LiteralPath $InputBuffer1
		[int]$iError1 = 0

		foreach ($Line1 in $LineArray1){
			[array]$HashArray = $Line1 -Split '  ', 2, "SimpleMatch"
			[string]$FileHash1 = (Get-FileHash -LiteralPath "$InputPath1\$($HashArray[1])" -algorithm "SHA1").Hash
			Write-Host "`n$($HashArray[0])  $($HashArray[1])"
			Write-Host $FileHash1
			if($HashArray[0] -ieq $FileHash1){
				if ($IsLocaleChinese) { Write-Host "$InputPath1\$($HashArray[1]) 的 Hash 验证成功！" -ForegroundColor green }
				else { Write-Host "$InputPath1\$($HashArray[1]) 's hash verification succeed!" -ForegroundColor green }
			}else{
				$iError1 += 1
				if ($IsLocaleChinese) { Write-Host "$InputPath1\$($HashArray[1]) 的 Hash 验证失败！" -ForegroundColor red }
				else { Write-Host "$InputPath1\$($HashArray[1]) 's hash verification failed!" -ForegroundColor red }
			}
		}

		if($iError1 -eq 0){
			if ($IsLocaleChinese) {
				while($true){ if((Read-Host -Prompt "全部正确！  输入`"yes`"退出") -ieq 'yes'){break} }
			} else {
				while($true){ if((Read-Host -Prompt "All correct!  Input `"yes`" to quit") -ieq 'yes'){break} }
			}
		}else{
			if ($IsLocaleChinese) {
				while($true){ if((Read-Host -Prompt "错误数：$iError1  输入`"yes`"退出") -ieq 'yes'){break} }
			} else {
				while($true){ if((Read-Host -Prompt "Fail count：$iError1  Input `"yes`" to quit") -ieq 'yes'){break} }
			}
		}
	}
	'2'{
		if ($IsLocaleChinese) {
			Write-Host "批量计算文件"
			Write-Host "可输入多次，留空开始计算"
		} else {
			Write-Host "Calculate files in batches"
			Write-Host "Can Input multiple times, leave blank to start"
		}
		[string]$InputBuffer2 = $null
		$PathList2 = [System.Collections.Generic.List[string]]::new()
		Do{
			if ($IsLocaleChinese) { $InputBuffer2 = (Read-Host -Prompt "输入文件路径") }
			else { $InputBuffer2 = (Read-Host -Prompt "Input file path") }
			if($InputBuffer2){
				$InputBuffer2 = $InputBuffer2 -replace '^"(.*)"$', '$1'
				#Write-Host $InputBuffer2
				if(Test-Path -LiteralPath $InputBuffer2 -PathType leaf){$PathList2.Add("$InputBuffer2")}
				else{
					if ($IsLocaleChinese) { Write-Host "文件路径错误！" -ForegroundColor red }
					else { Write-Host "File path wrong!" -ForegroundColor red }
				}
			}
		}while($InputBuffer2)

		foreach ($FilePath2 in $PathList2){
			[string]$FileHash2 = (Get-FileHash -LiteralPath "$FilePath2" -algorithm "SHA1").Hash
			Write-Host "$FileHash2  $((gi -LiteralPath $FilePath2).Name)"
		}
		
		if ($IsLocaleChinese) {
			while($true){ if((Read-Host -Prompt "计算完成！  输入`"yes`"退出") -ieq 'yes'){break} }
		} else {
			while($true){ if((Read-Host -Prompt "Calculate succeed!  Input `"yes`" to quit") -ieq 'yes'){break} }
		}
	}
}
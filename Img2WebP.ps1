$ErrorActionPreference = 'Inquire'
$host.ui.RawUI.WindowTitle = 'Img2WebP'

$WebPEncoderPath = 'D:\Program Files\libwebp-1.3.1-windows-x64\bin\cwebp.exe'
$GIF2WebPEncoderPath = 'D:\Program Files\libwebp-1.3.1-windows-x64\bin\gif2webp.exe'
# Download CWEBP.EXE and GIF2WEBP.EXE at: https://developers.google.com/speed/webp/docs/precompiled

$FFMPEGPath = 'D:\Program Files\ffmpeg-5.1.2-essentials_build\bin\ffmpeg.exe'
# Download FFMPEG.EXE at: https://www.gyan.dev/ffmpeg/builds/

$IdentifyPath = 'D:\Program Files\ImageMagick-7.1.1-38-Q16-HDRI-x64\identify.exe'
$MagickPath = 'D:\Program Files\ImageMagick-7.1.1-38-Q16-HDRI-x64\magick.exe'
# Download MAGICK.EXE and IDENTIFY.EXE at: https://imagemagick.org/script/download.php#windows

#> $NvidiaDecoderPath = 'C:\Codecs\NVIDIA Texture Tools\nvcompress.exe'
# Download NVCOMPRESS.EXE at: https://developer.nvidia.com/gpu-accelerated-texture-compression <#

# Check if FFMPEG.EXE encoder/decoder exists, otherwise prompt user to download.
if (-not(Test-Path $FFMPEGPath)) {
	echo "The FFMPEG encoder/decoder (FFMPEG.EXE) was not found.`n_________________________________________________________________________`n`nPlease download it at the link below:`n`nhttps://www.gyan.dev/ffmpeg/builds/`n_________________________________________________________________________`n`nIf you already have it installed, make sure the directories in the code is set correctly.`nThe code can be opened using Notepad."
}
# Check if ImageMagick is installed, otherwise prompt user to download it.
if(-not(Test-Path $MagickPath)) {
	echo "The ImageMagick encoder/decoder (MAGICK.EXE) was not found.`n_________________________________________________________________________`n`nPlease download it at the link below:`n`nhttps://imagemagick.org/script/download.php#windows`n_________________________________________________________________________`n`nIf you already have it installed, make sure the directories in the code are set correctly.`nThe code can be opened using Notepad."
}
# Check if GIF2WEBP.EXE encoder exists, otherwise prompt user to download.
if (-not(Test-Path $GIF2WebPEncoderPath)) {
	echo ("The WebP encoders (CWEBP.EXE and/or GIF2WEBP.EXE) were not found.`n_________________________________________________________________________`n`nPlease download both of them at the link below:`n`nhttps://developers.google.com/speed/webp/docs/precompiled`n_________________________________________________________________________`n`nIf you already have them installed, make sure the directories in the code is set correctly.`nThe code can be opened using Notepad.")
}

# Load assembly so messages can actually appear on your screen.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[void]([System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms"))

[bool]$IsLocaleChinese = (Get-WinSystemLocale).DisplayName | Select-String -Pattern "中文" -SimpleMatch -Quiet

function ImgConvert_Magick {
	param (
		[Parameter(Mandatory)]
		[object]$objImage,
		[Parameter(Mandatory)]
		[string]$outputFullPath
	)
	[long]$iImageLength = (Get-Item -LiteralPath $objImage.FullName).Length

	& $MagickPath -define webp:method=6 -define webp:use-sharp-yuv=1 -quality 90 $objImage.FullName "$outputFullPath"
	<#
	"D:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe" -define webp:method=6 -define webp:use-sharp-yuv=1 -quality 90 "C:\test\test3.jpg" "C:\test\test3_sharp90.webp"
	"D:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe" -define webp:method=6 -define webp:lossless=1 -quality 40 "C:\test\test1.png" "C:\test\test1_lossless40.webp"
	"D:\Program Files\ImageMagick-7.1.1-Q16-HDRI\magick.exe" -define webp:method=6 -define webp:use-sharp-yuv=1 -define webp:target-size=630453 "C:\test\test3.jpg" "C:\test\test3_630453.webp"
	#>
	Start-Sleep -Milliseconds 100
	if((Get-Item -LiteralPath "$outputFullPath").Length -gt $iImageLength * 1.05){
		if ($IsLocaleChinese) { Write-Host "$outputFullPath 文件过大！将重新缩小！" }
		else { Write-Host "$outputFullPath is too big! Will shrink again!" }
		Remove-Item -LiteralPath "$outputFullPath"
		& $MagickPath -define webp:method=6 -define webp:use-sharp-yuv=1 -define webp:target-size=$iImageLength $objImage.FullName "$outputFullPath"
		Start-Sleep -Milliseconds 100
	}
	(Get-Item -LiteralPath "$outputFullPath").LastWriteTimeUtc = $objImage.LastWriteTimeUtc
}

Write-Host 'This program based on original Img2WebP Copyright © Knew (2023-2023)'
Write-Host 'Source: https://github.com/Knewest'
if ($IsLocaleChinese) {
	Write-Host '版权所有 © 2024 csxinsheng1'
	Write-Host '源码：https://github.com/csxinsheng1'
	Write-Host ''
	Write-Host '本程序是自由软件：您可以基于自由软件基金会发布的 GNU General Public License 第三版或者（由您选择）任何后续版本的条款下重新分发和/或修改它。'
	Write-Host '分发本程序是希望它能派上用场，但没有任何担保，甚至也没有对其适销性或特定目的适用性的默示担保。更多细节请参见 GNU General Public License。'
	Write-Host '您应该已收到本程序随附的 GNU General Public License 的副本。如未收到，请参见：http://www.gnu.org/licenses/ 。'
	Write-Host ''
} else {
	Write-Host 'Copyright © 2024 csxinsheng1'
	Write-Host 'Source: https://github.com/csxinsheng1'
	Write-Host ''
	Write-Host 'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.'
	Write-Host 'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.'
	Write-Host 'You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>.'
	Write-Host '' 
}

[string]$WorkingPath = $null
Do{
	if ($IsLocaleChinese) { $WorkingPath = (Read-Host -Prompt "请输入目标目录") }
	else { $WorkingPath = (Read-Host -Prompt "Please input target directory") }
	$WorkingPath = $WorkingPath -replace '^"(.*)"$', '$1'
	$WorkingPath = $WorkingPath -replace '^(.*)\\$', '$1'
}while(-not (Test-Path -LiteralPath $WorkingPath -PathType Container))

[array]$FoldersBuffer = Get-ChildItem -LiteralPath $WorkingPath -Recurse -Depth 0 -Directory
[object]$EscapedPathList = [System.Collections.ArrayList]::new()
# -Exclude "Img2WebP_Output","Img2WebP_Exclude"
# manually exclude folders because PowerShell 5's childitem has lots of bug.
foreach ($folderObject in $FoldersBuffer) {
	if ($folderObject.Name -ne "Img2WebP_Output" -and $folderObject.Name -ne "Img2WebP_Exclude"){
		[void]($EscapedPathList.Add([Management.Automation.WildcardPattern]::Escape($folderObject.FullName)))
	}
}

# This will search for PNG, APNG, JPG, JPEG, JPE, JIF, JFIF, JIF, BMP, DIB, RLE, AVIF, TIF, TIFF, JXR, HDP, WDP, WMP, JXL, JP2, J2C, JPG2, JPF, JPX, J2K, TGA, DDS, HEIC, HEIF and GIF files in the current directory and its subdirectories.
[array]$IncludeBuffer = "*.png","*.apng","*.jpg","*.jpeg","*.jpe","*.jif","*.jfif","*.jfi","*.bmp","*.dib","*.rle","*.avif","*.tif","*.tiff","*.jxr","*.hdp","*.wdp","*.wmp","*.jxl","*.jp2","*.j2c","*.jpg2","*.jpf","*.jpx","*.j2k","*.tga","*.dds","*.heic","*.heif","*.gif"

[string]$EscapedWorkingPath = [Management.Automation.WildcardPattern]::Escape($WorkingPath)
[object]$EscapedPathIncludedList = [System.Collections.ArrayList]::new()
foreach ($includeIndex in $IncludeBuffer) {
	[void]($EscapedPathIncludedList.Add("$EscapedWorkingPath\$includeIndex"))
}

[array]$Images = Get-ChildItem -Path $EscapedPathIncludedList
# because PowerShell 5's childitem has lots of bug.
if($EscapedPathList.Count -ge 1){
	$Images += Get-ChildItem -Path $EscapedPathList -Include $IncludeBuffer -Recurse -File
}

# Ask the user if they want to create a folder to put the converted files in.
<#$createWebPFolder = [System.Windows.Forms.MessageBox]::Show('Would you like to create a folder to put the converted files in?

这将创建名为"Img2WebP_Output"的文件夹.

否则图片将输出在当前目录.', " ", [System.Windows.Forms.MessageBoxButtons]::YesNo)#>

# Set the path where the converted files will be stored.
[string]$outputPath = $WorkingPath + '\Img2WebP_Output'
[void](New-Item -ItemType Directory -Path $outputPath -Force)
[void](New-Item -ItemType Directory -Path "$($WorkingPath)\Img2WebP_Exclude" -Force)
<#if ($createWebPFolder -eq "Yes") {
}#>

$sTimeFormat = Get-Date -Format 'yyyyMMdd-HHmmss'

foreach ($image in $Images) {
	[string]$relativePath = ""
	if ($image.DirectoryName.Length -gt $WorkingPath.Length) {
		$relativePath = $image.DirectoryName.Substring($WorkingPath.Length)
	}
	[string]$outputDir = Join-Path $outputPath $relativePath
	if (-not (Test-Path -LiteralPath $outputDir -PathType Container)) {
		[void](New-Item -ItemType "Directory" -Path $outputDir)
	}
	[string]$outputDirBaseName = Join-Path $outputDir $image.BaseName

	if ($image.Extension -eq ".png" -or $image.Extension -eq ".apng") {
		# PNG type
		[string]$sFileHeader = Get-Content -LiteralPath "$image" -Encoding Byte -TotalCount 48
		if($sFileHeader | Select-String -Pattern '137 80 78 71' -SimpleMatch -Quiet){
			if($sFileHeader | Select-String -Pattern '0 8 97 99 84 76 0' -SimpleMatch -Quiet){
				if ($IsLocaleChinese) { Write-Host "$($image.FullName) 为罕见的APNG！" }
				else { Write-Host "$($image.FullName) is unusual APNG!" }
				& $FFMPEGPath -i $image.FullName -loop 1 -c:v libwebp_anim -compression_level 6 -lossless 1 -an -sn "$outputDirBaseName.lossless.webp"
				Start-Sleep -Milliseconds 100
				ImgConvert_Magick -objImage (Get-Item -LiteralPath "$outputDirBaseName.lossless.webp") -outputFullPath "$outputDirBaseName.webp"
				Start-Sleep -Milliseconds 100
				Remove-Item -LiteralPath "$outputDirBaseName.lossless.webp"
			}else{
				# If the image is not an animated PNG, convert it to a static WebP using FFMPEG.EXE too.
				ImgConvert_Magick -objImage $image -outputFullPath "$outputDirBaseName.webp"
			}
		}else{
			if ($IsLocaleChinese) { Write-Host "$($image.FullName) 不是真正的PNG！" }
			else { Write-Host "$($image.FullName) is not real PNG!" }
		}
	}

	elseif ($image.Extension -eq ".jpg" -or $image.Extension -eq ".jpeg" -or $image.Extension -eq ".jpe" -or $image.Extension -eq ".jfif" -or $image.Extension -eq ".jif" -or $image.Extension -eq ".jfi" -or $image.Extension -eq ".jp2" -or $image.Extension -eq ".j2c" -or $image.Extension -eq ".jpg2" -or $image.Extension -eq ".jpf" -or $image.Extension -eq ".jpx" -or $image.Extension -eq ".j2k") {
		# JPEG type
		ImgConvert_Magick -objImage $image -outputFullPath "$outputDirBaseName.webp"
	}
	
	elseif ($image.Extension -eq ".heic" -or $image.Extension -eq ".heif" -or $image.Extension -eq ".avif" -or $image.Extension -eq ".dds" -or $image.Extension -eq ".tga") {
		# This will losslessly convert DDS, TGA, HEIC, HEIF and AVIF to WebP using ImageMagick.
		ImgConvert_Magick -objImage $image -outputFullPath "$outputDirBaseName.webp"
	}
	
	elseif ($image.Extension -eq ".gif") {
		# This will losslessly convert animated GIF to animated WebP using GIF2WEBP.EXE.
		& $GIF2WebPEncoderPath -m 6 $image.FullName -o "$outputDirBaseName.webp"
	}

	else {
		#"$($image.FullName) 格式不兼容！" | Out-File -LiteralPath "$WorkingPath\Img2WebP-error-$sTimeFormat.log" -Append
		if ($IsLocaleChinese) { Write-Host "$($image.FullName) 格式不兼容！" }
		else { Write-Host "$($image.FullName) format incompatible!" }
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

# This will show a popup message once all files are converted to WebP.
<#$msgBoxTitle = "Image conversion complete:"
$msgBoxText = "The image conversion process has finished.`nEnjoy your WebP files!`n_______________________________________________________________`n`n`© Knew (2023-2023)`nThis program is licensed under Boost Software License 1.0.`n_______________________________________________________________`n`nSource: https://github.com/Knewest"
$msgBoxButton = "OK"
$msgBoxIcon = "Information"
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[System.Windows.Forms.MessageBox]::Show($msgBoxText, $msgBoxTitle, $msgBoxButton, $msgBoxIcon)#>

# Original Version 1.3.0 of Img2WebP Copyright (Boost Software License 1.0) 2023-2023 Knew
# Current Version Copyright 2024 csxinsheng1 (GNU GPL 3.0 or later)
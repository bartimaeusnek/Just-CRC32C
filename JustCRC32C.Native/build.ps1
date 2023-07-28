cd $PSScriptRoot
if (-not (Test-Path -Path "$PSScriptRoot\fasm\FASM.EXE")){
    $tmp = New-TemporaryFile | Rename-Item -NewName { $_ -replace 'tmp$', 'zip' } �PassThru
    Invoke-WebRequest -OutFile $tmp https://flatassembler.net/fasmw17331.zip
    $tmp | Expand-Archive -DestinationPath .\fasm -Force
    $tmp | Remove-Item
}
$env:INCLUDE="$PSScriptRoot\fasm\INCLUDE"
&.\fasm\fasm.exe .\JustCRC32C_Native_x64.ASM
&.\fasm\fasm.exe .\JustCRC32C_Native_x86.ASM
Copy-Item .\JustCRC32C_Native_x64.dll ..\JustCRC32C\JustCRC32C_Native_x64.dll
Copy-Item .\JustCRC32C_Native_x86.dll ..\JustCRC32C\JustCRC32C_Native_x86.dll
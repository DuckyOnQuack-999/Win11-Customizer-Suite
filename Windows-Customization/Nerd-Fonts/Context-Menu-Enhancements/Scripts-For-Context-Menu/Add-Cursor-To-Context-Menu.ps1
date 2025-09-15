32>
PS C:\Windows\System32> # Registry modifications for "Open Folder as Cursor Project" when right-clicking inside a folder

PS C:\Windows\System32> $backgroundKey = 'HKLM:\SOFTWARE\Classes\Directory\Background\shell\cursor'
PS C:\Windows\System32> $backgroundCommandKey = 'HKLM:\SOFTWARE\Classes\Directory\Background\shell\cursor\command'
PS C:\Windows\System32>
PS C:\Windows\System32> if (-not (Test-Path $backgroundKey)) {
>>     New-Item -Path $backgroundKey -Force | Out-Null
>>     Set-ItemProperty -Path $backgroundKey -Name '(Default)' -Value 'Open Folder as Cursor Project'
>>     Set-ItemProperty -Path $backgroundKey -Name 'Icon' -Value "$cursorApp,0"
>> }
PS C:\Windows\System32>
PS C:\Windows\System32> if (-not (Test-Path $backgroundCommandKey)) {
>>     New-Item -Path $backgroundCommandKey -Force | Out-Null
>>     Set-ItemProperty -Path $backgroundCommandKey -Name '(Default)' -Value "`"$cursorApp`" `"`%V`""
>> }
PS C:\Windows\System32>
PS C:\Windows\System32> # Optional: Add "Edit with Cursor" for files
PS C:\Windows\System32> $editWithCursorKey = 'HKLM:\SOFTWARE\Classes\*\shell\Open with Cursor'
PS C:\Windows\System32> $editWithCursorCommandKey = 'HKLM:\SOFTWARE\Classes\*\shell\Open with Cursor\command'
PS C:\Windows\System32>
PS C:\Windows\System32> if (-not (Test-Path $editWithCursorKey)) {
>>     New-Item -Path $editWithCursorKey -Force | Out-Null
>>     Set-ItemProperty -Path $editWithCursorKey -Name '(Default)' -Value 'Edit with Cursor'
>>     Set-ItemProperty -Path $editWithCursorKey -Name 'Icon' -Value "$cursorApp,0"
>> }


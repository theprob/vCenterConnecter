#
#	PowerShell Script which helps to connect vCenter servers via PowerCLI.
#	You can connect mulitple servers through the console, every connection will open in a new window.
#	You only need to type your password, the server and usernames are stored in a .json file,
#	calles 'environments.json', which should be kept in the same folder as the script itself.
#	Passwords are not stored! Credentials are handled with the native credential manager of windows.
#

$version = "1.0.0"
$fgc = 'darkgreen'
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -Confirm:$false  -DefaultVIServerMode Multiple -proxypolicy noproxy
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$profilePath = "$home\documents\vCenterConnecter\environments.json"
$environments = get-content $profilePath -encoding utf8 | ConvertFrom-Json
$wshell = New-Object -ComObject Wscript.Shell
$IsConnected = $false

function Show-Menu {
    Get-Profile
    Clear-Host
    write-host "======================================================"
    Write-Host -NoNewline "="
    write-host -NoNewline "              vCenter Connecter (v$version)            " -BackgroundColor $fgc
    Write-Host -NoNewline "="
    write-host "`n======================================================"
    Write-Host -NoNewline "`n====== " 
    Write-Host -NoNewline "Available Environments" -ForegroundColor $fgc
    Write-Host -NoNewline " ======`n"
    if ([System.IO.File]::Exists($profilePath)) {
        Write-Host -NoNewline "      ("
        Write-Host -NoNewline "Loaded profile:" -ForegroundColor $fgc
        Write-Host -NoNewline " $env:UserName)`n`n"
    }
    else {
        $wshell = New-Object -ComObject Wscript.Shell
        $answer = $wshell.Popup("Didn't found profile, would you like to create it?", 0, "Warning", 48 + 4)
        Switch ($answer) {
            '6' {
                New-Item -Type dir "$home\documents\vCenterConnecter\" | Out-Null
                Copy-Item "$scriptPath\environments.json" -Destination "$home\documents\vCenterConnecter\"
                $environments = get-content $profilePath -encoding utf8 | ConvertFrom-Json
            }
            '7' {
                exit
            }
        }
    }
    
    for ($i = 0; $i -lt $environments.Count; $i++) {
        Write-Host -NoNewline "["
        Write-Host -NoNewline "$($i+1)" -ForegroundColor $fgc
        Write-Host -NoNewline "]"
        Write-Host -NoNewline "`t$($environments[$i].Environment)`n" -ForegroundColor $fgc
        for ($j = 0; $j -lt $environments[$i].Servers.Count; $j++) {
            Write-Host -NoNewline "`t  └─"
            Write-Host -NoNewline "$($environments[$i].Servers[$j])"
            Write-Host -NoNewline "`n"
        }
    }
     
    Write-Host -NoNewline "`n["
    Write-Host -NoNewline "S" -ForegroundColor $fgc
    Write-Host -NoNewline "]"
    Write-Host -NoNewline "`tCreate/Update shortcut on your desktop."

    Write-Host -NoNewline "`n["
    Write-Host -NoNewline "H" -ForegroundColor $fgc
    Write-Host -NoNewline "]"
    Write-Host -NoNewline "`tHelp (Opens README)."

    Write-Host -NoNewline "`n["
    Write-Host -NoNewline "Q" -ForegroundColor $fgc
    Write-Host -NoNewline "]"
    Write-Host -NoNewline "`tQuit.`n`n"
}

do {
    Show-Menu
    $menu_select = Read-Host "Please make a selection"
    $WinTitle = "Connected vCenter(s): |"

    if ($menu_select -ge 1 -and $menu_select -le $environments.Count) {
        do {
            Clear-Host
            $credentials = Get-Credential -UserName $($environments[$($menu_select-1)].UserName) -Message "Enter your vCenter password"
            write-host "`t Working on the '$($environments[$($menu_select-1)].Environment)' Environment " -BackgroundColor $fgc
            for ($i = 0; $i -lt $($environments[$($menu_select-1)].Servers.Count); $i++) {
                Connect-VIServer -Server $($environments[$($menu_select-1)].Servers[$i]) -Credential $credentials -ErrorAction SilentlyContinue | Out-Null
                if ($global:DefaultVIServers.name -contains $($environments[$($menu_select-1)].Servers[$i]) -and $global:defaultviserver.isconnected -eq $true) {
                    $IsConnected = $true                    
                    $WinTitle += " $($environments[$($menu_select-1)].Servers[$i]) |"
                    Write-Host "`t  └─$($environments[$($menu_select-1)].Servers[$i])"
                }
                else {
                    $answer = $wshell.Popup("Connecting to [$($environments[$($menu_select-1)].Servers[$i])] failed.`nProbably due to incorrect username or password.`n`nDo you want to retry?", 0, "Connecting failed!", 16 + 4)
                    $IsConnected = $false
                }
            }
            $host.ui.RawUI.WindowTitle = $WinTitle
            Set-Location c:\
        }until($IsConnected -or $answer -eq 7)

    }
    elseif ($menu_select -like 's') {
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut("$home\desktop\vCenterConnecter.lnk")
        $Shortcut.TargetPath = "powershell.exe"
        $Shortcut.Arguments = " -noexit -ExecutionPolicy Bypass -File $scriptPath\vCenterConnecter.ps1"
        $Shortcut.Save()
    }
    elseif ($menu_select -like 'h') {
        Invoke-Item $scriptPath\README.txt
    }
    elseif ($menu_select -like 'q') {
        exit
    }
}until ($menu_select -eq 'q' -or $IsConnected)
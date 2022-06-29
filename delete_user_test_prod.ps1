
function Write-Color([String[]]$Text, [ConsoleColor[]]$Color) {
    for ($i = 0; $i -lt $Text.Length; $i++) {
        Write-Host $Text[$i] -Foreground $Color[$i] -NoNewLine
    }
    Write-Host
}


# temporarily overwrite Out-Default
function Out-Default {}
        
$Title = "Eliminar carpetas de usuario - Moa Nickel S.A. - Grupo de Redes"
$host.UI.RawUI.WindowTitle = $Title

Write-Host
Write-Host "--- [ RUNNING POWERSHELL SCRIPT TO DELETE USER'S FOLDER ] ---" -Foreground Black -Background Green
Write-Host

$UserCheck1 = $(Write-Host ">> Please, enter username to delete folders" -Foreground Green) + $(Write-Host "<< Username: " -ForegroundColor Yellow -NoNewLine; Read-Host)

# * Conform folder name of the user
$NameToFind = $UserCheck1 + ".MOANICKEL"
    
# * Get the folder from the file system
$HomesFolderForUser = Get-ChildItem -Path D:\PowerShellTESTS -Directory -Filter "$NameToFind"

# * Get the full name of the folder
$FullName = $HomesFolderForUser.FullName

# * Get the name of the computer
$PCName = [System.Net.Dns]::GetHostName()

# Write-Host "Results: The following folder was found: $FullName"
    
if ($FullName.Length -gt 0) {
    do {
        Write-Host
        Write-Host ">> The following folders were found: $FullName" -Foreground Yellow
        Write-Host
        
        
        $Answer = $(Write-Host " >> Proceed with DELETE action? (Y/N) " -Foreground Black -Background Red) + $(Write-Host "<< " -ForegroundColor Green -NoNewLine; Read-Host)
            
       
    } until ( ($Answer -ne "Y") -or ($Answer -ne "N") );

    if ($Answer -eq "Y") {
        Write-Host ">> $Answer PRESSED. Proceeding with delete action" -Foreground Red
        Write-Host

        try {
            $(Write-Host ">> This action will " -ForegroundColor Yellow -NoNewline) 
            $(Write-Host "DELETE" -ForegroundColor Red -NoNewline) 
            $(Write-Host " permanently all folders of user [ $UserCheck1 ] in $PCName server. " -ForegroundColor Yellow)
            $(Write-Host " >> Are you completely sure? (Y/N) " -ForegroundColor Black -BackgroundColor Red)

            $ConfirmAnswer = $(Write-Host "<< " -ForegroundColor Green -NoNewline; Read-Host)

            if ($ConfirmAnswer -eq "N") {
                Write-Host "<< $ConfirmAnswer PRESSED. Delete action will NOT be performed" -ForegroundColor Green
                Write-Host
            }
            elseif ($ConfirmAnswer -eq "Y") {
                Write-Host ">> $ConfirmAnswer PRESSED. Completing delete action." -ForegroundColor Yellow
                Write-Host
    
                # * THE LINE THAT DELETES THE FOLDER IN $FullName
                # Remove-Item -LiteralPath "$FullName" -Force -Recurse

                Write-Host ">> Folder [ $NameToFind ] was successfully removed" -ForegroundColor Yellow
                Write-Host
            }

        }
        catch {
            Write-Host
            Write-Host ">> -------------------------" -ForegroundColor Red
            Write-Host ">>   Some error ocurred..."  -ForegroundColor Red
            Write-Host ">> -------------------------" -ForegroundColor Red
            Write-Host
        }
    }
    else {

        Write-Host ">> $Answer PRESSED" -Foreground Yellow
    }
}
else {
    $EmojiIcon = [System.Convert]::toInt32("1F61E", 16)
    $EmojiIconType = $EmojiIcon.GetType() 
    $Emoji = [System.Char]::ConvertFromUtf32($EmojiIcon)

    Write-Host
    Write-Host ">> No folder for user [ $UserCheck1 ] was found $Emoji. Are you sure you have the right user?" -Foreground Green
    Write-Host
}

# Clear-Host
# Write-Host
Write-Host "--- [ EXITING SCRIPT ] ---" -Foreground Black -Background Green
Write-Host

Pause

# restore Out-Default
Remove-Item -Path function:Out-Default
exit



# if ($UserCheck1 -ne $UserCheck2) {
#     Write-Color -Text "=== Los usuarios no coinciden... ===" -Color Red
# } else {
#     $Date = Get-Date
#     Write-Host "Your user is '$UserCheck1' on '$Date'"
# }
# Write-Host 
# Read-Host -Prompt "Presiona alguna tecla para salir..."
# # Write-Host ""
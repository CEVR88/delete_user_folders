# * [STRING VERSION] Tests every path in the $PathsArray array, and if it exists, 
function TestPathAndAddPath([Array[]]$PathsArray) {
    # $ExistentList = [System.Collections.ArrayList]::new()
    # $NonExistentList = [System.Collections.ArrayList]::new()
    $ExistentList = ""
    $NonExistentList = ""
    
    foreach ($currentItemName in $PathsArray) {
        try {
            if (Test-Path -Path $currentItemName.FullName) {
                $ExistentList = $ExistentList  + "=" + $currentItemName.FullName
            }
        }
        catch {
            # * ...useless catch 😃
            $NonExistentList = $NonExistentList + "=" + $currentItemName.FullName
        }
    }

    # $HashList = @{existence = $ExistentList; non_existent = $NonExistentList}

    $ExistentList = $ExistentList.TrimStart("=")
    # Write-Host "Existent List: $ExistentList"
    return $ExistentList
}

# temporarily overwrite Out-Default
function Out-Default {}

# * Clear the all inputs
Clear-Host

$Title = "Eliminar carpetas de usuario - Grupo de Redes"
$host.UI.RawUI.WindowTitle = $Title

Write-Host
Write-Host "--- [ RUNNING POWERSHELL SCRIPT TO DELETE USER'S FOLDER ] ---" -Foreground Black -Background Green
Write-Host

# * Conform folder name of the user
$NameToFind = $(Write-Host ">> Please, enter username to delete folders" -Foreground Green) + $(Write-Host "<< Username: " -ForegroundColor Yellow -NoNewLine; Read-Host)

# # * Getting the folders from the file system

# ! At server
$HomesFolderForUser = Get-ChildItem -Path E:\Semoh -Directory -Filter "$NameToFind.MNKL"
$FRFolderForUser = Get-ChildItem -Path E:\RF -Directory -Filter "$NameToFind"
$ProfiliaFolderForUser = Get-ChildItem -Path E:\Ailifrop -Directory -Filter "$NameToFind.MNKL.V2"
$OTROSUsuariosFolderForUser = Get-ChildItem -Path E:\SORTO\Soirausu -Directory -Filter "$NameToFind"

# * Structure with folders from the file system
$PathsArray = @($HomesFolderForUser, $FRFolderForUser, $ProfiliaFolderForUser, $OTROSUsuariosFolderForUser)

# * Run my function (it is at the top of this script)
# $PathsFullNameArrayList = TestPathAndAddPath $PathsArray
# [ STRING VERSION ]
$PathsFullNameString = TestPathAndAddPath $PathsArray
$PathsFullNameString = $PathsFullNameString.TrimStart("=")

# [ STRING VERSION ]
$ExistentPaths = $PathsFullNameString.Split("=")

# * Get the name of the computer
$PCName = [System.Net.Dns]::GetHostName()

# Write-Host "Count of paths: $($ExistentPaths.count) .. GT 0? $($ExistentPaths.count -gt 0)"

# if ($ExistentPaths.count -gt 0) {
if ($ExistentPaths -notlike '') {
    Write-Host
    Write-Host ">> The following folders were found:" -Foreground Green

    # Write-Host "ExistentPaths: -$ExistentPaths-"
    foreach ($currentItemName in $ExistentPaths) {
        Write-Host ">>       + $currentItemName" -Foreground Yellow
    }

    # * New Line
    Write-Host          

    # * Empty variable
    $answer = ""        

    while ("yes", "no", "y", "n" -notcontains $answer) {
        $answer = $(Write-Host " >> Proceed with DELETE action? Type [Y]es or [N]o  " -Foreground Black -Background Red) + $(Write-Host "<< " -ForegroundColor Green -NoNewLine; Read-Host)
    }

    if ($answer -eq "y" -or $answer -eq "yes") {
        Write-Host ">> $answer PRESSED. Proceeding with " -NoNewLine -Foreground Green
        Write-Host "DELETE action" -Foreground Red
        Write-Host

        $(Write-Host ">> This action will " -ForegroundColor Yellow -NoNewline) 
        $(Write-Host "DELETE" -ForegroundColor Red -NoNewline) 
        $(Write-Host " permanently all folders of user [ $NameToFind ] in $PCName server. " -ForegroundColor Yellow)
        Write-Host

        $ConfirmAnswer = ""
        while ("yes", "no", "y", "n" -notcontains $ConfirmAnswer) {
            $(Write-Host " >> Are you completely sure? (Y/N) " -ForegroundColor Black -BackgroundColor Red)
            $ConfirmAnswer = $(Write-Host "<< " -ForegroundColor Green -NoNewline; Read-Host)
        }


        if ($ConfirmAnswer -eq "N") {
            Write-Host "<< $ConfirmAnswer PRESSED. Delete action will NOT be performed" -ForegroundColor Green
            Write-Host
        }
        elseif ($ConfirmAnswer -eq "Y") {
            Write-Host ">> $ConfirmAnswer PRESSED. Completing delete action." -ForegroundColor Yellow
            Write-Host

            # * THE LINES THAT DELETES THE FOLDERS -xxxxxxxxx- IN $HomesFullName
            foreach ($currentPath in $ExistentPaths) {
                Write-Host ">> Removing $currentPath..." -ForegroundColor Yellow -NoNewline
                Remove-Item -LiteralPath "$currentPath" -Force -Recurse
                # Write-Host " (FAKE)" -ForegroundColor Red -NoNewLine
                Write-Host " DONE!" -ForegroundColor Green
            }

            Write-Host
            Write-Host ">> Folders for user [ $NameToFind ] were successfully removed" -ForegroundColor Green
            Write-Host
        }
    }
    else {
        Write-Host ">> $Answer PRESSED" -Foreground Yellow
    }
}
else {
    $EmojiIcon = [System.Convert]::toInt32("1F61E", 16)
    # $EmojiIconType = $EmojiIcon.GetType() 
    $Emoji = [System.Char]::ConvertFromUtf32($EmojiIcon)

    Write-Host
    Write-Host ">> No folder for user [ $NameToFind ] was found $Emoji... Are you sure you have the right user?" -Foreground Green
    Write-Host
}

# Write-Host
Write-Host "--- [ EXITING SCRIPT ] ---" -Foreground Black -Background Green
Write-Host

Pause

Clear-Host
# restore Out-Default
Remove-Item -Path function:Out-Default
exit

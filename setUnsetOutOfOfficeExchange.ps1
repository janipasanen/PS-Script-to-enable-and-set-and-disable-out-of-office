<#  Script för att definiera out of office (OOF) meddelande och för att aktivera och avaktivera det. Schemaläggning görs med Task Scheduler i Windows.
    Copyright Jani Pasanen, 2015 (jani.m.pasanen@gmail.com)
    
    PowerShell.exe -PSConsoleFile "C:\Program Files\Microsoft\Exhange Server\V14\Bin\ExShell.psc1" -Command ". 'C:\pcs\YourScript.ps1'"
#>

# Argument / Parametrar vid körning av script dvs vilket konto som skall hanteras
Param (
     [Parameter(Mandatory=$true)] [string] $konto,
     [Parameter(Mandatory=$true)] [string] $fil
 
)

# Hämta klockslag (24 timmars klocka)
$tid = (get-date -format HH)

# Hämta status för OOF för specifict konto (Enabled | Disabled | Scheduled)
$OOFStatus = (Get-MailboxAutoReplyConfiguration -identity $konto).AutoReplyState

# OOF meddelande från extern fil (ifrån samma katalog som scriptet körs från)
$Msg = Get-Content $fil

 if ($OOFStatus -eq "Disabled" -and $tid -gt 15 -or $tid -lt 8)  { # Kontrollera om OOF är avaktiverad och aktivera det och ange meddelandet som skall skickas
    Set-MailboxAutoReplyConfiguration -Identity $konto -AutoReplyState Enabled -ExternalAudience all -InternalMessage $Msg -ExternalMessage $Msg 
    } 
 else { # Om out of office meddelande är aktiverad avaktivera det
    Set-MailboxAutoReplyConfiguration -Identity $konto -AutoReplyState Disabled
    }



$webhookUrl = "https://discord.com/api/webhooks/<WebhookID>/<WebhookToken>/messages/<MessageID>"

$isserverrunning = (Get-Process | Where-Object { $_.Name -eq "PalServer-Win64-Shipping-Cmd"}).Count
$ServerStatus = if ($isserverrunning -eq 0) {":red_circle: Offline"} else {":green_circle: Online"}

$VRAMcalc = (Get-WmiObject win32_operatingsystem | Select @{L='commit';E={($_.totalvirtualmemorysize - $_.freevirtualmemory)*1KB/1GB}}).commit;
$VRAM = if ($isserverrunning -eq 0) {"N/A"} else {[math]::Round($VRAMcalc,2)}

$VRAMmsg = 
if($VRAM -gt 28) {"$VRAM GB - Server Restarting"} 
elseif ($VRAM -lt 24){"$VRAM GB - Good"}
else {"$VRAM GB - Critical, Restart Imminent"}

$Players = C:\Scripts\ARRCON-3.3.7-Windows\ARRCON.exe -H 127.0.0.1 -P 12345 -p rconPassowrdHere 'showplayers' | Select -Skip 2 | Select -skiplast 1
$PlayerCount = $Players.Count
$Playerlist = 
if ($PlayerCount -eq 0) {"N/A"} 
elseif ($PlayerCount -eq 1) {$Players -replace ',.*', ''} 
else {$Players -replace ',.*', ' - '}

$StartTime = (Get-Process PalServer-Win64-Shipping-Cmd).StartTime
$TimeStamp = Get-Date

$nextrestarttime = Get-ScheduledTask -TaskName "Reboot Server" | Get-ScheduledTaskInfo | Select-Object -expandproperty NextRunTime
$hoursnext = ($nextrestarttime - $TimeStamp).hours
$minutesnext = ($nextrestarttime - $TimeStamp).minutes
$nextrestart = if ($isserverrunning -eq 0) {"N/A"} else {"in $hoursnext hrs, $minutesnext mins"}

$uptime = $TimeStamp - $StartTime
$hoursup = ($uptime).hours
$minutesup = ($uptime).minutes
$serveruptime = if ($isserverrunning -eq 0) {"N/A"} else {"$hoursup hrs, $minutesup mins"}

$embedcolor = if ($isserverrunning -eq 0) {"15548997"} else {"4289797"}


$embed = @{
color = "$embedcolor"
title = "Add Text Here or delete"
description = "Add Text Here or delete"
footer = @{
text = "This message is automatically updated  -  $Timestamp" }

    'fields'   = @(@{
        name    = "**STATUS**"
        value = "$ServerStatus"
        inline  = "$false"
        },
        @{
        name    = "PLAYERS"
        value = "$Playercount / 32"
        inline  = "$false"
        },
        @{
        name    = "CURRENT MEMORY COMMITED"
        value = "$VRAMmsg"
        inline  = "$false"
        },
        @{
        name    = "SERVER UPTIME"
        value = "$serveruptime"
        inline  = "$false"
        },
        @{
        name    = "NEXT RESTART"
        value = "$nextrestart"
        inline  = "$false"
        },
        @{
        name    = "PLAYER LIST"
        value = "$Playerlist"
        inline  = "$false"

        
    })
}

$params = @{
    Uri     = $webhookUrl
    Method  = "Patch"
    Headers = @{ "Content-Type" = "application/json" }
    Body    = @{embeds = @($embed) } | ConvertTo-Json -Depth 5 -Compress
    
}

Invoke-RestMethod @params
$sourceFiles = @("williamsville_calendar.csv","rochester_calendar.csv","orchard_park_calendar.csv")
$broadcastCsvPath = "$PSScriptRoot\schedule.csv"

$allEntries =  $sourceFiles | foreach {
    $Path = "$PSScriptRoot\$_"
    Write-Host $Path
    if((Get-Content $Path)[0].Substring(0,2) -eq ",0"){
        "Index"+ ((Get-Content $Path) -join "`r`n") | Set-Content $Path
    }
    Import-Csv $Path
}

$allEntries | foreach {$_.PSObject.Properties.Remove("Index")}

$allEntries | Export-Csv -NoTypeInformation $broadcastCsvPath

$updatedData = Get-Content $broadcastCsvPath | foreach {$_.Replace('"0","1","2","3","4"', "name,location,startTime,endTime,email")} 
Set-Content -Path $broadcastCsvPath -Value $updatedData


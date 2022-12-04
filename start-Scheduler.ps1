
$credentialFileName = "credentials.json"

$preProcessedFileName = "output.csv"

$credentialPath = "$PSScriptRoot\$credentialFileName"
$preProcessedDataPath = "$PSScriptRoot\$preProcessedFileName"

if(-not (Test-Path $credentialPath)){
    Write-Host "Error: Credentials file not found.  Please download the file $credentialFileName to the path: $credentialPath" -ForegroundColor Red
    Write-Host "This file can be downloaded from: Google Drive - Urgent Care service tokens shared folder " -ForegroundColor Red
    Write-Host "https://drive.google.com/drive/folders/1YazPjpNy_rC0WneHDuGjptp8ctmqHEXx"
    Write-Host "Please re-run this process once the file is downloaded"
    Read-Host "Press enter to continue"
    exit
}

python.exe "$PSScriptRoot\requestor.py"
python.exe "$PSScriptRoot\process_csv.py"

"Index"+ ((Get-Content $preProcessedDataPath) -join "`r`n") | Set-Content $preProcessedDataPath
Write-Host "Pre-processed $((Import-Csv $preProcessedDataPath).Length) records into $preProcessedFileName"

python.exe "$PSScriptRoot\optimizer.py"
. "$PSScriptRoot\merge-Schedules.ps1"
python.exe "$PSScriptRoot\publisher.py"

# Start-Process powershell.exe -Wait -ArgumentList ($PSScriptRoot\)


param (
  [Parameter(Mandatory = $true)][string]$BackupFile
)

$ListSql = 'file-list.sql'
$DisconnectSql = 'disconnect-db.sql'
$RestoreSql = 'restore-db.sql'

docker cp $PSScriptRoot\$ListSql sql1:/tmp/
docker cp $PSScriptRoot\$DisconnectSql sql1:/tmp/
docker cp $PSScriptRoot\$RestoreSql sql1:/tmp/

$BackupSize = Get-Item $BackupFile | Select-Object -ExpandProperty Length

Write-Output "Copying $( [math]::Round($BackupSize / 1mb)  ) MB $BackupFile in to MSSQL container..."
docker cp $BackupFile sql1:/var/opt/mssql/backup/db.bak

$sqlcmd = 'docker exec sql1 /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P <YourNewStrong!Passw0rd> -d master'

Write-Output "Checking files in backup"
$Files = -split (Invoke-Expression "$sqlcmd -i /tmp/$ListSql -h -1")
$DataFile = $Files[0]
$LogFile = $Files[1]

Write-Output "Found $DataFile and $LogFile"

Write-Output "Dropping existing DB (if exists)"
# Use a few strategies to try and and kill connections which might prevent drop
Invoke-Expression "$sqlcmd -i /tmp/$DisconnectSql"
Invoke-Expression "$sqlcmd -Q ""ALTER DATABASE main SET SINGLE_USER WITH ROLLBACK IMMEDIATE"""
Invoke-Expression "$sqlcmd -Q ""DROP DATABASE main;"""

Write-Output "Restoring DB"
Invoke-Expression "$sqlcmd -v DataFile=""$DataFile"" -v LogFile=""$LogFile"" -i /tmp/$RestoreSql"
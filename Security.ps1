#Création d'un script permettant d'évaluer le niveau de securité de la machine

$Wuauserv = Get-Service -name wuauserv | Select-Object Status
$Defender = Get-Service -Name WinDefend | Select-Object Status
#$tab = @{"$Wuauserv"}        

echo "Windows_Update :"$Wuauserv | ft
echo "Windows_Defender:"$Defender | ft

if ($Wuauserv -match "*Stopped*") {
    Set-Service -name wuauserv -Status Running
    echo "Demarrage de Windows_Update"
    }

#Check de l'ouverture des ports 
#Select port range
$portrange = 20..1000
#Open connection for each port from the range
Foreach ($p in $portrange)
{
$Socket = New-Object Net.Sockets.TcpClient      
$ErrorActionPreference = 'SilentlyContinue'
#Connect on the given port
$Socket.Connect("10.94.102.15", $p)
#Determine if the connection is established
if ($Socket.Connected) {
Write-Host "Outbound port $p is open." -ForegroundColor Green
$Socket.Close()
}
#else {
#Write-Host "Outbound port $p is closed or filtered."}
} #end foreach

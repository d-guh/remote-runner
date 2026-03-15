# 50-Firewall.ps1
# Author: Dylan Harvey
# Description: Automated firewall hardening script to lock down machines, can be destructive
# YOU WILL NEED TO MANUALLY ADD RULES FOR SERVICES AND/OR DOMAIN

# === CONFIG ===
$AllowIPs             = @("10.2.0.0/24")         # CHANGE, exact IPs preferable, supports CIDR, be careful with VPNs masquerade, empty list means any!
$DisableExistingRules = $true                    # DESTRUCTIVE ACTION!!! WILL BREAK SERVICES
$InboundAction        = "Block"                  # default Block
$OutboundAction       = "Block"                  # default Allow (Block super strict, will break services but also stop C2+RevShell)
$BACKUP_PATH          = "C:\firewall_backup.wfw"
$RULE_NAME            = "BLUE_MGMT"

Write-Host "[*] Backing up firewall rules..."
if (Test-Path -Path $BACKUP_PATH -PathType Leaf) {
    Write-Host "WARNING: Found existing backup at $BACKUP_PATH, moving to $($BACKUP_PATH).old"
    Move-Item -Path $BACKUP_PATH -Destination "$($BACKUP_PATH).old" -Force
}
netsh advfirewall export $BACKUP_PATH

Write-Host "[*] Enabling firewall for all profiles..."
Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True
Set-NetFirewallProfile -Profile Domain, Public, Private -DefaultInboundAction $InboundAction -DefaultOutboundAction $OutboundAction

Write-Host "[*] Allowing IPs..."
New-NetFirewallRule -DisplayName $RULE_NAME -Direction Inbound -Action Allow -RemoteAddress $AllowIPs -Description "Blue Team Inbound"
New-NetFirewallRule -DisplayName $RULE_NAME -Direction Outbound -Action Allow -RemoteAddress $AllowIPs -Description "Blue Team Outbound"

if ($DisableExistingRules) {
    Write-Host "[*] Disabling existing rules..."
    Get-NetFirewallRule | Where-Object { $_.DisplayName -ne $RULE_NAME -and $_.Enabled -eq 'True' } | Disable-NetFirewallRule
}

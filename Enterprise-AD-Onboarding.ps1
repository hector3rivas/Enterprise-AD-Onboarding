param(
    [string]$CsvPath = "C:\Scripts\AD-Lab\Users.csv"
)
Import-Module ActiveDirectory

$LogFile = "C:\Scripts\AD-Lab\ImportLog.txt"
$Password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force


function Write-Log
{
    param(
        [string]$Message,
        [string]$Color = "White"
    )

    Write-Host $Message -ForegroundColor $Color
    Add-Content -Path $LogFile -Value $Message
}


$DepartmentMappings = @{
    IT = @{
        OU    = "OU=IT Users,OU=Users OU,DC=lab,DC=local"
        Group = "IT"
    }

    HR = @{
        OU    = "OU=HR Users,OU=Users OU,DC=lab,DC=local"
        Group = "HR"
    }

    Accounting = @{
        OU    = "OU=Accounting Users,OU=Users OU,DC=lab,DC=local"
        Group = "Accounting"
    }
    Managers = @{
        OU    = "OU=Managers,OU=Users OU,DC=lab,DC=local"
        Group = "Managers"
    }
}

if (-not (Test-Path $CsvPath))
{
    Write-Host "CSV file not found: $CsvPath" -ForegroundColor Red
    exit
}

$Users = Import-Csv $CsvPath

foreach ($User in $Users)
{
    $ExistingUser = Get-ADUser `
        -Filter "SamAccountName -eq '$($User.Username)'" `
        -ErrorAction SilentlyContinue

    if ($ExistingUser)
    {
        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $($User.Username) already exists. Skipping."

        Write-Log -Message $Message -Color Yellow

        continue
    }

    $DepartmentConfig = $DepartmentMappings[$User.Department]

    if (-not $DepartmentConfig)
    {
        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - No department mapping found for $($User.Username): $($User.Department)"

	Write-Log -Message $Message -Color Red

        continue
    }

    $TargetOUPath = $DepartmentConfig.OU
    $TargetGroupName = $DepartmentConfig.Group

    $TargetOU = Get-ADOrganizationalUnit `
        -Identity $TargetOUPath `
        -ErrorAction SilentlyContinue

    if (-not $TargetOU)
    {
        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - OU not found for $($User.Username): $TargetOUPath"

        Write-Log -Message $Message -Color Red

        continue
    }

    $TargetGroup = Get-ADGroup `
        -Identity $TargetGroupName `
        -ErrorAction SilentlyContinue

    if (-not $TargetGroup)
    {
        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Group not found for $($User.Username): $TargetGroupName"

        Write-Log -Message $Message -Color Red

        continue
    }

    try
    {
        New-ADUser `
            -Name "$($User.FirstName) $($User.LastName)" `
            -GivenName $User.FirstName `
            -Surname $User.LastName `
            -SamAccountName $User.Username `
            -UserPrincipalName "$($User.Username)@lab.local" `
            -Department $User.Department `
            -Title $User.Title `
            -Path $TargetOUPath `
            -AccountPassword $Password `
            -Enabled $true `
            -ChangePasswordAtLogon $true `
            -ErrorAction Stop

        Add-ADGroupMember `
            -Identity $TargetGroupName `
            -Members $User.Username `
            -ErrorAction Stop

        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $($User.Username) created successfully."

        Write-Log -Message $Message -Color Green

    }
    catch
    {
        $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Failed to create $($User.Username): $($_.Exception.Message)"

        Write-Log -Message $Message -Color Red
    }
}
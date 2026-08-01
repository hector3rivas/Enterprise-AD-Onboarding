Import-Module ActiveDirectory

$CsvPath = "C:\Scripts\AD-Lab\Users.csv"
$LogFile = "C:\Scripts\AD-Lab\ImportLog.txt"

$Password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

$DepartmentMappings = @{
    IT = @{
    OU    = "OU=IT Users,OU=Users OU,DC=lab,DC=Local"
    Group = "IT"
  }

    HR = @{
    OU    = "OU=HR Users,OU=Users OU,DC=lab,DC=local"
    Group = "HR"

  }

    Accounting = @{
    OU    = "OU=Accounting OU=Users OU,DC=lab,DC=local"
    Group = "Accounting"

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

    Write-Host $Message -ForegroundColor Yellow
    Add-Content -Path $LogFile -Value $Message

    continue
}

$DepartmentConfig = $DepartmentMappings[$User.Department]

if (-not $DepartmentConfig)
{
    $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - No Department mapping found for $($User.Username):$(User.Department)"

    Write-Host $Message -ForegroundColor Red
    Add-Content -Path $LogFile -Value $Message

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

        Write-Host $Message -ForegroundColor Red
        Add-Content -Path $LogFile -Value $Message

        continue

    }
$TargetGroup = Get-ADGroup `

    else

    {
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
                    -Path $User.OU `
                    -AccountPassword $Password `
                    -Enabled $true `
                    -ChangePasswordAtLogon $true `
                    -ErrorAction Stop


                Add-ADGroupMember `
                    -Identity $User.Group `
                    -Members $User.Username `
                    -ErrorAction Stop
        
               $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $($User.Username) created successfully." 


                Write-Host $Message -ForegroundColor Green
                Add-Content -Path $LogFile -Value $Message
        }
        catch
        {


             $Message = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Failed to create $($User.Username): $($_.Exception.Message)"


             Write-Host $Message -ForegroundColor Red
             Add-Content -Path $LogFile -Value $Message
        }

    }

    }




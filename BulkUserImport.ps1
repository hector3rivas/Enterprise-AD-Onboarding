Import-Module ActiveDirectory

$Users = Import-Csv "C:\Scripts\AD-Lab\Users.csv"

$Password = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force

$LogFile = "C:\Scripts\AD-Lab\ImportLog.txt"

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

    }

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




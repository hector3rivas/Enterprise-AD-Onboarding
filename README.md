## About This Project

# Enterprise AD Onboarding

Enterprise AD Onboarding is a PowerShell automation project that provisions Active Directory users from a CSV file.

I built this project as part of my Windows Server and PowerShell home lab to strengthen my systems administration skills while preparing for a career in cybersecurity.

---

## Features

- Import users from a CSV file
- Validate that the CSV file exists
- Check if a user already exists before creating the account
- Map departments to the correct Active Directory OU
- Map departments to the correct Active Directory security group
- Validate OU and Group before creating users
- Create Active Directory user accounts
- Add users to security groups
- Log successful and failed operations
- Reusable PowerShell logging function
- Configurable CSV path using PowerShell parameters

---

## Technologies Used

- PowerShell
- Windows Server
- Active Directory
- Git
- GitHub

---

## Project Structure

```
Enterprise-AD-Onboarding/
│
├── Enterprise-AD-Onboarding.ps1
├── Users.csv
├── .gitignore
└── README.md
```

---

## CSV Format

Example:

```csv
FirstName,LastName,Username,Department,Title
John,Smith,jsmith,IT,Help Desk Technician
Sarah,Johnson,sjohnson,HR,HR Specialist
Paul,Walker,pwalker,Accounting,Accountant
```

Departments are mapped to the correct Organizational Unit and Security Group using a PowerShell hashtable.

---

## How to Run

Run using the default CSV file:

```powershell
.\Enterprise-AD-Onboarding.ps1
```

Or specify a different CSV file:

```powershell
.\Enterprise-AD-Onboarding.ps1 -CsvPath "C:\Imports\NewUsers.csv"
```

---

## Skills Demonstrated

- PowerShell scripting
- Active Directory administration
- Automation
- Error handling
- Logging
- Functions
- Parameters
- CSV processing
- Git version control
- Troubleshooting

---

## Future Improvements

- Generate secure random passwords
- Email summary report
- HTML reporting
- User account expiration support
- Automatic home folder creation
- Bulk updates for existing users

---

## About This Project

This project was developed as part of my Windows Server and PowerShell home lab to strengthen my systems administration skills while preparing for a career in cybersecurity.

The goal was not only to automate user provisioning but also to learn software version control with Git, build maintainable PowerShell code, and create a professional portfolio project demonstrating enterprise administration concepts.

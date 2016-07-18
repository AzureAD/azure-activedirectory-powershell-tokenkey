---
services: active-directory
author: gsacavdm
---

# Azure Active Directory Token Key Scripts
This repository contains PowerShell Scripts that allow Azure Active Directory administrators to override the Azure Active Directory token signing key for a given application.

This script is intended for production use.

For more information, see check out the [Signing key rollover in Azure Active Directory documentation](https://azure.microsoft.com/en-us/documentation/articles/active-directory-signing-key-rollover/)

# Impact
Any user that signs in to the application after the script is run.

# Pre-requisites
- Either a test app that you are ok having downtime on 
- Or a downtime window for your production app
Note: Downtime will only happen if your app doesn’t support automatic rollover which is what you are trying to assess.

# Steps to run the script
1.	Download and extract the scripts attached
2.	Start Windows Powershell
3.	Navigate to the folder where you extracted the scripts
4.	Run .\install-aadGraphModule.ps1
5.	Execute the script .\UpdateThumbprint-RollForward
6.	Wait for X (getting confirmation on how long this takes) 
7.	Test you web application – Make sure you use a new InPrivate browser window to ensure you get a new token.
8.	If the web application signs you in properly, you are fine.
9.	Execute the script .\UpdateThumbprint-RestoreDefaultBehavior.ps1

# Security Reporting

If you find a security issue with our libraries or services please report it to [secure@microsoft.com](mailto:secure@microsoft.com) with as much detail as possible. Your submission may be eligible for a bounty through the [Microsoft Bounty](http://aka.ms/bugbounty) program. Please do not post security issues to GitHub Issues or any other public site. We will contact you shortly upon receiving the information. We encourage you to get notifications of when security incidents occur by visiting [this page](https://technet.microsoft.com/en-us/security/dd252948) and subscribing to Security Advisory Alerts.

# We Value and Adhere to the Microsoft Open Source Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
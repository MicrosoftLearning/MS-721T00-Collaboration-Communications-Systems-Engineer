---
lab:
    title: 'Lab: Expand your Teams Voice Environment to use Direct Routing'
    type: 'Answer Key'
    module: 'Learning Path 01: Plan and design Teams collaboration communications systems'
---

# Lab 03: Expand your Teams Phone Environment to use Direct Routing
# Student lab answer key

## Lab Scenario

As part of the expanding business, the organization has an existing SIP trunk in its primary data center. The contractual obligations mean that it’s more cost-effective to utilize the SIP trunk and move to Microsoft Calling Plans later. As part of the move, Megan will be moved from the old telephone system to the new Microsoft Phone solution.

## Lab Setup

  - **Estimated Time to complete**: 200 minutes

## Instructions

> [!IMPORTANT]
> Throughout this lab, you will use PowerShell cmdlets that must be customized for your specific lab configuration. In the instructions below, when you see &lt;LAB NUMBER&gt; in a PowerShell command, you should replace it with the LAB NUMBER obtained in Exercise 1, Task 2. LAB DOMAIN refers to the full lab domain (i.e. lab12345.o365ready.com).

## Exercise 1: Configure lab for Direct Routing

### Exercise Duration

  - **Estimated Time to complete**: 25 minutes

In this exercise, you will run scripts to provision user accounts, groups, teams, and other resources used by the labs in this course. This script will also add your lab's custom domain to Office 365. If you have already added your lab's custom domain, the script will verify that it exists. 

### Task 1 - Identify your lab's public IP address

In the following task, you will identify your lab’s public IP address to ensure that you can regain access to your lab environment at a later date.

1. Sign in to **MS721-CLIENT01** as “Admin” with the password provided to you. You can find the password in the “Resource” section on the right side of the lab window.

1. Open Microsoft Edge and then browse to **http://www.bing.com**.

1. In the **Search** box, enter **What is my IP** and then press **Enter**.

1. The first result box with the label **Your public IP address** is your IP retrieved by Bing.

1. Copy or write down your public IP address. 

You have successfully identified and stored your IP address. When you restart your lab environment, you will possibly be assigned a new public IP address and need to perform the first task again.

### Task 2 - Retrieve your lab number

This task updates the o365ready.com DNS server with your lab's public IP address and creates a DNS delegation zone for your lab domain pointing to the DNS server running on MS721-RRAS01. Requests for hosts in your lab domain will be resolved by the DNS server running on MS721-RRAS01.

**Note**: If you have restarted this lab or if it expired and the virtual machines were reset, perform the steps in the knowledge section at the end of this task. You do not need to be issued a new lab number.  

1. You are still signed in to MS721-CLIENT01 as “Admin” with the password provided to you.

1. In Microsoft Edge, browse to **http://www.o365ready.com**.

1. On the Welcome page, select the **Generate Lab Number** tab.

1. In the **IP address** box, enter your public IP address from the previous task.

1. In the **Lab Code** box, enter **MS720**, press **Enter** or select **Submit** (**Note**: Do not enter MS721.).

1. Take note your LAB NUMBER. This lab code will expire 90 days after the start of this course. We will refer to this as your **LAB NUMBER** going forward in the lab.

1. When the process is completed, you will see a **Student LAB NUMBER** dialog, followed by a 5 digit number. Note this number down and remember it. You will refer to this five-digit number throughout the labs.

1. You will be using all five digits as part of your organization's on-premises domain.

1. Leave the browser window open and continue with the next task.

    ![Screenshot of the o365ready.com website showing the lab number provisioning tool form.](./Linked_Image_Files/M01_L01_E01_T02.png)

> [!NOTE]
> If you have restarted this lab or if the lab timer has expired and the virtual machines were reset, you will likely have a new public IP address. Perform the following steps to update your lab domain delegation zone's public IP address.

1. In Microsoft Edge, browse to [http://www.o365ready.com](http://www.o365ready.com/).

1. On the Welcome page, select the **Update Public IP Address** tab.

1. In the **Student LAB NUMBER** box, type your five-digit lab number. If you did not write down your original lab number, you can find it by signing in to Microsoft 365 and browsing to the **Domains** feature.

1. In the **Old public IP address** box, type the previously used public IP address. If you did not write down your original public IP address, open a command prompt and try to ping your lab domain name. Although you will not receive a response, the domain name should resolve to IP.

1. In the **New public IP address** box, type the new public IP address retrieved from Bing and then press Enter.

1. Select **Submit** and wait for the update to complete. This may take a couple of minutes.

You have successfully identified your lab number and updated your public IP address.

### Task 3 - Run MS-721TeamsDirectRoutingLabSetup-V2.ps1

In this task, you will run a script to create a new DNS zone on MS721-RRAS01 and the DNS records for Microsoft 365 services.  The script will also connect to Microsoft Graph and add your new student lab domain. Lastly, the script will generate a certificate signing request (CSR) for DigiCert to provision a signed certificate for the SBC.

1. You are still signed in to MS721-CLIENT01 as **Admin** with the password provided to you.

1. Download the latest version of the script from: [MS-721TeamsDirectRoutingLabSetup-V2.ps1](https://github.com/MicrosoftLearning/MS-721T00-Collaboration-Communications-Systems-Engineer/tree/main/Instructions/Labs/Labfiles/MS-721TeamsDirectRoutingLabSetup-V2.ps1) and save it to **C:\Scripts**.

1. Open **Windows PowerShell as Administrator**.

1. In the **User Account Control** dialog box, select **Yes**.

1. Make sure you have the latest Microsoft Graph PowerShell module installed with the following cmdlet. If you receive an **Untrusted repository** prompt, select **[A] Yes to all**.

    > NOTE: This command can take several minutes to complete, wait for the prompt in PowerShell to return or not all the Graph sub-modules will install.

    ```powershell
    Install-Module Microsoft.Graph -Force -AllowClobber

    ```

1. Change directories and run MS-721TeamsDirectRoutingLabSetup-V2.ps1:

    ```powershell
	cd C:\Scripts

    Set-ExecutionPolicy Unrestricted

    .\MS-721TeamsDirectRoutingLabSetup-V2.ps1

	```

1. When prompted, enter the **Microsoft 365 Administrator** email address and password. Do not use the credentials for Allan Deyoung, because we need additional permissions to work with Microsoft Graph.

1. After entering your credentials, you will be asked to provide authorization to Microsoft Graph to access your tenant's data. Check the box for **Consent on behalf of your organization** and then click **Accept**.

    ![A screenshot asking to provide consent for Microsoft Graph.](Linked_Image_Files/M03_E03_T01_01.png)

1. You will be prompted again to enter the username and password for the Administrator account on MS721-RRAS01.  When prompted, fill out the following information and select **OK**:

	- **User name:** Administrator

	- **Password:** *Enter the local Administrator password from the _“Resource”_ section on the right side of the lab window. _DO NOT_ enter the MOD Administrator's account password.*

	![A screenshot asking for local administrator credentials.](Linked_Image_Files/M03_E03_T02_01.png)

1. Next, enter the **5-digit Lab Number** you generated in Task 2.

1. The script will attempt to resolve your student lab domain and output the IP address.  If the values match, enter **Y** or **Yes** to confirm.

    > NOTE: DNS Records for your lab domain will be created. If it appears that the script has stopped after the _sipfederationtls SRV record has been created, click the PowerShell icon on the taskbar and sign in again to the MOD Administrator account. 

1. When prompted to **Press any key to continue** to generate a CSR for the lab, press enter.

1. When you see **Lab setup complete.** you may continue to Task 4.

### Task 4 - Request your public certificate from DigiCert

In the following task, you will request your public certificate for the SBC (Session Border Controller) so you can use it later in the labs. This is used to authenticate connections to multiple tenants and networks served from a single SBC.

1. You are still signed in to MS721-CLIENT01 as “Admin” with the password provided to you.

1. Open File Explorer and then browse to **C:\LabFiles**.

1. Double-click **CertReq-lab&lt;LAB NUMBER&gt;.o365ready.com.txt**. This certificate request was created by the configuration script.

    ![Screenshot of the completed certificate request file in Windows Explorer](./Linked_Image_Files/M01_L01_E01_T04.png)

1. In Notepad, select all the text in the file and then press Ctrl+C or right-click or tap and hold and select **Copy** to copy the contents to the clipboard.

1. Open Microsoft Edge, open a new tab and then browse to **https://www.digicert.com/friends/exchange.php**.

1. On the Microsoft Event CSR Submission page, in the **Paste CSR** box, right-click or tap and hold inside the box, and then select **Paste**.

1. Verify that you have pasted the contents of your certificate request.

1. Under **Certificate Details**, review the common name and subject alternative names (SAN) information that will be assigned to the certificate. Ensure that all SAN entries are lowercase. All SAN entries may not be used for this lab.

1. Under Certificate Delivery, in the **Email Address** and **Email Address (again)** boxes, enter the MOD Administrator account name, which is also the user's email address.

1. Select the **I agree to the Terms of Service above** check box.

1. Select **Submit**.

    ![Screenshot of the Microsoft Event CSR Submission form](./Linked_Image_Files/M01_L01_E01_T04-1.png)

1. Close File Explorer.

You have successfully requested the certificate from DigiCert and will download it later.

### Task 5 - Verify the custom domain has been added to your Microsoft 365 tenant

In this task, you will verify your custom domain so you can work with it and assign it to users.

1. You are still on **MS721-CLIENT01** where you are still signed in as **Admin**. 

1. In **Microsoft Edge**, browse to the Microsoft 365 admin center at [**https://admin.microsoft.com**](https://admin.microsoft.com/).

1. On the **Sign in** screen, enter the credentials of the Global Admin account of the **MOD Administrator** with the username and password provided to you.

1. When a **Save password** dialog is displayed, select **Never**.

1. When a **Stay signed in?** dialog is displayed, select **No**.

1. In the left navigation, select the three dashes and select **… Show all**.

1. Select **Settings** then select **Domains**.

1. Verify your custom domain has been added to Microsoft 365. This domain starts with a **lab** and your five digits lab number, followed by the **o365ready.com** domain. The domain may still be listed as Incomplete setup, this will not cause problems in the lab.

1. Leave the browser window open.

    ![Screenshot of the Microsoft 365 admin center Domains page, showing the custom lab domain as Default.](./Linked_Image_Files/M01_L01_E02_T01.png)

You have successfully verified the custom domain created from the script is set as the default domain for your tenant, which is important for later tasks.

### Task 6 - Assign the custom lab domain to Megan Bowen

In the following task, you will add the custom domain to Megan Bowen.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”, and you are still in the **Microsoft 365 admin center** as **MOD Administrator**.

1. In the left navigation, select **Users** and **Active users**.

1. In the **Active users** list, select **Megan Bowen** to open the right-side menu.

1. In the Megan Bowen user card, select the **Account** tab under **Username and email** select **Manage username and email**.

1. Below **Primary email address and username**, you can see the default UPN of Megan Bowen. Select the pencil symbol, select the textbox under **Domains** and select **lab&lt;LAB NUMBER&gt;.o365ready.com**.

1. Select **Done**, then select **Save changes**.

1. Repeat steps 3-6 with user **Nestor Wilke**.

1. Leave the browser open for the next task.

You have successfully added the custom domain to Megan Bowen and Nestor Wilke.

## Exercise 2: Deploy the session border controller

### Exercise Duration

  - **Estimated Time to complete**: 30 minutes

In this exercise, you will deploy the AudioCodes Mediant VE Session Border Controller (SBC) from the Azure Marketplace, and install the services needed to ensure the custom domain and SBC work as expected.

### Task 1 - Add the SBC to the tenant

In this task, you will verify and add your SBC to your tenant.

1. You are still on MS721-CLIENT01 and signed in as “Admin”.

1. Open a new tab in Microsoft Edge and then browse to [**https://admin.teams.microsoft.com**](https://admin.teams.microsoft.com/).

1. Sign in to the Teams admin center as **MOD Administrator**.

1. In the left navigation select **Voice**, select **Direct Routing**, and under SBCs, select **Add**.

1. Add the FQDN **sbc01.lab&lt;LAB NUMBER&gt;.o365ready.com** and then set the following parameters and then click **Save**. Please note, use **ALL lower case** letters as it is case sensitive. Leave all the other settings as-is. 

	- **Enabled:** Toggle On

	- **Forward call history:** Toggle On

	- **Forward P-Asserted-Identity (PAI) header:** Toggle On

	- **SBC supports PIDF/LO for emergency Calls:** Toggle On

    ![Screenshot of the Teams Admin Center Add SBC page, showing the settings required.](./Linked_Image_Files/M03_E02_T01_01.png)

1. Leave the browser open at the end of this task.

You have successfully verified your custom domain and added an SBC to the tenant.

### Task 2 - Retrieve your public certificate file

In the following task, you will download the DigiCert certificate you requested earlier in the lab so you can use it for your SBC. This step is required to upload the certificate in the compressed archive container in the next task.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin” 

1. Open Microsoft Edge and then browse to **Outlook on the web** [**https://outlook.office.com**](https://outlook.office.com/), where you should still be signed in as the **MOD Administrator**.

1. In the message list, locate and select the email from **DigiCert** with the zip file attachment. The message may arrive in the Focused or Other folder and should arrive within 2-5 minutes.

1. Download the **sbc01_lab&lt;LAB NUMBER&gt;.o365ready.comXXXXXXX.zip** file attachment, it will be saved to the default Downloads folder.

1. Close the browser window to end the task.

You have successfully downloaded the certificate you requested in an earlier exercise and it is now available to certify your SBC.

> [!WARNING]
> Download the file as-is. Do not compress the already compressed zip file. Some web-based email systems allow you to compress or zip your download. This will cause the already compressed file to be compressed again and will cause the script in this lab to fail.

### Task 3 - Run the ImportLabCert script located in C:\Scripts

In the following task, you will import the certificate to the local machine and convert it to a format the SBC can read.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”.

1. Switch to File Explorer and then browse to **C:\Scripts**.

1. Double-click **ImportLabCert.exe**.

1. In the **User Account Control** dialog box, select **Yes**.

1. In the window, select **Import lab certificate**.

1. When the script completes, select **Finish**.

1. Close File Explorer.

You have successfully converted the certificate for the SBC.

### Task 4 – Setting up Session Border Controller (SBC) Virtual Machine resources

In the following task you will create the new session boarder controller resource hosted within Microsoft Azure.

1. You are still on MS721-CLIENT01 where you are still signed in as **Admin**.

1. Open a new **In-Private Microsoft Edge browser window** by right-clicking on the Microsoft Edge icon in the taskbar and selecting **New InPrivate Window** and then navigate to **https://portal.azure.com**.

1. Log in with the **Azure Portal username and password** provided to you by your lab provider.  **DO NOT** log in with your Microsoft 365 account.

1. Select **Create a resource**.

1. Search for **Mediant VE Session Border Controller (SBC)**.

1. Select **Mediant VE Session Border Controller (SBC)**.

1. Select **Create > AudioCodes Mediant VE SBC for Microsoft Azure**

1. For **Resource group**, select **Create New**.

1. Fill **Name** with **SBC** then Select **OK**.

1. Fill out the following information and leave everything else as-is:

	- **Virtual machine name:** sbc01

	- **Username:** sbcadmin

	- **Password:** *Enter the MOD Administrator password in the _"Resource"_ section on the right side of the lab window.*

1. Select **Next** to configure **Virtual Machine Settings**

1. Select **Change size** and then choose **D2s_v3** from the list and then choose **Select** at the bottom.

1. Select **Review + Create** (If you see a "Validation failed" message, you need to select **Previous** and select **Review + Create** again).

1. Select **Create** and wait for the deployment to complete.

### Task 5 - Retrieve SBC Public IP and configure DNS routing

In the following task you will retrieve the public IP address of the SBC and routing to the public DNS so Teams can locate the SBC.

1. Select **Go to resource group**.

1. Select **sbc01-ip**.

1. Make note of the Public IP Address to use later.

1. Select the start button, enter **Windows PowerShell** and select **Run as administrator** below PowerShell from the start menu.

1. When Windows PowerShell window has opened, enter the following cmdlet to a session with the DNS Server (**Note**: the machine name should stay as MS720-RRAS01, despite the course being MS-721):

    ```powershell
    $Cimsession = New-CimSession -Name MS720-RRAS01 -ComputerName MS720-RRAS01 -Authentication Negotiate -Credential (Get-Credential -Credential Administrator)

    ```

1. When prompted to provide credentials fill out the following information and select **OK**:

	- **User name:** Administrator

	- **Password:** *Enter the local Administrator password from the _“Resource”_ section on the right side of the lab window. _DO NOT_ enter the MOD Administrator's account password.*

1. Once the module is installed you will see the command prompt again.

1. Enter and modify the following cmdlet with your **LAB NUMBER** and **Public SBC IP Address** to configure the DNS Record for the SBC (**Note**: the machine name should be stay as MS720-RRAS01, despite the course being MS-721):

    ```powershell
    Add-DnsServerResourceRecordA -ComputerName MS720-RRAS01 -CimSession $Cimsession -ZoneName lab<LAB NUMBER>.o365ready.com -Name sbc01 -IPv4Address <Public SBC IP>
    ```

1. Verify the DNS zone was created successfully by running the following command.  You should see it pointing to the Public IP Address that the SBC was assigned through Azure:

    ```powershell
	nslookup sbc01.lab<LAB NUMBER>.o365ready.com

	```

1. You can close the Windows PowerShell window by selecting the **X** in the top right.

You have successfully created an SBC hosted inside Microsoft Azure.

### Task 6 – Sign into and apply a base configuration to the SBC

 In the following task, we will configure the Session Boarder Controller (SBC) to work with Microsoft Teams.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”.

1. Open a new Microsoft Edge browser window and navigate to [**https://&lt;SBCpublicIPAddress&gt;**](*) or [https://sbc01.lab&lt;LAB NUMBER&gt;. o365ready.com](*). Ensure that you replace &lt;SBCpublicIPAddress&gt; or &lt;LAB NUMBER&gt; with the IP address of the SBC instance or the lab number you got from o365ready.com.

    > NOTE: You may see a connection message indicating your connection isn't private (NET::ERR_CERTIFICATE_TRANSPARENCY_REQUIRED or NET::ERR_CERT_COMMON_NAME_INVALID).  Select **Advanced** and then the link at the bottom to **Continue to &lt;SBCpublicIPAddress&gt;**.

1. Logon to the SBC using the following credentials you configured earlier:

	- **Username:** sbcadmin

	- **Password:** *Enter the MOD Administrator password in the _“Resource”_ section on the right side of the lab window.*

1. Once you have successfully logged onto the SBC, click on **Actions** and then **Configuration File**.

1. Under the **Configuration File** section, select **Choose File**, select the file named **Lab<LAB NUMBER>-SBC01-Config.ini** inside of the **C:\LabFiles** directory, and then click **Upload INI File**. The SBC will reboot

1. Upon reboot of the SBC, log back into the box. To confirm successful configuration, ensure that you see two IP Groups at the top of **Topology View**


    ![Screenshot of the AudioCodes SBC, showing the Topology View before SSL Cert Import.](./Linked_Image_Files/M03_L03_E03_T06_03.png)

You have successfully performed the base configuration of the AudioCodes SBC.

## Exercise 3: Configure the session border controller

### Exercise Duration

  - **Estimated Time to complete**: 10 minutes

In this exercise, you will configure the session border controller, and install the services needed to ensure the custom domain and SBC work as expected.

### Task 1 - Upload the lab certificate to the SBC

In the following task, you will upload the lab certificate you requested earlier to the SBC. This is needed to secure the connection between the SBC and Microsoft Teams  

1. Login again to the SBC after the reboot. Once signed in Navigate to **Setup -> IP Network -> Security -> TLS Contexts**

1. In the TLS Contexts table, select the context called **External**.

1. Scroll down below the **External** TLS Context's information and select **Change Certificate**.

1. In the Change Certificates window, scroll down to the **UPLOAD CERTIFICATE FILES FROM YOUR COMPUTER** section.

1. In the **Private key pass-phrase (optional)** box, enter the **Admin** password for MS721-CLIENT01 virtual machine.
 
1. Under **Send Private Key file from your computer to the device**, select **Load Private Key File**.  

1. In the Open window, browse to **C:\LabFiles**, select **Labcert.pfx**, and then select **Open**. If you cannot find the certificate, select **All files (*.*)** in the bottom right corner.  

1. To the right of the lab certificate file path, select **Load File**.  

> [!IMPORTANT]
> After uploading the lab certificate, go back and verify that the **DigiCert Global Root G2** and **DigiCert Global G2 TLS RSA SHA2** trusted certificate authorities are present in the External TLS context. If not, repeat task 7 again.

1. Review the banner and verify that the certificate was loaded. 

1. Select **Save** at the top right of the page, then select **Yes**.

1. Leave the browser window open for the next task.

You have successfully uploaded the lab certificate, and signed its communication to Microsoft Teams.

### Task 2 - Verify the SBC Connections to Teams

In the following task, you will validate the SBC to be ready for Teams

On the SBC, select **Monitor** at the top and under **VOIP Status &gt; Proxy Set Status**, the output should be **Online** for the three entries for psthub.Microsoft.com. 

If the output shows the correct value for all three entries your SBC is configured correctly and you will be able to continue with the next exercise.


## Exercise 4: Configure Teams for Direct Routing

### Exercise Duration

  - **Estimated Time to complete**:  120 minutes

In this exercise, you will create a direct route routing policy, PSTN Usage policy, and voice route to enable Megan Bowen to perform voice calls over the SBC. Megan resides in a location where the telephone number assigned to her has a long-standing contract and requires her to continue to use the telephone service provider's telephone number rather than moving to a calling plan from Microsoft. Long term the plan is to move the telephone number over to a calling plan, however, currently, this is cost prohibitive. 

### Task 1 - Create a voice routing policy with PSTN usages containing voice routes

In the following task, you will create your first voice routing policy and PSTN usage so you can later assign this policy to your users.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”.

1. Select the Windows symbol in the task bar, type **PowerShell** and open a regular PowerShell window.

1. In Windows PowerShell, enter the following cmdlet to connect to Teams in your tenant:

    ```powershell
    Connect-MicrosoftTeams

    ```

    > NOTE: If you get an error stating that the MicrosoftTeams PowerShell module is not installed, run **Install-Module MicrosoftTeams** as an administrator.

1. In the PowerShell prompt, sign in as **Allan Deyoung** with the credentials provided to you.

1. In Windows Powershell, enter the following and then press **Enter**. By running the command you will see that the existing PSTN usages in place. You can see what is in place and what usage plans are being assigned to the identity. 

    ```powershell
    Get-CsOnlinePstnUsage

    ```

1. Review the output of the command.

If you have several usages defined, the names of the usages might truncate. Use the command Get-CSOnlinePSTNUsage to display a list of the defined PSTN usages. An online PSTN usage links an online voice policy to a route. The output will show if there is an identity that can be used or possibly reused, or also excluded from being used. For example, there may be a PSTN usage called Seattle, that can cover all of the Pacific North West of the United States. The overall goal is to keep your PSTN Usage rules to a minimum and keep them simple as it will reduce the overall administration effort later. We want to validate that the information we have in the tenant is relevant and also ensure we do not duplicate any existing PSTN usages. 

1. Run the Set-CSOnlinePSTNUsage cmdlet is used to add or remove phone usages to or from the usage list. This list is global so it can be used by policies and routes throughout the tenant:

    ```powershell
	Set-CsOnlinePstnUsage -Identity Global -Usage @{Add = 'NA-Emergency', 'NA-Service', 'NA-National'}

    ```

1. Run the New-CSOnlineVoiceRoutingPolicy to create a new online voice routing policy. Online voice routing policies are used in Microsoft Phone System Direct Routing scenarios. Assigning your Teams users an online voice routing policy enables those users to receive and to place phone calls to the public switched telephone network by using your on-premises SIP trunks:

    ```powershell
    New-CsOnlineVoiceRoutingPolicy "NA-National" -OnlinePstnUsages 'NA-Emergency','NA-Service','NA-National'

    ```

1. Run the New-CsOnlineVoiceRoute command - Creates a new online voice route. Online voice routes contain instructions that tell Microsoft Teams how to route calls from Office 365 users to phone numbers on the public switched telephone network (PSTN) or a private branch exchange (PBX):

    ```powershell
	New-CsOnlineVoiceRoute -Identity "NA-Emergency" -NumberPattern '^\+?(911|933)$' -OnlinePstnGatewayList sbc01.lab<LAB NUMBER>.o365ready.com -Priority 1 -OnlinePstnUsages 'NA-Emergency'
	New-CsOnlineVoiceRoute -Identity "NA-Service" -NumberPattern '^\+?([2-9]\d{2})$' -OnlinePstnGatewayList sbc01.lab<LAB NUMBER>.o365ready.com -Priority 2 -OnlinePstnUsages 'NA-Service'
	New-CsOnlineVoiceRoute -Identity "NA-National" -NumberPattern '^\+1[2-9]\d\d[2-9]\d{6}$' -OnlinePstnGatewayList sbc01.lab<LAB NUMBER>.o365ready.com -Priority 3 -OnlinePstnUsages 'NA-National'

    ```

1. Run the Get-CSOnlineVoiceRoute command, this command returns information about the online voice routes configured for use in your tenant. Online voice routes contain instructions that tell Microsoft Teams how to route calls from Office 365 users to phone numbers on the public switched telephone network (PSTN) or a private branch exchange (PBX):

    ```powershell
    Get-CsOnlineVoiceRoute

    ```

1. Review the output of the command and verify that your new voice routes have been added.

1. Leave the PowerShell window open for the next task.

You have successfully created a voice routing policy with PSTN Usages containing voice routes.

### Task 2 - Assign the voice routing policy named NA-National to Megan Bowen

In the following task, you will asign the voice routing policy you created in an earlier task to your users.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”, and you have an open **Teams PowerShell** session signed in as **Allan Deyoung**.

1. Run the Grant-CsOnlineVoiceRoutingPolicy, the command assigns a per-user online voice routing policy to one or more users. Online voice routing policies manage online PSTN usages for Phone System users:

    ```powershell
    Grant-CsOnlineVoiceRoutingPolicy -Identity MeganB@lab<LAB NUMBER>.o365ready.com -PolicyName "NA-National"

    ```

If you receive an error stating that the **Policy "NA-National" is not a user policy. You can assign only a user policy to a specific user**., wait 2-3 minutes and then retry the command. You may need to retry the command several times before it is successful and it may take up to 15 minutes before it becomes available. If the policy is still not updated in the service, you continue to the next lab and return later.

1. Run the Get-CsOnlineUser command, the command returns information about users who have accounts homed on Microsoft Teams:

    ```powershell
    Get-CsOnlineUser MeganB | select OnlineVoiceRoutingPolicy

    ```

1. Review the output of the command. If the policy is empty, try the command again.

1. Leave the PowerShell window open for the next task.

You have successfully used PowerShell to assign your voice routing policy to your users.

### Task 3 - Enable users for Direct Routing

In the following task, you will enable the end user for voice services through the direct routing SBC, assign the telephone number, and enable the user for dial pad service.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin” and you have an open **Teams PowerShell** session signed in as **Allan Deyoung**.

1. Run the Set-CsPhoneNumberAssignment command, the command assigns a phone number to a user or resource account. When you assign a phone number the EnterpriseVoiceEnabled flag is automatically set to True.:

    ```powershell
    Set-CsPhoneNumberAssignment -Identity MeganB@lab<LAB NUMBER>.o365ready.com -PhoneNumber "+14255551234" -PhoneNumberType DirectRouting

    ```

1. The cmdlet does not provide any output. When you are back on the command prompt, leave the window open for the next task.

You have successfully assigned a telephone number to the end user and you have enabled the end user for the dial pad.

### Task 4 - Translate numbers to an alternate format

In the following task, you will create a normalization record for a 4-digit dial plan

1. You are still signed in to MS721-CLIENT01 as “Admin”.

1. Open Microsoft Edge and then browse to the **Microsoft Teams admin center** at https://admin.teams.microsoft.com.

1. Sign in with **Allan Deyoung**, who is your Teams Administrator in this lab.

1. In the left navigation pane select **Voice,** select **Dial Plans** and select **Global (Org-wide default).**

1. Under **Normalization** **rules** select **Add.**

1. Under **Name** enter **4 Digit Extension** and under Description **4-digit extension dialing.**

1. Select “**The length of the number being dialed is”** set to **4** and select **Exactly.**

1. Under **Then do this** select **Add this number to the beginning** and enter **+1425555.**

1. Verify functionality by typing **1234** into the test box and pressing **Test –** Output should be +14255551234.

1. Select **Save**.

1. Leave the browser window open for the end of this task.

You have successfully you have assigned a 4-digit extension dial to the global group.


### Task 5 - Configure Emergency Location Identification Number (ELIN)

In the following task, you will assign the Emergency Location Identification number to a location existing in Microsoft Teams Admin center already. This field is optional and not required in most E911 deployments.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. In the left navigation pane select the three dashes, select **Locations** and select **Emergency addresses.**

1. Select **Bellevue Office Address** and then select **Edit**.

1. Review the settings for **ELIN**. It should be **425-555-1200**. The number was set in an earlier task, and once the location has been validated, it's properties cannot be changed. This includes the ELIN number. 

1. Select **Save**.

1. Leave the browser window open.

You have successfully assigned the ELIN number to the location for emergency addresses.


### Task 6 - Configure Emergency Call Routing Policy

In the following task, you will modify the Global Emergency Call Routing Policy in Microsoft Teams Admin center. This will enable Dynamic Emergency Calling and route emergency calls to the SBC.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. Select the three dashes, select **Voice**, then **Emergency policies**, and then **Call routing policies** across the top.

1. Select the **Global (Org-wide default)** policy, and change **Dynamic emergency calling** to **On**.

1. Select **Add** and then provide the following configuration:

	- **Emergency dial string:** 911

	- **Emergency dial mask:** 911;9911;999;112

	- **PSTN Usage:** NA-Emergency

1. Select **Add** again and then provide the following configuration for the second line:

	- **Emergency dial string:** 933

	- **Emergency dial mask:** 933;9933

	- **PSTN Usage:** NA-Emergency

1. Select **Save** and leave the browser window open.

    ![Screenshot of the Teams Admin Center Emergency Call Routing Policy page, showing the settings required.](./Linked_Image_Files/M03_L03_E04_T06_01.png)


### Task 7 - Configure Emergency Calling Policy

In the following task, you will modify the Global Emergency Calling Policy in Microsoft Teams Admin center. This will enable external location lookup and enable emergency call notifications.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. Select the three dashes, select **Voice**, and then **Emergency policies.**

1. Select the **Global (Org-wide default)** policy, and change **External location lookup mode** to **On**.

1. In the **Emergency Services Disclaimer** box, enter the following text:

    ```
    If you are working offsite, please set your location by clicking "Location Not Detected" below
    ```

1. Under **Emergency Numbers** select **Add** and then provide the following configuration:

	- **Emergency dial string:** default

	- **Notification mode:** Send Notification Only

	- **Users and Groups for emergency calls notifications:** Alex Wilber

1. Select **Save** and leave the browser window open.

    ![Screenshot of the Teams Admin Center Emergency Calling Policy page, showing the settings required.](./Linked_Image_Files/M03_L03_E04_T07_01.png)


### Task 8 - Deploy Location-Based Routing & Dynamic Emergency Policy Assignment based on subnets

In the following task, you will configure location-based routing to allow connectivity to the local SBC to the end user depending upon the subnet IP address allocated. Additionally, you will set the Emergency Calling Policy and Emergency Call Routing policy created previously to be dynamically assigned to users as they visit this network site. This will override any user-level emergency policies.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. Select the three dashes, select **Locations**, then **Network topology.**

1. Select **Add**, give the Network Site a name of **Washington** and description as **Washington Network**. Set the **Network region** to **US** and then hange **Location based routing** to **On**.

1. Select **Add subnets,** for **IP address** enter **192.168.0.0** and a **Network Range** of **24,** select **Apply,** and then select **Save**

    ![Screenshot of the Teams Admin Center Network Topology Network Sites page, showing the settings required.](./Linked_Image_Files/M03_L03_E04_T08_01.png)

1. Within the Teams Admin Center select **Locations**, then **Netowork topology.**

1. Select **Trusted IPs**, then **Add**. Enter the workstation IP found in Exercise 1, Task 1 with a **Network Range** of **32**, a **Description** of **Washington.**, and then select **Save**

    ![Screenshot of the Teams Admin Center Network Topology Trusted IPs page, showing the settings required.](./Linked_Image_Files/M03_L03_E04_T08_02.png)

1. Within the Teams Admin Center select **Voice**, then **Direct Routing.**

1. Select **sbc01**, select **settings** and then **edit SBC.**

1. Under **Location based routing and media optimization**, turn on **Location based routing**, select **Gateway site ID** to **Washington**, then select **Save**.

    ![Screenshot of the Teams Admin Center SBC Page, showing the settings required.](./Linked_Image_Files/M03_L03_E04_T08_03.png)

1. Leave the browser window open.

You have successfully implemented the Location based routing which will route your calls dependent upon the machine's local subnet to which it is registered. Additionally, you have sucvcessfully implemented dynamic Emergency Calling Policy and Emergency Call Routing policy assignment for users as they visit this network site.

### Task 9 - Modify the Global Dial Plan to Support Dialing 911 and 933

In the following task, you will configure a Microsoft teams dial plan rule to allow 911 and 933 to be sent out to the SBC as is. Without this rule, Microsoft Teams' Tenant Dial Plan rules will normalize this to +1911 as an example.

1. In the PowerShell window from Task 1, run the following commands:

    ```powershell
    $nr1=New-CsVoiceNormalizationRule -Parent Global -Name 'NA-Emergency' -Pattern '^9?(911|933)$' -Translation '$1' -InMemory
    Set-CsTenantDialPlan -Identity 'Global' -NormalizationRules @{Add =$nr1}
    
    ```
You have successfully created a dial plan rule that supports sending 911 and 933 to the sbc as-is with no modifications. 

## Exercise 5: Test and Validate your Configuration

### Exercise Duration

  - **Estimated Time to complete**: 30 minutes

In this exercise, you will validate that the SBC is accepting calls, and test E911 configuration to ensure items created work as expected.

### Task 1 - Validate Location-Based Routing blocks calls not allowed

In this task, you will validate that Location-Based Routing is blocking calls that are not permitted on the gateway defined.

1. Sign in to **MS721-CLIENT02** as “Admin” with the password provided to you. You can find the password in the “Resource” section on the right side of the lab window.

1. Launch the Microsoft Teams client and sign in as **MeganB@lab<LAB NUMBER>.o365ready.com** using the User Password in the "Resource" section on the right side of the lab window.

1. Once signed into Microsoft Teams, navigate to the **Calls** tab and place a call to "+14255550001". The call should fail and show the below error:

    ![Screenshot of the Teams client for Michelle, showing location-based routing blocking calls.](./Linked_Image_Files/M03_L03_E05_T01_01.png)

1. To correct this issue, we are going to disable Location-Based Routing. Open the **Microsoft Teams admin center** as **Allan Deyoung**.

1. Select the three dashes, select **Locations**, then **Network topology**, and then select **Washington**. Turn off **Location Based Routing** and then click **Save**

1. Within the Teams Admin Center select **Voice**, then **Direct Routing.** Select **sbc01**, select **settings** and then **edit SBC.**

1. Under **Location based routing and media optimization**, turn off **Location based routing**, clear the **Gateway site ID**, then select **Save**.

    ![Screenshot of the Teams Admin Center, showing location-based routing being turned off.](./Linked_Image_Files/M03_L03_E05_T01_02.png)

1. After about 30 minutes, attempt to place the call again to +14255550001. The call should connect. While you will not hear anything in the lab, the call should show a connected window with a timer in the top left as shown below:

    ![Screenshot of the Teams client, showing a test call connected through the SBC.](./Linked_Image_Files/M03_L03_E05_T01_03.png)

1. Leave the Teams client window open and continue with the next task.

You have successfully placed a test call in the lab through your SBC and validated correct routing.

### Task 2 - Validate PIDF/LO Information is being sent to the SBC

In this task, you will validate that PIDF/LO information from the LIS database in Microsoft Teams is being sent to the SBC. 

1. Sign in to **MS721-CLIENT02** as “Admin” with the password provided to you. You can find the password in the “Resource” section on the right side of the lab window.

1. Launch the **Microsoft Edge** and download the **AudioCodes Syslog Viewer** at: http://redirect.audiocodes.com/install/syslogViewer/syslogViewer-setup.exe

1. Run **syslogViewer-setup.exe** once downloaded keeping all defaults in the setup wizard.

1. Once installed, open Syslog Viewer and then press the Chain-Link icon in the top toolbar

    ![Screenshot of Syslog Viewer, showing the "Connect To" button](./Linked_Image_Files/M03_L03_E05_T02_01.png)

1. On the **Web Connection** window, provide the following configuration and then click **Connect:**

	- **Address:** the IP address or FQDN of your Azure SBC

	- **Username:** sbcadmin

	- **Password:** The MOD Administrator account password. You can find the password in the “Resource” section on the right side of the lab window.

    ![Screenshot of Syslog Viewer, showing the "Web Connection" window](./Linked_Image_Files/M03_L03_E05_T02_02.png)

1. Now that the syslog capture is running, open the Microsoft Teams client, click on **Calls** and you should see the Belleview Address previously created.

    ![Screenshot of the Microsoft Teams Client, showing the Emergency Address](./Linked_Image_Files/M03_L03_E05_T02_03.png)

    > NOTE: If you see "Location Not Detected" You can either set your location manually for this test or restart your Microsoft Teams client. The policies created previously can take some time to take effect.

1. Dial **933** in Microsoft Teams and then verify that +1933 does not show in the translation. If it does, restart the Microsoft Teams client.

    ![Screenshot of the Microsoft Teams Client, showing that 933 has no +1 in front](./Linked_Image_Files/M03_L03_E05_T02_04.png)

1. Once you have confirmed that 933 looks correct, click **Call**. A New call window will open stating that an emergency call is in progress showing your number and address. hang up the call after 5 seconds.

    ![Screenshot of the Microsoft Teams Client, showing the emergency call in progress](./Linked_Image_Files/M03_L03_E05_T02_05.png)

1. On **MS721-CLIENT02** open the AudioCodes Syslog Viewer and press the **Snowflake** button at the top to pause capture. Then Press the **Blue I** to open the sip ladder.

    ![Screenshot of Syslog viewer, showing which buttons to press](./Linked_Image_Files/M03_L03_E05_T02_06.png)

1. In the **SIP Flow Diagram** Window, select **Show Calls** in the dropdown on the middle-right. Then select the call to 933 above this. In the message window below, scroll down and you will see XML PIDF/LO XML Data.

    ![Screenshot of Syslog viewer, showing the XML Data](./Linked_Image_Files/M03_L03_E05_T02_07.png)

1. If you continue scrolling right, you will see the XML encoded version of your Emergency Address.

    ![Screenshot of Syslog viewer, showing the expanded XML Data](./Linked_Image_Files/M03_L03_E05_T02_08.png)

Congratulations, you have just validated that the SBC is recieving PIDF/LO information when Emergency calls are being placed and that required policies are working as expected.
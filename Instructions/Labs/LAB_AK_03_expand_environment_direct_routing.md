---
lab:
    title: 'Lab: Expand your Teams Voice Environment to use Direct Routing'
    type: 'Answer Key'
    module: 'Learning Path 01: Plan and design Teams collaboration communications systems'
---

# Lab 03: Expand your Teams Phone Environment to use Direct Routing
# Student lab answer key

## Lab scenario

As part of the expanding business, the organization has an existing SIP trunk in its primary data center. The contractual obligations mean that it’s more cost-effective to utilize the SIP trunk and move to Microsoft Calling Plans later. As part of the move, Megan will be moved from the old telephone system to the new Microsoft Phone System solution.

## Lab Setup

  - **Estimated Time to complete**: 200 minutes

## Instructions

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

1. In the **Lab Code** box, enter **MS720**, press **Enter** or select **Submit** ((Note: Do not enter MS721.)).

1. This lab code will expire 90 days after the start of this course.

1. When the process is completed, you will see a **Student Lab Number** dialog, followed by a 5 digit number. Note this number down and remember it. You will refer to this five-digit number throughout the labs.

1. You will be using all five digits as part of your organization's on-premises domain.

1. Leave the browser window open and continue with the next task.

    ![Screenshot of the o365ready.com website showing the lab number provisioning tool form.](./Linked_Image_Files/M01_L01_E01_T02.png)

> [!NOTE]
> If you have restarted this lab or if the lab timer has expired and the virtual machines were reset, you will likely have a new public IP address. Perform the following steps to update your lab domain delegation zone's public IP address.

1. In Microsoft Edge, browse to [http://www.o365ready.com](http://www.o365ready.com/).

1. On the Welcome page, select the **Update Public IP Address** tab.

1. In the **Student Lab Number** box, type your five-digit lab number. If you did not write down your original lab number, you can find it by signing in to Microsoft 365 and browsing to the **Domains** feature.

1. In the **Old public IP address** box, type the previously used public IP address. If you did not write down your original public IP address, open a command prompt and try to ping your lab domain name. Although you will not receive a response, the domain name should resolve to IP.

1. In the **New public IP address** box, type the new public IP address retrieved from Bing and then press Enter.

1. Select **Submit** and wait for the update to complete. This may take a couple of minutes.

You have successfully identified your lab number and updated your public IP address.

### Task 3 - Run the CallandMeetLabs.exe script

In the following task you will execute a script to setup your lab environment.

1. You are still signed in to MS721-CLIENT01 as “Admin” with the password provided to you.

1. Open File Explorer and then browse to **C:\Scripts**.

1. Double-click **CallandMeetLabs.exe**.

1. In the **User Account Control** dialog box, select **Yes**.

1. In the **Office 365 Admin username** box, enter your M365 tenant MOD Administrator account name. You can find your tenant username in the resource section on the right side of the lab window.

1. In the **Office 365 Admin password** box, enter the MOD Administrator password, provided to you.

1. In the **5-digit lab number** box, enter your lab number from the previous task and select **Verify**.

1. The script tries to use the delivered credentials to access your tenant. Ensure the credentials were verified and review the identified public IP address in the blank window.

    **Note**: If the reported public IP address is not the same as your lab's **&lt;public IP&gt;**, verify your public IP address is correct using the steps found earlier in this exercise. If the public IP addresses do not match, cancel and run the script again. If the public IP address you have identified and the public IP found by the script still do not match, contact a lab proctor.

    ![Screenshot of the Lab Provisioning Tool](./Linked_Image_Files/M01_L01_E01_T03.png)

1. If you see a **Ready to run script message**, select **Run Script** to prepare your lab tenant.

1. When the script has completed and you can see a **Complete** message, select **Finish**.

    ![Screenshot of the completed Lab Provisioning Tool](./Linked_Image_Files/M01_L01_E01_T03-1.png)

As soon as the script finishes successfully, you have successfully configured your lab environment with the provided scripts.

### Task 4 - Request your public certificate from DigiCert

In the following task, you will request your public certificate for the SBC (Session Border Controller) so you can use it later in the labs. This is used to authenticate connections to multiple tenants and networks served from a single SBC.

1. You are still signed in to MS721-CLIENT01 as “Admin” with the password provided to you.

1. Open File Explorer and then browse to **C:\LabFiles**.

1. Double-click **CertReq-lab&lt;customlabnumber&gt;.o365ready.com.txt**. This certificate request was created by the configuration script.

    ![Screenshot of the completed certificate request file in Windows Explorer](./Linked_Image_Files/M01_L01_E01_T04.png)

1. In Notepad, select all the text in the file and then press Ctrl+C or right-click or tap and hold and select **Copy** to copy the contents to the clipboard.

1. Open Microsoft Edge, open a new tab and then browse to **https://www.digicert.com/friends/exchange.php**.

1. On the Microsoft Event CSR Submission page, in the **Paste CSR** box, right-click or tap and hold inside the box, and then select **Paste**.

1. Verify that you have pasted the contents of your certificate request.

1. Under **Certificate Details**, review the common name and subject alternative names (SAN) information that will be assigned to the certificate. Ensure that all SAN entries are lowercase. All SAN entries may not be used for this lab.

1. Under Certificate Delivery, in the **Email Address** and **Email Address (again)** boxes, enter the MOD Administrator account name, which is also the user's email address.

1. Select the **I agree to the Terms of Service above** check box.

1. Select **Submit**.

    ![Screenshot of the Microsoft Event CSR Submission form](./Linked_Image_Files/M01_L01_E01_T04.png)

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

1. Verify your custom domain has been added to Office 365 and is set as Default. This domain starts with a **Lab** string and your five digits lab number, followed by the **o365ready.com** domain. The domain may still be listed as Incomplete setup, this will not cause problems in the lab.

1. Leave the browser window open.

    ![Screenshot of the Microsoft 365 admin center Domains page, showing the custom lab domain as Default.](./Linked_Image_Files/M01_L01_E02_T01.png)

You have successfully verified the custom domain created from the script is set as the default domain for your tenant, which is important for later tasks.

### Task 6 - Assign the custom lab domain to Megan Bowen

In the following task, you will add the custom domain to Megan Bowen.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”, and you are still in the **Microsoft 365 admin center** as **MOD Administrator**.

1. In the left navigation, select **Users** and **Active users**.

1. In the **Active users** list, select **Megan Bowen** to open the right-side menu.

1. In the Megan Bowen user card, select the **Account** tab under **Username and email** select **Manage username and email**.

1. Below **Primary email address and username**, you can see the default UPN of Megan Bowen. Select the pencil symbol, select the textbox under **Domains** and select **lab&lt;customlabnumber&gt;.o365ready.com**.

1. Select **Done**, then select **Save changes**.

    ![Screenshot of the Microsoft 365 admin center user detail page for Megan Bowen.](./Linked_Image_Files/M01_L01_E02_T03.png)

1. Close the **Manage username and email** pane and then close the Megan Bowen user card.

1. Leave the browser open for the next task.

You have successfully added the custom domain to Megan Bowen.

## Exercise 2: Deploy the session border controller

### Exercise Duration

  - **Estimated Time to complete**: 30 minutes

In this exercise, you will deploy the AudioCodes Mediant VE Session Border Controller (SBC) from the Azure Marketplace, and install the services needed to ensure the custom domain and SBC work as expected.

### Task 1 - Add the SBC to the tenant

In this task, you will verify and add your SBC to your tenant.

1. You are still on MS721-CLIENT01 and signed in as “Admin”.

1. Open a new tab in Microsoft Edge and then browse to [**https://admin.teams.microsoft.com**](https://admin.teams.microsoft.com/).

1. Sign in as **MOD Administrator** with the credentials provided to you.

1. In the left navigation select **Voice**, select **Direct Routing** and select **Add**.

1. Add the FQDN **sbc01.lab&lt;customlabnumber&gt;.o365ready.com** and select **Save**. Please note, use lower case, it is case sensitive. 

1. Leave the browser open at the end of this task.

You have successfully verified your custom domain and added an SBC to the tenant.

### Task 2 - Retrieve your public certificate file

In the following task, you will download the DigiCert certificate you requested earlier in the lab so you can use it for your SBC. This step is required to upload the certificate in the compressed archive container in the next task.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin” 

1. Open Microsoft Edge and then browse to **Outlook on the web** [**https://outlook.office.com**](https://outlook.office.com/), where you should still be signed in as the **MOD Administrator**.

1. In the message list, locate and select the email from **DigiCert** with the zip file attachment. The message may arrive in the Focused or Other folder and should arrive within 2-5 minutes.

1. Download the **sbc01_lab&lt;customlabnumber&gt;.o365ready.comXXXXXXX.zip** file attachment, it will be saved to the default Downloads folder.

1. Close the browser window to end the task.

You have successfully downloaded the certificate you requested in an earlier exercise and it is now available to certify your SBC.

> [!WARNING]
> Download the file as is. Do not compress the already compressed zip file. Some web-based email systems allow you to compress or zip your download. This will cause the already compressed file to be compressed again and will cause the script in this lab to fail.

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

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”.

1. Open a new Microsoft Edge browser window and navigate to **https://portal.azure.com**.

1. Log in with the Azure Portal username and password provided to you by your lab provider.  **Do not** log in with your Microsoft 365 account.

1. Select **create a resource**.

1. Search for **Mediant VE Session Border Controller (SBC)**.

1. Select **Mediant VE Session Border Controller (SBC)**.

1. Select **Create.**

1. For **Resource group**, select **Create New**.

1. Fill **Name** with **SBC** then Select **OK**.

1. Fill out the following information and leave everything else as-is:

	- **Virtual machine name:** sbc01

	- **Username:** sbcadmin

	- **Password:** *Enter the MOD Administrator password in the _"Resource"_ section on the right side of the lab window.*

1. Select **Review + Create** (If you see a "Validation failed" message, you need to select **Previous** and select **Review + Create** again).

1. Select **Create** and wait for the deployment to complete.

### Task 5 - Retrieve SBC Public IP and configure DNS routing

In the following task you will retrieve the public IP address of the SBC and routing to the public DNS so Teams can locate the SBC.

1. Select **Go to resource group**.

1. Select **sbc01-ip**.

1. Make Note of the Public IP Address.

1. Select the start button, enter **Windows PowerShell** and select **Run as administrator** below PowerShell from the start menu.

1. When Windows PowerShell window has opened, enter the following cmdlet to a session with the DNS Server (**Note**: the machine name should be stay as MS720-RRAS01, despite the course being MS-721):

    ```powershell
    $Cimsession = New-CimSession -Name MS720-RRAS01 -ComputerName MS720-RRAS01 -Authentication Negotiate -Credential (Get-Credential)

    ```

1. When prompted to provide credentials fill out the following information and select **OK**:

	- **User name:** Administrator

	- **Password:** *Enter the default Admin password from the _“Resource”_ section on the right side of the lab window. _DO NOT_ enter the MOD Administrator's account password.*

1. Once the module is installed you will see the command prompt again.

1. Enter and modify the following cmdlet with your **Lab Number** and **Public SBC IP Address** to configure the DNS Record for the SBC (**Note**: the machine name should be stay as MS720-RRAS01, despite the course being MS-721):

    ```powershell
    Add-DnsServerResourceRecordA -ComputerName MS720-RRAS01 -CimSession $Cimsession -ZoneName lab<Lab Number>.o365ready.com -Name sbc01 -IPv4Address <Public SBC IP>
    ```

1. You can close the Windows PowerShell window by selecting the **X** in the top right.

You have successfully created an SBC hosted inside Microsoft Azure.

### Task 6 – Sign into the SBC

 In the following task, we will configure the Session Boarder Controller (SBC) to work with Microsoft Teams.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”.

1. Open a new Microsoft Edge browser window and navigate to [**https://&lt;SBCpublicIPAddress&gt;**](*) or [https://sbc01.lab&lt;Lab Number&gt;.o365ready.com](*)

> [!NOTE]
> You may see a connection message indicating your connection isn't private (NET::ERR_CERTIFICATE_TRANSPARENCY_REQUIRED or NET::ERR_CERT_COMMON_NAME_INVALID).  Select **Advanced** and then the link at the bottom to **Continue to &lt;SBCpublicIPAddress&gt;**.

1. Logon to the SBC using the following credentials you configured earlier:

	- **Username:** sbcadmin

	- **Password:** *Enter the MOD Administrator password in the _“Resource”_ section on the right side of the lab window.*

You have successfully logged onto the SBC.

### Task 7 - Upload root certificates to the SBC

In the following task, you will add the root certificate to the session border controller.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin” and on the SBC configuration website as **sbcadmin**.

1. On the top menu, select **IP NETWORK**.

1. In the left navigation, select **SECURITY &gt; TLS Contexts**.

1. Above the results pane, in the **TLS Contexts** table, select **New**.

1. Enter **Teams-TLSContext** as the Name.

1. Change the **TLS Version** option to **TLSv1.2** and leave everything else the same.

1. Select **APPLY**.

1. Scroll down, and below the **Teams-TLSContext** information, select **Trusted Root Certificates**.

1. In the Trusted Root Certificates window, select **Import**.

1. In the **Import New Certificate** dialog box, select **Choose File**.

1. Browse to **C:\LabFiles**, select **BaltimoreTrustedRootCA.cer**, and then select **Open**. If you cannot find the certificate, select **All files (\*.\*)** in the bottom right corner.

1. In the **File upload** dialog box, select **Close**.

1. Review the information for the selected root certificate that was installed.

1. Perform the steps above and load the following root certificates:

	- **DigicertTrustedRoot.cer**

	- **DigicertTrustedRootIntermediate.cer**

1. When complete, in the Trusted Root Certificates window, to the left of **TLS Context[#1]**, select the back arrow icon.

1. Leave the browser window open for the next task.

You have successfully uploaded the root certificate to your SBC and can now continue uploading the lab certificate in the chain.

### Task 8 - Upload the lab certificate to the SBC

In the following task, you will upload the lab certificate you requested earlier.  

1. In the TLS Contexts window, in the TLS Contexts table, select **Teams-TLSContext**.

1. Scroll down, and below the **Teams-TLSContext** information, select **Change Certificate**.

1. In the Change Certificates window, scroll down to the **UPLOAD CERTIFICATE FILES FROM YOUR COMPUTER** section.

1. In the **Private key pass-phrase (optional)** box, enter the default Admin password in the “Resource” section on the right side of the lab window.
 
1. Under **Send Private Key file from your computer to the device**, select **Load Private Key File**.  

1. In the Open window, browse to **C:\LabFiles**, select **Labcert.pfx**, and then select **Open**. If you cannot find the certificate, select **All files (*.*)** in the bottom right corner.  

1. To the right of the lab certificate file path, select **Load File**.  

    > [!IMPORTANT]
    > After uploading the lab certificate, go back to Task 7 and verify that all 3 trusted root certificates are present.  If not, add any missing certificates and scroll up, select **Save** from the top menu to save the SBC configuration.

1. Review the banner and verify that the certificate was loaded. 

1. Select **Apply**, then **Save** at the top of the page, then select **Yes**.
1. Leave the browser window open for the next task.

You have successfully uploaded the lab certificate and prepared your SBC to sign its communication.

## Exercise 3: Configure the session border controller

### Exercise Duration

  - **Estimated Time to complete**: 45 minutes

In this exercise, you will configure the session border controller, and install the services needed to ensure the custom domain and SBC work as expected.

### Task 1 – Configure SIP Interfaces on SBC

In the following task, you will configure the SIP interfaces that allow your SBC to identify where to send SIP information.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin” and on the SBC configuration website as **sbcadmin**.

1. On the top menu, select **Signaling &amp; Media.**

1. Select **Core Entities**, **SIP Interfaces**, and select **New**.

1. Fill out the following information:

	- **Name:** Teams 

	- **Network Interface:** #0 [eth0]

	- **UDP Port:** 0 

	- **TCP port:** 0 

	- **TLS Port:** 5067 

	- **Enable TCP Keepalive:** Enable 

	- **Classification Failure Response Type:** 0

	- **Media Realm:** #0 

	- **TLS Context Name:** Teams-TLSContext

	- **TLS Mutual Authentication:** Enable

1. Select **Apply**, then **Save**, then select **Yes**.

You have successfully configured SIP Interfaces on the SBC.

### Task 2 – Configure Proxy Sets on SBC

In the following task, you will configure the SBC Proxy Sets.

1. Select **Proxy Sets**, then select **New** and fill out the following information:

	- **Name:** Teams

	- **SBC IPv4 SIP Interface:** #1 Teams

	- **TLS Context name:** Teams-TLSContext

	- **Proxy Keep-alive:** Using OPTIONS

	- **Proxy Hot Swap:** Enable

	- **Proxy Load Balancing Method:** Random Weights

1. Select **Apply**, then **Save**, then select **Yes**.

You have successfully configured Proxy Sets on the SBC.

### Task 3 – Configure Proxy Addresses Interfaces on SBC

In the following task, you will configure the SBC Proxy Addresses Interfaces.

1. Scroll to the bottom of the page and select **Proxy Address 0 items**, select **New** and fill out the following information:

	- **Proxy address:** sip.pstnhub.microsoft.com:5061

	- **Transport type:** TLS

	- **Proxy Priority:** 1

	- **Proxy Random weight:** 1

1. Select **Apply**.

1. Add another Proxy Address by selecting **New** and fill out the following information:

	- **Proxy address:** sip2.pstnhub.microsoft.com:5061

	- **Transport type:** TLS

	- **Proxy Priority:** 2

	- **Proxy Random weight:** 1

1. Select **Apply**.

1. Add another Proxy Address by selecting **New** and fill out the following information:

	- **Proxy address:** sip3.pstnhub.microsoft.com:5061

	- **Transport type:** TLS

	- **Proxy Priority:** 3

	- **Proxy Random weight:** 1

1. Select **Apply**, then **Save**, then select **Yes**.

You have successfully configured Proxy Addresses on the SBC.

### Task 4 – Configure Coder Groups on SBC

In the following task, you will configure the Coder Groups on the SBC.

1. Navigate to **Coders &amp; Profiles &gt; Coder Groups**, and highlight "AudioCodersGroup_0" and select "Coders Table 1 items" below.

1. Add and configure the following **Coder Names:**

	- SILK-NB with a pay lode type of 103

	- Silk-WB with a pay lode type of 104

	- G.711A-law

	- G.711U-Law

	- G.729

1. Select **Apply**, then **Save**, then select **Yes**.

You have successfully configured Coder Groups on the SBC.

### Task 5 – Configure IP Profiles on the SBC

In the following task, you will configure the IP Profiles for the SBC.

1. To configure IP profiles under **Coders &amp; Profiles**, select **IP Profiles** and then select **New** and configure the following:

	- **Name:** Teams

	- **SBC Media Security Mode:** Secured

	- **Remote Early Media RTP Detection Mode:** By Media

	- **Extension Coders Group:** #0

	- **RTCP Mode:** Generate Always

	- **SIP UPDATE Support:** Not Supported

	- **Remote re-INVITE:** Supported only with SDP

	- **Remote Delayed Offer Support:** Not Supported

	- **Remote REFER Mode:** Handle Locally

	- **Remote 3xx Mode:** Handle Locally

	- **Remote Hold Format:** Inactive 

1. Select **Apply** and then **Save**. 

1. In the **Save Configuration** dialogue, select **Yes**.

You have successfully configured IP Profiles on the SBC.

### Task 6 – Configure IP Groups on SBC

In the following task, you will configure IP groups for the SBC.

1. To configure IP Groups under **Core Entities**, select **IP Groups**, then select **New** and configure the following:

	- **Name:** Teams

	- **Topology Location:** Up

	- **Proxy Set:** #1 [Teams]

	- **IP Profile:** #0 [Teams]

	- **Media Realm:** #0 [DefaultRealm]

	- **Classify By Proxy Set:** Disable

	- **Local Host Name:** the name given to the device during creation - **sbc01.lab&lt;customlabnumber&gt;.o365ready.com**

	- **Always Use Src Address:** Yes

	- **Proxy Keep-Alive using IP Group settings:** Enable

1. Select **Apply** and then **Save**.

1. In the **Save Configuration** dialogue, select **Yes**.

You have successfully configured IP Groups on the SBC.

### Task 7 – Configure SRTP on SBC

In the following task, you will configure the SBC to be ready for Teams.

1. To configure SRTP go to **Media**, then select **Media security**, select **Media Security** and set it to **Enable**.

1. Select **Apply** and then **Save**.

1. In the **Save Configuration** dialogue, select **Yes**.

You have successfully configured SRTP on the SBC.

### Task 8 – Configure Message Manipulation on SBC

In the following task, you will add the message manipulation on the SBC.

1. To create a Message Condition Rule go to **Message Manipulation**, then select **Message Conditions**

1. Select **New**, and configure the **Name** as **Teams**

1. To configure the condition, select **Editor** and fill out **Header.Contact.URL.Host contains 'pstnhub.microsoft.com'**, select **Save**.

1. select **Apply**, then select **Save**.

1. In the **Save Configuration** dialogue, select **Yes**.

1. Next, create a Classification Rule by navigating to **SBC &gt; Classification**, then select **New** and configure the following settings:

	- **Name:** Teams

	- **Source SIP Interface:** #1 [Teams]

	- **Source IP Address:** 52.114.\*.\* 

	- **Destination Host:** FQDN of SBC (**sbc01.lab&lt;customlabnumber&gt;.o365ready.com)**

	- **Message Condition:** Teams 

	- **Action type:** Allow

	- **Source IP Group:** #1 Teams

1. Select **Apply** and then **Save**.

1. In the **Save Configuration** dialogue, select **Yes**.

You have successfully configured message manipulation on the SBC.

### Task 9 – Configure IP to IP Calling rules on SBC

In the following task, you will configure 4 IP to IP calling rules on the SBC.

1. Go to **SBC**, **Routing**, **IP to IP Routing**, then select **New**

1. Create a rule with the following options: 

	- **Name:** Terminate OPTIONS

	- **Source IP Group:** Any

	- **Request type:** OPTIONS

	- **Destination type:** Dest Address

	- **Destination Address:** Internal

1. Select **Apply**.

1. Select **New** again and create another rule with the following options:

	- **Name:** REFER From Teams

	- **Source IP Group:** Any

	- **Call Trigger:** REFER

	- **ReRoute IP Group:** Teams

	- **Destination Type:** Request URI

	- **Destination IP Group:** Teams

1. Select **Apply**.

1. Select **New** again and create another rule with the following options:

	- **Name:** Teams -> SIP Trunk

	- **Source IP Group:** Teams

	- **Destination Type:** IP Group

1. Open the Dropdown menu **Destination IP Group** select **Add new** and fill out the following information:

	- **Name:** SIP Trunk

1. Select **Apply** twice.

1. Select **New** again and create another rule with the following options:

	- **Name:** SIP Trunk -> Teams

	- **Source IP Group:** SIP Trunk

	- **Destination Type:** IP Group

	- **Destination IP Group:** Teams 

1. Select **Apply** and then **Save**.

1. In the **Save Configuration** dialogue, select **Yes**.

You have successfully configured the AudioCodes SBC to receive requests from the Microsoft 365 Direct Routing service. 

### Task 10 - Verify the SBC Connections to Teams

In the following task, you will validate the SBC to be ready for Teams

On the SBC, select **Monitor** at the top and under **VOIP Status &gt; Proxy Set Status**, the output should be **Online** for the three entries for psthub.Microsoft.com. 

If the output shows the correct value for all three entries your SBC is configured correctly and you will be able to continue with the next exercise.

## Exercise 4: Configure Teams for Direct Routing

### Exercise Duration

  - **Estimated Time to complete**:  120 minutes

In this exercise, you will create a direct route routing policy, PSTN Usage policy, and voice route to enable Megan Bowen to perform voice calls over the SBC. Megan resides in a location where the telephone number assigned to her has a long-standing contract and requires her to continue to use the telephone service provider's telephone number rather than moving to a calling plan from Microsoft. Long term the plan is to move the telephone number over to a calling plan, however, currently, this is cost prohibitive. 

### Task 1 - Create a voice routing policy with one PSTN usage

In the following task, you will create your first voice routing policy and PSTN usage so you can later assign this policy to your users.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”.

1. Select the Windows symbol in the task bar, type **PowerShell** and open a regular PowerShell window.

2. In Windows PowerShell, enter the following cmdlet to connect to Teams in your tenant:

    ```powershell
    Connect-MicrosoftTeams

    ```

1. In the prompt sign in as **Allan Deyoung** with the credentials provided to you.

1. In Windows Powershell, enter the following and then press **Enter**. By running the command you will see that the existing PSTN usages in place. You can see what is in place and what usage plans are being assigned to the identity. 

    ```powershell
    Get-CsOnlinePstnUsage

    ```

1. Review the output of the command.

If you have several usages defined, the names of the usages might truncate. Use the command, (Get-CSOnlinePSTNUsage).Usage, to display a list of the defined PSTN usages. An online PSTN usage links an online voice policy to a route. The output will show if there is an identity that can be used or possibly reused, or also excluded from being used. For example, there may be a PSTN usage called Seattle, that can cover all of the Pacific North West of the United States. The overall goal is to keep your PSTN Usage rules to a minimum and keep them simple as it will reduce the overall administration effort later. We want to validate that the information we have in the tenant is relevant and also ensure we do not duplicate any existing PSTN usages. 

1. Run the Set-CSOnlinePSTNUsage cmdlet is used to add or remove phone usages to or from the usage list. This list is global so it can be used by policies and routes throughout the tenant:

    ```powershell
    Set-CsOnlinePstnUsage -Identity Global -Usage @{Add="US and Canada"}

    ```

1. Run the New-CSOnlineVoiceRoutingPolicy to create a new online voice routing policy. Online voice routing policies are used in Microsoft Phone System Direct Routing scenarios. Assigning your Teams users an online voice routing policy enables those users to receive and to place phone calls to the public switched telephone network by using your on-premises SIP trunks:

    ```powershell
    New-CsOnlineVoiceRoutingPolicy "North America" -OnlinePstnUsages "US and Canada"

    ```

1. Run the New-CsOnlineVoiceRoute command - Creates a new online voice route. Online voice routes contain instructions that tell Microsoft Teams how to route calls from Office 365 users to phone numbers on the public switched telephone network (PSTN) or a private branch exchange (PBX):

    ```powershell
    New-CsOnlineVoiceRoute -Identity "10 Digit Dialing" -NumberPattern "^\+1(\d{10})$" -OnlinePstnGatewayList sbc01.lab<customlabnumber>.o365ready.com -OnlinePstnUsages "US and Canada"

    ```

1. Run the Get-CSOnlineVoiceRoute command, this command returns information about the online voice routes configured for use in your tenant. Online voice routes contain instructions that tell Microsoft Teams how to route calls from Office 365 users to phone numbers on the public switched telephone network (PSTN) or a private branch exchange (PBX):

    ```powershell
    Get-CsOnlineVoiceRoute

    ```

1. Review the output of the command and verify that your new voice route has been added.

1. Leave the PowerShell window open for the next task.

You have successfully created a voice routing policy with a PSTN Usage.

### Task 2 - Create a new voice routing policy named North America and assign it to Megan Bowen

In the following task, you will create another voice routing policy with the PSTN usage you created in an earlier task and assign this policy to your users.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin”, and you have an open **Teams PowerShell** session signed in as **Allan Deyoung**.

1. Run the Grant-CsOnlineVoiceRoutingPolicy, the command assigns a per-user online voice routing policy to one or more users. Online voice routing policies manage online PSTN usages for Phone System users:

    ```powershell
    Grant-CsOnlineVoiceRoutingPolicy -Identity MeganB@lab<customlabnumber>.o365ready.com -PolicyName "North America"

    ```

If you receive an error stating that the **Policy "North America" is not a user policy. You can assign only a user policy to a specific user**., wait 2-3 minutes and then retry the command. You may need to retry the command several times before it is successful and it may take up to 15 minutes before it becomes available. If the policy is still not updated in the service, you continue to the next lab and return later.

1. Run the Get-CsOnlineUser command, the command returns information about users who have accounts homed on Microsoft Teams:

    ```powershell
    Get-CsOnlineUser MeganB | select OnlineVoiceRoutingPolicy

    ```

1. Review the output of the command. If the policy is empty, try the command again.

1. Leave the PowerShell window open for the next task.

You have successfully used PowerShell to assign your voice routing policy to your users.

### Task 3 - Enable users for Direct Routing, voice, and voicemail

In the following task, you will enable the end user for voice services through the direct route, assign the telephone number, and enable the user for dial pad service.

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin” and you have an open **Teams PowerShell** session signed in as **Allan Deyoung**.

1. Run the Set-CsPhoneNumberAssignment command, the command assigns a phone number to a user or resource account. When you assign a phone number the EnterpriseVoiceEnabled flag is automatically set to True.:

    ```powershell
    Set-CsPhoneNumberAssignment -Identity MeganB@lab<customlabnumer>.o365ready.com -PhoneNumber "+14255551234" -PhoneNumberType DirectRouting

    ```

1. The cmdlet does not provide any output. When you are back on the command prompt, leave the window open for the next task.

You have successfully assigned a telephone number to the end user and you have enabled the end user for the dial pad.

### Task 4 - Configure voice routing

In the following task, you will assign a voice route to a user, this will grant the user the ability to make calls to the policy applied. 

1. You are still on MS721-CLIENT01 where you are still signed in as “Admin” and you have an open **Teams PowerShell** session signed in as **Allan Deyoung**.

1. In Windows PowerShell, enter the following and then press **Enter**, this will assign the policy to the identified user, in this instance the identity is **Megan Bowan**, we will be assigning her the **North American** Policy. 

    ```powershell
    Grant-CsOnlineVoiceRoutingPolicy -Identity MeganB@lab<customlabnumer>.o365ready.com -PolicyName "North America"

    ```

1. The cmdlet does not provide any output. Close the PowerShell window to end this task.

You have successfully assigned a telephone number to the end user and you have enabled the end user for the dial pad.

### Task 5 - Translate numbers to an alternate format

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

### Task 6 - Configure Emergency Location Identification Number (ELIN)

In the following task, you will assign the Emergency Location Identification number to a location existing in Microsoft Teams Admin center already. 

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. In the left navigation pane select the three dashes, select **Locations** and select **Emergency addresses.**

1. Select **Bellevue Office Address** and then select **Edit**.

1. Review the settings for **ELIN**. It should be **425-555-1200**. The number was set in an earlier task, and once the location has been validated, it's properties cannot be changed. This includes the ELIN number. 

1. Select **Save**.

1. Leave the browser window open.

You have successfully assigned the ELIN number to the location for emergency addresses.

### Task 7 - Deploy Location-Based Routing based on subnets

In the following task, you will configure location-based routing to allow connectivity to the local SBC to the end user depending upon the subnet IP address allocated. 

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. Select the three dashes, select **Locations**, then **Network topology.**

1. Select **Add**, give the Network Site a name of **Washington** and description as **Washington Network.** Select **Location based routing** to **On.**

1. Select **Add subnets,** for **IP address** enter **192.168.0.0** and a **Network Range** of **32,** select **Apply,** select **Save**

1. Within the Teams Admin Center select **Voice**, then **Direct Routing.**

1. Select **sbc01**, select **settings** and **edit SBC**

1. Under **Location based routing and media optimization**, turn **on Location based routing**, select **Gateway site ID** to **Washington**, then select **Save**.

1. Leave the browser window open.

You have successfully implemented the Location based routing which will route your calls dependent upon the machine's local subnet to which it is registered. 

---
lab:
  title: 'Lab 05: Manage Microsoft Teams Devices'
  type: Answer Key
  module: 'Learning Path 02: Manage Teams collaboration communications systems'
  description: In this lab, you will configure, deploy, and manage Microsoft Teams devices, including shared devices, Teams Rooms, and Surface Hub. The scenario covers account setup, licensing, device policies, and remote management for Teams-enabled hardware.
  duration: 120 minutes
  level: 400
  islab: true
  primarytopics:
    - Microsoft Teams
---

> **Abstract:**  
> In this lab, you will configure, deploy, and manage Microsoft Teams devices, including shared devices, Teams Rooms, and Surface Hub. The scenario covers account setup, licensing, device policies, and remote management for Teams-enabled hardware.

# Lab 05: Manage Microsoft Teams Devices
# Student lab answer key

## Lab Scenario

As part of the expanding business, the organization has began deploying various types of Microsoft Teams devices in their organization. You need to manage the deployment of these devices.

## Lab Duration

  - **Estimated Time to complete**: 120 minutes

## Instructions

> [!IMPORTANT]
> This lab runs independently of Lab 3. Replace &lt;LAB Domain&gt; in PowerShell commands with the domain shown for your accounts in **Microsoft 365 admin center > Users > Active users**. Replace &lt;TENANT NAME&gt; with your Microsoft 365 tenant name (for example, M365x01234567). The optional Direct Routing task requires a Lab 3 SBC and voice routing policy in the **same tenant**.

## Exercise 1: Configuring Teams Shared Device and Room Resource Accounts

### Exercise Duration

  - **Estimated Time to complete**: 30 minutes

In this exercise, you configure accounts for a shared phone and a Teams Room. Account creation, room booking, and policy configuration don't require a PSTN number or an SBC. Direct Routing number assignments are an optional extension if Lab 3 has been completed in this same tenant.

### Task 1 - Create a resource account for Teams Shared Devices (Common Area Phones)

In this task, you will sign into the Microsoft 365 admin center and will create a user account for use with a Microsoft Teams Shared Device.

1. Connect to **MS721-CLIENT01** and sign in as **Admin**. 

1. In **Microsoft Edge**, browse to the Microsoft 365 admin center at [**https://admin.microsoft.com**](https://admin.microsoft.com/).

1. On the **Sign in** screen, enter the credentials of the Global Admin account of the **MOD Administrator** with the username and password provided to you.

1. When a **Save password** dialog is displayed, select **Never**.

1. When a **Stay signed in?** dialog is displayed, select **No**.

    > NOTE: You may get a prompt to **Let's keep your account secure**. Click **Next** on this prompt and setup 2-Factor Authentication with the Microsoft Authenticator app. 

1. In the left navigation, select **Users**, select **Active Users**, and then **Add a user**

1. Use the following parameters for this task and then click **Next**:

	- **Display Name:** CAP_Reception

	- **Username:** CAP_Reception

	- **Automatically create a password:** Uncheck this box and enter the "User Password" for your Microsoft 365 user accounts.

	- **Require this user to change their password when they first sign in:** Uncheck this box

    ![A screenshot showing the basics of user setup.](Linked_Image_Files/M05_L05_E01_T01_01.png)

1. On the licensing page, assign a **Microsoft Teams Shared Devices** license to the shared phone account if your tenant has one, and then select **Next**.

    > [!NOTE]
    > If this license isn't available in your lab tenant, create the account without it and continue with the account and policy exercises. Don't substitute a Teams Rooms Pro license for a shared phone. Signing a physical shared phone into this account requires the appropriate shared-device license and a supported device; neither is validated without them. A PSTN number is optional for the account and is not needed for the later policy exercise.

1. Continue clicking **Next** until you get the username and password presented to you. Write these down for future use. Keep the browser open for the next task.

You have created an account that will be used on a common area phone.

### Task 2 - Create a Microsoft 365 Resource Account for Teams Rooms

In this task, you will sign into the Microsoft 365 admin center and will create a rooom resource account for use with a Microsoft Teams Room.

1. You are still signed in to MS721-CLIENT01 as “Admin” and in the **Microsoft 365 admin center** as **MOD Administrator**

1. In the left navigation, select **Resources**, select **Rooms & equipment**, and then **Add resource**.

1. Use the following parameters for this task and then click **Save**:

	- **Resource type:** Room

	- **Name:** CONF_Room1

	- **Email:** CONF_Room1

	- **Capacity:** 10

    - **Location:** Bellevue, WA

    ![A screenshot showing resource account setup page.](Linked_Image_Files/M05_L05_E01_T02_01.png)

1. In the left navigation, select **Users**, select **Active Users**, and then select the **CONF_Room1** account. 

1. Select **Licenses and Apps** on the user card, assign a **Microsoft Teams Rooms Pro** license to the room account, and then select **Save changes**. A Calling Plan license or Direct Routing number is not required to book the room or sign in to Teams Rooms for meetings.

1. While still in the user card, select **Reset Password** and set the password to the **User password** for your Microsoft 365 account, then close the user card.

    > [!IMPORTANT]
    > The Teams Rooms resource account must sign in without an interactive multifactor authentication (MFA) prompt. If an MFA challenge or a Conditional Access block affects **CONF_Room1**, ask your identity administrator to review the policy for this device. Do not disable MFA for the entire tenant to complete the lab.

1. In the **Microsoft 365 Admin Center** under **Active Users** you should see two accounts matching the following:

    ![A screenshot showing the two created user accounts.](Linked_Image_Files/M05_L05_E01_T02_02.png)

The room account is licensed and ready for configuration. The shared-phone account is licensed only if your tenant has the Microsoft Teams Shared Devices license.

### Task 3 - Disable password expiration on the accounts

In this task, you will sign into the Microsoft Graph PowerShell Module and disable Password Expiration on the accounts. Based on organization policies, resource account passwords may be set to expire automatically after a period of time. If the resource account password expires, the Teams Rooms device with sign out and can't sign in again without manual intervention.

1. You are still signed in to MS721-CLIENT01 as **Admin** with the password provided to you.

1. Open **Windows PowerShell as Administrator**. In the **User Account Control** dialog box, select **Yes**.

1. Make sure you have the latest Microsoft Graph PowerShell module installed with the following cmdlet. If you receive an **Untrusted repository** prompt, select **[A] Yes to all**.

    > NOTE: This command can take several minutes to complete, wait for the prompt in PowerShell to return or not all the Graph sub-modules will install.

    ```powershell
    Install-Module Microsoft.Graph -Force -AllowClobber

    ```

1. Connect to Microsoft Graph with User.ReadWrite.All permissions:

    ```powershell
    Connect-MgGraph -Scopes "User.ReadWrite.All"

	```

1. When prompted, enter the **Microsoft 365 Administrator** email address and password.

1. After entering your credentials, you will be asked to provide authorization to Microsoft Graph to access your tenant's data. Check the box for **Consent on behalf of your organization** and then click **Accept**.

    ![A screenshot asking to provide consent for Microsoft Graph.](Linked_Image_Files/M03_E03_T01_01.png)

1. Set the password to never expire for each resource account. NOTE: Please replace <Lab Domain> in each of the below commands with that of your lab environment.

    ```powershell
    Update-MgUser -UserId CAP_Reception@<LAB Domain>.onmicrosoft.com -PasswordPolicies DisablePasswordExpiration
    Update-MgUser -UserId CONF_Room1@<LAB Domain>.onmicrosoft.com -PasswordPolicies DisablePasswordExpiration

	```
The accounts anow have password expiration disabled and are ready to have additional configurations applied.

### Task 4 - Optional: assign Direct Routing numbers to the accounts

Skip this task in a standalone Lab 5 tenant and continue with Exercise 2. The shared-phone and room policies, room booking, and Teams Rooms meetings don't require a PSTN number. If you completed Lab 3 in **this same tenant**, registered its SBC, and configured the `NA-National` voice routing policy, you can use the following commands to practice Direct Routing number assignment. These assignments alone do not verify PSTN calling.

1. You are still signed in to MS721-CLIENT01 as **Admin** with the password provided to you.

1. Open Windows PowerShell and connect to Microsoft Teams. When prompted for credentials, sign in as **Allan Deyoung**:

    ```powershell
    Connect-MicrosoftTeams
    ```

1. Grant the `NA-National` voice routing policy from this tenant to both accounts. Replace `<LAB Domain>` with the domain of the actual account usernames in **Active users**:

    ```powershell
    Grant-CsOnlineVoiceRoutingPolicy -Identity CAP_Reception@<LAB Domain>.onmicrosoft.com -PolicyName "NA-National"
    Grant-CsOnlineVoiceRoutingPolicy -Identity CONF_Room1@<LAB Domain>.onmicrosoft.com -PolicyName "NA-National"
    ```

1. Assign a Direct Routing phone number to each resource account:

    ```powershell
    Set-CsPhoneNumberAssignment -Identity CAP_Reception@<LAB Domain>.onmicrosoft.com -PhoneNumber "+14255551201" -PhoneNumberType DirectRouting
    Set-CsPhoneNumberAssignment -Identity CONF_Room1@<LAB Domain>.onmicrosoft.com -PhoneNumber "+14255551202" -PhoneNumberType DirectRouting
    ```

1. Confirm the assignments by running:

    ```powershell
    Get-CsOnlineUser CAP_Reception | Select DisplayName, LineUri, OnlineVoiceRoutingPolicy
    Get-CsOnlineUser CONF_Room1 | Select DisplayName, LineUri, OnlineVoiceRoutingPolicy
    ```

1. Leave the PowerShell window open at the end of the task.

If you performed the optional task, verify the assignments shown by the readback commands. Otherwise, continue with the licensed room account and the shared-phone policy exercise without PSTN connectivity.

## Exercise 2: Deploy Microsoft Teams Common Area Phones

In this exercise, you will create policies for Common Area Phones, apply the policy to the previously created user, and enable the phone for Teams Voice.

### Exercise Duration

  - **Estimated Time to complete**: 30 minutes

### Task 1 - Configure Microsoft Teams IP Phone Policies

In this task, you will connect to Microsoft Teams PowerShell and create an IP Phone Policy for Common Area Phones. This policy removes the default user experience and locks the phone down so that it cannot be easily signed out of, and restricts the device to make and recieve calls. Access to other apps on the phone is prohibited.

1. You are still on **MS721-CLIENT01** where you are still signed in as “Admin”.

1. Select the Windows symbol in the task bar, type **PowerShell** and open a regular PowerShell window.

1. In Windows PowerShell, enter the following cmdlet to connect to Teams in your tenant:

    ```powershell
    Connect-MicrosoftTeams

    ```

    > NOTE: If you get an error stating that the MicrosoftTeams PowerShell module is not installed, run **Install-Module MicrosoftTeams** as an administrator.

1. In the PowerShell prompt, sign in as **MOD Administrator** with the credentials provided to you.

1. In Windows Powershell, enter the following and then press **Enter**. By running the command you will see that the tenant has a default policy that is assigned to all users by default. When a user signs into a phone, they will get the **UserSignIn** experience which is fully featured.

    ```powershell
    Get-CsTeamsIPPhonePolicy

    ```
    
    ![A screenshot showing the Global IP Phone policy.](Linked_Image_Files/M05_L05_E02_T01_01.png)

1. Run the New-TeamsIPPhonePolicy cmdlet. This command creates a per-user online IP Phone Policy that will lock down the phone to the CommonAreaSignIn experience. It also disables the home screen and the better together functionality with the Teams client.

    ```powershell
   New-CsTeamsIPPhonePolicy -Identity CAP -SignInMode CommonAreaPhoneSignIn -AllowHomeScreen Disabled -AllowBetterTogether Disabled

    ```

1. Run the Get-CsTeamsIPPhonePolicy command. The command will show the Global and the newly created policy

    ```powershell
    Get-CsTeamsIPPhonePolicy

    ```

1. Review the output of the command. You will see the Global and the CAP policy created previously.

    ![A screenshot showing the two created IP Phone.](Linked_Image_Files/M05_L05_E02_T01_02.png)

1. Leave the PowerShell window open for the next task.

### Task 2 - Assign Teams IP Phone Policies to users

In this task, you will connect to Microsoft Teams PowerShell and assign the previously created policy to a user. This policy can only be assigned, managed, and created in PowerShell.

1. You have an active PowerShell window on **MS721-CLIENT01** where you are still signed in as “Admin”.

1. Run the `Grant-CsTeamsIPPhonePolicy` command. The command will apply the policy to the user created previously. Make sure you replate &lt;LAB DOMAIN&gt; with the UPN associated to the user in the lab.

    ```powershell
    Grant-CsTeamsIPPhonePolicy -PolicyName CAP -Identity CAP_Reception@<LAB Domain>.onmicrosoft.com

    ```

1. The cmdlet does not provide any output. When you are back on the command prompt, leave the window open for the next exercise.

You have successfully provisioned an account for use with a Common Area Phone in Microsoft Teams.

## Exercise 3: Deploy Microsoft Teams Rooms on Windows & Surface Hub 3

### Exercise Duration

  - **Estimated Time to complete**: 120 minutes

In this exercise, you will deploy finish configuration of a room resource account for Microsoft Teams Rooms on Windows and Surface Hub 3. You will then test the account and sign into a virtual Surface Hub 3 virtual machine and then manage the room from the Teams Rooms Pro Portal.

### Task 1 - Configure the Room Resource Account's Calendar Processing Settings

In this task, you will sign into Microsoft Exchange PowerShell and configure the mailbox for the room resource account as a Room and Modify Calendar Processing.

1. You are still on **MS721-CLIENT01** where you are still signed in as “Admin”.

1. Select the Windows symbol in the task bar, type **PowerShell** and open a Administrator-elevated PowerShell window.

1. In Windows PowerShell, check whether the Exchange Online Management module is already installed:

    ```powershell
    Get-Module -ListAvailable ExchangeOnlineManagement
    ```

    If the command returns no installed module, run `Install-Module ExchangeOnlineManagement`. If a version is already installed, use it for the next step. You don't need to uninstall an existing version.

1. In Windows PowerShell, enter the following cmdlet to connect to Exchange Online Management:

    ```powershell
    Connect-ExchangeOnline

    ```

1. In the PowerShell prompt, sign in as **MOD Administrator** with the credentials provided to you.

1. In Windows Powershell, enter the following and then press **Enter**. By running the command, the room resource account will automatically process or deny meeting invites when the room is invited to a meeting based on the room calendar.

    ```powershell
    Set-CalendarProcessing -Identity "CONF_Room1" -AutomateProcessing AutoAccept -AddOrganizerToSubject $false -AllowRecurringMeetings $true -DeleteAttachments $true -DeleteComments $false -DeleteSubject $false -ProcessExternalMeetingMessages $true -RemovePrivateProperty $false -AddAdditionalResponse $true -AdditionalResponse "This is a Microsoft Teams Meeting room!"

    ```

    > [!TIP]
    > To verify booking, send a near-term internal test invitation from a licensed organizer to **CONF_Room1** as the room. Check the organizer's inbox for the room's automatic acceptance response. When the room device is signed in, check its home screen near the booking time to confirm the event appears. The response verifies mailbox processing; the home-screen listing verifies calendar sync. A non-Teams event does not test meeting join.

You have successfully setup calendar processing on a Teams Rooms Account.

### Task 2 - Setup Surface Hub 3

In this task, you will sign into the a virtual Surface Hub 3 running Teams Rooms on Windows and will validate that the account was setup properly.

1.  Connect to **MS721-SH3** under the **Resources** in the lab. You will see a **Welcome to Microsoft Teams! A happier place for teams to work together** message. Click **Get Started.**

    ![A screenshot showing the Teams Rooms welcome screen.](Linked_Image_Files/M05_L05_E03_T02_01.png)

    > [!NOTE]
    > If the device can't reach the internet, confirm that **MS721-RRAS01** is running and that **MS721-CLIENT01** can reach Microsoft Teams. Restart the Surface Hub only after network access is restored. If the device reports **Unable to sign in**, check the saved **CONF_Room1** address and the room account's **User password** in the Teams Rooms **Settings > Account** page. Do not substitute the MOD Administrator password. A successful sign-in to Teams on the web does not verify device sign-in.

    > [!NOTE]
    > To investigate a persistent sign-in failure, open Event Viewer on **MS721-SH3** as the local Administrator and review **Applications and Services Logs > Microsoft > Windows > AAD > Operational**, Event ID **1098**. **AADSTS50126** reports invalid credentials for the device sign-in. **AADSTS50076** or **AADSTS50079** indicates an MFA requirement, and **AADSTS53003** indicates a Conditional Access block. Ask your identity administrator to investigate policy failures rather than changing tenant-wide MFA. See [Fix Teams Rooms resource account sign-in issues](https://learn.microsoft.com/troubleshoot/microsoftteams/teams-rooms-and-devices/teams-rooms-resource-account-sign-in-issues).

1. On the next page click **Accept** to the **End User Agreement** and then click **Manual Setup**. Enter the following credentials:

	- **Email:** CONF_Room1@<Lab Domain>.onmicrosoft.com *Replace <Lab Domain> with your labs domain.*

	- **Password:** Type the room account's **User password** from the **Resources** section of the lab window directly into the password field on **MS721-SH3**. The **Type Text User Password** control can omit characters when forwarding text to this device. If you use it, verify every character before saving. If you can't verify the masked password, clear the field and type it manually.

1. Wait for the Teams Rooms home screen shown below. If the device still displays **Unable to sign in**, do not treat it as configured or continue to Task 3.

    ![A screenshot showing the Teams Rooms home screen.](Linked_Image_Files/M05_L05_E03_T02_02.png)

    > [!TIP]
    > If the device reports **AADSTS50126** after you use **Type Text User Password**, open **Settings > Account** on **MS721-SH3**. Clear the saved password, type the room account's **User password** manually, and select **Save and exit**. Confirm that the home screen appears before you continue.

After the home screen appears, the room account is signed in to the virtual Surface Hub 3.

### Task 3 - Manage Surface Hub 3 & Teams Rooms on Windows with the Pro Management Portal

In this task, you sign in to the Teams Rooms Pro Management Portal and manage the Surface Hub 3. Teams Rooms on Windows devices normally install the Pro agent during setup and appear in the portal after Teams sign-in. Allow up to an hour for the room to appear.

1. Connect to **MS721-CLIENT01** and sign in as **Admin**. 

1. In **Microsoft Edge**, browse to the Pro Management Portal at [**https://portal.rooms.microsoft.com**](https://portal.rooms.microsoft.com/).

1. On the **Sign in** screen, enter the credentials of the Global Admin account of the **MOD Administrator** with the username and password provided to you.

1. Once signed in, navigate to **Rooms** and select the room signed in as **CONF_Room1** when it appears. If the room card shows **Onboarding** and offers **Enroll**, select **Enroll**. Otherwise, continue to the room settings.

    ![A screenshot showing the room card in the Pro Management Portal.](Linked_Image_Files/M05_L05_E03_T03_01.png)

    > [!NOTE]
    > If the room does not appear after an hour, pause this task. On **MS721-SH3**, open an elevated PowerShell window and run `Get-Tpm`. Teams Rooms Pro Management requires a Trusted Platform Module (TPM) to identify and enroll the device. If `TpmPresent` or `TpmReady` is `False`, ask your lab provider whether the virtual machine can be provisioned with a TPM. You can't complete portal enrollment or the theme change on that machine until the TPM prerequisite is met. If the TPM is ready, check Teams sign-in, the **Microsoft Managed Rooms** agent, its **ManagedRoomsLauncher** and **ManagedRoomsUpdater** tasks, and the [required network endpoints](/microsoftteams/rooms/enroll-a-device#urls-required-for-communication). See [Troubleshoot an unmonitored Teams Rooms device](/microsoftteams/devices/pmpsignal-unmonitored-offline). An empty room list does not establish a problem with the room account password.

1. Under the room card, select **Settings**, then **Theming**, and then change the theme to something else and then click **Apply.**

1. A **Select Schedule** window will appear. On this window, click **Apply Now** and then click **Submit.**

    ![A screenshot showing the Schedule for a room in the Pro Management Portal.](Linked_Image_Files/M05_L05_E03_T03_02.png)

1. Within 5-10 minutes the room will show the theme change that was requested.

    ![A screenshot showing the Schedule for a room in the Pro Management Portal.](Linked_Image_Files/M05_L05_E03_T03_03.png)

You have successfully setup a Microsoft Teams Room and configured settings in the room with the Pro Management Portal.
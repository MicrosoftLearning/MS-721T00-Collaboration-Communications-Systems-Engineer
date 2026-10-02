---
lab:
  title: 'Lab 04: Manage your Teams Voice Environment'
  type: Answer Key
  module: 'Learning Path 02: Manage Teams collaboration communications systems'
  description: This lab guides you through managing and troubleshooting Teams Phone users, configuring call queues and auto attendants, provisioning Teams devices, and monitoring call quality. The scenario addresses real-world support and operational tasks in a Teams Phone deployment.
  duration: 180 minutes
  level: 400
  islab: true
---

> **Abstract:**  
> This lab guides you through managing and troubleshooting Teams Phone users, configuring call queues and auto attendants, provisioning Teams devices, and monitoring call quality. The scenario addresses real-world support and operational tasks in a Teams Phone deployment.

# Lab 04: Manage your Teams Phone environment
# Student lab answer key

## Lab Scenario

Contoso needs to make changes to existing users who are enabled for Teams Voice and add Teams Devices. Whilst making changes, support tickets have been raised due to problems users have reported with connectivity and troubleshooting must be performed.

## Lab Duration

  - **Estimated Time to complete**: 180 minutes

## Instructions

> [!IMPORTANT]
> This lab continues in the Lab 1 and Lab 2 lab launch, in the same Microsoft 365 tenant that Lab 3 uses. You don't need Lab 3 or the SBC except for the optional Direct Routing steps.
>
> - **Tenant domain:** Replace &lt;TENANT NAME&gt; with your tenant's name (for example, WWLx012345 in WWLx012345.onmicrosoft.com).
> - **Lab domain:** The optional Direct Routing steps use lab&lt;LAB NUMBER&gt;.o365ready.com from Lab 3.
> - **Usernames:** If you completed Lab 3, Nestor Wilke and Isaiah Langer use the lab domain. Check usernames in **Microsoft 365 admin center > Users > Active users**.

## Exercise 1: Manage voice users

### Exercise Duration

  - **Estimated Time to complete**: 30 minutes

In this exercise, you will perform day-to-day management tasks for Teams Phone users.

### Task 1 - Change user call pickup settings

In this task, you will sign into the Microsoft Teams admin center and make changes so that Isaiah’s colleague Allan can pick up their calls.

1. On **MS721-CLIENT01**, sign in to Windows as **Admin**. Open Microsoft Edge, browse to the **Microsoft Teams admin center** at https://admin.teams.microsoft.com, and sign in as **Allan Deyoung**.

1. In the left navigation menu select **Users** and **Manage users** and find **Isaiah Langer** and select the name to open the user’s properties.

1. On the user’s properties page, select the **Voice** tab.

1. Under the **Call answering rules** section, also allow **Group call pickup**.

1. Select **Manage call group**, then select **Add people**.

1. Search for **Allan Deyoung** and select **Add** to include them in the **People list**, then select **Apply**.

1. Allan prefers an on-screen notification instead of a ring. In the Group call pickup list, find **Allan Deyoung**.

1. In the **Notification** column, update the value from **Ring** to **Banner** from the drop-down menu. Then select **Save**.

1. In the left navigation menu select **Manage users** to exit the properties page for Isaiah Langer.

Allan now sees a banner when Isaiah receives a call and can answer it.

### Task 2 - Check Teams Phone users (optional Direct Routing extension)

In this task, you check that Nestor Wilke and Isaiah Langer are licensed for Teams Phone. The Direct Routing steps are optional. Run them **only if** you completed Lab 3.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. In Microsoft Edge, open a new tab and browse to the **Microsoft 365 admin center** at https://admin.microsoft.com. Select **Users > Active users**. Check the licenses and usernames for **Nestor Wilke** and **Isaiah Langer**. Both have Microsoft 365 E5, which includes Teams Phone, and you enabled Enterprise Voice for them in Lab 1.

1. If you didn't complete Lab 3, **skip the remaining steps in this task** and continue with Task 3.

1. Select Start, type PowerShell and open a non-Administrative **Windows PowerShell** window.
 
1. Run the following commands to import the module and connect to Microsoft Teams:

    ```powershell
    Import-Module MicrosoftTeams  
    Connect-MicrosoftTeams
    ```

1. When prompted for credentials, enter the credentials of **Allan Deyoung**.

1. Assign the policy to Nestor using the username you verified. Replace the sample identity if the actual username differs:

    ```powershell
    Grant-CsOnlineVoiceRoutingPolicy -Identity NestorW@lab<LAB NUMBER>.o365ready.com -PolicyName "NA-National"

    ```

1. Type the following command to enable Nestor Wilke for Direct Routing:

    ```powershell
    Set-CsPhoneNumberAssignment -Identity NestorW@lab<LAB NUMBER>.o365ready.com -PhoneNumber "+14255551122" -PhoneNumberType DirectRouting
    ```

1. Assign the same policy and a Direct Routing number to **Isaiah Langer**. Replace both sample identities with Isaiah's actual username if it differs:

    ```powershell
    Grant-CsOnlineVoiceRoutingPolicy -Identity IsaiahL@lab<LAB NUMBER>.o365ready.com -PolicyName "NA-National"
    Set-CsPhoneNumberAssignment -Identity IsaiahL@lab<LAB NUMBER>.o365ready.com -PhoneNumber "+14255551133" -PhoneNumberType DirectRouting
    ```

1. Close the PowerShell Window at the end of the task.

If you completed the optional commands, Nestor and Isaiah have Direct Routing assignments. Otherwise, continue with the independent Teams user-management tasks.

### Task 3 - Configure call delegation

In this task, you will configure Nestor Wilke so that Allan Deyoung is a delegate of Nestor Wilke and is allowed to make and receive calls on their behalf.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. Select **Users** and **Manage users**.

1. Find **Nestor Wilke** and select the name to open the user’s properties.

1. On the user’s properties page, select the **Voice** tab.

1. Under the **Call answering rules** section, also allow **Call delegation**.

1. Scroll down to **Call delegation** and select **Add people**

1. Search for **Allan Deyoung**, and select **Add** to include them on the **People list**, then select **Apply**.

1. In the list below **Call delegation**, find **Allan Deyoung** and leave the **Permission** value as **Make and Receive calls**. Switch the **Allow changing call settings** radio button to **Off**.

1. Select **Save**.

1. Leave the browser window open.

The changes are now active.

### Task 4 - Enable audio conferencing

In this task, you validate audio conferencing is enabled for Isaiah Langer and change the default settings.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. Select **Meetings** and **Audio Conferencing**.

1. Select **Add** from **Audio Conferencing policies**.

1. Enter **No toll-free numbers** for **Name** and **No toll-free numbers in meetings** for **Description**

1. Turn off **Include toll-free numbers in meetings created by users of this policy** and **Save**.

1. Select the row with **No toll-free numbers** policy that was just created and select **Assign users**.

1. In the **Manage users** pane, search for **Isaiah**, select **Isaiah Langer**, select **Add** next to the search result, and then select **Apply** and **Confirm**. Wait for the confirmation that the policy was assigned to one user.

1. Select **Users** and **Manage users**.

1. Find **Isaiah Langer** and select the name to open the user’s properties.

1. On the user's properties page, select the **Account** tab. Confirm that **Audio Conferencing** displays **On**, and then select **Edit**.

    The **Audio Conferencing** pane shows the toll number. The assigned Audio Conferencing policy controls whether toll-free numbers appear in meeting requests.

1. Select the **Toll number** dropdown and change it to **+1 689 206 9333 Orlando, United States**. If that particular number isn't available, choose any other available toll number from the dropdown.

1. Select **Apply**.

1. Leave the browser window open.

You have successfully modified the audio-conferencing settings for Isaiah Langer. 

### Task 5 - Assign a dial out policy

In this task you will assign a new Dial out policy to Megan Bowen, to restrict her from making outbound calls.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. Select **Users** and **Manage users**.

1. Find **Megan Bowen** and select the name to open the user’s properties.

1. On the user’s properties page, select the **Voice** tab.

1. Under **Outbound calling**, select **Don't allow** from the drop-down menu, and then select **Confirm** when the assignment warning appears.

1. Wait until the notification **The dial out policy was assigned** shows, then select **Manage users** to exit the properties page.

1. Leave the browser window open.

Outbound calls from Megan Bowen have been restricted.

## Exercise 2: Configure call queues and auto attendants

### Exercise Duration

  - **Estimated Time to complete**: 45 minutes

In this exercise, you configure a call queue and auto attendant for the Sales team. Isaiah Langer initially answers calls in the queue, and you later connect the queue to the Sales Group team.

### Task 1 - Create and license resource accounts

In this task, you create and license resource accounts for the Sales call queue and the Sales auto attendant. For the domain, use your tenant's `onmicrosoft.com` domain.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. In the **Microsoft Teams admin center**, select **Voice** > **Resource accounts**.

1. Select **Add**, enter the following values, and then select **Save**:

    - **Display name**: **Sales CQ**
    - **Username**: **SalesCQ**
    - **Domain name**: Select &lt;TENANT NAME&gt;.onmicrosoft.com
    - **Resource account type**: **Call queue**

1. Select **Add** again, enter the following values, and then select **Save**:

    - **Display name**: **Sales AA**
    - **Username**: **SalesAA**
    - **Domain name**: Select the same available domain as for **Sales CQ**
    - **Resource account type**: **Auto attendant**

1. Switch to the **Microsoft 365 admin center** tab, or open https://admin.microsoft.com in a new tab. Select **Users** > **Active users**.

1. Search for **Sales**, then select the checkboxes next to **Sales CQ** and **Sales AA**.

1. Select **Manage product licenses** > **Assign more**, select **Microsoft Teams Phone Resource Account**, and then select **Save changes**.

1. After the portal confirms that it assigned the license to both accounts, return to the **Microsoft Teams admin center**.

You have created and licensed the resource accounts required by the Sales call queue and auto attendant.

### Task 2 - Create a call queue in the Teams admin center

In this task, you create a call queue and add Isaiah Langer as an agent.

1. In the **Microsoft Teams admin center**, select **Voice** > **Call queues**, then select **Add**.

1. Enter **Sales CQ** as the name, then select **Advanced setup**.

1. On the **General info** page, configure the following settings:

    - **Name**: **Sales CQ**
    - **Language**: **English (United States)**
    - **Resource accounts**: Select **Add**, search for **Sales CQ**, select the result, select **Add** next to the account, and then select **Save**.

    You don't need to assign a calling ID for this lab.

1. Select **Next** to keep the default greeting and music settings.

1. On the **Call answering** page, select **Choose users and groups** > **Add users**. Search for **Isaiah Langer**, select the result, select **Add** next to the user, and then select **Add** at the bottom of the pane.

1. Leave the remaining options at their default values, then select **Submit**.

1. Confirm that **Sales CQ** appears in the call queues list with the **Sales CQ** resource account.

You have created the Sales CQ call queue and added Isaiah Langer as an agent.

### Task 3 - Create an auto attendant for the Sales call queue

In this task, you create an auto attendant and route its business-hours calls to the Sales call queue.

1. In the **Microsoft Teams admin center**, select **Voice** > **Auto attendants**, then select **Add**. If **Add** isn't visible, select **More actions** (**...**) > **Add**.

1. In **Quick setup**, configure the following settings:

    - **Name**: **Sales AA**
    - **Time zone**: **(UTC-08:00) Pacific Time (US & Canada)**
    - **Language**: **English (United States)**
    - **How do you receive a call**: **Assign Resource accounts**

1. Search for **Sales AA**, select the result, select **Add** next to the resource account, and then select **Next**.

1. On the **Select call routing options** page, select **Choose a destination to redirect call to**. Select **Voice app**, search for and select **Sales CQ**, and then select **Submit**.

1. Close the confirmation dialog, and then select **Sales AA** in the auto attendants list.

1. Select **Business-hours call flow**, select **Add a greeting message**, and enter **Thank you for calling Contoso. Your call is important to us. Please wait while we handle your call.**

1. Confirm that **Redirect call** is set to **Voice app** > **Sales CQ**, and then select **Submit**.

1. Confirm that **Sales AA** appears in the auto attendants list with one resource account.

You have created the Sales AA auto attendant and routed its business-hours calls to the Sales CQ call queue.

### Task 4 – Configure a Call Queue to use a channel

In this task, you connect the Sales call queue to a Teams channel. Members of the Sales Group team become the queue's agents and can collaborate in the channel while they take calls.

1. You are still signed in to MS721-CLIENT01 as “Admin” and have the **Microsoft Teams admin center** open as **Allan Deyoung**.

1. Under **Voice**, and **Call Queues**, select **Sales CQ**.

1. Under **Call answering**, select **Choose a team**, and then select **Add a channel**.

1. Search for **Sales Group**, select the result, and then select **Add** next to the team.

1. Under **Select the channel**, select **General**, and then select **Apply**.

1. Select **Submit**, and leave the Teams admin center open for the next task.

You have successfully assigned the call answering for the Call Queue to the General channel within the Sales Group team.

### Task 5 - Configure a Call Queue to forward to voicemail if busy

In this task, you send calls that time out in the queue to the Sales Group shared voicemail instead of disconnecting them.

1. You are still signed in to MS721-CLIENT01 as “Admin” and have the **Microsoft Teams admin center** open as **Allan Deyoung**.

1. Under **Voice**, select **Call queues**, and then select **Sales CQ**.

1. Under **Exception handling**, expand **Call timeout**. Under **When call times out**, select **Redirect this call to**, and then select **Voicemail (shared)** from the **Redirect to** dropdown list.

1. Search for and select **Sales Group**.

1. Turn **Transcription** on.

1. Select **Add a greeting message**, and enter **We are unable to take your call, please leave a message and we will be back with you as soon as possible.**

1. Select **Submit**.

You have successfully assigned a voicemail to the Call Queue should it reach a time out period. 

### Task 6 - Explore conference mode toggle

In this task, you confirm that conference mode is on. Conference mode connects callers to agents faster.

1. You are still signed in to MS721-CLIENT01 as **Admin** and have the **Microsoft Teams admin center** open as **Allan Deyoung**.

1. Under **Voice**, and **Call Queues**, select **Sales CQ**.

1. Under **Call answering**, find **Conference mode** and validate the toggle is **On**.

1. Select **Submit**.

You have confirmed that conference mode is on for the **Sales CQ** call queue.

### Task 7 - Set holiday modes within AA

In this task, you create a holiday and add a holiday call flow to the Sales auto attendant. Use any holiday date you like.

1. You are still signed in to MS721-CLIENT01 as “Admin” and have the **Microsoft Teams admin center** open as **Allan Deyoung**.

1. In the Microsoft Teams admin center, go to **Voice** > **Holidays**.

1. Select **Add** to start the creation of a new holiday.

1. Enter a name for the holiday.

1. Select **Add new date**.

1. Under **Start time**, select the calendar icon and choose the date when you'd like the holiday to begin.

1. Use the drop-down list to select a start time for the holiday.

1. Under **End time**, select the calendar icon and choose the date when you'd like the holiday to end.

1. Use the drop-down list to select an end time for the holiday. **The End** time must be after the **Start time**.

1. Optionally, add more dates for recurring holidays.

1. Select **Save**.

1. Return to **Voice**, select **Auto attendants**, and then select **Sales AA**.

1. In the **Sales AA** editor, select **Holidays call flow**, and then select **Add**.

1. Enter **Contoso holiday** for the call flow name.

1. From the **Holiday** dropdown list, select the holiday that you created.

1. Under **Greeting options**, select **Add a greeting message**, and then enter **Contoso is closed for the holiday. Please call back during business hours.**

1. Under **Call routing options**, select **Disconnect**.

1. Select **Save** to add the holiday call flow, and then select **Submit** to update **Sales AA**. Confirm that the auto attendants list shows one holiday for **Sales AA**.

You have successfully created a holiday and assigned its call flow to the Sales AA auto attendant.

### Task 8 - Import an MP3 file for custom music on hold

In this task, you use the provided MP3 file as custom music on hold for the Sales CQ call queue.

1. You are still signed in to MS721-CLIENT01 as “Admin” and have the **Microsoft Teams admin center** open as **Allan Deyoung**.
 
1. Under **Voice**, select **Call queues**, and then select **Sales CQ**.

1. Select **Greeting and music**.

1. Under **Music on hold**, select **Play an audio file**.

1. Select **Upload file**, navigate to the `C:\LabFiles` folder, select **MoH-sample.mp3**, and then select **Open**. Wait for the file name to appear under **Music on hold**.

1. Select **Submit**. Reopen **Sales CQ** and confirm that **MoH-sample.mp3** remains selected under **Greeting and music**.

1. Select the circle with the **AD** initials in the upper right-side and select **Sign out**.

1. Close all browser windows currently open.

You have assigned a custom MP3 file as music on hold for the call queue.

## Exercise 3: Manage Teams devices

### Exercise Duration

  - **Estimated Time to complete**: 30 minutes

In this exercise, you start provisioning a Teams phone, and then create and license an account for a Microsoft Teams Room.

### Task 1 - Perform remote provisioning of Teams Phones

> [!NOTE]
> The instructions provided here are for reference only and will not complete successfully because the lab environment doesn't include a physical Teams phone.

In this task, you will provision a Teams Phone device in the Teams administration center.

1. On MS721-CLIENT01, open Microsoft Edge from the taskbar and browse to the **Microsoft Teams admin center** at [https://admin.teams.microsoft.com](https://admin.teams.microsoft.com/).

1. Sign in as **Allan Deyoung**, who has the Teams Administrator role.

1. Select **Teams devices** and then select **Phones**.

1. Select **Actions** in the upper right corner, then from the drop-down menu, select **Provision Devices**.

1. The **Provision devices** page shows. Under **Waiting on activation** select **Add MAC addresses manually**.

1. In the **Add MAC** addresses dialogue, enter the MAC address of **ab-cd-12-34-ef-56** and for location enter **Bellevue**, for the Teams IP Phone.

	In a production environment, you would enter the actual MAC address of the device you want to connect.

1. Select **Save** to save the change.

1. The **Waiting on activation page** will show the Teams IP Phone’s MAC address and location. Select the MAC address from the list, then select **Generate verification code**

    **Since there are no physical phones to connect to the lab environment, the lab is complete here. The steps below are strictly informational to demonstrate the remainder of the process. You may now proceed to the next task**.

1. On the Teams IP Phone, select **Settings,** then choose **Provision phone**

1. Enter the generated verification code on the Teams IP Phone, then select **Next**

1. **Device provisioned successfully** should display on the Teams IP Phone screen.

1. In the Teams Admin Center, on the **Provision devices** page, choose **Refresh**, then choose the **Waiting for sign in** tab. The Teams IP Phone will show in the list.

1. Select the circle in the upper right-side with the **AD** initials and select Sign out.

1. Close the browser window at the end of this task.

The Teams IP Phone can now be signed in to by a user or remotely signed in to a common area account.

### Task 2 - Create a resource account and Exchange Online mailbox for Teams Rooms

In this task, you use Exchange Online PowerShell to create a room resource account with a mailbox.

1. On MS721-CLIENT01, select Start, type **PowerShell**, right-click **Windows PowerShell**, and select **Run as administrator**.

1. Make sure you have the latest Exchange Online PowerShell modules installed with the following cmdlet. If you receive an **Untrusted repository** prompt, select **[A] Yes to all**.

    ```powershell
    Install-Module ExchangeOnlineManagement -Force

    ```

1. Connect to Exchange Online PowerShell, when prompted for credentials, enter the credentials of **Allan Deyoung**:

    ```powershell
    Connect-ExchangeOnline
    
    ```

1. Run the following command to create a new resource account with an Exchange Online mailbox.  Replace &lt;TENANT NAME&gt; and &lt;USER PASSWORD&gt; with the correct values:

    ```powershell
    New-Mailbox -MicrosoftOnlineServicesID mtr01@<TENANT NAME>.onmicrosoft.com -Name "mtr01" -Alias mtr01 -Room -EnableRoomMailboxAccount $true -RoomMailboxPassword (ConvertTo-SecureString -String '<USER PASSWORD>' -AsPlainText -Force)

    ```

1. Run the following command to configure the settings on the room mailbox:

    ```powershell
    Set-CalendarProcessing -Identity "mtr01" -AutomateProcessing AutoAccept -AddOrganizerToSubject $false -DeleteComments $false -DeleteSubject $false -ProcessExternalMeetingMessages $true -RemovePrivateProperty $false -AddAdditionalResponse $true -AdditionalResponse "This is a Microsoft Teams Meeting room!"
    ```

1. Leave the PowerShell window open for the next task.

You have created the mtr01 room resource account and mailbox.

### Task 3 - Configure and license resource account with Microsoft Graph

In this task, you use Microsoft Graph PowerShell to set the account's password policy and assign the Teams Rooms Pro license.

1. In the same administrator PowerShell window, make sure you have the latest Microsoft Graph PowerShell module installed with the following cmdlet. If you receive an **Untrusted repository** prompt, select **[A] Yes to all**.

    > [!NOTE]
    > This command can take some time to run, wait for the prompt in PowerShell to return or not all the Graph sub-modules will install.

    ```powershell
    Install-Module Microsoft.Graph -Force -AllowClobber

    ```

1. Run the following commands to set the usage location and turn off password expiration. When prompted, sign in as **MOD Administrator** and select the check box to consent on behalf of your organization:

    ![A screenshot asking to provide consent for Microsoft Graph.](Linked_Image_Files/M03_E03_T01_01.png)

    ```powershell
    Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All

    Update-MgUser -UserId "mtr01@<TENANT NAME>.onmicrosoft.com" -UsageLocation US -PasswordPolicies DisablePasswordExpiration

    ```

1. Run the following commands to look up the Teams Rooms Pro license and assign it to **mtr01@&lt;TENANT NAME&gt;.onmicrosoft.com**:

    ```powershell
    
    $MTRProSku = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'Microsoft_Teams_Rooms_Pro'
    
    Set-MgUserLicense -UserId "mtr01@<TENANT NAME>.onmicrosoft.com" -AddLicenses @{SkuId = $MTRProSku.SkuId} -RemoveLicenses @()

    ```

1. Close the PowerShell window.

The mtr01 account is now licensed and can sign in to a Microsoft Teams Room system with the password you set.

### Task 4 - Prepare to manage devices by creating tags in the Teams Admin Center

In this task, you create two device tags, **Executive** and **Contact Center**, so support technicians can identify important devices.

1. On MS721-CLIENT01, open Microsoft Edge and browse to the Microsoft Teams admin center at [https://admin.teams.microsoft.com](https://admin.teams.microsoft.com/).

1. Sign in as **Allan Deyoung**.

1. Select **Teams devices**, then select **Phones**.

1. Select **Actions**, then from the upper right-side and select **All Device tags**.

1. From the **Manage tags** dialogue, select **Add**.

1. Enter **Executive** and choose the **Save** icon.

1. Select **Add**.

1. Enter **Contact Center** and select the **Save** icon.

1. Select **Cancel** to close the Manage Tags dialogue.

    > [!NOTE]
    > Tags are assigned to users or resource accounts and applied to devices when they sign in. This lab has no phone, so you can't verify tag application here.

1. Select the circle with the **AD** initials in the upper right-side, select **Sign out**, and then close the browser window.

You have created the **Executive** and **Contact Center** device tags.

## Exercise 4: Monitor and troubleshoot Teams Phone

### Exercise Duration

  - **Estimated Time to complete**: 120 minutes

In this exercise, you troubleshoot voicemail, test a dial-plan rule, review call health and network connectivity, and explore calling reports. You don't need Lab 3, an SBC, or a PSTN trunk.

### Task 1 - Troubleshoot Teams voicemail with Support Assistant

Isaiah Langer reports that they aren't receiving voicemails. In this task, you use Support Assistant to review troubleshooting guidance and run the Voicemail diagnostic before opening a support request.

1. On MS721-CLIENT01, open the [Microsoft 365 admin center](https://admin.microsoft.com/) and sign in as **Allan Deyoung**.

1. On the left menu, select **Show all**, then select **Users** > **Active users**.

1. Find **Isaiah Langer** and note their username or email address. You need it to run the diagnostic.

1. On the left menu, select **Show all**, then select **Support** > **Help & support**.

1. Confirm that **Support Assistant** is **On**. In the message field, enter **Help me troubleshoot why a Teams user is not receiving voicemail**, then send the message.

1. Review the troubleshooting guidance. When Support Assistant offers the Teams voicemail diagnostic, enter Isaiah Langer's exact username from **Active users**, then select **Run Tests**.

1. Review the results. The diagnostic should report that it didn't find any problems. If it reports an issue, review and apply the recommended tenant or policy corrections.

You have successfully used Support Assistant and the Microsoft 365 self-help diagnostic to check Isaiah Langer's voicemail configuration.

### Task 2 - Test and repair a dial-plan rule

In this task, you create a dial-plan rule that translates the test extension `00001` to `+14255550001`, break it, and then repair it. The **Test** control checks the translation only; it doesn't place a call.

1. You are still signed in to **MS721-CLIENT01** as “Admin” and signed into the **Microsoft 365 admin center** as **Allan Deyoung**.

1. In Microsoft Edge, open a new tab and browse to the **Microsoft Teams admin center** at [https://admin.teams.microsoft.com](https://admin.teams.microsoft.com/).

1. Select **Voice** > **Dial plans**, and then select the **Global (org wide default)** dial plan.

1. Under Normalization rules select **Add** to get to the add new rule dialogue.

1. For **Name** enter **Converts 00001 to lab test number**.

1. For **Description** enter **Converts 00001 to lab test number**.

1. Select **Advanced**.

1. In **If the dialed number matches this regular expression**, enter **^(00001)$**.

1. In **Then do this**, enter **+14255550001**.

1. Test the rule by entering **00001** and selecting **Test**. Verify the output is **+14255550001**, then select **Save**.

1. In the list of normalization rules, move the new rule above any broader rule that also matches `00001`, such as a four-digit extension rule.

1. Select **Save** on the global dial plan. If saving fails, read the validation message and correct the indicated field before retrying.

Next, break the rule's pattern to see how a mismatch affects normalization, and then repair it.

1. In **Voice > Dial plans > Global (Org-wide default)**, edit **Converts 00001 to lab test number**.

1. Change its pattern from `^(00001)$` to `^(0001)$`. In **Test this rule**, enter `00001` and select **Test**. Verify that it no longer produces `+14255550001`.

1. Restore the pattern to `^(00001)$`, test `00001` again, and verify the output is `+14255550001`.

1. Select **Save** on the rule and **Save** on the global dial plan. Reopen the rule to confirm that the working pattern remains in place.

1. Leave the browser window open.

You have diagnosed and repaired a normalization error without placing a PSTN call.

### Task 3 - Review Call Health Real Time Stats on a live call

In this task, Isaiah Langer calls Allan Deyoung in Teams, and you review the call's network and audio performance.

1. On **MS721-CLIENT01**, open the **Microsoft Teams** desktop client and sign in as **Allan Deyoung** if Teams isn't already signed in as Allan.

1. Sign in to **MS721-CLIENT02** as **Admin**.

1. Open the **Microsoft Teams** desktop client.

1. Sign in as **Isaiah Langer** if Teams is not already signed in.

1. Select the calls button on the left rail.

1. In **Calls**, search for **Allan Deyoung** and start an audio call to his Teams account. On MS721-CLIENT01, answer as Allan. Don't dial a phone number.

1. If your lab machine prompted you to use your microphone select **allow**.

1. If you are prompted by Windows Defender Firewall for Microsoft Teams select **Allow Access**.

1. Verify that the call connects. If it doesn't, fix the sign-in or device problem first.

1. While the call is connected, select **More** (**...**) in the Teams call window, then **Settings > Call health**.

1. Review the network and audio metrics, then end the call.

Call Health shows you the following:

#### Network Metrics

| Metric| Description |
|:---------|:---------|
| Roundtrip time| In group calls, it's the response time between your system and the Teams Service. In one-on-one calls, it's the response time between your system and the other participant's. Lower is better. |
| Received packet loss| The percentage of audio packets not received by your system. Lower is better. |
| Teams send limit| The max limit of data Teams can send based on the current network conditions and how it's used. This isn't your ISP speed limit. |
| Teams receive limit| The maximum amount of data Teams can receive under current network conditions. This isn't your ISP speed limit. |

#### Audio

| Metric| Description |
|:---------|:---------|
| Sent bitrate| The amount of audio data sent. High is better. |
| Sent packets| Data gets sent over the network in packets. This value is the number of data packets sent during a call. |
| Roundtrip time| Response time between your system and the Teams server. Lower is better. |
| Sent codec| The codec used for encoding audio sent by your system. |
| Received jitter| The distortion in audio caused by inconsistent audio packet arrival times. Lower is better |
| Received packets| The number of audio data packets received |
| Received packet loss| The result of a poor network connection, this is the percentage of audio data packets not received by your system. Lower is better |
| Received codec| The codec used for encoding audio data received by your system. |

### Task 4 - Use the Microsoft 365 connectivity test tool

A Teams Phone user working from home reports call quality issues. In this task, you run the Microsoft 365 network connectivity test on MS721-CLIENT01, acting as the user's PC. You ran the same test in Lab 2, so the .NET Desktop Runtime should already be installed.

1. Switch to **MS721-CLIENT01**.

1. In Microsoft Edge, open a new tab and browse to [https://connectivity.m365.cloud.microsoft](https://connectivity.m365.cloud.microsoft).

1. Choose a location for the test. Allow location access, or enter a location manually.

1. Select **Run test**, and wait for the results page.

1. From Edge's **Downloads** menu, open `Connectivity.<report-id>.exe`. If Windows reports that a **.NET Desktop Runtime** is missing, install it as you did in Lab 2, and then reopen the file.

1. Wait for **Office 365 Network Onboarding Advanced Tests** to finish. If Windows Defender Firewall prompts you for NetworkOnboardingClient, select **Allow Access**.

1. On the browser results page, select **Details** and review the following:

	- The Exchange and SharePoint front door locations should have green check marks.

	- Under **Microsoft Teams**, check the media connectivity, packet loss, latency, and jitter results.

1. Close the connectivity test tab.

If the Teams results aren't green, check whether the user is on Wi-Fi and test with a wired connection. If the front door locations aren't green and the user isn't on a VPN, contact the user's ISP.

You have tested network connectivity and performance from a user's machine.

### Task 5 - Inspect PSTN Usage Reports

In this task, you review the PSTN usage report, which summarizes calling and audio conferencing activity.

1. You are still signed in to MS721-CLIENT01 as “Admin”.

1. In Microsoft Edge, switch to the **Microsoft Teams admin center** tab, where you're signed in as **Allan Deyoung**.

1. Select **Analytics &amp; reports** on the left menu then **Usage reports**.

1. Under report select the **PSTN usage** report.

1. Under Date range select **last 7 days**.

1. Select **Run report**.

The report shows PSTN activity from the last seven days. With no PSTN connectivity, a report with zero calls is expected. The Teams-to-Teams call from Task 3 isn't a PSTN call.

The report shows:

- **Start time (UTC)** is the time the call started.

- **Display name** is the display name of the user. You can click the display name to go to the user's setting page in the Microsoft Teams admin center.

- **Username** is the user's sign-in name.

- **Phone number** is the number that received the call for inbound calls or the number dialed for outbound calls.

- **Caller ID** is the number of the source caller.

- **Operator** is the operator in which the number was routed through.

- **Call type** is whether the call was a PSTN outbound or inbound call and the type of call such as a call placed by a user or an audio conference. 

- **Destination dialed** is the number dialed.

- **Cost** is the amount of money or cost of the call that's charged to your account.

- **Currency** is the type of currency used to calculate the cost of the call.

- **Duration** is how long the call was connected.

- **Domestic/International** tells you whether the call was domestic (within a country or region) or international (outside a country or region) based on the user's location.

- **Call ID** is the call ID for a call. It's an identifier for the call you can use when calling Microsoft Support.

- **Number type** is the user's phone number type, such as a service of toll-free number.

- **User's location** is the usage location.

- **Conference ID** is the conference ID of the audio conference.

- **Capability** is the license used for the call.

You have reviewed the PSTN usage report. An empty report isn't a failure in this lab.

### Task 6 - Review Calls in Call Analytics

In this task, you review Isaiah Langer's calls, including the call from Task 3, in Call Analytics.

1. You are still signed into MS721-CLIENT01 as “Admin” and in the **Microsoft Teams admin center** as **Allan Deyoung**.

1. Select **Users** and **Manage users** on the left menu.

1. Find and select **Isaiah Langer**.

1. Select the **Meetings &amp; calls** tab.

1. Scroll down to **Completed meetings** to review Isaiah's recent calls and meetings. If the list shows **No data is available**, skip to the next task; the remaining steps require a completed call.

1. If calls are available, select one of the longer calls by duration.

1. In the top bar, note how Teams rated the overall audio quality. Because the call ran on a virtual machine, some information, such as device details, might be missing.

1. In the **Overview** tab Select **Network** and review the network metrics.

1. Select the **Advanced** tab to see all key metrics on one page.

1. Select the **Debug** tab to see all metrics (complete and incomplete).

You now know how to access and review call and meeting information in Call Analytics in the Teams Admin Center.

### Task 7 - Review Calls in Call Quality Dashboard

In this task, you open the Call Quality Dashboard (CQD) to review call and meeting quality across the organization.

1. You are still signed into MS721-CLIENT01 as “Admin” and in the **Microsoft Teams admin center** as **Allan Deyoung**.

1. In the navigation menu on the left, select **Analytics & reports** then select **Call quality dashboard**.

1. A new browser tab opens the [Microsoft Call Quality Dashboard](https://cqd.teams.cloud.microsoft/).

1. If prompted, sign in as **Allan Deyoung**.

    > [!NOTE]
    > This environment has few calls, and lab VMs don't report all metrics, so some reports are blank or incomplete.

1. As an example, select **Help Desk Reports** from the top menu and on the Help Desk report page select the **Call Details** tab to see recent calls.

In this task, you have learned how to open and navigate Call Quality Dashboard.

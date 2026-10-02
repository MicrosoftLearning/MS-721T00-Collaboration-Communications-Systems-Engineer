---
lab:
  title: 'Lab 06: Manage Microsoft Teams Premium'
  type: Answer Key
  module: 'Learning Path 02: Manage Teams collaboration communications systems'
  description: This lab explores advanced Teams Premium features, including configuring the Queues app, voice application policies, and meeting customization. The scenario demonstrates how to enable, assign, and validate premium capabilities for specialized Teams experiences.
  duration: 120 minutes
  level: 300
  islab: true
  primarytopics:
    - Microsoft Teams
---

> **Abstract:**  
> This lab explores advanced Teams Premium features, including configuring the Queues app, voice application policies, and meeting customization. The scenario demonstrates how to enable, assign, and validate premium capabilities for specialized Teams experiences.

# Lab 06: Manage Microsoft Teams Premium
# Student lab answer key

## Lab Scenario

As part of the expanding business, the organization has began needing access to more specialized areas of Microsoft Teams for different departments.

## Lab Duration

  - **Estimated Time to complete**: 120 minutes

## Instructions

> [!IMPORTANT]
> This lab continues in the Lab 1 and Lab 2 lab launch, in the same Microsoft 365 tenant that Lab 3 uses. It doesn't need the Lab 3 SBC or a phone number. Replace &lt;TENANT NAME&gt; with your tenant's name (for example, WWLx012345 in WWLx012345.onmicrosoft.com). If you completed Lab 3, Megan Bowen signs in with the lab domain (lab&lt;LAB NUMBER&gt;.o365ready.com).

## Exercise 1: Setup and Configure the Queues App and Voice Application Policies

### Exercise Duration

  - **Estimated Time to complete**: 45 minutes

In this exercise, you enable Megan Bowen for the Queues app and use a voice applications policy to let her manage a call queue.

### Task 1 - Assigning Teams Premium Licenses

In this task, you assign a Teams Premium license to Megan Bowen, who uses the Queues app later.

1. Connect to **MS721-CLIENT01** and sign in as **Admin**. 

1. In **Microsoft Edge**, browse to the Microsoft 365 admin center at [**https://admin.microsoft.com**](https://admin.microsoft.com/).

1. If prompted, sign in as **Allan Deyoung** with the credentials provided to you.

1. When a **Save password** dialog is displayed, select **Never**.

1. When a **Stay signed in?** dialog is displayed, select **No**.

    > NOTE: You may get a prompt to **Let's keep your account secure**. Click **Next** on this prompt and setup 2-Factor Authentication with the Microsoft Authenticator app. 

1. In the left navigation, select **Users**, select **Active Users**, and then select **Megan Bowen.**

1. Select **Licenses and Apps** on the user card, assign the **Microsoft Teams Premium** license to the user account, and then click **Save changes.**

1. In Microsoft Edge, open a new tab and browse to the Microsoft Teams admin center at [https://admin.teams.microsoft.com](https://admin.teams.microsoft.com/). Select **Users** > **Manage users** > **Megan Bowen** > **Account**.

1. Under **Assigned phone number**, turn on **Enterprise Voice**, select **Enable**, and verify that the setting shows **On**. Megan must have Enterprise Voice to appear in the call queue agent picker.

You have assigned a Teams Premium license and enabled Megan for call queue agent selection.

### Task 2 - Creating Resource Accounts for Voice Applications

In this task, you create and license a resource account for the call queue you build in Task 3.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. In the **Microsoft Teams admin center**, select **Voice** on the left menu, then select **Resource Accounts.**

1. Click **+ Add**, enter the following information, and then click **Save**:

	- **Display Name:** CQ_MainLine

	- **Unique Username:** CQ_MainLine@&lt;TENANT NAME&gt;.onmicrosoft.com

	- **Resource Account Type:** Call Queue

    ![A screenshot showing the basics of Resource Account setup.](Linked_Image_Files/M06_L06_E01_T02_01.png)

1. Switch to the **Microsoft 365 admin center** tab.

1. In the left navigation, select **Users**, select **Active Users**, and then select **CQ_MainLine.**

1. Select **Licenses and Apps** on the user card, assign the **Microsoft Teams Phone Resource Account** license to the account, and then click **Save changes.**

1. Return to **Voice** > **Resource accounts** in the Microsoft Teams admin center and verify that **CQ_MainLine** shows **Licensed**. If it doesn't yet, wait a few minutes and refresh.

You have successfully created a Teams Phone Resource Account for a Call Queue and licensed it accordingly.

### Task 3 - Creating a Call Queue

In this task, you create a call queue with Megan Bowen as an agent and authorized user.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. In the **Microsoft Teams admin center**, select **Voice** on the left menu, then select **Call Queues.**

1. Select **+ Add**, and then select **Advanced setup**. Set the following parameters across the wizard pages, and then select **Submit** to create the call queue:

    - **General Info Tab**

        - **Add a name for your call queue:** CQ_MainLine

        - **Language:** English (United States)

        - **Resource accounts:** Select **Add**, search for the beginning of **CQ_MainLine@&lt;TENANT NAME&gt;.onmicrosoft.com**, select the account, and confirm **Add** in the picker.

    - **Call Answering Tab**

        - **Choose users and groups:** Select **Add users**, search for **Megan Bowen**, select **Add** beside her name, and confirm **Add** in the picker.

        - **Conference mode:** On

    - **Agent Selection Tab**

        - **Presence-based routing:** Toggle Off

    - **Authorized Users Tab**

        - **Add:** Megan Bowen. Select **Add** beside her name, and confirm **Add** in the picker.

1. Reopen the queue and verify that **Megan Bowen** appears under **Call answering** and **Authorized users**.

You have created the CQ_MainLine call queue.

### Task 4 - Configuring Voice Application Policies

In this task, you create a voice applications policy that lets users change call queue settings in the Teams client, without access to the Teams admin center.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. In the **Microsoft Teams admin center**, select **Voice** on the left menu, then select **Voice applications policies.**

1. Select **Add**, set the following parameters, and then select **Save** to create the voice applications policy:

    - **Name:** Managers
  
    - **Call Queue Greetings:** Toggle All Settings **On**

    - **Call Queue General:** Toggle All Settings **On**

    - **Call Queue Exception Handling:** Toggle All Settings **On**
  
    - **Call Queue Agent Monitoring:**
  
        - **Agent Monitor Mode:** Takeover
    
        - **Agent Monitor Notification Mode:** Agent
  
    - **Call Queue Reporting:** Set all four metrics to **Only authorized call queues**.

    ![A screenshot showing Voice Application Policy.](Linked_Image_Files/M06_L06_E01_T04_01.png)

You have successfully created a Voice Application Policy. You are now ready to assign this to a user.

### Task 5 - Assigning Voice Application Policies

In this task, you assign the Managers voice applications policy to Megan Bowen.

1. You are still signed in to MS721-CLIENT01 as “Admin” and signed into the **Microsoft Teams admin center** as **Allan Deyoung**.

1. In the **Microsoft Teams admin center**, select **Users** on the left menu, then select **Manage Users.**

1. Select **Megan Bowen**, select **Policies**, and then select **Edit.**

1. Scroll down to **Select Voice Applications Policy**, select the **Managers** policy created earlier, then click **Apply** and **Confirm.**

1. Verify that **Voice applications policy** shows **Managers** for Megan.

You have successfully applied a Voice Application policy to a user.

## Exercise 2: Using the Queues App

### Exercise Duration

  - **Estimated Time to complete**: 30 minutes

In this exercise, you use the Queues app as Megan Bowen.

### Task 1 - Accessing the Queues App

In this task, you sign in to Teams as Megan Bowen and open the Queues app.

1. Switch to **MS721-CLIENT02**. In the Microsoft Teams desktop client, sign out as **Isaiah Langer**, and then sign in as **Megan Bowen**.

1. In the Teams desktop client, select **More apps** (**...**) on the left app bar, search for **Queues**, and open it. The Queues app isn't supported in Teams on the web.

    ![A screenshot showing how to access the Queues App.](Linked_Image_Files/M06_L06_E02_T01_01.png)

1. On the **CQ_MainLine** overview, confirm that **Megan Bowen (You)** appears as an opted-in agent, and review the queue metrics and management controls.

    ![A screenshot showing  the Queues App.](Linked_Image_Files/M06_L06_E02_T01_02.png)

You have successfully accessed the Teams Queues App as Megan Bowen.

### Task 2 - Modifying Call Queue Parameters from within the Teams client

In this task, you use Megan's voice applications policy to change a call queue setting from the Teams client.

1. You are still on **MS721-CLIENT02**, where Teams is signed in as **Megan Bowen**.

1. In Teams, select **Settings and more** (**...**) in the upper right, then select **Settings** > **Calls**.

1. At the top of the **Calls** settings, select **CQ_MainLine**. The settings you can change depend on Megan's assigned voice applications policy.

    ![A screenshot showing  the users calling settings.](Linked_Image_Files/M06_L06_E02_T02_01.png)

1. Under **Call handling and routing**, turn **Presence-based routing** **On**. Select the **Personal** tab, return to **CQ_MainLine**, and confirm that the setting remains **On**.

    > [!NOTE]
    > This confirms the setting change, not call delivery. Testing an inbound call requires a phone number on the queue.

You have successfully edited the call queue from within the Microsoft Teams client.

## Exercise 3: Customizing Meetings with Teams Premium

### Exercise Duration

  - **Estimated Time to complete**: 15 minutes

In this exercise, you create a custom meeting theme for Teams Premium users and verify it on the meeting join page.

### Task 1 - Create a Meeting Customization Policy

In this task, you add a Contoso meeting theme to the Global meeting customization policy.

1. Switch to **MS721-CLIENT01**, where the Microsoft Teams admin center is open as **Allan Deyoung**.

1. In the **Microsoft Teams admin center**, select **Meetings** on the left menu, then select **Customization Policies.**

1. Open the **Global (Org-wide default)** policy, select **Add a theme**, and set the following parameters:

	- **Meeting theme name:** Contoso

	- **Logo Light Theme:** [Logo.png](https://github.com/MicrosoftLearning/MS-721T00-Collaboration-Communications-Systems-Engineer/tree/main/Instructions/Labs/Labfiles/Logo.png)

	- **Logo Dark Theme:** [Logo.png](https://github.com/MicrosoftLearning/MS-721T00-Collaboration-Communications-Systems-Engineer/tree/main/Instructions/Labs/Labfiles/Logo.png)

	- **Images Light Theme:** [Theme.png](https://github.com/MicrosoftLearning/MS-721T00-Collaboration-Communications-Systems-Engineer/tree/main/Instructions/Labs/Labfiles/Theme.png)

	- **Images Dark Theme:** [Theme.png](https://github.com/MicrosoftLearning/MS-721T00-Collaboration-Communications-Systems-Engineer/tree/main/Instructions/Labs/Labfiles/Theme.png)

	- **Color Hex Code:** #2760C9

    ![A screenshot showing the settings on the flyout.](Linked_Image_Files/M06_L06_E03_T01_01.png)

    > [!NOTE]
    > On MS721-CLIENT01, both image files are in `C:\LabFiles`.

1. In the **Meeting themes** pane, select **Preview** to review the light and dark themes, then select **Close** and **Apply**.

1. In the Global policy, verify that **Contoso** appears as the active theme, and then select **Save**. Reopen the policy to confirm that the theme remains active.

    ![A screenshot showing the meeting customizatiion policy preview.](Linked_Image_Files/M06_L06_E03_T01_02.png)

You have successfully modified the Global meeting customization policy and applied it to users with Teams premium licensing.

### Task 2 - Create a Meeting as a Teams Premium User and validate the branding has applied

In this task, you create a meeting as Megan Bowen and check the branding on its join page.

> [!IMPORTANT]
> Allow at least 30 minutes after Task 1 for the policy to take effect.

1. Switch to **MS721-CLIENT02**, where Teams is signed in as **Megan Bowen**.

1. In the Teams desktop client, select **Calendar** > **New**. Enter a name, choose a future time, turn **Teams meeting** **On**, and select **Save**.

    > [!IMPORTANT]
    > If Teams can't create a meeting link, select **Don't Send** and retry later. Don't use **Meet now** instead.

1. Open the saved meeting and select **Copy** beside its Teams meeting join URL.

    ![A screenshot showing the meeting join URL.](Linked_Image_Files/M06_L06_E03_T02_01.png)

1. Open a new Microsoft Edge **InPrivate** window, paste the copied meeting join URL, and select **Join in this browser**. If the browser displays an audio and video prompt, select **Continue without audio or video**.

1. On the prejoin page, verify that the background matches `Theme.png` and the logo matches `Logo.png`. You don't need to join the meeting.

    ![A screenshot showing the meeting join page.](Linked_Image_Files/M06_L06_E03_T02_02.png)

    > [!NOTE]
    > If you don't see the branding, wait another 30 minutes and repeat this task.

You have successfully created a meeting as a Teams Premium user and validated that your organization's meeting customization policy has taken effect.
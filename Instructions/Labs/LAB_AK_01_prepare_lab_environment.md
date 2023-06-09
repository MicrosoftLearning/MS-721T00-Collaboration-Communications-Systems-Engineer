---
lab:
    title: 'Lab 01: Configure the lab environment'
    type: 'Answer Key'
    module: 'Learning Path 01: Plan and design Teams collaboration communications systems'
---

# Lab 01: Configure the lab environment
# Student lab answer key

## Lab scenario

In the labs for this course, you are taking on the role of Allan Deyoung, Contoso Ltd.’s Collaboration Communications Systems Engineer. You have deployed Microsoft 365 in a lab environment, and you have been tasked with completing a pilot project that tests the Voice and Phone device management features in Microsoft Teams as they relate to Contoso's business requirements.

You have just started the pilot project. In this first lab you will set up a personalized Microsoft 365 user account for Allan that will be used throughout all the labs in this course. This first exercise also requires that you perform several setup tasks that will initialize your trial tenant for the remaining labs in this course. You must configure your trial tenant, create a personalized Teams Service user account in Microsoft 365 for Kate, configure several test users and groups that will be used throughout the remaining labs, and request a certificate signed by a public certificate authority.

## Lab Duration

  - **Estimated Time to complete**: 30 minutes

## Instructions

### WWL Tenants - Terms of Use

> [!IMPORTANT]
> If you are being provided with a tenant as a part of an instructor-led training delivery, please note that the tenant is made available for the purpose of supporting the hands-on labs in the instructor-led training. 
> Tenants should not be shared or used for purposes outside of hands-on labs. The tenant used in this course is a trial tenant and cannot be used or accessed after the class is over and are not eligible for extension.
> Tenants must not be converted to a paid subscription. Tenants obtained as a part of this course remain the property of Microsoft Corporation and we reserve the right to obtain access and repossess at any time. 

## Exercise 1: Assign permissions and licenses

### Exercise Duration

  - **Estimated Time to complete**: 15 minutes

In this exercise, you will assign the required admin permissions to continue with the other labs and exercises in this course.

### Task 1 - Assign Allan Deyoung to the Teams Administrator role

In the following task, you will use the global administrator account MOD Administrator to assign Teams Service Administrator permissions to the account for Allan Deyoung.

1. Log in to MS721-CLIENT01 as “Admin”.

1. Open **Microsoft Edge** and browse to the Microsoft 365 admin center at [**https://admin.microsoft.com**](https://admin.microsoft.com/).

1. On the **Sign in** screen, enter the credentials of the Global Admin account of the **MOD Administrator** with the username and password provided to you.

1. In the upper left navigation, select the three dashes to the left of the organization name to open the full left-side menu.

1. Select **Users** and **Active users** from the menu below.

1. In the **Active users** list, select **Allan Deyoung** to open the right-side panel.

1. Under **Roles**, select **Manage roles**.

1. In the **Manage admin roles** pane, select **Admin center access**.

1. In the list, select **Exchange Administrator** and **Teams Administrator**.

1. At the bottom of the card, select **Save changes**. Admin roles are updated.

1. Return to the **Allan Deyoung** card by pressing the **left arrow**, and then select **Reset Password**.

1. Deselect **Automatically create a password** and **Require this user to change their password when they first sign in**.

1. Enter the MOD Administrator password in the _"Resource"_ section on the right side of the lab window.

1. Press **Reset password**.

1. Press **Close**.

1. Leave the browser window open for the next task.

You have successfully assigned the Teams Service administrator permission to Allan Deyoung.

### Task 2 - Validate licenses in the admin portal

In this task you will sign into the clients provided by your training provider and run a certain script also provided by the lab hoster, to understand what licenses are inside the tenant and what licenses are applied.

1. You are still signed in to MS721-CLIENT01 as “Admin” and in the **Microsoft 365 admin center** as **MOD Administrator**.

1. On the upper left side, select the **Navigation menu** with the three dashes then select **Billing** and then select **Licenses**. 

1. When the Licenses Panel is shown, validate you can see 10 of the **Office 365 E5** licenses are now applied to users, with 5 remaining licenses available.

1. Select **Office 365 E5** to see who has the licenses applied.

1. Leave the browser open at the end of the task.

You have successfully signed into your test clients and reviewed the overall number of licenses applied to the Office 365 tenant.

### Task 3 - Add the Microsoft Teams Domestic Calling Plan trial license to your tenant

As an admin, you can enable users to make phone calls with a Domestic Calling Plan or an International Calling Plan in Office 365. Isaiah Langer recently joined Contoso and his job requires him to make domestic phone calls. In this task, you will activate the trial for domestic calling.

1. You are still signed in to MS721-CLIENT01 as “Admin” and in the **Microsoft 365 admin center** as **MOD Administrator**.

1. On the Microsoft 365 admin center page, select the three dashed in the upper left side, select **Marketplace**, then **All products**.

1. Under **View by category**, clear all categories except **Add-ons**.

1. In the search box, search for and select **Microsoft Teams Domestic Calling Plan for US and Canada Trial**, note you may need to expand the list to see all the add-ons and be sure to select the trial version.

1. Select **Details** and select **Start free trial**. 

1. On the Check out page, select **Try now**.

1. On the order receipt page, select **Continue**.

1. Leave the browser window open at the end of the task.

You have successfully activated the Calling Plan trial in your tenant.

### Task 4 - Start a trial for Microsoft Teams Rooms Pro licenses

As an admin, you can enable users to make phone calls with a Domestic Calling Plan or an International Calling Plan in Office 365. Isaiah Langer recently joined Contoso and his job requires him to make domestic phone calls. In this task, you will activate the trial for domestic calling.

1. You are still signed in to MS721-CLIENT01 as “Admin” and in the **Microsoft 365 admin center** as **MOD Administrator**.

1. On the Microsoft 365 admin center page, select the three dashed in the upper left side, select **Marketplace**, then **All products**.

1. Under **View by category**, clear all categories except **Collaboration and Communication**.

1. In the search box, search for and select **Microsoft Teams Rooms Pro**, note you may need to expand the list to see all the add-ons and be sure to select the trial version.

1. Select **Details** and select **Start free trial**. 

1. On the Check out page, select **Try now**.

1. On the order receipt page, select **Continue**.

1. Leave the browser window open at the end of the task.

You have successfully activated the Calling Plan trial in your tenant.

### Task 5 - Assign the Domestic Calling Plan license to Isaiah Langer

As an admin, you can assign the Calling Plan license that gives users the right to be assigned a phone number and make and receive PSTN calls. This is a Domestic Calling Plan or an International Calling Plan in Office 365. Isaiah Langer recently joined Contoso and his job requires him to make domestic phone calls. In this task, you will activate the Calling Plan license for Isaiah Langer. Isaiah already has an E5 license, so has a Teams Phone System license, but requires a calling plan license.

1. You are still signed in to MS721-CLIENT01 as **Admin** and in the **Microsoft 365 admin center** as **MOD Administrator**.

1. On the Microsoft 365 admin center page, in the left navigation, select **Users**, then **Active users**.

1. In the **Active users** list, select **Isaiah Langer**.

1. In the **Isaiah Langer** card, select **Reset Password**.

1. Deselect **Automatically create a password** and **Require this user to change their password when they first sign in**.

1. Enter the **MOD Administrator** password in the _“Resource”_ section on the right side of the lab window.

1. Press **Reset password**.

1. Press **Close**.

1. In the **Active users** list, again select **Isaiah Langer**.

1. In the **Isaiah Langer** card, select **Licenses and apps** tab.

1. In the **Licenses** list, select the **Microsoft Teams Domestic Calling Plan** check box.

1. Select **Save changes** and then close the user card.

1. Sign out the **MOD Administrator** with the MA initials in the circle in the upper right-side corner and select **Sign out**.

1. Close the browser window at the end of the task.

You have successfully assigned the license to Isaiah Langer, activated additional features for this account and reset his password. Remember or write down the password. You will continue with additional tasks for assigning phone numbers in a later exercise. 

## Exercise 2: Setup PowerShell for Microsoft Teams administration

### Exercise Duration

  - **Estimated Time to complete**: 10 minutes

Several configuration steps of Microsoft Teams in this lab can also be done or must be done through the Microsoft Teams PowerShell module. In this exercise, you will install the Microsoft Teams PowerShell module and validate the correct version number for being ready for Teams Administration tasks during your lab.

### Task 1 – Install the latest Teams PowerShell module

In this task, you will install the latest Teams PowerShell module on your lab client and check the correct version number.

1. You are still signed in to MS721-CLIENT01 as “Admin” with the password provided to you.

1. Select the start button, enter **Windows PowerShell** and select **Run as administrator** below PowerShell from the start menu.

1. Confirm the **User Account Control** message with **Yes** to open a window with elevated permissions.

1. When Windows PowerShell window has opened, enter the following cmdlet to download the Microsoft Teams PowerShell module from the PSGallery and Install it:

    ```powershell
    Install-Module MicrosoftTeams -Force
    ```

1. Once the module is installed you will see the command prompt again.

1. Enter the following cmdlet to import the newly installed Microsoft Teams PowerShell module:

    ```powershell
    Import-Module MicrosoftTeams
    ```

1. After importing the module, you are back on the command prompt again. Enter the following cmdlet to get the module version and available commands:

    ```powershell
    Get-Module -Name MicrosoftTeams
    ```

1. You should see a version number of 4.9.1 or above and a multi-value field with different cmdlets available.

    ![Screenshot of the process of installing and importing the Microsoft Teams PowerShell module.](./Linked_Image_Files/M01_L01_E04_T01.png)

1. Now login to Microsoft Teams via PowerShell to confirm you can connect. At the command prompt type the following cmdlet:

    ```powershell
    Connect-MicrosoftTeams
    ```

1. When the **Sign in to your account** window opens, enter the credentials of Allan Deyoung (AllanD@M365x&lt;TenantName&gt;.onmicrosoft.com) to sign in with your Teams Administrator user.

1. When you are successfully signed in you will be returned to the **PowerShell**.

1. To check you are signed in correctly, you will be able to retrieve objects from your tenant. To get a list of users, run the following command:

    ```powershell
    Get-CSOnlineUser
    ```

1. You should see some users and their attributes scroll across the screen. If you see this, you have signed in successfully and can interact with Teams in your tenant.

1. Create a new Team to be used throughout the labs in this course by running the following command:

    ```powershell
    New-Team -DisplayName "Sales Group" -Description "Sellers at Contoso" -Visibility Public
    ```

1. Disconnect your session by running the following command at the command prompt.

    ```powershell
    Disconnect-MicrosoftTeams
    ```

1. You can close the Windows PowerShell window by selecting the **X** in the top right.

    ![Screenshot of the disconnecting to the Microsoft Teams PowerShell module.](./Linked_Image_Files/M01_L01_E04_T01-2.png)

You have successfully installed the Teams PowerShell Module, signed into Teams and tested a PowerShell command.

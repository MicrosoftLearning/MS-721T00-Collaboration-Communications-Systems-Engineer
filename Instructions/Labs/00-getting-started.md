---
title: Get started with the MS-721 labs
---

# Get started with the MS-721 labs

These labs give you hands-on practice with Microsoft Teams Phone, Direct Routing, Teams devices, and Teams Premium for the Contoso scenario.

## Your lab environment

| Item | Detail |
| --- | --- |
| Tenant | A Microsoft 365 trial tenant. Lab steps show its domain as `<TENANT NAME>.onmicrosoft.com`. |
| MS721-CLIENT01 | The main lab VM. You do administration, PowerShell, network tests, and Direct Routing setup here. |
| MS721-CLIENT02 | A second Teams client for test calls and Teams Premium checks. |
| SBC | A session border controller in Azure, used only in Lab 03. |
| Lab files | The read-only **AllFiles (F:)** drive on the lab VMs. |

> [!NOTE]
> Sign in to the VMs as **Admin**, and sign in to Microsoft 365 with the MOD Administrator account. The passwords are provided in your lab environment. Replace `<TENANT NAME>` in lab steps with your tenant name.

## Lab files

The **AllFiles (F:)** drive holds files you copy during the labs, such as the Lab 03 setup script. The drive is read-only, so copy a file before you edit or run it. Other lab files, such as the hold music and branding images, are already in `C:\LabFiles` on the VMs. If you aren't using the hosted lab environment, each step that uses a file from the drive links to it so you can download it.

## How the labs work

- **Start with Lab 01.** It prepares the trial tenant for the remaining labs.
- **Lab 03 runs separately.** Lab 03 is a separate lab launch with its own VMs, tenant, and SBC. Labs 01, 02, 04, 05, and 06 share one environment, and Labs 04 through 06 don't require Lab 03, an SBC, or a phone number.
- **Your lab domain comes from Lab 03.** Lab 03 uses the lab domain `lab<LAB NUMBER>.o365ready.com`. You get your lab number in Exercise 1, Task 2.
- **Expect delays.** DNS can take a few minutes to update, a policy can take up to 15 minutes to apply, and Teams Premium branding can take another 30 minutes to appear.
- **Don't convert the trial.** The trial tenant can't be accessed after class and must not be converted to a paid subscription.

## The labs

{% assign course = site.data.course %}
{% for section in course.sections %}{% for group in section.groups %}
**{{ group.title }}**

{% for item in group.items %}- [{{ item.title }}]({{ item.url | relative_url }}){% if item.minutes %} ({{ item.minutes }} minutes){% endif %}
{% endfor %}
{% endfor %}{% endfor %}
When you're ready, start with Lab 01.

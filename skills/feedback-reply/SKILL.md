---
name: feedback-reply
description: Draft and send personalized email replies to customer feedback. Maps feedback to topic-based response templates and creates Outlook drafts.
disable-model-invocation: true
argument-hint: [path-to-csv]
---

# Feedback Reply Skill

You are helping a Buildertrend product designer reply to customer feedback.

## Step 1: Ingest and Summarize Feedback

Ask the user to provide their feedback data as a CSV or spreadsheet (file path or paste). The data should include at minimum: user name, email, and feedback text. It may also include columns like: User ID, Builder, Builder ID, Role, Rating, Extra Info, Demo Builder, Feedback ID, Date. Adapt to whatever columns are present.

After ingesting:
1. Filter out empty rows and demo builders (Demo Builder = "Yes").
2. Consolidate duplicate users (same person submitted multiple times).
3. **Summarize the feedback** by presenting:
   - Total number of unique users
   - A breakdown of the top themes/topics found in the feedback (e.g., "12 users mentioned mobile app access, 8 mentioned markups, 5 mentioned printing")
   - Average rating if ratings are provided
   - Any bug reports or broken-feature callouts flagged separately
4. Present this summary to the user.

## Step 2: Get Response Templates

After the summary, ask:

**"Do you have a template document with your topic-based response blocks? If so, provide the file path or paste them here. If not, I can draft suggested responses for each theme based on the feedback -- just let me know."**

Explain that topic blocks are pre-written responses for common feedback themes (like "Mobile App", "Markups", "Export/Print") that get mixed and matched per user based on what they wrote about.

If the user wants you to draft responses, write a suggested template for each theme identified in the summary. Present them for the user to review and edit before proceeding.

When mapping feedback to topics, look for these common patterns:
- **Markups / Annotations / Redlining**: Requests for drawing on plans, annotating, redlining, measurement tools
- **Mobile App**: Can't see on phone/iPad, need app access, field crew access
- **Export / Print**: Download plans, print full set, print all pages
- **Revisions / Version History**: Version control, supersede, update individual pages, track changes
- **Comments / Collaboration**: Commenting, tagging, collaboration on plans
- **Client / Subs Portal Access**: Visibility for homeowners, subcontractors, vendors
- **Folders / Organization**: Organize by category, subfolders, grouping plans
- **Entity Linking**: Connect plans to bids, POs, estimates, to-dos, change orders
- **Notifications**: Alerts when plans are updated
- **Page Navigation / UX**: Hard to navigate, confusing UI, need better browsing
- **Upload Size Limits**: File too large, upload limits
- **Bug Reports**: Something is broken, not working as expected -- flag these separately

## Step 3: Onboarding (First-Time Setup)

Once templates are confirmed, check if `~/.claude/feedback-reply-config.json` exists.

**If it does NOT exist**, ask the following questions ONE AT A TIME (wait for each answer before asking the next):

1. **"What email subject line do you want to use?"** (e.g., "BT Plans feedback")
2. Show the suggested opening and closing templates and ask: **"Here's the default opening and closing I'll use for every email. Want to change either of them?"**

Default opening:
> Hi [First Name],
>
> Thank you for taking the time to share feedback on [Feature Name]. We appreciate hearing how you want to improve the feature.

Default closing:
> In the meantime, if you have any questions or run into anything, don't hesitate to reach out to me!

Do NOT ask for a signature block -- Outlook's auto-signature handles this.

Save all answers to `~/.claude/feedback-reply-config.json` and confirm setup is complete. Show a preview email with a sample name.

**If the config file DOES exist**, read it and tell the user: "I have your settings loaded, sending as '[Subject Line]' for [Feature Name] feedback. Want to update anything before we start drafting?"

## Step 4: Map and Preview

1. Map each feedback entry to one or more topic blocks.
2. **Save the full mapping as a markdown file** in the user's Downloads folder (e.g., `~/Downloads/feedback-mapping-[date].md`). Include a table with: #, Name, Email, Topic(s), and Flags. Also include a flagged items section at the bottom for bug reports, duplicate users, same-company pairs, and unmapped feedback.
3. Tell the user: **"Here's a full mapping of customers to the topic templates I've mapped. I saved it to [file path] -- review it if you like. Here's an example of the first email in your sheet:"**
4. Immediately open a draft of the first email in Outlook so the user can see exactly what they'll get.
5. Then ask: **"Look good? Check the 'From' field -- is it showing your Buildertrend email? If it's showing a personal Gmail or another account instead, I can walk you through fixing that. Otherwise, I'll do the rest in batches of 5. Say 'next' when you're ready, or let me know if you want to change anything."**

### Fixing the From Account

If the user says the From is wrong or showing a personal email:

1. Tell them: **"No problem -- you just need to disable your personal accounts in Outlook's profile settings. Here's how:"**
2. Walk them through these steps:
   - Open Outlook
   - Go to **Outlook menu > Profiles > Manage Profiles** (or search "Profiles" in Outlook settings)
   - In the Profiles window, under **Accounts**, uncheck any non-Buildertrend email accounts (e.g., personal Gmail accounts)
   - Leave only the Buildertrend account checked
   - Close the Profiles window
3. Then recreate the preview draft and ask them to confirm the From is now correct.
4. Once confirmed, proceed with batches.

## Step 5: Draft Emails

Create email drafts in Outlook for Mac using the HTML file + AppleScript approach.

### Email HTML Format

Always use this HTML structure (critical for Outlook paragraph spacing):

```html
<html>
<body style="font-family: Calibri, sans-serif; font-size: 11pt;">
<p>Opening paragraph</p>

<p>Topic block 1</p>

<p>Topic block 2</p>

<p>Closing paragraph</p>

<p><span style="background-color: [highlight color];">[Highlighted line if configured]</span></p>

<p>Sign-off paragraph</p>
</body>
</html>
```

### Creating Outlook Drafts

Use this exact approach (writing HTML to a temp file, then reading it via AppleScript):

```bash
cat > /tmp/email_username.html << 'HTMLEOF'
[HTML content here]
HTMLEOF

osascript << 'ASEOF'
set htmlContent to read POSIX file "/tmp/email_username.html" as «class utf8»
tell application "Microsoft Outlook"
    set newMessage to make new outgoing message with properties {subject:"[SUBJECT]", content:htmlContent}
    tell newMessage
        make new to recipient with properties {email address:{address:"[EMAIL]"}}
    end tell
    open newMessage
end tell
ASEOF
```

**Important**: Do NOT use AppleScript string escaping for the body. Always write to a temp file and read it back. This is the only approach that preserves paragraph spacing in Outlook for Mac.

Open drafts in batches of 5 so the user can review and send without being overwhelmed. After each batch, tell the user which emails have been drafted, how many remain, and ask "Ready for the next 5?"

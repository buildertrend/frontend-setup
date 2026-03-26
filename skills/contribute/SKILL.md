---
name: contribute
description: Guide the user through making changes to the Buildertrend frontend — from setting up a safe copy to submitting changes for review. Activate when the user wants to edit, update, fix, or change something in BTNet.
---

You are guiding a non-technical user (designer or PM) through the full process of making changes to the Buildertrend frontend. This covers everything from getting set up to submitting their work for a teammate to review.

You know about these other skills and should use them when appropriate:

- `/frontend-setup:branch-management` — sets up a safe copy of the project so the user's changes don't affect the main codebase
- `/frontend-setup:preview` — starts the app locally so the user can see their changes in the browser

## Language rules

Never use these technical terms with the user. Use the plain-English alternative instead:

| Don't say | Say instead |
|---|---|
| branch | "your own copy" or "safe copy" |
| commit | "save your changes" or "save point" |
| push | "upload your changes" |
| pull request / PR | "send your changes for review" or "submit for review" |
| merge | "add your changes to the main project" |
| repository / repo | "the project" or "the codebase" |
| diff | "what changed" |

If the user uses technical terms, that's fine — understand them but respond in plain language.

**IMPORTANT: Never combine commands with shell operators.** No `&&`, `||`, `;`, `|`, `>`, `<`, `` ` ``, `$(...)`, or `eval`. Always run each command as a separate Bash tool call.

## Step 1: Make sure they have a safe copy

Before any edits happen, the user needs to be working on their own copy — not the main project directly.

Use the `/frontend-setup:branch-management` skill to handle this. It will find the BTNet project, check whether the user already has a safe copy, and create one if needed.

If branch-management finds the user is already on their own copy, continue to Step 2.

## Step 2: Help make changes

Ask the user what they'd like to change if they haven't already said. Then help them find the right files and make the edits.

After each change, briefly explain what you did in plain English. For example: "I updated the header color from blue to green."

If they want to see how their changes look, offer to run `/frontend-setup:preview` to open the app in their browser.

## Step 3: Save changes

After a logical set of changes (or when the user pauses), proactively offer to save. Say something like: "Want me to save what we've done so far?"

When they agree:

1. `cd` into the BTNet directory if not already there.
2. Run `git add -A`.
3. Run `git status` to see what changed.
4. Summarize the changes to the user in plain English.
5. Write a commit message following the project's conventions: a short description of the user-facing effect.
6. Run `git commit -m "<message>"`.
7. Tell the user: **"I've saved your changes. You can keep making more changes, or we can send these for review."**

You can repeat this step multiple times if the user keeps making changes.

## Step 4: Send for review

When the user is ready to submit, or after saving their last set of changes, offer to send their work for review.

When they agree:

1. Run `git push` to upload the changes.
   - If this fails because there's no remote copy yet, run `git push --set-upstream origin <branch-name>`.
   - If push fails for auth reasons, tell the user their credentials may have expired. Point them to the Azure DevOps Git credentials page and ask them to generate a new password, then try again.

2. Create a review request using the Azure DevOps MCP tools:
   - Title: a short summary of what changed (derived from the commit messages)
   - Description: a plain-English summary of what was changed and why, written for the reviewer
   - Target branch: `master`

3. Share the link with the user and tell them: **"Your changes have been sent for review. A teammate will look at them and either approve them or suggest adjustments. You can use this link to check on the status."**

## Step 5: What happens next

Briefly explain:

- A developer will review their changes
- They might leave comments or ask for small tweaks
- Once approved, the changes get added to the main project
- If they need to make more changes later, they can come back and use this skill again

## Troubleshooting

- **Upload fails with an auth error:** The user's credentials may have expired. Have them visit their Azure DevOps Git credentials page to generate a new password.
- **Changes conflict with someone else's work:** This is beyond what most non-technical users can resolve. Tell them to reach out to **Michael Hanson** for help.
- **Azure DevOps connection isn't working:** The user may need to connect it. Tell them to run `/frontend-setup:first-time-setup` and skip ahead to the "Connect your tools" step.

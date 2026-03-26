---
name: branch-management
description: Ensure the user is on a feature branch before making changes to code in the BTNet project. Activate when about to edit, create, or modify files in BTNet.
---

You are helping a non-technical user (designer or PM) make sure their changes are on a separate branch before editing any code. This keeps the main codebase safe and makes it easy to review changes later.

## Your approach

- Use simple, non-technical language
- Say "your own workspace" or "a safe copy" instead of "branch"
- Do this check quickly — don't over-explain unless the user asks

**IMPORTANT: Never combine commands with shell operators.** No `&&`, `||`, `;`, `|`, `>`, `<`, `` ` ``, `$(...)`, or `eval`. Always run each command as a separate Bash tool call.

## Step 1: Find the BTNet repo

Look for a `BTNet` directory. Check common locations:

- The user's home directory (e.g., `~/BTNet`)
- The desktop (e.g., `~/Desktop/BTNet`)
- Common dev folders (e.g., `~/dev/BTNet`, `~/repos/BTNet`, `~/code/BTNet`)
- Documents and Downloads (e.g., `~/Documents/BTNet`, `~/Downloads/BTNet`)

Run `ls` on each candidate path to find it. Verify it's the right project by checking that `Clients.App` exists inside it.

If you can't find it, ask the user where it is. If they don't have it, tell them to run `/frontend-setup:first-time-setup` first, then stop.

Once found, `cd` into the BTNet directory.

## Step 2: Check the current branch

Run `git branch --show-current`.

- If the user is on `master` or `main`: continue to Step 3.
- If the user is on any other branch: they already have their own workspace. Tell them briefly ("You're already working in your own workspace — go ahead and make your changes.") and stop.
- If git fails or the directory isn't a repo: stop — something is wrong. Tell the user to reach out to **Michael Hanson** for help.

## Step 3: Pull the latest changes

Run `git pull` to make sure master is up to date.

If this fails (network issues, auth problems), tell the user it's OK and continue — they'll just be working from a slightly older copy.

## Step 4: Ask what they're working on

Ask the user two things in a single message:

1. **"Do you have a ticket number?"** (e.g., "ado-231499"). Tell them it's fine if they don't.
2. **"In a few words, what are you changing?"** (e.g., "update the header color", "fix login button spacing")

Wait for their response.

## Step 5: Create the branch

Using their answers, build a branch name.

**Sanitization rules (apply these yourself, don't explain them to the user):**

- Take the description, lowercase it
- Replace spaces with hyphens
- Remove anything that isn't a letter, number, or hyphen
- Collapse multiple hyphens into one
- Trim to 40 characters max (don't cut mid-word)
- If they gave a ticket ID, extract just the number (e.g., "ado-231499" becomes "231499") and prepend it: `<number>-<description>`
- If no ticket: just `<description>`

**Examples:**

- Ticket "ado-231499", description "Update header color" -> `231499-update-header-color`
- No ticket, description "Fix the login button spacing!" -> `fix-the-login-button-spacing`

Run:

```bash
git checkout -b <branch-name>
```

Tell the user: "I've set up a safe workspace for your changes. Everything you do from here won't affect the main project until someone reviews it."

## Step 6: Done

Let the user continue with whatever they were about to do. Don't prompt for anything else.

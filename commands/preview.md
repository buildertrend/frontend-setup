---
description: Start the dev server and open the Buildertrend frontend in your browser. Use when someone asks to run the code, preview their changes, or see the frontend.
---

You are helping a non-engineering user see the Buildertrend frontend in their browser. They have already completed the initial setup using `/frontend-setup:start` and now want to view or preview the UI.

## Your approach

- Be patient and use simple, non-technical language
- Explain what each step does in plain English before running it
- Detect their OS automatically and adjust all commands accordingly
- If something is missing, tell the user to run `/frontend-setup:start` to complete the initial setup first, then stop

**IMPORTANT: Never combine commands with shell operators.** No `&&`, `||`, `;`, `|`, `>`, `<`, `` ` ``, `$(...)`, or `eval`. Always run each command as a separate Bash tool call.

## Step 1: Find the BTNet repo

Look for a `BTNet` directory. Check common locations:

- The user's home directory (e.g., `~/BTNet`)
- The desktop (e.g., `~/Desktop/BTNet`)
- Common dev folders (e.g., `~/dev/BTNet`, `~/repos/BTNet`, `~/code/BTNet`)

Run `ls` on each candidate path to find it. If you can't find it anywhere, tell the user:

- "I can't find the project on your computer. It may not have been downloaded yet."
- "Run `/frontend-setup:start` to set everything up from scratch."

Then stop — do not continue with the remaining steps.

Once found, `cd` into the BTNet directory.

## Step 2: Quick prerequisite check

Run these checks silently (no need to explain each one to the user unless something is wrong):

1. `node --version` — must be >=22.12.0 <23. If wrong, run `fnm use 22`. If fnm is missing, tell the user to run `/frontend-setup:start`.
2. `pnpm --version` — must be >=10.0.0. If missing, tell the user to run `/frontend-setup:start`.
3. Check that the file `Clients.App/.env.development.local` exists. If missing, create it with this content:

```
VITE_WARN_FLAGS=true
VITE_APIX_PROXY=https://api.test.buildertrend.net
VITE_WEBFORMS_URL=https://test.buildertrend.net
```

## Step 3: Check the hosts file

**On Mac:** Read `/etc/hosts` and look for a line containing `local.buildertrend.net`. If it's already there, skip to the next step.

If missing, walk the user through adding it:

1. Tell them to open a terminal window
2. Tell them to type this command and press Enter: `sudo sh -c 'echo "127.0.0.1 local.buildertrend.net" >> /etc/hosts'`
3. Tell them the terminal may ask for their Mac login password — they should type it and press Enter (the password won't be visible as they type)
4. Ask them to let you know once it's done

**On Windows:** Read `C:\Windows\System32\drivers\etc\hosts` and look for `local.buildertrend.net`. If missing, walk the user through editing it:

1. Click the Start menu and search for **Notepad**
2. Right-click on Notepad and choose **Run as administrator**
3. In Notepad, go to **File → Open** and navigate to `C:\Windows\System32\drivers\etc\`
4. In the file type dropdown (bottom-right of the Open dialog), change it from "Text Documents" to **All Files**
5. Select the file called **hosts** and click Open
6. At the very bottom of the file, add a new line: `127.0.0.1 local.buildertrend.net`
7. Save the file (Ctrl+S) and close Notepad

After adding the entry on either OS, verify it worked by reading the hosts file again.

## Step 4: Check if the server is already running

**On Mac:** Run `lsof -i :443`. If the output shows a process listening on port 443, the server is already running — skip to Step 6.

**On Windows:** Run `netstat -ano -p TCP` and look for `:443` in the output. If present, the server is already running — skip to Step 6.

## Step 5: Start the dev server

First, change into the Clients.App directory:

```bash
cd Clients.App
```

**On Mac**, the dev server needs elevated permissions:

```bash
sudo pnpm run start
```

Tell the user they may be prompted for their Mac login password.

**On Windows:**

```bash
pnpm run start
```

If you are unable to run the dev server (permission issues, hangs, gets blocked), walk the user through doing it manually:

1. Open a new terminal window
2. Navigate to the Clients.App folder inside BTNet (give them the exact `cd` command with the full path)
3. On Mac: run `sudo pnpm run start` and enter their password if prompted
4. On Windows: run `pnpm run start`
5. Wait for the terminal to show that the server is ready

## Step 6: Open the browser

Tell the user to open their browser and go to: **https://local.buildertrend.net:443/**

Confirm with the user that they can see the Buildertrend UI in their browser.

## Troubleshooting

- **Browser shows blank page or errors**: Check the terminal for error output. The dev server may still be starting up — wait for the "ready" message.
- **"Cannot find module" errors**: Dependencies may need reinstalling. Run `rm -rf node_modules && pnpm install` from the BTNet root directory.
- **Node version errors**: Run `fnm use 22` to switch to the correct version.
- **Port 443 already in use but no server visible**: Another process may be using port 443. On Mac, run `lsof -i :443` to see what it is. The user may need to stop that process first.
- **Login/authentication issues (Auth0)**: The user must sign in with their **@buildertrend.com** email address.

If you can't resolve an issue, tell the user to reach out to **Michael Hanson** for help.

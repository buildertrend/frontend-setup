---
name: first-time-setup
description: Walk through setting up the Buildertrend frontend on your local machine. For designers and PMs who are new to development tools.
---

You are helping a non-engineering user (probably a designer or PM) set up the BTNet frontend on their local machine. They may have little to no experience with terminals, Git, or development tools.

## Your approach

- Be patient and use simple, non-technical language
- Explain what each step does in plain English before running it
- Explain why you're running a command before you run it (use plain English)
- Avoid technical terms or command names when communicating with the user
- Detect their OS automatically and adjust all commands accordingly
- Check for each prerequisite before installing — don't reinstall things that already exist
- If something fails, explain what went wrong simply and try the fallback approach
- When something goes wrong and the user needs help, ask them to copy and paste the text from their terminal into the chat so you can see the error. Explain how to select and copy text from the terminal if needed.

**IMPORTANT: Never combine commands with shell operators.** No `&&`, `||`, `;`, `|`, `>`, `<`, `` ` ``, `$(...)`, or `eval`. Always run each command as a separate Bash tool call. The only exception is piping to `pbcopy` or `clip` to copy a command to the clipboard (see below).

**Copy commands to the clipboard automatically.** Whenever a step requires the user to run a command in a separate terminal, copy the command to their clipboard before telling them to run it. On Mac, use `echo <command> | pbcopy`. On Windows, use `echo <command> | clip`. Then tell the user the command has been copied to their clipboard and they just need to paste it into their terminal and press Enter.

## Goal

Get the Buildertrend frontend (Clients.App) running locally in their browser so they can view and interact with the UI connected to our shared test environment.

## Step 1: Detect OS and check prerequisites

First, detect whether this is Mac or Windows.

**On Mac only — check for admin privileges first:**

Run `id -Gn | grep -q admin` to check if the user has admin access. If they do NOT (the command exits with a non-zero code), stop the setup and explain:

- "Your computer account doesn't have permission to install the tools we need."
- "Please reach out to **Team Help** to get admin access on your Mac, then come back and run this again."

Do not continue with any installation steps if the user is not an admin on Mac.

**If the user is an admin (or on Windows),** check for each of these and install any that are missing:

**On Mac:**
1. Xcode Command Line Tools — check with `xcode-select -p`. If missing, run `xcode-select --install` and wait for the user to complete the system dialog.
2. Homebrew — check with `brew --version`. If missing, install using two steps: first download the installer with `curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/brew_install.sh`, then run it with `NONINTERACTIVE=1 bash /tmp/brew_install.sh`. After install, follow any "Next steps" instructions the installer prints (usually adding Homebrew to PATH).
3. fnm (Fast Node Manager) — check with `fnm --version`. If missing, install via Homebrew: `brew install fnm`, then add fnm's shell initialization to their shell profile (`fnm env --use-on-cd` — see https://github.com/Schniz/fnm#shell-setup).
4. Node.js 22.x — check with `node --version`. Need version >=22.12.0 <23. If missing or wrong version, use `fnm install 22` then `fnm use 22`.
5. corepack and pnpm — run `corepack enable` then verify with `pnpm --version`. Need version >=10.0.0.

**On Windows:**
1. Git — check with `git --version`. If missing, install via `winget install Git.Git` or direct them to https://git-scm.com/download/win.
2. fnm (Fast Node Manager) — check with `fnm --version`. If missing, install via `winget install Schniz.fnm`, then add fnm's shell initialization to their shell profile (see https://github.com/Schniz/fnm#shell-setup).
3. Node.js 22.x — check with `node --version`. Need version >=22.12.0 <23. If missing or wrong version, use `fnm install 22` then `fnm use 22`.
4. corepack and pnpm — run `corepack enable` then verify with `pnpm --version`. Need version >=10.0.0.

Tell the user what you found and what you're going to install before proceeding.

## Step 2: Check for an existing copy of the project

Before downloading anything, check if the project is already on this computer. Look for a `BTNet` directory in these common locations:

- The user's home directory (e.g., `~/BTNet`)
- The desktop (e.g., `~/Desktop/BTNet`)
- Common dev folders (e.g., `~/dev/BTNet`, `~/repos/BTNet`, `~/code/BTNet`)
- Documents and Downloads (e.g., `~/Documents/BTNet`, `~/Downloads/BTNet`)

Run `ls` on each candidate path to find it. If you find a `BTNet` directory, verify it's the right project by checking that `Clients.App` exists inside it (run `ls` on the `BTNet/Clients.App` path).

**If found:** Tell the user you found an existing copy. Ask if they need to re-run any setup steps — for example, reinstalling dependencies, reconfiguring the environment, or connecting tools. If they do, `cd` into the BTNet directory and skip ahead to the relevant step. If they don't need anything, suggest:

- Run `/frontend-setup:preview` to start the app and see it in your browser
- Run `/frontend-setup:contribute` to make changes to the frontend

Then stop — do not continue with the remaining steps.

**If not found:** Ask the user: "I don't see the project on your computer yet. Have you downloaded it before? If so, let me know where it is. Otherwise, we'll download it now." If the user provides a path, verify it the same way (check for `Clients.App` inside it). If they say no, continue with Steps 3 and 4.

## Step 3: Generate Git credentials (MANUAL — user must do this in their browser)

*Skip this step if you already found the project in Step 2.*

This is the one step that cannot be automated. Walk the user through it clearly:

1. Tell the user to open the BTNet repository in Azure DevOps (ADO). If they don't have the link, tell them to reach out to **Michael Hanson**.
2. They may need to sign in with their Buildertrend Microsoft/Azure account.
3. Once on the page, they should click the **"Clone"** button in the upper right area of the page.
4. In the dropdown that appears, under the HTTPS section, they should click **"Generate Git Credentials"**.
5. This will show them a **username** and **password** — tell them to keep this page open or copy both values somewhere, they'll need them in a moment. Make sure they know this is a **separate password from their computer login password** — it's a special one-time password just for downloading the project.
6. They should also copy the **clone URL** shown in that same dropdown (under HTTPS). They'll need this in the next step.

If they can't find "Generate Git Credentials" or run into issues with this step, tell them to reach out to **Michael Hanson** for help before continuing.

Ask the user to confirm when they have their credentials and clone URL ready before continuing.

## Step 4: Clone the repository

*Skip this step if you already found the project in Step 2.*

**Important:** You cannot run `git clone` yourself because it will prompt for the Git credential password (the one they generated in Azure DevOps, NOT their computer login password), which requires interactive input that Claude cannot handle. Instead, walk the user through running it themselves in a separate terminal window:

1. Tell the user to open a new terminal window (on Mac: open the Terminal app; on Windows: open PowerShell or Command Prompt)
2. Tell them to type `git clone` followed by the clone URL they copied in Step 2, then press Enter. (Give them an example of how the command will look, like `git clone https://...`)
3. Tell them the terminal will ask for a password — they should paste the **Git credential password they generated in Azure DevOps** (NOT their computer login password) and press Enter (the password won't be visible as they type).
4. Warn them that cloning can take several minutes — it's a large codebase. Tell them to sit tight and let you know when the download finishes. Don't assume it failed just because it's taking a while.
5. Ask the user to let you know once the clone is complete, then continue from here.

After cloning, cd into the repo:

```bash
cd BTNet
```

## Step 5: Authenticate to the private package feed and install dependencies

The project uses private npm packages that require authentication. This step needs to open a browser window for sign-in, so the user must run it themselves — Claude cannot open browsers.

First, figure out the full path to the BTNet repo. Run `pwd` to see where you are. If you cloned it in Step 4, check if a `BTNet` folder exists nearby. Construct the full path to it.

Walk the user through running the command in their terminal:

1. Tell them to open a terminal window (or use an existing one)
2. Tell them to navigate to the BTNet folder by typing `cd <full path to BTNet>` — give them the exact command with the actual path filled in
3. Tell them to type `pnpm run setup-project` and press Enter
4. Tell them a browser window should open asking them to sign in — they should sign in with their Buildertrend Microsoft/Azure account
5. After signing in, the terminal will continue and install all the project's dependencies. This can take several minutes.
6. Ask the user to let you know once the command finishes

**If this fails (especially on Mac)**, tell the user to try the cross-platform alternative instead: have them run `pnpm run setup-btfeedauth-crossplatform` first, then `pnpm install`, in the same terminal.

**If both fail**, tell the user to reach out to **Michael Hanson** for help with package feed authentication before continuing.

After the user reports success, ask if they saw any errors in the output before moving on.

## Step 6: Configure the environment

Create the file `Clients.App/.env.development.local` with this content:

```
VITE_WARN_FLAGS=true
VITE_APIX_PROXY=https://api.test.buildertrend.net
VITE_WEBFORMS_URL=https://test.buildertrend.net
```

This tells the frontend to connect to the shared test environment instead of looking for a local backend server.

## Step 7: Add the local development address

The dev server uses a custom address (`local.buildertrend.net`) that your computer doesn't know about yet. You need to add an entry to your computer's hosts file so it knows that address points to your own machine.

First, read the hosts file to check if the entry already exists:

**On Mac:** Read `/etc/hosts` and look for a line containing `local.buildertrend.net`. If it's already there, skip to the next step.

If the entry is missing, you cannot run this command yourself because it requires admin permissions and file redirection that Claude can't do. Walk the user through running it in a separate terminal:

1. Tell them to open a new terminal window (or use an existing one)
2. Tell them to type this command and press Enter: `sudo sh -c 'echo "127.0.0.1 local.buildertrend.net" >> /etc/hosts'`
3. Tell them the terminal may ask for their Mac login password — they should type it and press Enter (the password won't be visible as they type)
4. Ask them to let you know once it's done

**On Windows:** This step must be done manually. Walk the user through it:

1. Click the Start menu and search for **Notepad**
2. Right-click on Notepad and choose **Run as administrator**
3. In Notepad, go to **File → Open** and navigate to `C:\Windows\System32\drivers\etc\`
4. In the file type dropdown (bottom-right of the Open dialog), change it from "Text Documents" to **All Files**
5. Select the file called **hosts** and click Open
6. At the very bottom of the file, add a new line: `127.0.0.1 local.buildertrend.net`
7. Save the file (Ctrl+S) and close Notepad

After adding the entry on either OS, verify it worked by reading the hosts file again and confirming the line is present.

## Step 8: Start the app

Now let's get the app running. Invoke `/frontend-setup:preview` — it will start the dev server and help the user open it in their browser.

Wait for the user to confirm the app is working before continuing to Step 9.

## Step 9 (optional): Connect Figma, Azure DevOps, and Confluence

This step is optional — the frontend is already running. But connecting these tools lets Claude help the user work with designs in Figma, work items in Azure DevOps, and documentation in Confluence directly from the chat.

Tell the user you're going to connect three tools they may use in their day-to-day work: **Figma** (for viewing designs), **Azure DevOps** (for viewing work items and code), and **Confluence** (for viewing wiki pages and documentation). Explain that each one may open a browser window asking them to sign in.

**Connect Azure DevOps:**

1. Tell the user you're going to try connecting to Azure DevOps, and that a browser window may open for sign-in.
2. Attempt a simple read-only call to the Azure DevOps MCP server (e.g., list repositories or get project info).
3. If the user is prompted to sign in, tell them to use their **Buildertrend Microsoft/Azure account**.
4. If it succeeds, let the user know Azure DevOps is connected.
5. If it fails, tell them it's not required and they can try again later, or reach out to **Michael Hanson** for help.

**Connect Figma:**

1. Tell the user you're going to try connecting to Figma, and that a browser window may open for sign-in.
2. Attempt a simple read-only call to the Figma MCP server (e.g., get the current user's info or list recent files).
3. If the user is prompted to sign in, tell them to use their **Figma account** (the one associated with their Buildertrend team).
4. If it succeeds, let the user know Figma is connected.
5. If it fails, tell them it's not required and they can try again later, or reach out to **Michael Hanson** for help.

**Connect Confluence:**

1. Tell the user you're going to try connecting to Confluence, and that a browser window may open for sign-in.
2. Attempt a simple read-only call to the Confluence MCP server (e.g., search for a page or list spaces).
3. If the user is prompted to sign in, tell them to use their **Buildertrend Microsoft/Azure account** (the same one they use for other Buildertrend tools).
4. If it succeeds, let the user know Confluence is connected.
5. If it fails, tell them it's not required and they can try again later, or reach out to **Michael Hanson** for help.

If any tool connects without prompting for sign-in, that means the user is already authenticated — just let them know it's ready to use.

## Troubleshooting

If something goes wrong, here are common issues:

- **"Out of memory" or crashes during install/start**: The project needs ~16GB RAM. If their machine has less, this may be a problem. There's no easy fix — they may need a more powerful machine.
- **"Cannot find module" or "ERR_MODULE_NOT_FOUND"**: Dependencies didn't install properly. Run `rm -rf node_modules && pnpm install` from the BTNet root directory.
- **"Unauthorized" or "401" during pnpm install**: The package feed authentication expired or failed. Re-run `pnpm run setup-bt-feed-credentials` or `pnpm run setup-btfeedauth-crossplatform`.
- **Node version errors**: Make sure they're on Node 22.x with `node --version`. Use `fnm use 22` to switch.
- **Git credential issues**: If the clone fails with auth errors, double-check they're using the correct username/password from ADO. They can re-generate credentials.
- **"EACCES" permission errors on Mac**: May need to fix npm global permissions. First run `whoami` and `npm config get prefix` to get the username and npm prefix path, then run `sudo chown -R <username> <prefix>/{lib/node_modules,bin,share}` with those literal values filled in.
- **Browser shows blank page or errors**: Check the terminal for error output. The dev server may still be starting up — wait for the "ready" message before opening the browser.
- **Login/authentication issues (Auth0)**: The user must sign in with their **@buildertrend.com** email address. If their Buildertrend account uses a different email, they'll need to update it first: go to https://buildertrend.net, sign in, navigate to **Security & Login -> Edit Username**, and change it to their @buildertrend.com email.

If you can't resolve an issue using the steps above, tell the user to reach out to **Michael Hanson** for help.

# Buildertrend Product Toolkit

Claude Code plugins for designers, PMs, and other non-engineering roles at Buildertrend.

## Plugins

### Frontend Setup

A single plugin with several skills, such as:

- **First time setup** — Full setup flow: installs tools, gets credentials, downloads code, and starts the app.
- **Preview** — Starts the dev server and opens the frontend in your browser.
- **Contribute** — Guides you through making changes end-to-end: setting up a safe copy, editing files, saving your work, and submitting it for review.

## How to use it

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and working
- **macOS users:** admin privileges on your account (needed to install tools and run the dev server)
- A Buildertrend Microsoft/Azure account
- The URL for BT's code repository

### Setup

1. Open a terminal
2. Type `claude` and press Enter
3. Type each of these commands into the Claude prompt and press Enter after each one:

    ```text
    /plugin marketplace add buildertrend/product-toolkit
    ```

    ```text
    /plugin install frontend-setup
    ```

    When prompted, select **"Install for you (user scope)"** and press Enter.

    ```text
    /reload-plugins
    ```

    Switch to Claude's smartest model:

    ```text
    /model opus
    ```

    ```text
    /frontend-setup:first-time-setup
    ```

That last command kicks off the setup. Here's what it does:

1. **Checks your computer** — detects your OS and installs any missing tools automatically
2. **Helps you get credentials** — walks you through generating credentials to download our code from Azure DevOps
3. **Downloads the code**
4. **Installs dependencies** — authenticates with the private package feed and installs dependencies our code needs
5. **Configures the environment** — sets up the connection to the shared test environment
6. **Starts the app** — launches the dev server and opens it in your browser

When it's done, you'll have the Buildertrend frontend running at `https://local.buildertrend.net:443/`.

Next time you want to start the app, just run `/frontend-setup:preview` — it skips the initial setup and goes straight to launching the dev server.

### Uninstall

Open Claude Code and paste:

```text
Help me uninstall the frontend-setup plugin.
```

## Features

- **Simple language** — no technical jargon; everything is explained in plain English
- **Auto-approval** — safe commands are approved automatically so you aren't interrupted by permission prompts
- **Cross-platform** — works on Mac and Windows
- **Error recovery** — if something fails, Claude tries to fix it before asking for help
- **Figma integration** — Claude can read your Figma designs
- **Azure DevOps integration** — Claude can access repos, work items, and wiki
- **Confluence integration** — Claude can access wiki pages and documentation

## What this plugin installs

The setup process installs standard development tools as needed:

- **Xcode Command Line Tools** (Mac only)
- **Homebrew** (Mac only)
- **fnm** (Fast Node Manager) — manages Node.js versions
- **Node.js 22.x** — the JavaScript runtime
- **pnpm** — the package manager used by the project

The plugin only modifies files within the BTNet repository directory. Nothing is installed globally beyond the tools listed above.

## Need help?

If you run into issues at any point, reach out to **Michael Hanson**.

## Contributing

### Repo structure

```
product-toolkit/
├── .claude-plugin/
│   ├── marketplace.json      # Marketplace manifest (for plugin install)
│   └── plugin.json           # Plugin manifest (metadata, hooks)
├── .mcp.json                 # Figma, Azure DevOps + Confluence MCP configuration
├── skills/
│   ├── first-time-setup/
│   │   └── SKILL.md          # /frontend-setup:first-time-setup — full setup flow
│   ├── preview/
│   │   └── SKILL.md          # /frontend-setup:preview — start dev server
│   ├── contribute/
│   │   └── SKILL.md          # /frontend-setup:contribute — make and submit changes
│   └── branch-management/
│       └── SKILL.md          # Guides users onto a feature branch
├── scripts/
│   └── approve-commands.sh   # PermissionRequest hook — auto-approves safe commands
├── CLAUDE.md                 # Behavior guidelines for Claude
├── CHANGELOG.md
├── mise.toml                 # Linting, validation, and hook tests
└── README.md
```

### How it works

This is a [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin with **skills** and an **auto-approval hook**:

- **`/frontend-setup:first-time-setup`** is the main skill. It contains a detailed step-by-step guide that Claude follows to walk the user through the full setup process.
- **`/frontend-setup:preview`** is a lighter skill that starts the dev server for users who have already completed initial setup.
- **`/frontend-setup:contribute`** guides users through making changes end-to-end: setting up a safe copy, editing files, saving work, and submitting it for review. Delegates to `branch-management` and `preview` as needed.
- **`branch-management`** is a skill that activates when a user is about to edit code in BTNet. It guides them onto a feature branch using simple, non-technical language.
- **`.mcp.json`** configures Figma, Azure DevOps, and Confluence MCP servers so Claude can access designs, work items, and documentation.
- **`scripts/approve-commands.sh`** is a PermissionRequest hook that auto-approves safe commands (file reads, git, brew, fnm, node, pnpm, etc.) so non-technical users don't get bombarded with permission prompts. Unrecognized commands are still surfaced for manual approval.
- **`mise.toml`** defines automated checks — markdown linting, plugin structure validation, and hook tests.

### Making changes

1. Clone the repo
2. Edit the files you want to change
3. Run automated checks:

    ```bash
    mise run test
    ```

4. Test locally:

    ```bash
    claude --plugin-dir .
    ```

5. Run `/frontend-setup:first-time-setup` to verify the flow works
6. Open a PR

Use conventional commit messages with the plugin name as scope (e.g., `feat(frontend-setup): Add preview command`). Write the message in plain English describing the user-facing effect, not the code change.

### Testing

Run automated checks (markdown linting, JSON validation, structure validation, hook tests):

```bash
mise run test
```

Then load the plugin from a local checkout for manual testing:

```bash
claude --plugin-dir /path/to/product-toolkit
```

Manual checklist:

- [ ] `/frontend-setup:first-time-setup` detects OS and checks prerequisites correctly
- [ ] Missing tools are installed without errors
- [ ] Credential generation instructions are clear
- [ ] Dependency install completes successfully
- [ ] Environment file is created with correct values
- [ ] Dev server starts and the app loads in the browser
- [ ] `/frontend-setup:preview` starts the server and opens the app
- [ ] `/frontend-setup:contribute` walks through making a change and submitting it

### Editing skills

Each skill lives in `skills/<name>/SKILL.md`. Key things to preserve when editing any skill:

- **Non-technical language** — users are designers and PMs, not developers
- **Step ordering** — later steps depend on earlier ones completing successfully
- **Manual steps** — Git credential generation and `git clone` must be done by the user (Claude can't handle interactive password prompts)
- **Error handling** — fallback commands are included for steps that commonly fail
- **Troubleshooting section** — covers the most common issues users hit

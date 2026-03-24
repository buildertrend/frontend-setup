# Buildertrend Frontend Setup

A Claude Code plugin that walks designers, PMs, and other non-technical users through setting up the Buildertrend frontend (Clients.App) on their local machine. No coding knowledge needed — just follow the prompts.

## Install

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and working
- **macOS users:** admin privileges on your account (needed to install tools and run the dev server)
- A Buildertrend Microsoft/Azure account
- The URL for BT's code repository

### Setup

1. Add the Buildertrend marketplace (one-time):

    ```bash
    claude plugin marketplace add buildertrend/buildertrend-frontend-setup
    ```

2. Install the plugin:

    ```bash
    claude plugin install buildertrend-frontend-setup
    ```

### Uninstall

```bash
claude plugin remove buildertrend-frontend-setup
```

## Usage

1. Open a terminal
2. Type `claude` and press Enter
3. Run the setup command:

    ```text
    /frontend-setup
    ```

Claude walks you through the entire process step by step:

1. **Checks your computer** — detects your OS and installs any missing tools automatically
2. **Helps you get credentials** — walks you through generating Git credentials in Azure DevOps
3. **Downloads the code** — guides you through cloning the repository
4. **Installs packages** — authenticates with the private package feed and installs dependencies
5. **Configures the environment** — sets up the connection to the shared test environment
6. **Starts the app** — launches the dev server and opens it in your browser

When it's done, you'll have the Buildertrend frontend running at `https://local.buildertrend.net:443/`.

## Features

- **Simple language** — no technical jargon; everything is explained in plain English
- **Auto-approval** — safe commands are approved automatically so you aren't interrupted by permission prompts
- **Cross-platform** — works on Mac and Windows
- **Error recovery** — if something fails, Claude tries to fix it before asking for help
- **Figma integration** — Claude can read your Figma designs (sign in when prompted)
- **Azure DevOps integration** — Claude can access repos, work items, and wiki

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
buildertrend-frontend-setup/
├── .claude-plugin/
│   ├── marketplace.json      # Marketplace manifest (for plugin install)
│   └── plugin.json           # Plugin manifest (metadata, hooks)
├── .mcp.json                 # Figma + Azure DevOps MCP configuration
├── commands/
│   └── frontend-setup.md     # /frontend-setup command — the full setup flow
├── scripts/
│   ├── approve-commands.sh   # PermissionRequest hook — auto-approves safe commands
│   └── install-deps.sh       # OS detection and prerequisite checker
├── CLAUDE.md                 # Behavior guidelines for Claude
└── README.md
```

### How it works

This is a [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin with a **setup command** and **auto-approval hook**:

- **`/frontend-setup`** is the main command. It contains a detailed step-by-step guide that Claude follows to walk the user through the full setup process.
- **`.mcp.json`** configures Figma and Azure DevOps MCP servers so Claude can access designs and work items.
- **`scripts/approve-commands.sh`** is a PermissionRequest hook that auto-approves safe commands (file reads, git, brew, fnm, node, pnpm, etc.) so non-technical users don't get bombarded with permission prompts. Unrecognized commands are still surfaced for manual approval.
- **`CLAUDE.md`** instructs Claude to use non-technical language and handle errors silently when possible.

### Making changes

1. Clone the repo
2. Edit the files you want to change
3. Test locally:

    ```bash
    claude --plugin-dir .
    ```

4. Run `/frontend-setup` to verify the flow works
5. Open a PR

### Testing

Load the plugin from a local checkout:

```bash
claude --plugin-dir /path/to/buildertrend-frontend-setup
```

Verify:

- [ ] `/frontend-setup` detects OS and checks prerequisites correctly
- [ ] Missing tools are installed without errors
- [ ] Credential generation instructions are clear
- [ ] Dependency install completes successfully
- [ ] Environment file is created with correct values
- [ ] Dev server starts and the app loads in the browser

### Editing the setup command

The setup command (`commands/frontend-setup.md`) contains the full setup flow. Key things to preserve when editing:

- **Non-technical language** — users are designers and PMs, not developers
- **Step ordering** — later steps depend on earlier ones completing successfully
- **Manual steps** — Git credential generation and `git clone` must be done by the user (Claude can't handle interactive password prompts)
- **Error handling** — fallback commands are included for steps that commonly fail
- **Troubleshooting section** — covers the most common issues users hit

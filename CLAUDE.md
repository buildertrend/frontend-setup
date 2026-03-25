# Buildertrend Product Toolkit

Claude Code plugins for non-technical users (designers, PMs) at Buildertrend.

## Guidelines

- Use red-green TDD when implementing new features and fixing issues
- Use conventional commit prefixes (`fix:`, `feat:`, `chore:`, etc.)
- Write the rest of the message in plain English describing the user-facing effect, not the code change — non-technical users read the changelog
- Example: "fix: Allow the setup tool to search inside files" not "fix: Add grep to allowed commands in approve-commands hook"
- Run `mise run test` when done making changes
- When creating new skills, always create a skill and never a command unless instructed specifically to make a command

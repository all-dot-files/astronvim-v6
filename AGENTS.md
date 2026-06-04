# Agent Instructions for AstroNvim Configuration

This document provides guidelines for AI agents interacting with this Neovim configuration repository.

## Build, Lint, and Test Commands

- **Build:** No build step is necessary. This is a configuration-only project.
- **Lint:** Run `selene .` to lint Lua files. The configuration is in `selene.toml`.
- **Test:** There are no automated tests. Changes must be tested manually by launching Neovim.

## Code Style Guidelines

- **Language:** All configuration is written in Lua.
- **Formatting:** Follow standard Lua formatting conventions. Use `stylua` if available.
- **Imports:** Use `require` for modules.
- **Types:** This project does not use a static type checker for Lua.
- **Naming Conventions:**
  - Use `PascalCase` for modules that return a table with functions.
  - Use `snake_case` for local variables and function names.
- **Error Handling:** Use `pcall` and `xpcall` for error handling where appropriate.
- **General:** Adhere to the existing code style in the `lua/` directory.

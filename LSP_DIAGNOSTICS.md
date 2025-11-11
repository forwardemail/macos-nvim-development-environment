# LSP Diagnostics Guide

This guide explains what LSP diagnostics are, what the hints and icons mean, and how to interact with them.

## What Are LSP Diagnostics?

LSP (Language Server Protocol) diagnostics are real-time code analysis messages from language servers. They include:

- **Errors** (red) - Code that will not compile or run
- **Warnings** (yellow/orange) - Potential issues or bad practices
- **Hints** (green/blue) - Suggestions for improvement
- **Information** (blue) - General information about the code

## Understanding the Green Hints

The green text in the screenshot shows **LSP hints** or **information messages**. These are non-critical suggestions from the language server.

### Example: "Could not find a declaration file for module 'X'"

This specific message means:

- **What it is**: TypeScript can't find type definitions (`.d.ts` files) for the npm package
- **Why it appears**: The package doesn't ship with TypeScript definitions
- **Impact**: The code works fine, but TypeScript can't provide autocomplete or type checking for that package
- **Solution**: Install `@types/package-name` or ignore it (see below)

## The Lightbulb Icon (💡)

The lightbulb icon indicates **code actions are available**. This means the LSP server has suggestions to:

- Fix the issue automatically
- Refactor the code
- Add missing imports
- Generate code snippets

## Keybindings

### View Diagnostic Messages

| Hotkey | Command | Description |
|--------|---------|-------------|
| `<leader>d` (`,d`) | `:lua vim.diagnostic.open_float()` | Show full diagnostic message in a floating window |
| `K` | `:lua vim.lsp.buf.hover()` | Show hover documentation |

### Navigate Diagnostics

| Hotkey | Command | Description |
|--------|---------|-------------|
| `]d` | `:lua vim.diagnostic.goto_next()` | Jump to next diagnostic |
| `[d` | `:lua vim.diagnostic.goto_prev()` | Jump to previous diagnostic |
| `<leader>dl` (`,dl`) | `:lua vim.diagnostic.setloclist()` | Show all diagnostics in location list |

### Code Actions (Lightbulb)

| Hotkey | Command | Description |
|--------|---------|-------------|
| `<leader>ca` (`,ca`) | `:lua vim.lsp.buf.code_action()` | Open code actions menu |

## How to Fix "Could not find a declaration file"

You have several options to resolve TypeScript declaration file warnings:

### Option 1: Disable TypeScript LSP (Recommended for JavaScript-only projects)

If the project doesn't use TypeScript, disable the TypeScript language server:

1. Edit `lua/plugins/lsp.lua`
2. Comment out or remove the line: `{ 'ts_ls' }`
3. Restart Neovim

**This is already done in the latest config.**

### Option 2: Install Type Definitions

For packages that have type definitions available:

```bash
npm install --save-dev @types/node
npm install --save-dev @types/package-name
```

### Option 3: Configure TypeScript to Skip Checks

Create or update `tsconfig.json`:

```json
{
  "compilerOptions": {
    "skipLibCheck": true,
    "allowJs": true,
    "checkJs": false
  }
}
```

### Option 4: Suppress Individual Warnings

Add a comment above the line:

```javascript
// @ts-ignore
const package = require('package-name');
```

Or use `// @ts-nocheck` at the top of the file to disable all TypeScript checks.

## XO and Prettier Configuration

For projects using XO and Prettier:

### ESLint LSP (Works with XO)

XO uses ESLint under the hood, so the ESLint LSP server works with XO projects:

- **Enabled by default**: `eslint` LSP is configured in `lua/plugins/lsp.lua`
- **Automatic detection**: ESLint LSP will use XO's configuration if `.xo-config` or `"xo"` in `package.json` exists
- **No additional setup needed**

### Prettier Formatting

Prettier formatting is handled by `conform.nvim`, not the LSP:

- **Configuration**: See `lua/plugins/conform.lua`
- **Trigger**: Press `gA` or `,f` to format
- **Auto-detection**: Checks for `.prettierrc` or `"prettier"` in `package.json`

## Disabling Specific Diagnostics

To disable specific diagnostic types:

### Globally

Edit `lua/plugins/lsp.lua` and modify the diagnostic config:

```lua
vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = false, -- Disable inline diagnostic text
  severity_sort = true,
})
```

### Per-Buffer

Run in Neovim:

```vim
:lua vim.diagnostic.disable(0)  " Disable for current buffer
:lua vim.diagnostic.enable(0)   " Re-enable for current buffer
```

### Filter by Severity

Show only errors and warnings (hide hints):

```lua
vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
})
```

## Troubleshooting

### Diagnostics Not Showing

1. **Check if LSP is attached**:
   ```vim
   :LspInfo
   ```

2. **Check diagnostic configuration**:
   ```vim
   :lua print(vim.inspect(vim.diagnostic.config()))
   ```

3. **Restart LSP**:
   ```vim
   :LspRestart
   ```

### Too Many Diagnostics

If diagnostics are overwhelming:

1. **Disable virtual text** (inline messages):
   ```vim
   :lua vim.diagnostic.config({ virtual_text = false })
   ```

2. **Show only in location list**:
   ```vim
   :lua vim.diagnostic.setloclist()
   ```

3. **Filter by severity** (see above)

## Summary

**Quick Actions:**

- **View diagnostic**: `,d`
- **Code actions**: `,ca`
- **Next/previous**: `]d` / `[d`
- **All diagnostics**: `,dl`

**For XO/Prettier projects:**

- ESLint LSP works with XO automatically
- TypeScript LSP is disabled by default
- Prettier formatting via `gA` or `,f`

**To disable TypeScript warnings:**

- Already disabled in the config
- Or add `// @ts-nocheck` to files
- Or configure `tsconfig.json`

# Disabling Terminal URL Underlines

If you still see underlines on URLs/links in Neovim, this is likely coming from your **terminal emulator**, not from Neovim itself.

## Terminal-Specific Settings

### iTerm2 (macOS)
1. Go to **Preferences** → **Profiles** → **Text**
2. Uncheck **Underline hyperlinks**
3. Or go to **Preferences** → **Profiles** → **Advanced**
4. Set **Semantic History** to **Disabled**

### Warp Terminal
1. Go to **Settings** → **Features**
2. Disable **URL Detection** or **Hyperlink Detection**

### Alacritty
Add to `~/.config/alacritty/alacritty.yml`:
```yaml
hints:
  enabled: []
```

### Kitty
Add to `~/.config/kitty/kitty.conf`:
```
detect_urls no
```

### WezTerm
Add to `~/.wezterm.lua`:
```lua
config.hyperlink_rules = {}
```

### VS Code Terminal
1. Open **Settings** (Cmd+,)
2. Search for "terminal link"
3. Uncheck **Terminal > Integrated: Enable Links**

### Windows Terminal
1. Open **Settings** → **Profiles** → **Defaults** → **Advanced**
2. Disable **Detect URLs and make them clickable**

## What This Config Does

This Neovim configuration **completely disables all underlines** from:
- Syntax highlighting (`Underlined` group)
- Markdown links (`@markup.link*`)
- HTML links (`htmlLink`)
- All URL-related highlight groups

The underlines you see are from your terminal's built-in URL detection feature, which runs **outside** of Neovim's control.

## Verification

To verify Neovim itself has no underlines:
```vim
:highlight Underlined
```

Should show NO `gui=underline` or `cterm=underline`.

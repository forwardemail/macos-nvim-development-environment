# Linter Configuration Files Support

This Neovim configuration supports comprehensive linter configuration file detection for all integrated linters.

## Supported Linters

### XO (JavaScript/TypeScript)

**File Extensions:** `.js`, `.cjs`, `.mjs`, `.jsx`, `.ts`, `.cts`, `.mts`, `.tsx`

**Configuration Files (in order of precedence):**

*Modern (ESLint 9 flat config):*
- `xo.config.js` - JavaScript config
- `xo.config.ts` - TypeScript config
- `xo.config.cjs` - CommonJS config
- `xo.config.mjs` - ES module config

*Legacy (still supported):*
- `.xo-config.json` - JSON config
- `.xo-config.js` - JavaScript config
- `.xo-config.cjs` - CommonJS config
- `.xo-config` - JSON without extension

*Both styles:*
- `package.json` - Add `"xo"` field

**Note:** Both modern and legacy config patterns are fully supported.

### Remark (Markdown)

**File Extensions:** `.md`, `.markdown`, `.mdown`, `.mkdn`, `.mkd`, `.mdwn`, `.mdtxt`, `.mdtext`, `.mdx`

**Configuration Files (in order of precedence):**
1. `.remarkrc` - JSON format
2. `.remarkrc.cjs` - CommonJS
3. `.remarkrc.json` - JSON
4. `.remarkrc.js` - JavaScript (CJS or ESM depending on package.json type)
5. `.remarkrc.mjs` - ES module
6. `.remarkrc.yaml` - YAML
7. `.remarkrc.yml` - YAML
8. `package.json` - Add `"remarkConfig"` field

### Pug-lint (Pug Templates)

**File Extensions:** `.pug`, `.jade`

**Configuration Files:**
- `.pug-lintrc` - JSON format
- `.pug-lintrc.js` - JavaScript
- `.pug-lintrc.json` - JSON
- `package.json` - Add `"pugLintConfig"` field

**Note:** Does NOT support `.cjs`, `.mjs`, `.yaml`, `.yml` extensions

### Stylelint (CSS/SCSS/LESS)

**File Extensions:** `.css`, `.scss`, `.less`, `.sass`

**Configuration Files:**
- `stylelint.config.js` - JavaScript (using export default or module.exports)
- `stylelint.config.mjs` - ES module (using export default)
- `stylelint.config.cjs` - CommonJS (using module.exports)
- `.stylelintrc.js` - JavaScript
- `.stylelintrc.mjs` - ES module
- `.stylelintrc.cjs` - CommonJS
- `.stylelintrc` - YAML or JSON
- `.stylelintrc.yml` - YAML
- `.stylelintrc.yaml` - YAML
- `.stylelintrc.json` - JSON
- `package.json` - Add `"stylelint"` field

### PostCSS

**Note:** PostCSS itself is not a linter. For PostCSS file linting, use Stylelint with the `postcss-syntax` plugin.

**Configuration Files (for reference):**
- `postcss.config.js`, `.postcssrc.js`, etc.
- `package.json` - Add `"postcss"` field

## How It Works

1. **Config Detection:** Before running any linter, the configuration checks if a valid config file exists in the project
2. **Local First:** Linters prefer local `node_modules/.bin` installations
3. **Fallback:** Falls back to `npx`, then global commands
4. **No Config = No Lint:** If no configuration file is found, the linter will not run

## Example package.json

```json
{
  "name": "my-project",
  "xo": {
    "semicolon": false,
    "rules": {
      "unicorn/prefer-module": "off"
    }
  },
  "remarkConfig": {
    "plugins": [
      "remark-preset-lint-recommended",
      "remark-preset-lint-consistent"
    ]
  },
  "pugLintConfig": {
    "disallowIdLiterals": true,
    "requireClassLiteralsBeforeAttributes": true
  },
  "stylelint": {
    "extends": "stylelint-config-standard",
    "rules": {
      "color-no-invalid-hex": true
    }
  }
}
```

## References

- [XO Documentation](https://github.com/xojs/xo)
- [Remark Documentation](https://github.com/remarkjs/remark/tree/main/packages/remark-cli)
- [Pug-lint Documentation](https://github.com/pugjs/pug-lint)
- [Stylelint Documentation](https://stylelint.io/user-guide/configure)
- [PostCSS Documentation](https://github.com/postcss/postcss-load-config)

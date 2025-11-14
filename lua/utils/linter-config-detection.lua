--[[
  Linter Configuration File Detection

  Detects configuration files for various linters based on their
  cosmiconfig patterns and custom config loading logic.
]]

local M = {}

-- XO Configuration Files (supports BOTH legacy and modern patterns)
-- Source: https://github.com/xojs/xo
M.xo_config_files = {
  -- Modern flat config (ESLint 9 style)
  'xo.config.js',
  'xo.config.ts',
  'xo.config.cjs',
  'xo.config.mjs',
  -- Legacy config patterns (still widely used)
  '.xo-config.json',
  '.xo-config.js',
  '.xo-config.cjs',
  '.xo-config',
  'package.json',  -- Check for "xo" field
}

-- Remark Configuration Files (cosmiconfig via unified-args)
-- Source: https://github.com/remarkjs/remark/tree/main/packages/remark-cli
M.remark_config_files = {
  '.remarkrc',
  '.remarkrc.cjs',
  '.remarkrc.json',
  '.remarkrc.js',
  '.remarkrc.mjs',
  '.remarkrc.yaml',
  '.remarkrc.yml',
  'package.json',  -- Check for "remarkConfig" field
}

-- Pug-lint Configuration Files (custom config loading)
-- Source: https://github.com/pugjs/pug-lint
M.puglint_config_files = {
  '.pug-lintrc',
  '.pug-lintrc.js',
  '.pug-lintrc.json',
  'package.json',  -- Check for "pugLintConfig" field
}

-- PostCSS Configuration Files (cosmiconfig)
-- Source: https://github.com/postcss/postcss-load-config
M.postcss_config_files = {
  'package.json',  -- Check for "postcss" field
  '.postcssrc',
  '.postcssrc.json',
  '.postcssrc.yml',
  '.postcssrc.yaml',
  '.postcssrc.js',
  '.postcssrc.mjs',
  '.postcssrc.cjs',
  '.postcssrc.ts',
  '.postcssrc.mts',
  '.postcssrc.cts',
  'postcss.config.js',
  'postcss.config.mjs',
  'postcss.config.cjs',
  'postcss.config.ts',
  'postcss.config.mts',
  'postcss.config.cts',
}

-- Stylelint Configuration Files (cosmiconfig)
-- Source: https://stylelint.io/user-guide/configure
M.stylelint_config_files = {
  'stylelint.config.js',
  'stylelint.config.mjs',
  'stylelint.config.cjs',
  '.stylelintrc.js',
  '.stylelintrc.mjs',
  '.stylelintrc.cjs',
  '.stylelintrc',
  '.stylelintrc.yml',
  '.stylelintrc.yaml',
  '.stylelintrc.json',
  'package.json',  -- Check for "stylelint" field
}

---Find project root by looking upward for package.json
---@param filepath string Path to start searching from
---@return string|nil Root directory path or nil if not found
local function find_project_root(filepath)
  if not filepath or filepath == '' then
    return nil
  end

  -- Get directory of the file
  local dir = vim.fn.fnamemodify(filepath, ':p:h')

  -- Search upward for package.json
  local max_depth = 20
  for _ = 1, max_depth do
    local package_json = dir .. '/package.json'
    if vim.fn.filereadable(package_json) == 1 then
      return dir
    end

    -- Move up one directory
    local parent = vim.fn.fnamemodify(dir, ':h')
    if parent == dir then
      -- Reached root
      break
    end
    dir = parent
  end

  return nil
end

---Check if a config file exists for a linter
---@param linter_name string Name of the linter ('xo', 'remark', 'puglint', 'postcss', 'stylelint')
---@param filepath string Path to the file being linted
---@return boolean
function M.has_config(linter_name, filepath)
  local config_files = M[linter_name .. '_config_files']
  if not config_files then
    return false
  end

  -- Find project root
  local root = find_project_root(filepath)
  if not root then
    return false
  end

  -- Check each config file
  for _, config_file in ipairs(config_files) do
    if config_file == 'package.json' then
      -- Check if package.json has the linter config field
      local package_json_path = root .. '/package.json'
      if vim.fn.filereadable(package_json_path) == 1 then
        local ok, package_data = pcall(vim.fn.readfile, package_json_path)
        if ok then
          local content = table.concat(package_data, '\n')
          local decoded_ok, decoded = pcall(vim.json.decode, content)
          if decoded_ok and decoded then
            -- Check for linter-specific field in package.json
            local field_map = {
              xo = 'xo',
              remark = 'remarkConfig',
              puglint = 'pugLintConfig',
              postcss = 'postcss',
              stylelint = 'stylelint',
            }
            local field = field_map[linter_name]
            if field and decoded[field] then
              return true
            end
          end
        end
      end
    else
      -- Check if config file exists
      local config_path = root .. '/' .. config_file
      if vim.fn.filereadable(config_path) == 1 then
        return true
      end
    end
  end

  return false
end

---Find the config file path for a linter
---@param linter_name string Name of the linter
---@param filepath string Path to the file being linted
---@return string|nil Path to the config file, or nil if not found
function M.find_config(linter_name, filepath)
  local config_files = M[linter_name .. '_config_files']
  if not config_files then
    return nil
  end

  local root = find_project_root(filepath)
  if not root then
    return nil
  end

  for _, config_file in ipairs(config_files) do
    local config_path = root .. '/' .. config_file
    if vim.fn.filereadable(config_path) == 1 then
      if config_file == 'package.json' then
        -- Verify package.json has the linter config field
        local ok, package_data = pcall(vim.fn.readfile, config_path)
        if ok then
          local content = table.concat(package_data, '\n')
          local decoded_ok, decoded = pcall(vim.json.decode, content)
          if decoded_ok and decoded then
            local field_map = {
              xo = 'xo',
              remark = 'remarkConfig',
              puglint = 'pugLintConfig',
              postcss = 'postcss',
              stylelint = 'stylelint',
            }
            local field = field_map[linter_name]
            if field and decoded[field] then
              return config_path
            end
          end
        end
      else
        return config_path
      end
    end
  end

  return nil
end

return M

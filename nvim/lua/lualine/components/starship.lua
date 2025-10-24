local M = require("lualine.component"):extend()

local starship_config = [[
[git_branch]
format = '$branch'

[git_status]
format = '\[$all_status$ahead_behind\]'
]]

local function run_starship_module(module_name)
  local cmd = string.format(
    [[
    export STARSHIP_CONFIG=$(mktemp)
    cat > "$STARSHIP_CONFIG" << 'EOF'
%s
EOF
    starship module %s
    rm "$STARSHIP_CONFIG"
  ]],
    starship_config,
    module_name
  )
  local handle = io.popen(cmd .. " 2>/dev/null")
  if not handle then return "" end
  local result = handle:read("*a")
  handle:close()
  result = result:gsub("\n$", "")
  result = result:gsub("\27%[[0-9;]*m", "")
  return result
end

M.default_config = {
  color_branch = { fg = "#3377cc" },
  color_status = { fg = "#ff5f5f" },
  refresh_time = 16,
}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("force", M.default_config, options or {})
end

function M:update_status()
  local git_branch = run_starship_module("git_branch")
  local git_status = run_starship_module("git_status")

  local parts = {}
  local h = require("lualine.highlight")

  local hl_git_branch = h.create_component_highlight_group(self.options.color_branch, "git_branch", self.options)
  local hl_git_status = h.create_component_highlight_group(self.options.color_status, "git_status", self.options)

  table.insert(parts, h.component_format_highlight(hl_git_branch) .. " " .. git_branch)
  table.insert(parts, h.component_format_highlight(hl_git_status) .. git_status)
  return table.concat(parts, " ")
end

return M

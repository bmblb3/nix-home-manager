local lualine_require = require("lualine_require")
local modules = lualine_require.lazy_require({ highlight = "lualine.highlight" })
local M = lualine_require.require("lualine.component"):extend()

local default_options = {
  refresh = { refresh_time = 200 },
  git_color = { branch = { fg = "#ffffff" }, status = { fg = "#ff5f5f" } },
  branch_symbol = " ",
}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)

  self.highlights = {
    branch = self:create_hl(self.options.git_color.branch, "mylualine_git_branch"),
    status = self:create_hl(self.options.git_color.status, "mylualine_git_status"),
  }
end

local starship_config = [[
[git_branch]
format = '$branch'

[git_status]
format = '$all_status$ahead_behind'
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

function M:update_status()
  local colors = {}
  for name, highlight_name in pairs(self.highlights) do
    colors[name] = self:format_hl(highlight_name)
  end

  local result = {}

  local git_branch = run_starship_module("git_branch")
  if git_branch == "" then return "" end
  table.insert(result, colors.branch .. self.options.branch_symbol .. git_branch)

  local git_status = run_starship_module("git_status")
  table.insert(result, colors.status .. git_status)

  return table.concat(result, " ")
end

return M

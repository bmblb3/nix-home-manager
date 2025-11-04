local lualine_require = require("lualine_require")
local modules = lualine_require.lazy_require({ highlight = "lualine.highlight" })
local M = lualine_require.require("lualine.component"):extend()

local default_options = {
  refresh = { refresh_time = 200 },
}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

local function run_starship_module(module_name)
  local cmd = string.format("starship module %s", module_name)
  local handle = io.popen(cmd .. " 2>/dev/null")
  if not handle then return "" end
  local result = handle:read("*a")
  handle:close()
  result = result:gsub("\n$", "")
  result = result:gsub("\27%[[0-9;]*m", "")
  return result
end

function M:update_status()
  local result = {}

  local git_branch = run_starship_module("git_branch")
  if git_branch == "" then return "" end
  table.insert(result, git_branch)

  local git_status = run_starship_module("git_status")
  table.insert(result, git_status)

  return table.concat(result)
end

return M

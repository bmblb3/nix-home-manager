local lualine_require = require("lualine_require")
local M = lualine_require.require("lualine.component"):extend()

local default_options = {}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

local cache, last_update = "", 0
function M:update_status()
  if os.time() - last_update < 1 then return cache end
  last_update = os.time()

  local function get_output(module)
    local result = vim.system({ "starship", "module", module }, { text = true }):wait()
    return (result.code == 0) and result.stdout:gsub("\27%[[0-9;]*m", ""):gsub("\n$", "") or ""
  end

  local branch, status = get_output("git_branch"), get_output("git_status")
  cache = (branch ~= "" and status ~= "") and (branch .. " " .. status) or ""
  return cache
end

return M

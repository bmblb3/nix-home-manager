local lualine_require = require("lualine_require")
local modules = lualine_require.lazy_require({
  highlight = "lualine.highlight",
})
local M = lualine_require.require("lualine.component"):extend()

local default_options = {
  refresh = { refresh_time = 200 },
  symbols = { pool = "󰙨", pass = "✓", fail = "✗" },
  test_color = { pool = { fg = "#666666" }, pass = { fg = "#00bc11" }, fail = { fg = "#ff5f5f" } },
}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)

  self.highlights = {
    pool = self:create_hl(self.options.test_color.pool, "pool"),
    pass = self:create_hl(self.options.test_color.pass, "pass"),
    fail = self:create_hl(self.options.test_color.fail, "fail"),
  }
end

function M:update_status()
  local get_test_status = vim.b.get_test_status
  if not get_test_status or type(get_test_status) ~= "function" then return "" end

  local status = get_test_status()
  if not status or not status.pool or not status.fail then return "" end

  if status.pool == 0 then return "" end

  local colors = {}
  for name, highlight_name in pairs(self.highlights) do
    colors[name] = self:format_hl(highlight_name)
  end

  local result = {}
  table.insert(result, colors.pool .. self.options.symbols.pool .. status.pool .. ":")
  table.insert(result, colors.pass .. self.options.symbols.pass .. status.pass)
  table.insert(result, colors.pool .. "|")
  table.insert(result, colors.fail .. self.options.symbols.fail .. status.fail)

  return table.concat(result, "")
end

return M

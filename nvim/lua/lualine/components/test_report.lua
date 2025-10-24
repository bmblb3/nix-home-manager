local M = require("lualine.component"):extend()

M.default_config = {
  icon_pool = "󰙨",
  icon_pass = "✓",
  icon_fail = "✗",
  color_pool = { fg = "#666666" },
  color_pass = { fg = "#00bc11" },
  color_fail = { fg = "#ff5f5f" },
}

function M:init(options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend("force", M.default_config, options or {})
end

function M:update_status()
  local test_state = vim.b.test_state
  if not test_state or test_state.total == 0 then return "" end

  local pool = test_state.total
  local fail = test_state.failing
  local pass = pool - fail

  local parts = {}
  local h = require("lualine.highlight")

  local hl_pool = h.create_component_highlight_group(self.options.color_pool, "test_pool", self.options)
  local hl_pass = h.create_component_highlight_group(self.options.color_pass, "test_pass", self.options)
  local hl_fail = h.create_component_highlight_group(self.options.color_fail, "test_fail", self.options)

  table.insert(parts, h.component_format_highlight(hl_pool) .. self.options.icon_pool .. "" .. pool .. ":")
  table.insert(parts, h.component_format_highlight(hl_pass) .. self.options.icon_pass .. "" .. pass)
  table.insert(parts, h.component_format_highlight(hl_pool) .. "|")
  table.insert(parts, h.component_format_highlight(hl_fail) .. self.options.icon_fail .. "" .. fail)

  return table.concat(parts, "")
end

return M

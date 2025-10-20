if vim.b.rust_ftplugin_loaded then return end
vim.b.rust_ftplugin_loaded = true

local function get_git_root() -- TODO: make this a "global" util
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then return nil end
  return git_root
end

local git_root = get_git_root()
if not git_root then
  return -- exit early
end

local junit_path = git_root .. "/target/nextest/default/junit.xml"

local total_tests = 0 -- i.e no tests run
local failing_tests = 0

local uv = vim.uv or vim.loop

local fs_event = nil

local function update_teststatus()
  local file = io.open(junit_path, "r")
  if not file then -- We can't know test status
    total_tests = 0
    return
  end

  local content = file:read("*all")
  file:close()

  -- (Jenkins junit XML syntax)
  local tests = content:match('<testsuites[^>]*tests="(%d+)"')
  total_tests = tonumber(tests) or 0
  local failures = content:match('<testsuites[^>]*failures="(%d+)"')
  local errors = content:match('<testsuites[^>]*errors="(%d+)"')
  failing_tests = (tonumber(failures) or 0) + (tonumber(errors) or 0)
  if failing_tests > total_tests then total_tests = failing_tests end
end

local function start_watching()
  if fs_event then fs_event:stop() end

  fs_event = uv.new_fs_event()
  fs_event:start(
    junit_path,
    {},
    vim.schedule_wrap(function(err, _, _)
      if err then return end
      update_teststatus()
    end)
  )
end

-- Start watching if file exists, otherwise check periodically
if vim.fn.filereadable(junit_path) == 1 then
  update_teststatus()
  start_watching()
else
  -- Poll until the file appears (nextest creates it on first run)
  local timer = uv.new_timer()
  timer:start(
    0,
    2000,
    vim.schedule_wrap(function()
      if vim.fn.filereadable(junit_path) == 1 then
        timer:stop()
        update_teststatus()
        start_watching()
      end
    end)
  )
end

require("lualine").setup({
  sections = {
    lualine_b = {
      "diff",
      "diagnostics",
      {
        function() return total_tests end,
        icon = "🧪",
        color = { fg = "#666666" },
        component_separators = { left = nil, right = nil },
        cond = function() return total_tests > 0 end,
      },
      {
        function() return total_tests - failing_tests end,
        icon = "✓",
        color = { fg = "#00bc11" },
        component_separators = { left = nil, right = nil },
        cond = function() return total_tests > 0 end,
      },
      {
        function() return failing_tests end,
        icon = "✗",
        color = { fg = "#ff5f5f" },
        component_separators = { left = nil, right = nil },
        cond = function() return total_tests > 0 end,
      },
      -- useful_debug function() return total_tests .. " | " .. passing_tests .. " | " .. failing_tests end,
    },
  },
})

if vim.b.rust_ftplugin_loaded then return end
vim.b.rust_ftplugin_loaded = true

local function get_git_root()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then return nil end
  return git_root
end

local git_root = get_git_root()
if not git_root then return end

local junit_path = git_root .. "/target/nextest/default/junit.xml"
local uv = vim.uv or vim.loop

-- Initialize buffer-local test state
vim.b.test_state = {
  total = 0,
  failing = 0,
}

local fs_event = nil

local function update_teststatus()
  local file = io.open(junit_path, "r")
  if not file then
    vim.b.test_state = { total = 0, failing = 0 }
    return
  end

  local content = file:read("*all")
  file:close()

  local tests = content:match('<testsuites[^>]*tests="(%d+)"')
  local total = tonumber(tests) or 0
  local failures = content:match('<testsuites[^>]*failures="(%d+)"')
  local errors = content:match('<testsuites[^>]*errors="(%d+)"')
  local failing = (tonumber(failures) or 0) + (tonumber(errors) or 0)

  if failing > total then total = failing end

  vim.b.test_state = {
    total = total,
    failing = failing,
  }

  -- Refresh lualine
  vim.cmd("redrawstatus")
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

-- Cleanup on buffer unload
vim.api.nvim_create_autocmd("BufUnload", {
  buffer = 0,
  callback = function()
    if fs_event then
      fs_event:stop()
      fs_event = nil
    end
  end,
})

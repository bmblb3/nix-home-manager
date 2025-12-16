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

vim.b.get_test_status = function()
  local file = io.open(junit_path, "r")
  if not file then return end
  local content = file:read("*all")
  file:close()

  local tests = content:match('<testsuites[^>]*tests="(%d+)"')
  local failures = content:match('<testsuites[^>]*failures="(%d+)"')
  local errors = content:match('<testsuites[^>]*errors="(%d+)"')

  local pool = tonumber(tests) or 0
  local fail = (tonumber(failures) or 0) + (tonumber(errors) or 0)
  local pass = pool - fail

  return { pool = pool, pass = pass, fail = fail }
end

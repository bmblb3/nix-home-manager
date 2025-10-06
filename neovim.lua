vim.loader.enable()

-- options
vim.g.have_nerd_font = false
vim.g.loaded_python3_provider = 0
vim.g.loaded_python_provider = 0
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_silent = 1
vim.opt.autowriteall = true
vim.opt.breakindent = true
vim.opt.completeopt = "menu,menuone,preview,noselect"
vim.opt.cpoptions:append("I")
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fillchars = { foldopen = "", foldclose = "", diff = "╱" }
vim.opt.foldcolumn = "1"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.jumpoptions = "view"
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append({ a = true, I = true, c = true })
vim.opt.showmode = false
vim.opt.sidescrolloff = 4
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.softtabstop = 2
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.virtualedit = "block"
vim.opt.wildmode = "longest:full,full"
vim.opt.wrap = true
vim.api.nvim_create_autocmd("FileType", {
  desc = "remove formatoptions",
  callback = function() vim.opt.formatoptions:remove({ "c", "r", "o" }) end,
})

--
local map = function(mode, lhs, rhs, opts)
  local defaults = { silent = true, noremap = true }
  if opts then defaults = vim.tbl_extend("force", defaults, opts) end
  vim.keymap.set(mode, lhs, rhs, defaults)
end
local wk = require("which-key")

-- pretty
require("lualine").setup({})
require("hardtime").setup({})

-- general keymaps
map({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map({ "n", "v", "x" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
map({ "v", "x" }, "p", '"_dP', { desc = "Keep unammed register when overwriting in visual mode" })
map({ "n" }, "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

--
wk.add({ "<leader>g", group = "[g]it stuff" })
require("gitsigns").setup()
map({ "n", "o" }, "]g", function() vim.cmd("Gitsigns next_hunk") end, { noremap = true, silent = true, desc = "Next git hunk" })
map({ "n", "o" }, "[g", function() vim.cmd("Gitsigns prev_hunk") end, { noremap = true, silent = true, desc = "Prev git hunk" })
map("n", "<leader>gk", function() vim.cmd("Gitsigns preview_hunk") end, { noremap = true, silent = true, desc = "Preview hunk" })
map("n", "<leader>gr", function() vim.cmd("Gitsigns reset_hunk") end, { noremap = true, silent = true, desc = "Reset hunk" })
map("n", "<leader>gs", function() vim.cmd("Gitsigns stage_hunk") end, { noremap = true, silent = true, desc = "Stage/unstage hunk" })
map("n", "<leader>gc", function()
  if vim.bo.filetype ~= "gitcommit" then return end
  local buf = vim.api.nvim_get_current_buf()

  local diff = vim.fn.systemlist("git diff --cached")
  if vim.v.shell_error ~= 0 then return end
  if #diff == 0 then return end

  local prompt_base = [[
Write commit message for the below changes using the conventional-commits convention
- Keep the title under 50 characters
- The body is VERY MUCH OPTIONAL, add it ONLY if the commit is complex
- Don't add body for simple self explanatory commits
- Body if added should be readable bullet points
- Body if added should explain the 'why' of a commit
- Remember the exclamation mark if ANYTHING in the PUBLIC API changes
- Wrap message at 72 characters
- Output only the commit message, as raw text
]]

  local prompt = prompt_base .. "\n" .. table.concat(diff, "\n")

  require("CopilotChat").ask(prompt, {
    callback = function(response)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(response, "\n"))
      vim.cmd("CopilotChatClose")
    end,
  })
end, { desc = "Generate commit message with Copilot", noremap = true, silent = true })

--
local persistence = require("persistence")
persistence.setup({})
map("n", "<leader>n", function() persistence.load() end, { desc = "Load sessio[n]" })

--
local snacks = require("snacks")
snacks.setup({
  scratch = { enabled = true },
  picker = { enabled = true },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  indent = { enabled = true },
})

map("n", "<C-g>", function() snacks.lazygit.open() end, { noremap = true, silent = true, desc = "Open lazygit" })

map("n", "<leader>s", function() snacks.scratch() end, { desc = "Toggle [s]cratch" })
map("n", "<leader>S", function() snacks.scratch.select() end, { desc = "[S]elect scratch buffer" })

--
require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
})

--
vim.lsp.enable("basedpyright")
vim.lsp.enable("bashls")
vim.lsp.enable("docker_language_server")
vim.lsp.enable("jinja_lsp")
vim.lsp.enable("lua_ls")
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})
vim.lsp.enable("nil_ls")
vim.lsp.enable("ruff")
vim.lsp.enable("rust_analyzer")
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      diagnostics = { enable = false },
      check = { command = "clippy" },
    },
  },
})
vim.lsp.enable("superhtml")
vim.lsp.enable("tailwindcss")
vim.lsp.enable("ts_ls")
vim.lsp.enable("yamlls")
map({ "n", "o" }, "[d", function() vim.diagnostic.jump({ count = -vim.v.count1, float = true }) end, { desc = "Go to previous [d]iagnostic message" })
map({ "n", "o" }, "]d", function() vim.diagnostic.jump({ count = vim.v.count1, float = true }) end, { desc = "Go to next [d]iagnostic message" })
map("n", "<leader>k", vim.diagnostic.open_float, { desc = "Open [f]loating diagnostic message" })
map("n", "<leader>h", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle inlay [h]ints" })

--
require("copilot").setup({
  panel = { enabled = false },
  suggestions = { enabled = false },
})
local copilotchat = require("CopilotChat")
copilotchat.setup({})
local sticky = [[
#buffer
> @copilot
> Write SIMPLE, CLEAR, and RELIABLE code. Prefer explicitness over clever tricks. Keep functions short and readable. Use plain language and conventional/idiomatic patterns. Handle errors safely and predictably
> Do not add features I didn’t ask for. Do not use obscure idioms. Do not optimize prematurely. Do not add abstraction unless necessary. Do not overcomplicate variable names or structure. Do not add unnecessary comments
]]
map({ "n", "v" }, "<leader>a", function() copilotchat.toggle({ sticky = sticky }) end, { desc = "[A]I chat" })

--
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format", "ruff_organize_imports" },
    css = { "prettierd" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    html = { "prettierd", "djlint" },
    yaml = { "prettierd" },
    sh = { "shellharden", "shfmt", "shellcheck" },
    java = { "google-java-format" },
    nix = { "nixfmt" },
    typst = { "typstyle" },
    rust = { "rustfmt" },
  },
  format_on_save = true,
})
map("", "<leader>f", function() require("conform").format() end, { desc = "[f]ormat" })

--
local blink = require("blink.cmp")
blink.setup({
  cmdline = { enabled = false },
  sources = { default = { "lsp", "buffer", "snippets", "path", "copilot", "ripgrep" } },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    ghost_text = { enabled = true },
  },
})
blink.add_source_provider("copilot", {
  name = "copilot",
  module = "blink-copilot",
  score_offset = 0,
  async = true,
})
blink.add_source_provider("ripgrep", {
  name = "ripgrep",
  module = "blink-ripgrep",
  score_offset = -3,
  async = true,
})

--
require("flash").setup({ modes = { search = { enabled = true } } })
map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Fla[s]h" })
map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash tree[S]itter" })
map({ "o" }, "r", function() require("flash").remote() end, { desc = "flash [r]emote" })
map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Flash treesitter [R]emote" })
map({ "s" }, "<C-s>", function() require("flash").toggle() end, { desc = "Toggle Fla[^s]h Search" })

--
local augend = require("dial.augend")
require("dial.config").augends:register_group({
  default = {
    augend.hexcolor.new({ case = "upper" }),
    augend.integer.alias.decimal,
    augend.date.alias["%Y/%m/%d"],
    augend.date.alias["%Y-%m-%d"],
    augend.date.alias["%m/%d"],
    augend.date.alias["%H:%M"],
    augend.date.alias["%H:%M:%S"],
    augend.constant.alias.bool,
  },
})
map({ "n" }, "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, { desc = "Dial increment" })
map({ "n" }, "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, { desc = "Dial decrement" })
map({ "v" }, "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, { desc = "Dial increment" })
map({ "v" }, "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, { desc = "Dial decrement" })

--
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})

--
local picker = snacks.picker
map("n", "<leader>p", function() picker() end, { desc = "list [p]ickers" })
map("n", "<leader><Space>", function() snacks.picker.smart() end, { desc = "find files (smart)" })
map("n", "<leader>w", function() snacks.picker.buffers() end, { desc = "find files (buffers)" })
map("n", "<leader>/", function() snacks.picker.grep() end, { desc = "find by grep" })
map("n", "grd", function() snacks.picker.lsp_definitions() end, { desc = "Goto [d]efinition" })
map("n", "grD", function() snacks.picker.lsp_declarations() end, { desc = "Goto [D]eclaration" })
map("n", "grr", function() snacks.picker.lsp_references() end, { desc = "Goto [r]eferences" })
map("n", "gri", function() snacks.picker.lsp_implementations() end, { desc = "Goto [i]mplementation" })
map("n", "grt", function() snacks.picker.lsp_type_definitions() end, { desc = "Goto [t]ype Definition" })
map("n", "grg", function() snacks.picker.diagnostics() end, { desc = "Goto dia[g]nostics list" })

--
if os.getenv("EXTRA_VIMRC") then vim.cmd("source " .. os.getenv("EXTRA_VIMRC")) end

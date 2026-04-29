return {
  -- 1. Enable the "Golden Stack" Extras
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.rust" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.lang.docker" },
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.test.core" },

  -- 1b. Go tooling — provides :GoFillStruct, :GoIfErr, :GoAddTag, etc.
  --     Keybindings under <leader>cg (code → go), buffer-local to Go files.
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        lsp_cfg = false, -- LazyVim Go extra already configures gopls
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function(ev)
          local function buf(desc)
            return { buffer = ev.buf, desc = desc }
          end
          local map = vim.keymap.set
          -- <leader>cg — Go-specific code actions
          map("n", "<leader>cgs", "<cmd>GoFillStruct<cr>", buf("Go: Fill struct"))
          map("n", "<leader>cge", "<cmd>GoIfErr<cr>", buf("Go: if err"))
          map("n", "<leader>cga", "<cmd>GoAddTag<cr>", buf("Go: Add tags"))
          map("n", "<leader>cgr", "<cmd>GoRmTag<cr>", buf("Go: Remove tags"))
          map("n", "<leader>cgi", "<cmd>GoImpl<cr>", buf("Go: Implement interface"))
          map("n", "<leader>cgf", "<cmd>GoTestFunc<cr>", buf("Go: Test function"))
          map("n", "<leader>cgp", "<cmd>GoTest<cr>", buf("Go: Test package"))
        end,
      })
    end,
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },

  -- 2. Configure YAML to use Kubernetes schemas
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/api/json/catalog.json",
              },
              schemas = {
                kubernetes = "*.yaml", -- This tells it: "All YAML is K8s"
                ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
              },
            },
          },
        },
      },
    },
  },

  -- 3. Ensure Mason installs the necessary binary
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "yaml-language-server",
        "gopls",
        "delve",
        "basedpyright",
        "ruff",
        "rust-analyzer",
        "dockerfile-language-server",
      },
    },
  },

  -- 4. opencode.nvim — AI coding assistant terminal integration
  {
    "nickjvandyke/opencode.nvim",
    version = "*",
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true
      vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
      vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end, { desc = "Execute opencode action…" })
      vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
      vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end, { desc = "Add range to opencode", expr = true })
      vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })
      vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end, { desc = "Scroll opencode up" })
      vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })
      vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
      vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
    end,
  },
}

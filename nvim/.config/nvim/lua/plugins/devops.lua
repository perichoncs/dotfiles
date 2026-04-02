return {
  -- 1. Enable the "Golden Stack" Extras
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
  { import = "lazyvim.plugins.extras.lang.docker" },

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
        "basedpyright",
        "dockerfile-language-server",
      },
    },
  },
}

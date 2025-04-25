-- /home/jdhuan/.config/nvim/lua/plugins/c_dev.lua
return {
  -- 1. LSP 配置 (nvim-lspconfig 和 mason.nvim)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")

      -- 配置 mason
      mason.setup()

      -- 配置 mason-lspconfig 以管理 LSP 服务器
      mason_lspconfig.setup({
        ensure_installed = { "clangd" }, -- 确保安装 clangd
      })

      -- 配置 nvim-lspconfig 来启动 clangd
      mason_lspconfig.setup_handlers({
        function(server_name)
          if server_name == "clangd" then
            lspconfig[server_name].setup {
              -- 这里可以添加 clangd 的特定配置
              -- 例如，指定编译命令路径：
              -- cmd = { "clangd", "--compile-commands-dir", "/path/to/your/project" },
              -- 或者其他初始化选项
            }
          end
        end,
      })
    end,
  },

  -- 2. 补全框架 (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = {
          { name = "nvim_lsp" }, -- 来自 LSP 的补全
          { name = "luasnip" }, -- 来自 LuaSnip 的代码片段
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-space>"] = cmp.mapping.complete(), -- 触发补全
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- 确认选择
          ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
        }),
      })
    end,
  },

  -- 3. 代码片段引擎 (LuaSnip)
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load() -- 加载 VS Code 风格的代码片段
      -- 你可以添加自定义的代码片段，例如：
      -- require("luasnip").config.setup({
      --   snips = {
      --     c = {
      --       hello = {
      --         params = { trig = "hello", name = "Hello World" },
      --         desc = "Prints a simple hello world",
      --         dscr = "",
      --         snippet = "printf(\"Hello, world!\\n\");",
      --       },
      --     },
      --   },
      -- })
    end,
  },

  -- 4. 语法高亮 (nvim-treesitter)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- 在安装后执行此命令更新语法树
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c" }, -- 确保安装 C 语言的 parser
        highlight = { enable = true }, -- 启用语法高亮
      })
    end,
  },
}

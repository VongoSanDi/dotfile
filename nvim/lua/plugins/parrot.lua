return {
  "frankroeder/parrot.nvim",
  dependencies = { "ibhagwan/fzf-lua", "nvim-lua/plenary.nvim" },
  config = function()
    require("parrot").setup({
      -- Providers must be explicitly set up to make them available.
      providers = {
        perplexity = {
          name = "perplexity",
          api_key = "",
          endpoint = "https://api.perplexity.ai/chat/completions",
          headers = function(self)
            return {
              ["Content-Type"] = "application/json",
              ["Accept"] = "application/json",
              ["Authorization"] = "Bearer " .. self.api_key,
            }
          end,
          models = {
            "sonar-reasoning-pro",
            "r1-1776",
            "sonar-pro",
          },
          chat_conceal_model_params = false,
        },
      },
    })
  end,
  keys = {
    -- Normal and Insert mode mappings
    { "<C-g>c", "<cmd>PrtChatNew<cr>", mode = { "n", "i" }, desc = "New Chat" },
    { "<C-g>a", "<cmd>PrtAppend<cr>", mode = { "n", "i" }, desc = "Append" },
    { "<C-g>s", "<cmd>PrtStatus<cr>", mode = { "n", "i" }, desc = "Status" },

    -- Visual mode mappings
    { "<C-g>c", "<cmd>PrtChatNew<cr>", mode = "v", desc = "Visual Chat New" },
    { "<C-g>a", "<cmd>PrtAppend<cr>", mode = "v", desc = "Visual Append" },
  },
}

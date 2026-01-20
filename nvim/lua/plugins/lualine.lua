-- define function and formatting of the information
local function parrot_status()
  local status_info = require("parrot.config").get_status_info()
  local status = ""
  if status_info.is_chat then
    status = status_info.prov.chat.name
  else
    status = status_info.prov.command.name
  end
  return string.format("%s(%s)", status, status_info.model)
end

-- add to lueline section
return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      sections = {
        lualine_a = {
          {
            parrot_status,
            color = { bg = "#1e1e28", fg = "#cdd6f4" },
          },
        },
      },
    })
  end,
}

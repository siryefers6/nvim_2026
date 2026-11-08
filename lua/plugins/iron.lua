return {
  {
    "Vigemus/iron.nvim",
    ft = { "python" },

    config = function()
      local iron = require("iron.core")
      local common = require("iron.fts.common")
      local view = require("iron.view")

      iron.setup({
        config = {
          scratch_repl = true,

          repl_definition = {
            python = {
              command = { "uv", "run", "python", "-i" },
              format = common.bracketed_paste_python,

              -- Necesario para Python 3.13+
              env = {
                PYTHON_BASIC_REPL = "1",
              },

              -- Divisores de bloques
              block_dividers = {
                "# %%",
                "#%%",
              },
            },
          },

          -- Terminal bloques output
          repl_open_cmd = view.split.vertical.rightbelow("%40"),
        },

        keymaps = {
          toggle_repl = "<leader>rt",
          restart_repl = "<leader>rR",

          send_line = "<leader>rl",
          send_file = "<leader>rf",
          send_motion = "<leader>rc",
          visual_send = "<leader>rc",

          send_paragraph = "<leader>rp",
          send_code_block = "<leader>rb",
          send_code_block_and_move = "<leader>rn",

          interrupt = "<leader>ri",
          exit = "<leader>rq",
          clear = "<leader>rx",
        },

        ignore_blank_lines = true,
      })
    end,
  },
}

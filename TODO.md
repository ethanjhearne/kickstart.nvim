# TODO

- Fix bug in terminal fading stuff you wrote. To replicate:
  - Open a terminal
  - Split the window
  - Open a another terminal
  - The first terminal is now stuck in the "inactive" state (faded colors and
    line numbers on)
  - This continues even after you close the second terminal window

- Command to wrap long strings (syntax-aware)
- Figure out why Wezterm's choice of cursor color overrides neovim's. You can
  see this when you set wezterm to nightfox and do `:colorscheme dayfox`

- https://github.com/CopilotC-Nvim/CopilotChat.nvim

- Implement a "grep for word under cursor" telescope command
- After you jump to definition (or go to next search term?), you should automatically "zt" (or at least "zz").
- "quick filter" or whatever that TJ did for grep, where I can include/exclude certain files/directories
- Allow window switching from insert mode

- Implement "go to pytest fixture"
  - Could be a telescope picker that only considers document symbols in the current file, and conftest.py files up the file tree?

- Integrate pylint, mypy, pytest, PDM
  - Set up a makeprg for PDM
  - Parse results to quickfix

- If you run mypy in none-ls or pyre LSP, can you switch Pyright LSP for
  something that recognizes your venv?

- Plugins to add:
  - Jumping around text with two characters
    - Disable relative line numbers and rely on this instead
  - neotest
  - nvim lint
  - https://github.com/folke/zen-mode.nvim

- Things to fix:
  - Markdown file section jumping
    - Dedicated plugin just for this?
    - Can it work with just treesitter and ctags?  LSP (Oxide) seems like overkill.

- NormalNvim sounds like an appealing distro

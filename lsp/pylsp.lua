return {
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = true },
        flake8 = { enabled = false },
        mccabe = { enabled = true },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        rope_autoimport = { enabled = true },
        rope_completion = { enabled = false },
        yapf = { enabled = false },
      },
    },
  },
}

-----------------------------
-- Couldn't figure out how to get this to only use types for suggestions,
-- not for yelling at me in a million places!
-----------------------------
return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'basic',
      },
    },
  },
}

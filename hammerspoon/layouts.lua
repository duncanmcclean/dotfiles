return {
    {
        name = 'Standard Code',
        cells = {
          { '0,0 40x20' },
          { '40,0 20x20' },
        },
        apps = {
          Arc = { cell = 1, open = true },
          Discord = { cell = 1 },
          Spotify = { cell = 1 },
          GitHubDesktop = { cell = 1 },
          Tinkerwell = { cell = 1 },
          TablePlus = { cell = 1 },
          Slack = { cell = 2, open = true },
          Things = { cell = 2 },
          Ray = { cell = 2 },
        },
    },
    {
      name = 'Code Focused',
      cells = {
        { '0,0 15x20', positions.sixths.left },
        { '15,0 53x20', positions.fiveSixths.right },
      },
      apps = {
        Ray = { cell = 1, open = true },
        Code = { cell = 2, open = true },
        Arc = { cell = 2 },
        GitHubDesktop = { cell = 2 },
        Slack = { cell = 2 },
        Discord = { cell = 2 },
        Spotify = { cell = 2 },
      },
    },
  }

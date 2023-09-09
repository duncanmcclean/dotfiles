return {
    {
      name = 'Standard Dev',
      cells = {
        { '0,0 30x20' },
        { '30,0 30x20' },
        { '35,0 25x20' },
      },
      apps = {
        Arc = { cell = 1, open = true },
        Code = { cell = 2, open = true },
        GitHubDesktop = { cell = 2 },
        Slack = { cell = 3 },
        Discord = { cell = 3 },
      },
    },
    {
        name = 'Standard Dev (w/ Ray)',
        cells = {
          { '0,0 25x20' },
          { '25,0 10x20' },
          { '35,0 35x20' },
          { '35,0 25x20' },
          { '35,0 20x20' },
        },
        apps = {
          Arc = { cell = 1, open = true },
          Ray = { cell = 2, open = true },
          Code = { cell = 3, open = true },
          GitHubDesktop = { cell = 3 },
          Slack = { cell = 4 },
          Discord = { cell = 5 },
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

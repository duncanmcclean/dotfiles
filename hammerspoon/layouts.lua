return {
    {
        name = 'Full',
        cells = {
            { positions.full },
        },
        apps = {
          PhpStorm = { cell = 1, open = true },
          Firefox = { cell = 1 },
          Tower = { cell = 1 },
          Tinkerwell = { cell = 1 },
          TablePlus = { cell = 1 },
          Code = { cell = 1 },
          Ray = { cell = 1 },
          iTerm = { cell = 1 },
          Obsidian = { cell = 1 },
        },
    },
    {
        name = 'Split',
        cells = {
            { positions.halves.left },
            { positions.halves.right },
        },
        apps = {
            Firefox = { cell = 1, open = true },
            TablePlus = { cell = 1 },
            Obsidian = { cell = 1 },
            Code = { cell = 2 },
            PhpStorm = { cell = 2, open = true },
            iTerm = { cell = 2 },
            Ray = { cell = 1 },
            Tower = { cell = 2 },
            Tinkerwell = { cell = 2 },
        },
    },
    {
        name = 'Narrow Split',
        cells = {
            { '0,0 18x20', positions.twoThirds.left },
            { '18,0 42x20', positions.twoThirds.right },
        },
        apps = {
            Firefox = { cell = 1, open = true },
            TablePlus = { cell = 1 },
            Obsidian = { cell = 1 },
            Ray = { cell = 1 },
            iTerm = { cell = 1 },
            Code = { cell = 2 },
            Tower = { cell = 2 },
            Tinkerwell = { cell = 2 },
            PhpStorm = { cell = 2, open = true },
        },
    },
    {
        name = 'Split Three',
        cells = {
            { '0,0 14x20', positions.twoThirds.left },
            { '14,0 23x20', positions.twoThirds.right },
            { '37,0 23x20', positions.twoThirds.right },
        },
        apps = {
            Slack = { cell = 1 },
            Ray = { cell = 1 },
            iTerm = { cell = 1 },
            Firefox = { cell = 2, open = true },
            TablePlus = { cell = 2 },
            Tinkerwell = { cell = 2 },
            Obsidian = { cell = 2 },
            PhpStorm = { cell = 3, open = true },
            Code = { cell = 3 },
            Tower = { cell = 3 },
        }
    },
    {
        name = 'Narrow',
        cells = {
          { '0,0 15x20', positions.sixths.left },
          { '15,0 53x20', positions.fiveSixths.right },
        },
        apps = {
          Ray = { cell = 1, open = true },
          iTerm = { cell = 1 },
          PhpStorm = { cell = 2, open = true },
          Code = { cell = 2 },
          Firefox = { cell = 2 },
          Tower = { cell = 2 },
          Tinkerwell = { cell = 2 },
          Obsidian = { cell = 2 },
        },
    },
    {
        name = 'Centered',
        cells = {
          { '5,1 50x18' },
        },
        apps = {
          Firefox = { cell = 1 },
          Tower = { cell = 1 },
          Tinkerwell = { cell = 1 },
          TablePlus = { cell = 1 },
          Code = { cell = 1 },
          PhpStorm = { cell = 1, open = true },
          Ray = { cell = 1 },
          iTerm = { cell = 1 },
          Obsidian = { cell = 1 },
        },
    },
}

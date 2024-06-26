return {
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
          Arc = { cell = 2 },
          Tower = { cell = 2 },
          Tinkerwell = { cell = 2 },
        },
    },
    {
        name = 'Half & Half',
        cells = {
            { positions.halves.left },
            { positions.halves.right },
        },
        apps = {
            Arc = { cell = 1, open = true },
            TablePlus = { cell = 1 },
            Code = { cell = 2 },
            PhpStorm = { cell = 2, open = true },
            iTerm = { cell = 2 },
            Ray = { cell = 1 },
            Tower = { cell = 2 },
            Tinkerwell = { cell = 2 },
        },
    },
    {
        name = 'Thirds',
        cells = {
            { '0,0 14x20', positions.twoThirds.left },
            { '14,0 23x20', positions.twoThirds.right },
            { '37,0 23x20', positions.twoThirds.right },
        },
        apps = {
            Slack = { cell = 1 },
            Ray = { cell = 1 },
            iTerm = { cell = 1 },
            Arc = { cell = 2, open = true },
            TablePlus = { cell = 2 },
            PhpStorm = { cell = 3, open = true },
            Code = { cell = 3 },
            Tower = { cell = 3 },
            Tinkerwell = { cell = 3 },
        }
    },
    {
        name = 'Centered',
        cells = {
          { '5,1 50x18' },
        },
        apps = {
          Arc = { cell = 1 },
          Tower = { cell = 1 },
          Tinkerwell = { cell = 1 },
          TablePlus = { cell = 1 },
          Code = { cell = 1 },
          PhpStorm = { cell = 1, open = true },
          Ray = { cell = 1 },
          iTerm = { cell = 1 },
          Bear = { cell = 1 },
        },
    },
    {
        name = 'Full Width',
        cells = {
            { positions.full },
        },
        apps = {
          PhpStorm = { cell = 1, open = true },
          Arc = { cell = 1 },
          Tower = { cell = 1 },
          Tinkerwell = { cell = 1 },
          TablePlus = { cell = 1 },
          Code = { cell = 1 },
          Ray = { cell = 1 },
          iTerm = { cell = 1 },
          Bear = { cell = 1 },
        },
    },
    {
        name = 'Triage',
        cells = {
          { '0,0 20x10', positions.sixths.left },
          { '0,10 20x10', positions.sixths.left },
          { '20,0 38x20', positions.fiveSixths.right },
        },
        apps = {
          Arc = { cell = 1, open = true },
          Things = { cell = 2 },
          Ray = { cell = 2 },
          iTerm = { cell = 2 },
          Slack = { cell = 2 },
          PhpStorm = { cell = 3, open = true },
          Code = { cell = 3 },
          Tower = { cell = 3 },
          Tinkerwell = { cell = 3 },
        },
    },
}

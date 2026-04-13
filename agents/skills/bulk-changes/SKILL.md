---
name: bulk-changes
description: Makes the same change across multiple repositories.
---

I am a Software Developer at Statamic. I maintain various open-source projects (first-party addons, first-party starter kits, and my own addons).

Even so often, I need to make a bulk change across all of the repositories. This skill is intended to help make that process easier.

## 1. Select the projects

There are three groups of projects I might want you to update:

- First-party addons
  All located in `~/Code/Statamic`. `collaboration`, `eloquent-driver`, `importer`, `migrator`, `podcast-categories`, `seo-pro`, `ssg` and `wikilinks`
- First-party starter kits
  All located in `~/Code/Statamic`. Repositories that start with `starter-kit-`
- My own addons
  Most of which are located in `~/Code/SideProjects`. `cookie-notice`, `guest-entries`, `simple-commerce`, `statamic-cargo` and `~/Code/Runway`

When I execute this skill, you should ask me which group of projects to target.

## 2. Determine the task

Once the projects have been selected, you should ask me to specify the task. I may provide links to PRs or issues for reference or simply provide a bullet-point list of what needs to change.

## 3. Preview changes

Given information about the task, you should `cd` into the first project, checkout the default branch (whatever that is) and make the necessary changes.

Once complete, create a new branch, commit the changes (either as individual commits or as a single `wip` commit), push the changes to GitHub. From there, I will open a pull request and review the changes manually.

You should present me with a few options using the `ask_user_input_v0` tool:

- Question: "What would you like to do next?"
- Type: `single_select`
- Options: ["Continue", "Ask for Changes"]

Handle selections as follows:

- **"Continue"** → continue onto step 4.

- **"Ask for Changes"** → prompt the user: "What would you like to change?"
  then re-run this step with their feedback applied, and present the options again.

## 4. Copy changes

For each project:

1. Checkout the default branch
2. Make the necessary changes
  - Don't just copy changes from the original project. Exact changes may differ between projects.
  - Skip the remaining steps if no changes are necessary (eg. update has already been made manually, isn't required because dependency isn't present)
3. Create a new branch using the same name as the first project
4. Commit the changes (either as individual commits or as a single `wip` commit) and push the changes to GitHub.
5. Create a **draft** pull request using the `gh` CLI. You should check the original PR and use the same title and description.
  - Some projects include a version prefix in PR titles, eg. `[6.x] `. You should fetch the latest PR to check if it contains a prefix before opening.

## 5. Result

Please respond with the following details for each project:

- Whether changes were made or the project was skipped
- Title of the pull request
- Link to the pull request
- Brief summary of changes made

From here, I may discuss failing tests or other changes needing made.

---
name: phpstorm
description: Open a Git repository or worktree in PhpStorm Light, or produce a link that opens it. Use when the user says "open in phpstorm", "open this in phpstorm", "phpstorm", "phpstorm light", or when another skill asks for a PhpStorm link in its summary.
---

Open a repository in PhpStorm Light.

## Which directory

Use the path the user gave. Otherwise, use the root of the repository you're working in:

```sh
git rev-parse --show-toplevel
```

Inside a worktree, that resolves to the worktree itself (eg. `~/Code/Statamic/cms/worktrees/1234`) rather than the main checkout, which is what we want.

## Worktrees with a sandbox site

When the worktree has its own sandbox site (see the `worktree` skill), attach the sandbox to the worktree's project so both open in the same window.

From the package root (the parent of `worktrees/`), find the worktree's sandbox URL:

```sh
tether worktree list
```

Each line is the branch, its status and the sandbox URL. A URL like `http://sandbox-1234.test` maps to `~/Code/Throwaway/sandbox-1234`. If the branch has no URL, or the directory doesn't exist, there's no sandbox. Just open the worktree on its own.

PhpStorm keeps attached projects in `.idea/modules.xml`. If the worktree already has a `.idea` directory, leave it alone — it's either been attached already or I've set it up myself.

Otherwise, copy the main checkout's `.idea` into the worktree, so it keeps the PHP interpreter, test runner and plugin settings, but leave out the files tied to the main checkout:

```sh
rsync -a --exclude workspace.xml --exclude modules.xml ~/Code/Statamic/cms/.idea/ ~/Code/Statamic/cms/worktrees/1234/.idea/
```

Give the sandbox a module of its own:

```sh
mkdir -p ~/Code/Throwaway/sandbox-1234/.idea
cat > ~/Code/Throwaway/sandbox-1234/.idea/sandbox-1234.iml <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<module type="WEB_MODULE" version="4">
  <component name="NewModuleRootManager">
    <content url="file://$MODULE_DIR$">
      <excludeFolder url="file://$MODULE_DIR$/vendor" />
    </content>
    <orderEntry type="inheritedJdk" />
    <orderEntry type="sourceFolder" forTests="false" />
  </component>
</module>
XML
```

Then list both modules in the worktree's `modules.xml`, using the name of the `.iml` file copied from the main checkout (eg. `cms.iml`) and the absolute path to the sandbox's:

```sh
cat > ~/Code/Statamic/cms/worktrees/1234/.idea/modules.xml <<'XML'
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="ProjectModuleManager">
    <modules>
      <module fileurl="file://$PROJECT_DIR$/.idea/cms.iml" filepath="$PROJECT_DIR$/.idea/cms.iml" />
      <module fileurl="file:///absolute/path/to/Throwaway/sandbox-1234/.idea/sandbox-1234.iml" filepath="/absolute/path/to/Throwaway/sandbox-1234/.idea/sandbox-1234.iml" />
    </modules>
  </component>
</project>
XML
```

Open the worktree as normal and the sandbox appears alongside it.

## Opening it yourself

When the user asks you to open it:

```sh
open -a "/Applications/PhpStorm Light.app" "/absolute/path/to/repo"
```

## Providing a link instead

When summarising work for the user to review later, don't open PhpStorm yourself. Give them a link they can click when they get around to it, passing the absolute path as the `path` query parameter:

```
http://duncan.test/phpstorm.php?path=/absolute/path/to/repo
```
